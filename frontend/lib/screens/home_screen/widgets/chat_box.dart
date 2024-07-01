import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/message.dart';
import 'package:frontend/services/chat_service.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key, this.forBottomSheet = false});

  final bool forBottomSheet;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final _messages = <Message>[];

  final _focusNode = FocusNode();
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  late StreamSubscription<Message> messageStreamSubcription;

  @override
  void initState() {
    super.initState();
    _messages.addAll(ChatService.I.messages);
    messageStreamSubcription = ChatService.I.messageStream.listen((message) {
      _messages.insert(0, message);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          widget.forBottomSheet ? null : BoxDecoration(border: Border.all()),
      child: Column(
        children: [
          _buildMessageList(),
          _buildTextField(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: ListView.separated(
        reverse: true,
        padding: const EdgeInsets.all(16),
        controller: _scrollController,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final avatar = _buildAvatar();
          final content = _buildContent(message.content);

          return _getLayoutForMessage(
            message,
            avatar: avatar,
            content: content,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16);
        },
      ),
    );
  }

  Widget _getLayoutForMessage(
    Message message, {
    required Widget avatar,
    required Widget content,
  }) {
    if (message.isMe) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [content, const SizedBox(width: 16), avatar],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [avatar, const SizedBox(width: 16), content],
    );
  }

  Widget _buildContent(String content) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(content),
      ),
    );
  }

  Widget _buildAvatar() {
    return const CircleAvatar(
      radius: 20,
      child: Center(child: Icon(Icons.person_outline)),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Enter your message...',
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        suffixIcon: IconButton(
          onPressed: () {
            _submit(_textController.text);
          },
          icon: const Icon(Icons.send_outlined),
        ),
      ),
      onSubmitted: _submit,
    );
  }

  void _submit(String message) {
    message = message.trim();
    if (message.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();
    setState(() {
      _messages.insert(
        0,
        Message(content: message, isMe: true),
      );
    });
    ChatService.I.send(message);
    _scrollController.jumpTo(0);
  }
}
