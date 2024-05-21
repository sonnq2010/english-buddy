import 'dart:convert';

import 'package:frontend/constants.dart';

class WebSocketMessage {
  const WebSocketMessage(this.type, this.data);

  final WebSocketMessageType type;
  final WebSocketData data;

  factory WebSocketMessage.fromJson(Map json) {
    final type = WebSocketMessageType.fromString(json['type'].toString());
    final data = WebSocketData.fromJson(json['data']);
    return WebSocketMessage(type, data);
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
    this.from,
    this.roomId,
    this.offer,
    this.answer,
    this.candidates,
  });

  final String? clientId; // Client ID
  final String? from; // Socket ID
  final String? roomId; // Room ID
  final Map<String, dynamic>? offer; // Offer SDP
  final Map<String, dynamic>? answer; // Answer SDP
  final Map<String, dynamic>? candidates; // ICE candidates

  factory WebSocketData.fromJson(Map json) {
    return WebSocketData(
      clientId: json['clientId'],
      from: json['from'],
      roomId: json['roomId'],
      offer: json['offer'],
      answer: json['answer'],
      candidates: json['candidates'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'from': from,
      'roomId': roomId,
      'offer': offer,
      'answer': answer,
      'candidates': candidates,
    };
  }
}
