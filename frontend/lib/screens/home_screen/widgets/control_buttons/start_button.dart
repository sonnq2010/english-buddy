import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class StartButton extends StatefulWidget {
  const StartButton({
    super.key,
    this.size = ButtonSize.large,
    required this.onPressed,
  });

  final ButtonSize size;
  final VoidCallback onPressed;

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  bool isPressed = false;

  EdgeInsetsGeometry get _padding {
    if (widget.size == ButtonSize.small) return const EdgeInsets.all(20);
    return const EdgeInsets.all(32);
  }

  BorderRadiusGeometry get _borderRadius {
    if (widget.size == ButtonSize.small) return BorderRadius.circular(10);
    return BorderRadius.circular(20);
  }

  double get _size {
    if (widget.size == ButtonSize.small) return 50;
    return 100;
  }

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
        padding: _padding,
        shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      ),
      child: Icon(Icons.play_arrow_rounded, size: _size),
    );
  }
}
