import 'package:flutter/material.dart';

class Message {
  const Message({required this.content, required this.isMe});

  final String content;
  final bool isMe;
}

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final _messages = <Message>[];

  final _focusNode = FocusNode();
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMessageList(),
        _buildTextField(),
      ],
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: ListView.separated(
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
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter your message...',
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
      onSubmitted: (value) {
        value = value.trim();
        if (value.isEmpty) return;

        _textController.clear();
        _focusNode.requestFocus();
        setState(() {
          _messages.add(
            Message(content: value, isMe: true),
          );
        });
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      },
    );
  }
}
