import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/dropdown_button.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/user_services.dart';
import 'package:frontend/services/webrtc_service.dart';
import 'package:frontend/utils/image_util.dart';
import 'package:frontend/widgets/hover_builder.dart';
import 'package:image_picker/image_picker.dart';

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
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  void signOut() {
    AuthService.I.signOut();
    WebRTCService.I.tryStop();
    Navigator.pop(context);
  }

  void save() {
    UserService.I.updateProfile(user);
    Navigator.pop(context);
  }

  void onUserNameAndAvatarChanged(User newUser) {
    setState(() {
      user = newUser;
    });
  }

  void onGenderChanged(Gender? gender) {
    if (gender == null) return;
    setState(() {
      user = user.copyWith(gender: gender.name);
    });
  }

  void onExpectedGenderChanged(Gender? gender) {
    if (gender == null) return;
    setState(() {
      user = user.copyWith(expectedGender: gender.name);
    });
  }

  void onLevelChanged(EnglishLevel? level) {
    if (level == null) return;
    setState(() {
      user = user.copyWith(level: level.name);
    });
  }

  void onExpectedLevelChanged(EnglishLevel? level) {
    if (level == null) return;
    setState(() {
      user = user.copyWith(expectedLevel: level.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _UserAvatarAndName(
            user: user,
            onChanged: onUserNameAndAvatarChanged,
          ),
          const SizedBox(height: 24),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 160,
                child: Text('You are:'),
              ),
              const SizedBox(width: 8),
              CustomizeDropdownButton<Gender>(
                initialValue: Gender.fromString(user.profile.gender),
                values: const {
                  Gender.all: '',
                  Gender.male: 'Male',
                  Gender.female: 'Female',
                },
                onChanged: onGenderChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 160,
                child: Text('You are looking for:'),
              ),
              const SizedBox(width: 8),
              CustomizeDropdownButton<Gender>(
                initialValue: Gender.fromString(user.profile.expectedGender),
                values: const {
                  Gender.all: '',
                  Gender.male: 'Male',
                  Gender.female: 'Female',
                },
                onChanged: onExpectedGenderChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 160,
                child: Text('Your English level:'),
              ),
              const SizedBox(width: 8),
              CustomizeDropdownButton<EnglishLevel>(
                initialValue: EnglishLevel.fromString(user.profile.level),
                values: const {
                  EnglishLevel.all: '',
                  EnglishLevel.a1: 'A1',
                  EnglishLevel.a2: 'A2',
                  EnglishLevel.b1: 'B1',
                  EnglishLevel.b2: 'B2',
                  EnglishLevel.c1: 'C1',
                  EnglishLevel.c2: 'C2',
                },
                onChanged: onLevelChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 160,
                child: Text('You want to match with:'),
              ),
              const SizedBox(width: 8),
              CustomizeDropdownButton<EnglishLevel>(
                initialValue: EnglishLevel.fromString(
                  user.profile.expectedLevel,
                ),
                values: const {
                  EnglishLevel.all: '',
                  EnglishLevel.a1: 'A1',
                  EnglishLevel.a2: 'A2',
                  EnglishLevel.b1: 'B1',
                  EnglishLevel.b2: 'B2',
                  EnglishLevel.c1: 'C1',
                  EnglishLevel.c2: 'C2',
                },
                onChanged: onExpectedLevelChanged,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Sign out',
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserAvatarAndName extends StatefulWidget {
  const _UserAvatarAndName({
    required this.user,
    required this.onChanged,
  });

  final User user;
  final void Function(User user) onChanged;

  @override
  State<_UserAvatarAndName> createState() => _UserAvatarAndNameState();
}

class _UserAvatarAndNameState extends State<_UserAvatarAndName> {
  late User user;
  late TextEditingController userNameController;
  late ImagePicker picker;

  Image? userAvatar;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    userNameController = TextEditingController(text: user.profile.name);
    picker = ImagePicker();

    if (user.profile.avatar != null) {
      userAvatar = ImageUtil.imageFromBase64String(user.profile.avatar!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
  }

  void edit() {
    setState(() {
      isEditing = true;
    });
  }

  void save() {
    setState(() {
      user = user.copyWith(name: userNameController.text);
      isEditing = false;
    });
    widget.onChanged(user);
  }

  void pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    final bytes = await pickedImage.readAsBytes();
    final base64String = ImageUtil.base64StringFromBytes(bytes);

    setState(() {
      userAvatar = ImageUtil.imageFromBase64String(base64String);
      user = user.copyWith(avatar: base64String);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return _buildEditing();
    } else {
      return _buildReadonly();
    }
  }

  Widget _buildEditing() {
    return Row(
      children: [
        HoverBuilder(
          cursor: SystemMouseCursors.click,
          builder: (isHovered) {
            return GestureDetector(
              onTap: pickImage,
              child: Stack(
                children: [
                  if (userAvatar == null) ...[
                    const CircleAvatar(
                      radius: 24,
                      child: Center(
                        child: Icon(
                          Icons.person_outline,
                          size: 32,
                        ),
                      ),
                    ),
                  ] else ...[
                    CircleAvatar(
                      radius: 24,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Center(child: userAvatar),
                      ),
                    ),
                  ],
                  if (isHovered) ...[
                    CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      radius: 24,
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        Flexible(
          child: TextField(
            controller: userNameController,
            decoration: const InputDecoration(
              labelText: 'User name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: save,
          icon: const Icon(Icons.check),
        ),
      ],
    );
  }

  Widget _buildReadonly() {
    return Row(
      children: [
        if (userAvatar == null) ...[
          const CircleAvatar(
            radius: 24,
            child: Center(
              child: Icon(
                Icons.person_outline,
                size: 32,
              ),
            ),
          ),
        ] else ...[
          CircleAvatar(
            radius: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Center(child: userAvatar),
            ),
          ),
        ],
        const SizedBox(width: 12),
        Text(
          user.profile.name,
          style: const TextStyle(fontSize: 20),
        ),
        const Spacer(),
        IconButton(
          onPressed: edit,
          icon: const Icon(Icons.edit_outlined),
        ),
      ],
    );
  }
}
