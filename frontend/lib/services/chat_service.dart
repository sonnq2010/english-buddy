import 'dart:async';

import 'package:frontend/models/message.dart';
import 'package:frontend/models/web_socket_message.dart';
import 'package:frontend/services/user_services.dart';
import 'package:frontend/services/web_socket_service.dart';

class ChatService {
  ChatService._singleton();
  static final ChatService _instance = ChatService._singleton();
  static ChatService get I => _instance;

  final _messageStreamController = StreamController<Message>.broadcast();
  Stream<Message> get messageStream => _messageStreamController.stream;

  final List<Message> _messages = [];
  List<Message> get messages => _messages.reversed.toList();

  void send(String message) async {
    _messages.add(Message(content: message, isMe: true));

    // Send message to socket
    final user = await UserService.I.getCurrentUser();
    final webSocketMessage = WebSocketMessage.chat(
      message,
      avatar: user?.profile.avatar,
    );
    WebSocketService.I.sendMessage(webSocketMessage);
  }

  void onNewMessage(WebSocketMessage message) {
    final messageString = message.data.message ?? '';
    if (messageString.isEmpty) return;

    final chatMessage = Message(
      content: messageString,
      avatar: message.data.avatar,
      isMe: false,
    );

    _messages.add(chatMessage);
    _messageStreamController.add(chatMessage);
  }

  void clearMessages() {
    _messages.clear();
  }
}
