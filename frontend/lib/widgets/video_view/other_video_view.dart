import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/service/webrtc_service.dart';
import 'package:frontend/widgets/video_view/video_view.dart';

class OtherVideoView extends StatelessWidget {
  const OtherVideoView({super.key, this.useSwipe = false});

  final bool useSwipe;

  @override
  Widget build(BuildContext context) {
    if (!useSwipe) {
      return VideoView(videoRenderer: WebRTCService.I.otherVideoRenderer);
    }

    return Transform.rotate(
      angle: pi / 4,
      child: Container(
        color: Colors.pink.withOpacity(0.5),
        child: const Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
