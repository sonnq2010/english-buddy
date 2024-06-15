import 'package:flutter/material.dart';
import 'package:frontend/service/report_service.dart';
import 'package:frontend/widgets/chat_box.dart';
import 'package:frontend/widgets/control_buttons_and_filters.dart';
import 'package:frontend/widgets/video_view/my_video_view.dart';
import 'package:frontend/widgets/video_view/other_video_view.dart';

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
    return Expanded(
      flex: 13,
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                const OtherVideoView(),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.2),
                    ),
                    onPressed: ReportService.I.reportUser,
                    icon: const Icon(Icons.report_outlined, size: 30),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
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
