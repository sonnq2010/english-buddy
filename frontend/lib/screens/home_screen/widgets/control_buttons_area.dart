import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/control_buttons.dart';

class ControlButtonsArea extends StatelessWidget {
  const ControlButtonsArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all()),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FittedBox(child: ControlButtons()),
          ),
        ],
      ),
    );
  }
}
