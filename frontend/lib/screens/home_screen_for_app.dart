import 'package:flutter/material.dart';
import 'package:frontend/service/webrtc_service.dart';
import 'package:frontend/widgets/chat_box.dart';
import 'package:frontend/widgets/filter_bottom_sheet.dart';
import 'package:frontend/widgets/video_view.dart';

class HomeScreenForApp extends StatelessWidget {
  const HomeScreenForApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
      floatingActionButton: Row(
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
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: VideoView(videoRenderer: WebRTCService.I.otherVideoRenderer),
          ),
          Expanded(
            child: VideoView(videoRenderer: WebRTCService.I.myVideoRenderer),
          ),
        ],
      ),
    );
  }
}
