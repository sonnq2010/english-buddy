import 'package:flutter/material.dart';

class StartButton extends StatefulWidget {
  const StartButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  bool isPressed = false;

  void _onPressed() {
    setState(() {
      isPressed = true;
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isPressed ? null : _onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const Icon(Icons.play_arrow_rounded, size: 100),
    );
  }
}
