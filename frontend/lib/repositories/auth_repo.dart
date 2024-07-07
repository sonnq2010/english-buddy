import 'dart:convert';

import 'package:frontend/models/user.dart';
import 'package:frontend/repositories/api_client.dart';

class AuthRepo {
  const AuthRepo();

  static const _basePath = '/auth';

  Future<User?> signUp({
    required String userName,
    required String password,
  }) async {
    const path = '$_basePath/register';
    final body = jsonEncode({
      'username': userName,
      'password': password,
      'confirmPassword': password,
    });

    final response = await ApiClient.I.post(path, body: body);
    if (response == null) return null;
    if (response.hasError) return null;
    return User.fromJson(response.data);
  }

  Future<User?> signIn({
    required String userName,
    required String password,
  }) async {
    const path = '$_basePath/login';
    final body = jsonEncode({
      'username': userName,
      'password': password,
    });

    final response = await ApiClient.I.post(path, body: body);
    if (response == null) return null;
    if (response.hasError) return null;
    return User.fromJson(response.data);
  }
}
