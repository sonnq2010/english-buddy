import 'dart:async';
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

  bool _isStarted = false;

  late Timer _timer;

  Future<void> initialize() async {
    await _speech.initialize(
      onStatus: (status) {
        debugPrint(status.toString());
      },
      onError: (error) => log(error.errorMsg),
      finalTimeout: const Duration(minutes: 10),
    );

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!_isStarted) return;
      if (!WebRTCService.I.isConnected) return;

      if (_speech.isNotListening) {
        try {
          await startListen();
        } catch (e) {
          debugPrint('Try listen failed');
        }
      }
    });
  }

  void dispose() {
    _speech.cancel();
    _timer.cancel();
  }

  Future<void> startListen({bool clearCC = true}) async {
    if (_isStarted) return;

    _isStarted = true;
    if (clearCC) CCService.I.clearCC();

    debugPrint('started listening');
    await _speech.listen(
      onResult: _onResult,
      localeId: 'en_US',
      listenFor: const Duration(minutes: 5),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  Future<void> stopListen({bool clearCC = true}) async {
    if (!_isStarted) return;

    _isStarted = false;
    if (clearCC) CCService.I.clearCC();
    await _speech.stop();
  }

  Future<void> restart() async {
    await stopListen();
    await startListen();
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
