import 'package:frontend/models/web_socket_message.dart';
import 'package:get/get.dart';

class CCService extends GetxController {
  static final CCService _instance = Get.put(CCService());
  static CCService get I => _instance;

  final cc = RxString('');

  void handleRemoteCC(WebSocketMessage message) {
    final ccString = message.data.cc ?? '';
    if (ccString == cc.value) return;

    cc.value = ccString;
  }

  void clearCC() {
    cc.value = '';
  }
}
