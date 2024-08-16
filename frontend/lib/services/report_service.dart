import 'package:frontend/repositories/report_user_repo.dart';
import 'package:frontend/services/web_socket_service.dart';
import 'package:frontend/services/webrtc_service.dart';

class ReportService {
  ReportService._singleton();
  static final ReportService _instance = ReportService._singleton();
  static ReportService get I => _instance;

  final _repo = const ReportUserRepo();

  void reportUser({required String? reason}) async {
    if (!WebRTCService.I.isConnected.value) return;

    reason = reason?.trim();
    if (reason == null) return;
    if (reason.isEmpty) return;

    final reporter = WebSocketService.I.clientId;
    final roomId = WebSocketService.I.roomId;

    _repo.report(
      roomId: roomId,
      reporter: reporter,
      reason: reason,
    );

    WebRTCService.I.skip();
  }
}
