import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:therapistapp/helper/enum.dart';
import 'package:therapistapp/helper/utility.dart';
import 'package:therapistapp/model/chatModel.dart';
import 'package:therapistapp/model/user.dart';
import 'package:therapistapp/state/appState.dart';

class ChatState extends AppState {
  late bool setIsChatScreenOpen; //!obsolete
  late WebSocketChannel channel;
  List<ChatMessage>? _messageList;
  List<ChatMessage>? _chatUserList;
  UserModel? _chatUser;
  String serverToken = "<FCM SERVER KEY>";

  UserModel? get chatUser => _chatUser;
  set setChatUser(UserModel model) {
    _chatUser = model;
  }

  String? _channelName;

  /// Contains list of chat messages on main chat screen
  /// List is sortBy message timeStamp
  /// Last message will be display on the bottom of screen
  List<ChatMessage>? get messageList => _messageList;

  /// Initialize WebSocket connection
  void initializeWebSocket(String token) {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8000'), // Replace with your WebSocket URL
    );

    channel.sink.add(jsonEncode({'token': token}));

    channel.stream.listen((message) {
      final data = jsonDecode(message);
      if (data['type'] == 'message') {
        _messageList?.add(ChatMessage.fromJson(data['message']));
        notifyListeners();
      } else if (data['type'] == 'notification') {
        // Handle notifications
      }
    }, onError: (error) {
      cprint('WebSocket error: $error');
    }, onDone: () {
      cprint('WebSocket connection closed');
    });
  }

  /// Send a message via WebSocket
  void sendMessage(String text, bool isVoice, String token) {
    final message = {
      'text': text,
      'is_voice': isVoice,
      'token': token,
    };
    channel.sink.add(jsonEncode(message));
  }

  /// Close WebSocket connection
  void closeWebSocket() {
    channel.sink.close();
  }

  @override
  void dispose() {
    closeWebSocket();
    super.dispose();
  }

  /// Send a chat message
  Future<void> sendChatMessage(ChatMessage message) async {
    try {
      // Send message via WebSocket
      channel.sink.add(jsonEncode(message.toJson()));
      Utility.logEvent('send_message', parameter: {});
    } catch (error) {
      cprint(error);
    }
  }

  /// Channel name is like a room name
  /// which save messages of two user uniquely in database
  String getChannelName(String user1, String user2) {
    user1 = user1.substring(0, 5);
    user2 = user2.substring(0, 5);
    List<String> list = [user1, user2];
    list.sort();
    _channelName = '${list[0]}-${list[1]}';
    return _channelName!;
  }
}