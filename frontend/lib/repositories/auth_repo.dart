import 'dart:convert';

import 'package:frontend/models/user.dart';
import 'package:frontend/repositories/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  const AuthRepo();

  static const _key = 'id_token';
  static const _basePath = '/auth';

  static Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_key);
  }

  static Future<void> putToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_key, token);
  }

  static Future<void> deleteToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_key);
  }

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
