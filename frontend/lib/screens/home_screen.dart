import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen_for_app.dart';
import 'package:frontend/screens/home_screen_for_web_and_mac.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return const HomeScreenForApp();
    } else if (Platform.isIOS) {
      return const HomeScreenForApp();
    } else if (Platform.isMacOS) {
      return const HomeScreenForWebAndMac();
    } else if (kIsWeb) {
      return const HomeScreenForWebAndMac();
    }

    return const SizedBox.shrink();
  }
}
