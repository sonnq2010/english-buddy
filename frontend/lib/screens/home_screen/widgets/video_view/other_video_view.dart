import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/dialogs/report_reason_dialog.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/skip_button.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/start_button.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/stop_button.dart';
import 'package:frontend/services/report_service.dart';
import 'package:frontend/services/webrtc_service.dart';
import 'package:frontend/widgets/video_view.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class OtherVideoView extends StatelessWidget {
  const OtherVideoView({super.key, this.useSwipe = false});

  final bool useSwipe;

  void report(BuildContext context) async {
    final reason = await ReportReasonDialog.show(context);
    ReportService.I.reportUser(reason: reason);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!useSwipe) ...[
          VideoView(videoRenderer: WebRTCService.I.remoteVideoRenderer)
        ] else ...[
          const DismissableOtherVideoView(),
        ],
        Positioned(
          top: 8,
          right: 8,
          child: Obx(() {
            if (!WebRTCService.I.isConnected) return const SizedBox.shrink();
            return IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent.withOpacity(0.2),
              ),
              onPressed: () => report(context),
              icon: const Icon(
                Icons.report_outlined,
                size: 30,
                color: Colors.white,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class DismissableOtherVideoView extends StatefulWidget {
  const DismissableOtherVideoView({super.key});

  @override
  State<DismissableOtherVideoView> createState() =>
      _DismissableOtherVideoViewState();
}

class _DismissableOtherVideoViewState extends State<DismissableOtherVideoView> {
  late double _opacity;
  late bool _isStarted;

  @override
  void initState() {
    super.initState();
    _isStarted = WebRTCService.I.isStarted;
    _opacity = 0.0;
  }

  void _toggleOpacity() {
    if (!_isStarted) return;

    if (_opacity == 0.0) {
      setState(() {
        _opacity = 1.0;
      });
    } else {
      setState(() {
        _opacity = 0.0;
      });
    }
  }

  void start() {
    WebRTCService.I.start().then((value) {
      setState(() {
        _isStarted = true;
      });
    });
  }

  void skip() {
    setState(() {
      _opacity = 0.0;
    });
    WebRTCService.I.skip();
  }

  void stop() {
    setState(() {
      _opacity = 0.0;
      _isStarted = false;
    });
    WebRTCService.I.stop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleOpacity,
      child: Stack(
        children: [
          VideoView(videoRenderer: WebRTCService.I.remoteVideoRenderer),
          if (_isStarted)
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 500),
              child: Container(
                color: Colors.transparent.withOpacity(0.4),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: _opacity == 1.0,
                        child: SkipButton(
                          size: ButtonSize.small,
                          onPressed: skip,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Visibility(
                        visible: _opacity == 1.0,
                        child: StopButton(
                          size: ButtonSize.small,
                          isDisabled: false,
                          onPressed: stop,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Center(child: StartButton(onPressed: start)),
        ],
      ),
    );
  }
}
