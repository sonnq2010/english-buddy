import 'package:flutter/material.dart';
import 'package:frontend/service/webrtc_service.dart';
import 'package:frontend/widgets/control_buttons/next_button.dart';
import 'package:frontend/widgets/control_buttons/pause_button.dart';
import 'package:frontend/widgets/control_buttons/start_button.dart';

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

  void next() {
    WebRTCService.I.next();
  }

  void pause() {
    WebRTCService.I.pause();
    setState(() {
      isStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isStarted ? NextButton(onPressed: next) : StartButton(onPressed: start),
        const SizedBox(width: 16),
        PauseButton(isDisabled: !isStarted, onPressed: pause),
      ],
    );
  }
}
