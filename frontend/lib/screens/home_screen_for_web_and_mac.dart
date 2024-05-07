import 'package:flutter/material.dart';
import 'package:frontend/service/webrtc_service.dart';
import 'package:frontend/widgets/chat_box.dart';
import 'package:frontend/widgets/control_buttons_and_filters.dart';
import 'package:frontend/widgets/video_view.dart';

class HomeScreenForWebAndMac extends StatelessWidget {
  const HomeScreenForWebAndMac({super.key});

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
      flex: 13,
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
      flex: 7,
      child: Row(
        children: [
          Expanded(
            child: ControllButtonsAndFilters(),
          ),
          Expanded(
            child: ChatBox(),
          ),
        ],
      ),
    );
  }
}
