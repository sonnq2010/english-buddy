import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({super.key, required this.user});
  final User user;

  static void show(
    BuildContext context, {
    required User user,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return ProfileDialog(user: user);
      },
      barrierDismissible: false,
    );
  }

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            child: Center(child: Icon(Icons.person_outline)),
          ),
        ],
      ),
    );
  }
}
