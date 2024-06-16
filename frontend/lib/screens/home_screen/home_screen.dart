import 'package:flutter/material.dart';
import 'package:frontend/dialogs/sign_in_sign_up_dialog.dart';
import 'package:frontend/screens/home_screen/home_screen_large_device.dart';
import 'package:frontend/screens/home_screen/home_screen_small_medium_device.dart';
import 'package:frontend/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Open sign in/sign up dialog
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = await AuthService.I.getCurrentUser();
      if (user != null) return;
      if (!mounted) return;

      // Open dialog
      SignInSignUpDialog.show(context);
    });
  }

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
