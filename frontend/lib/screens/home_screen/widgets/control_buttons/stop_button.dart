import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class StopButton extends StatelessWidget {
  const StopButton({
    super.key,
    this.size = ButtonSize.large,
    required this.isDisabled,
    required this.onPressed,
  });

  final ButtonSize size;
  final bool isDisabled;
  final VoidCallback onPressed;

  EdgeInsetsGeometry get _padding {
    if (size == ButtonSize.small) return const EdgeInsets.all(20);
    return const EdgeInsets.all(32);
  }

  BorderRadiusGeometry get _borderRadius {
    if (size == ButtonSize.small) return BorderRadius.circular(10);
    return BorderRadius.circular(20);
  }

  double get _size {
    if (size == ButtonSize.small) return 50;
    return 100;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: _padding,
        shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      ),
      child: Icon(Icons.pause_rounded, size: _size),
    );
  }
}
