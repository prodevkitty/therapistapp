// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as io_socket;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  late io_socket.Socket socket;
  late String token;
  factory SocketManager() {
    // _instance.store = store;
    return _instance;
  }

  SocketManager._internal();
  Function? onNewMessage;
  void sendMessage(String message) {
    socket.emit('user_message_advanced',
        {'text': message, 'is_voice': false, 'token': token});
  }

  void initializeSocket(String token, onNewMessage) {
    try {
      this.token = token;
      this.onNewMessage = onNewMessage;
      socket = io_socket.io('http://192.168.118.221:8001', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'auth': {'token': 'Bearer $token'},
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 1000,
        // 'path': '/app-socket.io'
      });

      // Listen for connection
      socket.on('connect', (_) {
        print('Connected to socket');
      });

      // Listen for disconnection
      socket.on('disconnect', (_) {
        print('Disconnected from socket');
      });

      // Listen for errors
      socket.on('connect_error', (error) {
        print('Connection Error: $error');
      });

      socket.on('ai_response', (data) {
        print('Ai response: $data');
        this.onNewMessage!(data);
      });

      // Listen for any other events
      socket.on('first_notification', (data) {
        print('Event received: $data');
        this.onNewMessage!({'response': data['notification']});
      });

      socket.connect();
    } catch (err) {
      print(err);
    }
  }

  void closeSocket() {
    socket.disconnect();
    socket.dispose();
  }
}
