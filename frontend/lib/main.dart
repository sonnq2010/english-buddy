import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/english_buddy.dart';
import 'package:frontend/services/speech_recognitor.dart';
import 'package:frontend/services/web_socket_service.dart';
import 'package:frontend/services/webrtc_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadEnv();
  await WebSocketService.I.initialize();
  await WebRTCService.I.initialize();
  await SpeechRecognitor.I.initialize();

  runApp(const EnglishBuddy());
}

Future<void> loadEnv() async {
  try {
    if (kReleaseMode) {
      await dotenv.load(fileName: ".env.prod");
    } else {
      await dotenv.load(fileName: ".env");
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
