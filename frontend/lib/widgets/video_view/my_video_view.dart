import 'package:flutter/material.dart';
import 'package:frontend/service/webrtc_service.dart';
import 'package:frontend/widgets/video_view/video_view.dart';

class MyVideoView extends StatelessWidget {
  const MyVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoView(videoRenderer: WebRTCService.I.localVideoRenderer),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent.withOpacity(0.2),
            ),
            onPressed: () {},
            icon: const Icon(
              Icons.person_outline,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
