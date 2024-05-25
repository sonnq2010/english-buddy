import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:frontend/models/web_socket_message.dart';
import 'package:frontend/service/web_socket_service.dart';

class WebRTCService {
  WebRTCService._singleton();
  static final WebRTCService _instance = WebRTCService._singleton();
  static WebRTCService get I => _instance;

  final localVideoRenderer = RTCVideoRenderer();
  final remoteVideoRenderer = RTCVideoRenderer();

  late MediaStream localMediaStream;

  late RTCPeerConnection localPeerConnection;

  final Map<String, dynamic> iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'}
    ]
  };

  final Map<String, dynamic> constraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [],
  };

  Future<void> initialize() async {
    await localVideoRenderer.initialize();
    await remoteVideoRenderer.initialize();

    final mediaStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });

    localMediaStream = mediaStream;
    localVideoRenderer.srcObject = mediaStream;

    localPeerConnection = await createPeerConnection(iceServers, constraints);
    localPeerConnection.onConnectionState = _onConnectionState;
    localPeerConnection.onIceCandidate = _onIceCandidate;
    localPeerConnection.onAddStream = _onAddStream;
    localPeerConnection.onTrack = _onTrack;

    // Send local media stream and tracks to the other side
    localMediaStream.getTracks().forEach((track) async {
      await localPeerConnection.addTrack(track, localMediaStream);
    });
  }

  Future<void> dispose() async {
    localVideoRenderer.dispose();
    remoteVideoRenderer.dispose();
    localMediaStream.dispose();
  }

  Future<void> start() async {
    final message = WebSocketMessage.join();
    WebSocketService.I.sendMessage(message);
  }

  Future<void> next() async {}

  Future<void> pause() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void _createOffer() {}

  void _createAnswer() {}

  void _onConnectionState(RTCPeerConnectionState connectionState) {
    // TODO:
  }

  void _onIceCandidate(RTCIceCandidate candidate) {
    final message = WebSocketMessage.candidates(candidate);
    WebSocketService.I.sendMessage(message);
  }

  void _onAddStream(MediaStream mediaStream) {
    remoteVideoRenderer.srcObject = mediaStream;
  }

  void _onTrack(RTCTrackEvent trackEvent) {
    if (trackEvent.streams.isEmpty) return;
    remoteVideoRenderer.srcObject = trackEvent.streams.first;
  }
}
