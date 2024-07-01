import 'package:frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  const UserRepo();
  static const _idKey = 'user_id_key';
  static const _nameKey = 'user_name_key';
  static const _isAdminKey = 'is_admin_key';
  static const _avatarKey = 'user_avatar_key';
  static const _tokenKey = 'user_token_key';

  Future<User?> getCurrentUser() async {
    final pref = await SharedPreferences.getInstance();
    final id = pref.getString(_idKey);
    final name = pref.getString(_nameKey);
    final isAdmin = pref.getBool(_isAdminKey);
    // final avatar = pref.getString(_avatarKey);
    final idToken = pref.getString(_tokenKey);

    if (id == null) return null;
    if (name == null) return null;
    if (isAdmin == null) return null;
    // if (avatar == null) return null;
    if (idToken == null) return null;

    return User(
      id: id,
      userName: name,
      isAdmin: isAdmin,
      idToken: idToken,
    );
  }

  Future<void> putCurrentUser(User user) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_idKey, user.id);
    await pref.setString(_nameKey, user.userName);
    await pref.setBool(_isAdminKey, user.isAdmin);
    // await pref.setString(_avatarKey, user.avatar);
    await pref.setString(_tokenKey, user.idToken);
  }

  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_tokenKey);
  }

  Future<void> putToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_tokenKey, token);
  }

  Future<void> deleteToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_tokenKey);
  }
}
