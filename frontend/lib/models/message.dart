class Message {
  const Message({
    required this.content,
    required this.isMe,
  });

  final String content;

  // If [isMe] equal true, the message will be rendered
  // on the right side
  final bool isMe;
}
