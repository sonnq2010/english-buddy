import 'dart:convert';

import 'package:frontend/repositories/api_client.dart';

class ReportUserRepo {
  const ReportUserRepo();

  void report({
    required String roomId,
    required String reporter,
    required String reason,
  }) async {
    final body = jsonEncode({
      'roomId': roomId,
      'reporter': reporter,
      'reason': reason,
    });
    ApiClient.I.post('/report-user', body: body);
  }
}
