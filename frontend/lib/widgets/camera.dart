import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoView extends StatelessWidget {
  const VideoView({super.key, required this.videoRenderer});

  final RTCVideoRenderer videoRenderer;

  @override
  Widget build(BuildContext context) {
    return RTCVideoView(
      videoRenderer,
      mirror: true,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    );
  }
}
