import 'package:flutter_webrtc/flutter_webrtc.dart';

// Singleton
class WebRTCService {
  WebRTCService._singleton();
  static final WebRTCService _instance = WebRTCService._singleton();
  static WebRTCService get I => _instance;

  final myVideoRenderer = RTCVideoRenderer();
  final otherVideoRenderer = RTCVideoRenderer();

  late MediaStream myMediaStream;
  late MediaStream otherMediaStream;

  Future<void> initialize() async {
    await myVideoRenderer.initialize();
    await otherVideoRenderer.initialize();

    final mediaStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });

    myMediaStream = mediaStream;
    myVideoRenderer.srcObject = mediaStream;

    otherMediaStream = mediaStream;
    otherVideoRenderer.srcObject = mediaStream;
  }
}
