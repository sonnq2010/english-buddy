import 'dart:developer';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitor {
  SpeechRecognitor._();
  static final SpeechRecognitor _instance = SpeechRecognitor._();
  static SpeechRecognitor get I => _instance;

  final _speech = stt.SpeechToText();

  Future<void> initialize() async {
    await _speech.initialize(
      onStatus: (status) => log(status.toString()),
      onError: (error) => log(error.errorMsg),
    );
  }

  Future<void> startListen() async {
    _speech.listen(
      onResult: _onResult,
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
      ),
    );
  }

  Future<void> stopListen() async {
    _speech.stop();
  }

  void _onResult(SpeechRecognitionResult result) {
    log(result.recognizedWords);
  }
}
