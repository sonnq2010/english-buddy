import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/web_socket_message.dart';
import 'package:frontend/services/chat_service.dart';
import 'package:frontend/services/webrtc_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketService._singleton();
  static final _instance = WebSocketService._singleton();
  static WebSocketService get I => _instance;

  late WebSocketChannel _channel;
  late String clientId;
  late String roomId;

  final _channelUri = Uri.parse(
    '${dotenv.env['WS_URL']}:${dotenv.env['WS_PORT']}/ws',
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
        clientId = wsMessage.data.clientId ?? '';
        log('ClientID: $clientId');
        break;

      case WebSocketMessageType.join:
        roomId = wsMessage.data.roomId ?? '';
        log('RoomID: $roomId');
        WebRTCService.I.sendOffer();
        break;

      case WebSocketMessageType.offer:
        WebRTCService.I.handleRemoteOffer(wsMessage.data.offer);
        break;

      case WebSocketMessageType.answer:
        WebRTCService.I.handleRemoteAnswer(wsMessage.data.answer);
        break;

      case WebSocketMessageType.candidates:
        WebRTCService.I.handleRemoteCandidates(wsMessage.data.candidates);
        break;

      case WebSocketMessageType.skip:
        roomId = '';
        WebRTCService.I.handleRemoteSkipped();
        break;

      case WebSocketMessageType.stop:
        roomId = '';
        WebRTCService.I.handleRemoteStopped();
        break;

      case WebSocketMessageType.chat:
        ChatService.I.onNewMessage(wsMessage);
        break;

      case WebSocketMessageType.unknown:
        return;
    }
  }
}
