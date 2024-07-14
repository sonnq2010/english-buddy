import 'package:frontend/models/web_socket_message.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CCService {
  CCService._();
  static final CCService _instance = CCService._();
  static CCService get I => _instance;

  final cc = RxString('');

  void handleRemoteCC(WebSocketMessage message) {
    final ccString = message.data.cc ?? '';
    if (cc.value == ccString) return;
    cc.value = ccString;
  }

  void clearCC() {
    cc.value = '';
  }
}
