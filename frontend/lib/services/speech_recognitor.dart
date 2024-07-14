import 'dart:developer';

import 'package:frontend/models/web_socket_message.dart';
import 'package:frontend/services/cc_service.dart';
import 'package:frontend/services/web_socket_service.dart';
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
        if (status == 'notListening') {
          startListen(clearCC: false);
        }
      },
      onError: (error) => log(error.errorMsg),
    );
  }

  Future<void> startListen({bool clearCC = true}) async {
    _speech.listen(
      onResult: _onResult,
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
      ),
    );

    if (clearCC) CCService.I.clearCC();
  }

  Future<void> stopListen() async {
    _speech.stop();
    CCService.I.clearCC();
  }

  void _onResult(SpeechRecognitionResult recognitionResult) {
    final result = recognitionResult.recognizedWords;
    if (result == _lastResult) return;

    final minifiedResult = minifyRecognizedWords(result);
    final message = WebSocketMessage.cc(minifiedResult);
    WebSocketService.I.sendMessage(message);

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
