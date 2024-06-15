import 'package:flutter/material.dart';

class SignInSignUpDialog extends StatefulWidget {
  const SignInSignUpDialog({super.key});

  @override
  State<SignInSignUpDialog> createState() => _SignInSignUpDialogState();
}

class _SignInSignUpDialogState extends State<SignInSignUpDialog> {
  final bool _isSignIn = true;
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_getTitle()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _userNameController,
            decoration: const InputDecoration(
              labelText: 'User name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          const SizedBox(height: 16),
          _PasswordField(controller: _passwordController),
        ],
      ),
    );
  }

  String _getTitle() {
    if (_isSignIn) {
      return 'Sign in';
    }
    return 'Sign up';
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<_PasswordField> createState() => __PasswordFieldState();
}

class __PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      enableSuggestions: false,
      autocorrect: false,
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
