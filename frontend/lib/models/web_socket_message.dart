import 'dart:convert';
import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/services/web_socket_service.dart';

class WebSocketMessage {
  const WebSocketMessage(this.type, this.data);

  final WebSocketMessageType type;
  final WebSocketData data;

  factory WebSocketMessage.fromJson(Map json) {
    try {
      final type = WebSocketMessageType.fromString(json['type'].toString());
      final data = WebSocketData.fromJson(json['data']);
      return WebSocketMessage(type, data);
    } catch (e) {
      log(e.toString());
      return WebSocketMessage.unknown();
    }
  }

  factory WebSocketMessage.unknown() {
    return WebSocketMessage(
      WebSocketMessageType.unknown,
      WebSocketData(clientId: WebSocketService.I.clientId),
    );
  }

  factory WebSocketMessage.join({required String ipAddress}) {
    return WebSocketMessage(
      WebSocketMessageType.join,
      WebSocketData(
        clientId: WebSocketService.I.clientId,
        ipAddress: ipAddress,
      ),
    );
  }

  factory WebSocketMessage.candidates(RTCIceCandidate candidate) {
    return WebSocketMessage(
      WebSocketMessageType.candidates,
      WebSocketData(
        clientId: WebSocketService.I.clientId,
        roomId: WebSocketService.I.roomId,
        candidates: candidate.toMap(),
      ),
    );
  }

  factory WebSocketMessage.offer(RTCSessionDescription offer) {
    return WebSocketMessage(
      WebSocketMessageType.offer,
      WebSocketData(
        clientId: WebSocketService.I.clientId,
        roomId: WebSocketService.I.roomId,
        offer: offer.toMap(),
      ),
    );
  }

  factory WebSocketMessage.answer(RTCSessionDescription answer) {
    return WebSocketMessage(
      WebSocketMessageType.answer,
      WebSocketData(
        clientId: WebSocketService.I.clientId,
        roomId: WebSocketService.I.roomId,
        answer: answer.toMap(),
      ),
    );
  }

  factory WebSocketMessage.skip() {
    return WebSocketMessage(
      WebSocketMessageType.skip,
      WebSocketData(
        clientId: WebSocketService.I.clientId,
        roomId: WebSocketService.I.roomId,
      ),
    );
  }

  factory WebSocketMessage.stop() {
    return WebSocketMessage(
      WebSocketMessageType.stop,
      WebSocketData(
        clientId: WebSocketService.I.clientId,
        roomId: WebSocketService.I.roomId,
      ),
    );
  }

  factory WebSocketMessage.chat(
    String message, {
    String? avatar,
  }) {
    return WebSocketMessage(
      WebSocketMessageType.chat,
      WebSocketData(
        clientId: WebSocketService.I.clientId,
        roomId: WebSocketService.I.roomId,
        message: message,
        avatar: avatar,
      ),
    );
  }

  factory WebSocketMessage.cc(String cc) {
    return WebSocketMessage(
      WebSocketMessageType.cc,
      WebSocketData(
        clientId: WebSocketService.I.clientId,
        roomId: WebSocketService.I.roomId,
        cc: cc,
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
    this.message,
    this.avatar,
    this.ipAddress,
    this.cc,
  });

  final String? clientId; // Socket ID
  final String? roomId; // Room ID
  final Map<String, dynamic>? offer; // Offer SDP
  final Map<String, dynamic>? answer; // Answer SDP
  final Map<String, dynamic>? candidates; // ICE candidates
  final String? message; // Chat message
  final String? avatar;
  final String? ipAddress; // IP address
  final String? cc; // CC Speech to Text

  factory WebSocketData.fromJson(Map json) {
    return WebSocketData(
      clientId: json['clientId'],
      roomId: json['roomId'],
      offer: json['offer'],
      answer: json['answer'],
      candidates: json['candidates'],
      message: json['message'],
      avatar: json['avatar'],
      cc: json['cc'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (clientId != null) json['clientId'] = clientId;
    if (roomId != null) json['roomId'] = roomId;
    if (offer != null) json['offer'] = offer;
    if (answer != null) json['answer'] = answer;
    if (candidates != null) json['candidates'] = candidates;
    if (message != null) json['message'] = message;
    if (avatar != null) json['avatar'] = avatar;
    if (ipAddress != null) json['clientIP'] = ipAddress;
    if (cc != null) json['cc'] = cc;
    return json;
  }
}
