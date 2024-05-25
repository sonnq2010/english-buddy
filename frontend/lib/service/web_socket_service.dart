import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/web_socket_message.dart';
import 'package:frontend/service/chat_service.dart';
import 'package:frontend/service/webrtc_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketService._singleton();
  static final _instance = WebSocketService._singleton();
  static WebSocketService get I => _instance;

  late WebSocketChannel _channel;
  late String socketId;
  late String roomId;

  final _channelUri = Uri.parse(
    'ws://${dotenv.env['API_URL']}:${dotenv.env['API_PORT']}/ws',
  );

  Future<void> initialize() async {
    _channel = WebSocketChannel.connect(_channelUri);
    await _channel.ready;

    _channel.stream.listen((message) {
      handleNewMessage(message);
    });
  }

  Future<void> dispose() async {
    _channel.sink.close();
  }

  void sendMessage(WebSocketMessage message) {
    _channel.sink.add(message.jsonify());
  }

  void handleNewMessage(dynamic message) {
    final json = jsonDecode(message);
    final wsMessage = WebSocketMessage.fromJson(json);

    // Continue handle
    switch (wsMessage.type) {
      case WebSocketMessageType.id:
        socketId = wsMessage.data.clientId ?? '';
        log('SocketID: $socketId');
      case WebSocketMessageType.join:
        roomId = wsMessage.data.roomId ?? '';
        log('RoomID: $roomId');
        WebRTCService.I.onRoomJoined();
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
