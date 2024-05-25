import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/service/web_socket_service.dart';

class WebSocketMessage {
  const WebSocketMessage(this.type, this.data);

  final WebSocketMessageType type;
  final WebSocketData data;

  factory WebSocketMessage.fromJson(Map json) {
    final type = WebSocketMessageType.fromString(json['type'].toString());
    final data = WebSocketData.fromJson(json['data']);
    return WebSocketMessage(type, data);
  }

  factory WebSocketMessage.join() {
    return WebSocketMessage(
      WebSocketMessageType.join,
      WebSocketData(clientId: WebSocketService.I.socketId),
    );
  }

  factory WebSocketMessage.candidates(RTCIceCandidate candidate) {
    return WebSocketMessage(
      WebSocketMessageType.candidates,
      WebSocketData(
        clientId: WebSocketService.I.socketId,
        roomId: WebSocketService.I.roomId,
        candidates: candidate.toMap(),
      ),
    );
  }

  factory WebSocketMessage.offer(RTCSessionDescription offer) {
    return WebSocketMessage(
      WebSocketMessageType.offer,
      WebSocketData(
        clientId: WebSocketService.I.socketId,
        roomId: WebSocketService.I.roomId,
        offer: offer.toMap(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'data': data.toJson(),
    };
  }

  String jsonify() {
    return jsonEncode(toJson());
  }
}

class WebSocketData {
  const WebSocketData({
    this.clientId,
    this.roomId,
    this.offer,
    this.answer,
    this.candidates,
  });

  final String? clientId; // Socket ID
  final String? roomId; // Room ID
  final Map<String, dynamic>? offer; // Offer SDP
  final Map<String, dynamic>? answer; // Answer SDP
  final Map<String, dynamic>? candidates; // ICE candidates

  factory WebSocketData.fromJson(Map json) {
    return WebSocketData(
      clientId: json['clientId'],
      roomId: json['roomId'],
      offer: json['offer'],
      answer: json['answer'],
      candidates: json['candidates'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (clientId != null) json['clientId'] = clientId;
    if (roomId != null) json['roomId'] = roomId;
    if (offer != null) json['offer'] = offer;
    if (answer != null) json['answer'] = answer;
    if (candidates != null) json['candidates'] = candidates;
    return json;
  }
}
