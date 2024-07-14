import 'dart:async';

import 'package:frontend/models/web_socket_message.dart';

class CCService {
  CCService._();
  static final CCService _instance = CCService._();
  static CCService get I => _instance;

  final _ccStreamController = StreamController<String>.broadcast();
  Stream<String> get ccStream => _ccStreamController.stream;

  void handleRemoteCC(WebSocketMessage message) {
    final ccString = message.data.cc ?? '';
    _ccStreamController.add(ccString);
  }

  void clearCC() {
    _ccStreamController.add('');
  }
}
