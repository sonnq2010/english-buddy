import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen/home_screen.dart';
import 'package:frontend/services/speech_recognitor.dart';
import 'package:frontend/services/web_socket_service.dart';
import 'package:frontend/services/webrtc_service.dart';

class EnglishBuddy extends StatefulWidget {
  const EnglishBuddy({super.key});

  @override
  State<EnglishBuddy> createState() => _EnglishBuddyState();
}

class _EnglishBuddyState extends State<EnglishBuddy> {
  @override
  void dispose() {
    super.dispose();
    WebSocketService.I.dispose();
    WebRTCService.I.dispose();
    SpeechRecognitor.I.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
