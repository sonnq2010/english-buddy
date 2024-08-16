import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/skip_button.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/start_button.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/stop_button.dart';
import 'package:frontend/services/webrtc_service.dart';

class ControlButtons extends StatefulWidget {
  const ControlButtons({super.key});

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  late bool _isStarted;

  @override
  void initState() {
    super.initState();
    _isStarted = WebRTCService.I.isStarted;
  }

  void start() {
    WebRTCService.I.start().then((value) {
      setState(() {
        _isStarted = true;
      });
    });
  }

  void skip() {
    WebRTCService.I.skip();
  }

  void stop() {
    WebRTCService.I.stop();
    setState(() {
      _isStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _isStarted
            ? SkipButton(onPressed: skip)
            : StartButton(onPressed: start),
        const SizedBox(width: 16),
        StopButton(isDisabled: !_isStarted, onPressed: stop),
      ],
    );
  }
}
