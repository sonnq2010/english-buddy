import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/service/webrtc_service.dart';
import 'package:frontend/widgets/control_buttons/skip_button.dart';
import 'package:frontend/widgets/control_buttons/start_button.dart';
import 'package:frontend/widgets/control_buttons/stop_button.dart';
import 'package:frontend/widgets/video_view/video_view.dart';

class OtherVideoView extends StatelessWidget {
  const OtherVideoView({super.key, this.useSwipe = false});

  final bool useSwipe;

  @override
  Widget build(BuildContext context) {
    if (!useSwipe) {
      return VideoView(videoRenderer: WebRTCService.I.remoteVideoRenderer);
    }

    return const DismissableOtherVideoView();
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
