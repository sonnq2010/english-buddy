import 'package:frontend/models/message.dart';
import 'package:frontend/models/web_socket_message.dart';
import 'package:frontend/service/web_socket_service.dart';

class ChatService {
  ChatService._singleton();
  static final ChatService _instance = ChatService._singleton();
  static ChatService get I => _instance;

  final List<Message> _messages = [];
  List<Message> get messages => _messages.reversed.toList();

  void submit(String message) {
    _messages.add(Message(content: message, isMe: true));

    // Send message to socket
    final webSocketMessage = WebSocketMessage.chat(message);
    WebSocketService.I.sendMessage(webSocketMessage);
  }

  void onNewMessage(WebSocketMessage message) {
    final chatMessage = message.data.chatMessage ?? '';
    if (chatMessage.isEmpty) return;

    _messages.add(Message(content: chatMessage, isMe: false));
  }

  void clearMessages() {
    _messages.clear();
  }
}
