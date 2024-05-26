import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen_large_device.dart';
import 'package:frontend/screens/home_screen_small_medium_device.dart';

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
