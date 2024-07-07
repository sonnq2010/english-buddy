import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen/widgets/chat_box.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons_area.dart';
import 'package:frontend/screens/home_screen/widgets/video_view/my_video_view.dart';
import 'package:frontend/screens/home_screen/widgets/video_view/other_video_view.dart';

class HomeScreenForLargeDevice extends StatelessWidget {
  const HomeScreenForLargeDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_buildCameras(), _buildFilterAndChat()],
      ),
    );
  }

  Widget _buildCameras() {
    return const Expanded(
      flex: 13,
      child: Row(
        children: [
          Expanded(
            child: OtherVideoView(),
          ),
          Expanded(
            child: MyVideoView(),
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
            child: ControlButtonsArea(),
          ),
          Expanded(
            child: ChatBox(),
          ),
        ],
      ),
    );
  }
}
