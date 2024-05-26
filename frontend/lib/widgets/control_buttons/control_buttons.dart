import 'package:flutter/material.dart';
import 'package:frontend/service/webrtc_service.dart';
import 'package:frontend/widgets/control_buttons/skip_button.dart';
import 'package:frontend/widgets/control_buttons/start_button.dart';
import 'package:frontend/widgets/control_buttons/stop_button.dart';

class ControlButtons extends StatefulWidget {
  const ControlButtons({super.key});

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  bool isStarted = false;

  void start() {
    WebRTCService.I.start().then((value) {
      setState(() {
        isStarted = true;
      });
    });
  }

  void skip() {
    WebRTCService.I.skip();
  }

  void stop() {
    WebRTCService.I.stop();
    setState(() {
      isStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isStarted ? SkipButton(onPressed: skip) : StartButton(onPressed: start),
        const SizedBox(width: 16),
        StopButton(isDisabled: !isStarted, onPressed: stop),
      ],
    );
  }
}
