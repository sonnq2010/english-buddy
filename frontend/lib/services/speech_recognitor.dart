import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:frontend/models/web_socket_message.dart';
import 'package:frontend/services/cc_service.dart';
import 'package:frontend/services/web_socket_service.dart';
import 'package:frontend/services/webrtc_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitor {
  SpeechRecognitor._();
  static final SpeechRecognitor _instance = SpeechRecognitor._();
  static SpeechRecognitor get I => _instance;

  final _speech = stt.SpeechToText();
  String _lastResult = '';

  Future<void> initialize() async {
    await _speech.initialize(
      onStatus: (status) {
        log(status.toString());
        if (_speech.isNotListening && WebRTCService.I.isConnected) {
          stopListen(clearCC: false).then((_) => startListen(clearCC: false));
        }
      },
      onError: (error) => log(error.errorMsg),
      finalTimeout: const Duration(minutes: 10),
    );
  }

  Future<void> startListen({bool clearCC = true}) async {
    debugPrint('started listening');
    _speech.listen(
      onResult: _onResult,
      localeId: 'en_US',
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
      ),
    );

    if (clearCC) CCService.I.clearCC();
  }

  Future<void> stopListen({bool clearCC = true}) async {
    _speech.stop();
    if (clearCC) CCService.I.clearCC();
  }

  void _onResult(SpeechRecognitionResult recognitionResult) {
    debugPrint('received result');
    if (!WebRTCService.I.isConnected) return;

    final result = recognitionResult.recognizedWords;
    debugPrint('result: $result');
    if (result == _lastResult) return;

    final minifiedResult = minifyRecognizedWords(result);
    final message = WebSocketMessage.cc(minifiedResult);
    WebSocketService.I.sendMessage(message);
    debugPrint('result sended to socket');

    _lastResult = result;
  }

  // Minify to last 10 words
  String minifyRecognizedWords(String recognizedWords) {
    final tokens = recognizedWords.split(' ');
    if (tokens.length <= 10) {
      return tokens.join(' ');
    }

    final minifiedTokens = tokens.sublist(tokens.length - 10);
    return minifiedTokens.join(' ');
  }
}
