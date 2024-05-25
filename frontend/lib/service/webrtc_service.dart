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

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
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

    localPeerConnection = await createPeerConnection(iceServers, _config);
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

  // Create and send offer
  Future<void> onRoomJoined() async {
    final offer = await _createOffer();
    final message = WebSocketMessage.offer(offer);
    WebSocketService.I.sendMessage(message);
  }

  // Receive and accept offer, send back answer
  Future<void> onOfferReceived(Map<String, dynamic>? description) async {
    if (description == null) return;

    // Accept offer
    final offer = RTCSessionDescription(
      description['sdp'],
      description['type'],
    );
    localPeerConnection.setRemoteDescription(offer);

    // Create create and send back
    final answer = await _createAnswer();
    final message = WebSocketMessage.answer(answer);
    WebSocketService.I.sendMessage(message);
  }

  // Receive and accept answer
  Future<void> onAnswerReceived(Map<String, dynamic>? description) async {
    if (description == null) return;

    // Accept answer
    final offer = RTCSessionDescription(
      description['sdp'],
      description['type'],
    );
    localPeerConnection.setRemoteDescription(offer);
  }

  Future<void> onCandidatesReceived(Map<String, dynamic>? candidate) async {
    if (candidate == null) return;

    final iceCandidate = RTCIceCandidate(
      candidate['candidate'],
      candidate['sdpMid'],
      candidate['sdpMLineIndex'],
    );

    await localPeerConnection.addCandidate(iceCandidate);
  }

  Future<RTCSessionDescription> _createOffer() async {
    final offer = await localPeerConnection.createOffer(_dcConstraints);
    await localPeerConnection.setLocalDescription(offer);
    return offer;
  }

  Future<RTCSessionDescription> _createAnswer() async {
    final answer = await localPeerConnection.createAnswer(_dcConstraints);
    await localPeerConnection.setLocalDescription(answer);
    return answer;
  }

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
