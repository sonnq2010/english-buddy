import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/service/report_service.dart';
import 'package:frontend/widgets/chat_box.dart';
import 'package:frontend/widgets/filter_bottom_sheet.dart';
import 'package:frontend/widgets/video_view/my_video_view.dart';
import 'package:frontend/widgets/video_view/other_video_view.dart';

class HomeScreenForSmallAndMediumDevice extends StatelessWidget {
  const HomeScreenForSmallAndMediumDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                const OtherVideoView(useSwipe: false),
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

  Widget _buildFAB(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          mini: true,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: const ChatBox(forBottomSheet: true),
                );
              },
            );
          },
          child: const Icon(Icons.message_outlined),
        ),
        if (kIsWeb) const SizedBox(width: 16),
        FloatingActionButton(
          mini: true,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              builder: (context) {
                return const FilterBottomSheet();
              },
            );
          },
          child: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
