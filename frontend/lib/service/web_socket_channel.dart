import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/web_socket_data.dart';
import 'package:frontend/service/chat_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketService._singleton();
  static final _instance = WebSocketService._singleton();
  static WebSocketService get I => _instance;

  final _channelUri = Uri.parse(
    'ws://${dotenv.env['API_URL']}:${dotenv.env['API_PORT']}/ws',
  );

  Future<void> initialize() async {
    final channel = WebSocketChannel.connect(_channelUri);
    await channel.ready;

    channel.stream.listen((message) {
      handleNewMessage(message);
    });
  }

  void handleNewMessage(dynamic message) {
    final json = jsonDecode(message);
    final wsMessage = WebSocketMessage.fromJson(json);

    // Continue handle
    switch (wsMessage.type) {
      case WebSocketMessageType.id:
      // TODO: Handle this case.
      case WebSocketMessageType.join:
      // TODO: Handle this case.
      case WebSocketMessageType.offer:
      // TODO: Handle this case.
      case WebSocketMessageType.answer:
      // TODO: Handle this case.
      case WebSocketMessageType.candidates:
      // TODO: Handle this case.
      case WebSocketMessageType.skip:
      // TODO: Handle this case.
      case WebSocketMessageType.stop:
      // TODO: Handle this case.
      case WebSocketMessageType.chat:
        return ChatService.I.onNewMessage(wsMessage);
      case WebSocketMessageType.undefined:
        return;
    }
  }
}
