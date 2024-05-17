import 'package:frontend/models/message.dart';

class ChatService {
  ChatService._singleton();
  static final ChatService _instance = ChatService._singleton();
  static ChatService get I => _instance;

  final List<Message> _messages = [];
  List<Message> get messages => _messages.reversed.toList();

  void submit(String message) {
    _messages.add(Message(content: message, isMe: true));

    // Call API to submit message;
  }

  void clearMessages() {
    _messages.clear();
  }
}
