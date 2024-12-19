import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:therapistapp/helper/socket_manager.dart';
import 'package:therapistapp/state/authState.dart';
import 'package:therapistapp/ui/page/profile/widgets/circular_image.dart';
import 'package:therapistapp/ui/theme/theme.dart';
import 'package:therapistapp/widgets/url_text/customUrlText.dart';
import 'package:provider/provider.dart';

class ChatScreenPage extends StatefulWidget {
  const ChatScreenPage({
    Key? key,
  }) : super(key: key);

  @override
  _ChatScreenPageState createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  final messageController = TextEditingController();
  String? senderId;
  String userImage =
      'assats/images/logo_therabot.png';
  late ScrollController _controller;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  List<Map<String, String>> messages = [];

  @override
  void dispose() {
    messageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _controller = ScrollController();
    final state = Provider.of<AuthState>(context, listen: false);
    SharedPreferences.getInstance().then((sp) {
      SocketManager().initializeSocket(sp.getString('token')!, (data) {
        print('Event received: $data');
        setState(() {
          messages.add({'message': data['response'], 'sender': 'ai'});
        });
        _scrollToBottom();
      });
    });
    senderId = state.userId;
    super.initState();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void submitMessage() {
    if (messageController.text.isNotEmpty) {
      SocketManager().sendMessage(messageController.text);
      setState(() {
        messages.add({'sender': 'human', 'message': messageController.text});
      });
      _scrollToBottom();
    }
    messageController.clear();
  }

  Widget _chatScreenBody() {
    if (messages.isEmpty) {
      return const Center(
        child: Text(
          'No message found',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.builder(
      controller: _controller,
      shrinkWrap: true,
      reverse: false,
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) => chatMessage(messages[index]),
    );
  }

  Widget chatMessage(Map<String, String> message) {
    if (message['sender'] == 'ai') {
      return _message(message['message'], false);
    } else {
      return _message(message['message'], true);
    }
  }

  Widget _message(String? message, bool myMessage) {
    return Column(
      crossAxisAlignment:
          myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment:
          myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const SizedBox(
              width: 15,
            ),
            myMessage
                ? const SizedBox()
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("assets/images/logo_therabot.png"),
                  ),
            Expanded(
              child: Container(
                alignment:
                    myMessage ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right: myMessage ? 10 : (context.width / 7),
                  top: 20,
                  left: myMessage ? (context.width / 7) : 10,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: getBorder(myMessage),
                        color: myMessage
                            ? TwitterColor.dodgeBlue
                            : TwitterColor.mystic,
                      ),
                      child: UrlText(
                        text: message!,
                        style: TextStyle(
                          fontSize: 16,
                          color: myMessage ? TwitterColor.white : Colors.black,
                        ),
                        urlStyle: TextStyle(
                          fontSize: 16,
                          color: myMessage
                              ? TwitterColor.white
                              : TwitterColor.dodgeBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  BorderRadius getBorder(bool myMessage) {
    return BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomRight:
          myMessage ? const Radius.circular(0) : const Radius.circular(20),
      bottomLeft:
          myMessage ? const Radius.circular(20) : const Radius.circular(0),
    );
  }

  Widget _bottomEntryField() {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Divider(
            thickness: 0,
            height: 1,
          ),
            TextField(
            onSubmitted: (val) async {
              submitMessage();
            },
            controller: messageController,
            decoration: InputDecoration(
              contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              alignLabelWithHint: true,
              hintText: 'Start with a message...',
                suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: submitMessage,
                    ),
                    IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {
                      // Add functionality to handle voice input
                    },
                    ),
                ],
                ),
            ),
            ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    SocketManager().closeSocket();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UrlText(
                text: 'Chatting',
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Therapist AI',
                style: const TextStyle(color: AppColor.darkGrey, fontSize: 15),
              )
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.blue),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.symmetric(vertical: 12),
                child: _chatScreenBody(),
              )),
              _bottomEntryField()
            ],
          ),
        ),
      ),
    );
  }
}
