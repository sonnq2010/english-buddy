import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/dropdown_button.dart';
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
          _UserAvatarAndName(user: widget.user),
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
                values: const {
                  Gender.all: '',
                  Gender.male: 'Male',
                  Gender.female: 'Female',
                },
                onChanged: (value) {},
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
                initialValue: Gender.all,
                values: const {
                  Gender.all: '',
                  Gender.male: 'Male',
                  Gender.female: 'Female',
                },
                onChanged: (value) {},
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
                values: const {
                  EnglishLevel.all: '',
                  EnglishLevel.a1: 'A1',
                  EnglishLevel.a2: 'A2',
                  EnglishLevel.b1: 'B1',
                  EnglishLevel.b2: 'B2',
                  EnglishLevel.c1: 'C1',
                  EnglishLevel.c2: 'C2',
                },
                onChanged: (value) {},
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
                initialValue: EnglishLevel.all,
                values: const {
                  EnglishLevel.all: '',
                  EnglishLevel.a1: 'A1',
                  EnglishLevel.a2: 'A2',
                  EnglishLevel.b1: 'B1',
                  EnglishLevel.b2: 'B2',
                  EnglishLevel.c1: 'C1',
                  EnglishLevel.c2: 'C2',
                },
                onChanged: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserAvatarAndName extends StatefulWidget {
  const _UserAvatarAndName({required this.user});

  final User user;

  @override
  State<_UserAvatarAndName> createState() => _UserAvatarAndNameState();
}

class _UserAvatarAndNameState extends State<_UserAvatarAndName> {
  late User user;
  late TextEditingController userNameController;

  late ImagePicker picker;

  Image? image;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    userNameController = TextEditingController(text: user.userName);

    picker = ImagePicker();
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
      user.updateWith(userName: userNameController.text);
      isEditing = false;
    });

    // TODO: Call api to save new user
  }

  void pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    final bytes = pickedImage.readAsBytes();
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
                  const CircleAvatar(
                    radius: 24,
                    child: Center(
                      child: Icon(
                        Icons.person_outline,
                        size: 32,
                      ),
                    ),
                  ),
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
        const CircleAvatar(
          radius: 24,
          child: Center(
            child: Icon(
              Icons.person_outline,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          user.userName,
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
