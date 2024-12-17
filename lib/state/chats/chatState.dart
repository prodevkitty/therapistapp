// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:therapistapp/helper/socket_manager.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:therapistapp/helper/enum.dart';
// import 'package:therapistapp/helper/utility.dart';
// import 'package:therapistapp/model/chatModel.dart';
// import 'package:therapistapp/model/user.dart';
// import 'package:therapistapp/state/appState.dart';

// class ChatState extends AppState {
//   late bool setIsChatScreenOpen; //!obsolete
//   List<ChatMessage>? _messageList;
//   List<ChatMessage>? _chatUserList;
//   UserModel? _chatUser;
//   String serverToken = "<FCM SERVER KEY>";

//   UserModel? get chatUser => _chatUser;
//   set setChatUser(UserModel model) {
//     _chatUser = model;
//   }

//   String? _channelName;

//   /// Contains list of chat messages on main chat screen
//   /// List is sortBy message timeStamp
//   /// Last message will be display on the bottom of screen
//   List<ChatMessage>? get messageList => _messageList;

//   /// Initialize WebSocket connection
//   void initializeWebSocket(String token) {
//       SocketManager().initializeSocket(token);
//   }

//   /// Send a message via WebSocket
//   void sendMessage(String text, bool isVoice, String token) {
//     final message = {
//       'text': text,
//       'is_voice': isVoice,
//       'token': token,
//     };
//   }

//   /// Close WebSocket connection
//   void closeWebSocket() {
    
//   }

//   @override
//   void dispose() {
//     closeWebSocket();
//     super.dispose();
//   }

//   /// Send a chat message
//   Future<void> sendChatMessage(ChatMessage message) async {
//     try {
//       // Send message via WebSocket
//       Utility.logEvent('send_message', parameter: {});
//     } catch (error) {
//       cprint(error);
//     }
//   }

//   /// Channel name is like a room name
//   /// which save messages of two user uniquely in database
//   String getChannelName(String user1, String user2) {
//     user1 = user1.substring(0, 5);
//     user2 = user2.substring(0, 5);
//     List<String> list = [user1, user2];
//     list.sort();
//     _channelName = '${list[0]}-${list[1]}';
//     return _channelName!;
//   }
// }
