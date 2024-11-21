import 'package:frontend/models/message.dart';
import 'package:frontend/models/web_socket_message.dart';
import 'package:frontend/services/user_services.dart';
import 'package:frontend/services/web_socket_service.dart';
import 'package:frontend/services/webrtc_service.dart';
import 'package:get/get.dart';

class ChatService extends GetxController {
  static final ChatService _instance = Get.put(ChatService());
  static ChatService get I => _instance;

  final RxList<Message> messages = RxList();

  Future<bool> send(String message) async {
    if (!WebRTCService.I.isConnected.value) return false;

    message = message.trim();
    if (message.isEmpty) return false;

    messages.add(Message(content: message, isMe: true));

    // Send message to socket
    final user = await UserService.I.getCurrentUser();
    final webSocketMessage = WebSocketMessage.chat(
      message,
      avatar: user?.profile.avatar,
    );
    WebSocketService.I.sendMessage(webSocketMessage);
    return true;
  }

  void onNewMessage(WebSocketMessage message) {
    final messageString = message.data.message ?? '';
    if (messageString.isEmpty) return;

    final chatMessage = Message(
      content: messageString,
      avatar: message.data.avatar,
      isMe: false,
    );

    messages.add(chatMessage);
  }

  void clearMessages() {
    messages.clear();
  }
}
