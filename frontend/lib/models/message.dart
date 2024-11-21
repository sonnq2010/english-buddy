import 'package:frontend/services/user_services.dart';

class Message {
  Message({
    required this.content,
    String? avatar,
    this.isMe = true,
  }) {
    if (isMe) {
      UserService.I.getCurrentUser().then((user) {
        this.avatar = user?.profile.avatar;
      });
    } else {
      this.avatar = avatar;
    }
  }

  final String content;
  String? avatar;

  // If [isMe] equal true, the message will be rendered
  // on the right side
  final bool isMe;
}
