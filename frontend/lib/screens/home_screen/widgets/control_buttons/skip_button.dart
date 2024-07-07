import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({
    super.key,
    this.size = ButtonSize.large,
    required this.onPressed,
  });

  final ButtonSize size;
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
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: _padding,
        shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      ),
      child: Icon(Icons.keyboard_double_arrow_right_rounded, size: _size),
    );
  }
}
