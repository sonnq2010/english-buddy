import 'package:frontend/services/webrtc_service.dart';

class ReportService {
  ReportService._singleton();
  static final ReportService _instance = ReportService._singleton();
  static ReportService get I => _instance;

  void reportUser() async {
    if (!WebRTCService.I.isConnected) return;

    // TODO
  }
}
