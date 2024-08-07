import 'dart:async';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:frontend/models/web_socket_message.dart';
import 'package:frontend/services/chat_service.dart';
import 'package:frontend/services/speech_recognitor.dart';
import 'package:frontend/services/web_socket_service.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class WebRTCService {
  WebRTCService._singleton();
  static final WebRTCService _instance = WebRTCService._singleton();
  static WebRTCService get I => _instance;

  final localVideoRenderer = RTCVideoRenderer();
  final remoteVideoRenderer = RTCVideoRenderer();

  late MediaStream localMediaStream;
  late RTCPeerConnection localPeerConnection;
  late String _ipAddress;

  var isStarted = false;
  var currentConnectionState =
      Rx(RTCPeerConnectionState.RTCPeerConnectionStateNew);

  bool get isConnected {
    return currentConnectionState.value ==
        RTCPeerConnectionState.RTCPeerConnectionStateConnected;
  }

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {
        'urls': dotenv.env['TURN_URL'],
        'username': dotenv.env['TURN_USERNAME'],
        'credential': dotenv.env['TURN_CREDENTIAL']
      },
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
    Ipify.ipv4().then((value) => _ipAddress = value);

    await localVideoRenderer.initialize();
    await remoteVideoRenderer.initialize();

    final mediaStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });

    localMediaStream = mediaStream;
    localVideoRenderer.srcObject = mediaStream;
  }

  Future<void> dispose() async {
    localVideoRenderer.dispose();
    remoteVideoRenderer.dispose();

    localMediaStream.getTracks().forEach((element) async {
      await element.stop();
    });
    localMediaStream.dispose();
  }

  Future<void> start() async {
    debugPrint('Start');
    isStarted = true;
    final message = WebSocketMessage.join(ipAddress: _ipAddress);
    WebSocketService.I.sendMessage(message);
  }

  Future<void> skip() async {
    remoteVideoRenderer.srcObject = null;
    await localPeerConnection.close();

    final message = WebSocketMessage.skip();
    WebSocketService.I.sendMessage(message);

    ChatService.I.clearMessages();

    start();
  }

  Future<void> stop() async {
    isStarted = false;
    remoteVideoRenderer.srcObject = null;
    await localPeerConnection.close();

    final message = WebSocketMessage.stop();
    WebSocketService.I.sendMessage(message);

    ChatService.I.clearMessages();
    SpeechRecognitor.I.stopListen();
  }

  Future<void> tryStop() async {
    if (!isStarted) return;
    stop();
  }

  Future<void> initPeerConnection() async {
    localPeerConnection = await createPeerConnection(_iceServers, _config);
    localPeerConnection.onConnectionState = _onConnectionState;
    localPeerConnection.onIceCandidate = _onIceCandidate;
    localPeerConnection.onAddStream = _onAddStream;
    localPeerConnection.onTrack = _onTrack;

    // Send local media stream and tracks to the other side
    localMediaStream.getTracks().forEach((track) async {
      await localPeerConnection.addTrack(track, localMediaStream);
    });
  }

  // Create and send offer
  Future<void> sendOffer() async {
    debugPrint('Send offer');
    await initPeerConnection();
    final offer = await _createOffer();
    final message = WebSocketMessage.offer(offer);
    WebSocketService.I.sendMessage(message);
  }

  // Receive and accept offer, send back answer
  Future<void> handleRemoteOffer(Map<String, dynamic>? description) async {
    debugPrint('Handle remote offer');
    if (description == null) return;

    // Accept offer
    final offer = RTCSessionDescription(
      description['sdp'],
      description['type'],
    );
    localPeerConnection.setRemoteDescription(offer);

    // Create create and send back
    debugPrint('Create answer and send back');
    final answer = await _createAnswer();
    final message = WebSocketMessage.answer(answer);
    WebSocketService.I.sendMessage(message);

    SpeechRecognitor.I.startListen();
  }

  // Receive and accept answer
  Future<void> handleRemoteAnswer(Map<String, dynamic>? description) async {
    debugPrint('Handle remote answer');
    if (description == null) return;

    // Accept answer
    final offer = RTCSessionDescription(
      description['sdp'],
      description['type'],
    );
    localPeerConnection.setRemoteDescription(offer);
    SpeechRecognitor.I.startListen();
  }

  Future<void> handleRemoteCandidates(Map<String, dynamic>? candidate) async {
    debugPrint('Handle remote candidate');
    if (candidate == null) return;

    final iceCandidate = RTCIceCandidate(
      candidate['candidate'],
      candidate['sdpMid'],
      candidate['sdpMLineIndex'],
    );

    await localPeerConnection.addCandidate(iceCandidate);
  }

  Future<void> handleRemoteSkipped() async {
    debugPrint('Remote skipped');
    remoteVideoRenderer.srcObject = null;
    ChatService.I.clearMessages();

    start();
  }

  Future<void> handleRemoteStopped() async {
    debugPrint('Remote stopped');
    remoteVideoRenderer.srcObject = null;
    ChatService.I.clearMessages();

    start();
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
    currentConnectionState.value = connectionState;
    debugPrint(connectionState.toString());
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
