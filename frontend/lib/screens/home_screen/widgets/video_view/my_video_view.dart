import 'package:flutter/material.dart';
import 'package:frontend/dialogs/profile_dialog.dart';
import 'package:frontend/dialogs/sign_in_sign_up_dialog.dart';
import 'package:frontend/services/user_services.dart';
import 'package:frontend/services/webrtc_service.dart';
import 'package:frontend/widgets/video_view.dart';

class MyVideoView extends StatelessWidget {
  const MyVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoView(videoRenderer: WebRTCService.I.localVideoRenderer),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent.withOpacity(0.2),
            ),
            onPressed: () {
              UserService.I.getCurrentUser().then((currentUser) {
                if (currentUser == null) {
                  SignInSignUpDialog.show(context);
                  return;
                }

                ProfileDialog.show(context, user: currentUser);
              });
            },
            icon: const Icon(
              Icons.person_outline,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
