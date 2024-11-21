import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/hover_builder.dart';

class SignInSignUpDialog extends StatefulWidget {
  const SignInSignUpDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const SignInSignUpDialog();
      },
      barrierDismissible: false,
    );
  }

  @override
  State<SignInSignUpDialog> createState() => _SignInSignUpDialogState();
}

class _SignInSignUpDialogState extends State<SignInSignUpDialog> {
  bool _isSignIn = true;
  String errorMessage = '';
  String successMessage = '';
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _comfirmPasswordController = TextEditingController();

  void setErrorMessage(String message) {
    errorMessage = message;
    successMessage = '';
  }

  void setSuccessMessage(String message) {
    successMessage = message;
    errorMessage = '';
  }

  Future<void> signIn() async {
    final ok = await AuthService.I.signIn(
      userName: _userNameController.text,
      password: _passwordController.text,
    );
    if (!ok) {
      setState(() {
        setErrorMessage('Wrong username or password');
      });
      return;
    }
    if (!mounted) return;

    Navigator.pop(context);
  }

  Future<void> signUp() async {
    final ok = await AuthService.I.signUp(
      userName: _userNameController.text,
      password: _passwordController.text,
      confirmPassword: _comfirmPasswordController.text,
    );
    if (!ok) {
      setState(() {
        setErrorMessage('Invalid sign up information');
      });
      return;
    }

    _passwordController.clear();
    _comfirmPasswordController.clear();
    setState(() {
      setSuccessMessage("Sign up successfully! Please sign in again.");
      _isSignIn = !_isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _isSignIn ? 'Sign in' : 'Sign up',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _userNameController,
            decoration: const InputDecoration(
              labelText: 'User name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
            onSubmitted: (value) {
              if (_isSignIn) {
                signIn();
              } else {
                signUp();
              }
            },
          ),
          const SizedBox(height: 16),
          _PasswordField(
            labelText: 'Password',
            controller: _passwordController,
            onSubmitted: (value) {
              if (_isSignIn) {
                signIn();
              } else {
                signUp();
              }
            },
          ),
          if (!_isSignIn) ...[
            const SizedBox(height: 16),
            _PasswordField(
              labelText: 'Confirm password',
              controller: _comfirmPasswordController,
              onSubmitted: (value) {
                if (_isSignIn) {
                  signIn();
                } else {
                  signUp();
                }
              },
            ),
          ],
          if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          if (successMessage.isNotEmpty)
            Text(
              successMessage,
              style: const TextStyle(color: Colors.green),
            ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _isSignIn = !_isSignIn;
              });
            },
            child: HoverBuilder(
              builder: (isHovered) {
                return Text(
                  _isSignIn
                      ? 'Does not have account? Sign up here'
                      : 'Already have account? Sign in here',
                  style: TextStyle(
                    decoration: isHovered ? TextDecoration.underline : null,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_isSignIn) {
                signIn();
              } else {
                signUp();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              minimumSize: const Size.fromHeight(40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _isSignIn ? 'Sign in' : 'Sign up',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text("OR"),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Continue as guess'),
          )
        ],
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.labelText,
    required this.controller,
    required this.onSubmitted,
  });

  final String labelText;
  final TextEditingController controller;
  final void Function(String value) onSubmitted;

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
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      onSubmitted: widget.onSubmitted,
    );
  }
}
