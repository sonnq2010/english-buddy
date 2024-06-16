import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  const AuthRepo();

  static const _key = 'id_token';

  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_key);
  }

  Future<void> putToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_key, token);
  }

  Future<void> deleteToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_key);
  }
}
