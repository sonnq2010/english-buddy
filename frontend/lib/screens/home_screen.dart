import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen_for_app.dart';
import 'package:frontend/screens/home_screen_for_web_and_mac.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final width = MediaQuery.of(context).size.width;

        if (width <= 992) {
          return const HomeScreenForSmallAndMediumDevice();
        }

        return const HomeScreenForLargeDevice();
      },
    );
  }
}
