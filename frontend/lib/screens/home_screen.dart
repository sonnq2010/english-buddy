import 'package:flutter/material.dart';
import 'package:frontend/service/service.dart';
import 'package:frontend/widgets/camera.dart';
import 'package:frontend/widgets/chat_box.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_buildCameras(), _buildFilterAndChat()],
      ),
    );
  }

  Widget _buildCameras() {
    return Expanded(
      flex: 7,
      child: Row(
        children: [
          Expanded(
            child: VideoView(videoRenderer: WebRTCService.I.myVideoRenderer),
          ),
          Expanded(
            child: VideoView(videoRenderer: WebRTCService.I.otherVideoRenderer),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAndChat() {
    return const Expanded(
      flex: 3,
      child: Row(
        children: [
          Expanded(
            child: Placeholder(),
          ),
          Expanded(
            child: ChatBox(),
          ),
        ],
      ),
    );
  }
}
