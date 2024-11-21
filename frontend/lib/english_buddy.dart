import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen/home_screen.dart';
import 'package:get/get.dart';

class EnglishBuddy extends StatefulWidget {
  const EnglishBuddy({super.key});

  @override
  State<EnglishBuddy> createState() => _EnglishBuddyState();
}

class _EnglishBuddyState extends State<EnglishBuddy> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'English Buddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
