import 'dart:convert';

import 'package:frontend/models/dto/update_profile_dto.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repositories/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  const UserRepo();
  static const _idKey = 'user_id_key';
  static const _nameKey = 'user_name_key';
  static const _isAdminKey = 'is_admin_key';
  static const _tokenKey = 'user_token_key';

  static const _profileNameKey = 'profile_name_key';
  static const _profileAvatarKey = 'profile_avatar_key';
  static const _profileGenderKey = 'profile_gender_key';
  static const _profileExpectedGenderKey = 'profile_expected_gender_key';
  static const _profileLevelKey = 'profile_level_key';
  static const _profileExpectedLevelKey = 'profile_expected_level_key';

  Future<User?> getCurrentUser() async {
    final pref = await SharedPreferences.getInstance();
    final id = pref.getString(_idKey);
    final userName = pref.getString(_nameKey);
    final isAdmin = pref.getBool(_isAdminKey);
    final idToken = pref.getString(_tokenKey);

    if (id == null) return null;
    if (userName == null) return null;
    if (isAdmin == null) return null;
    if (idToken == null) return null;

    final name = pref.getString(_profileNameKey);
    final avatar = pref.getString(_profileAvatarKey);
    final gender = pref.getString(_profileGenderKey);
    final expectedGender = pref.getString(_profileExpectedGenderKey);
    final level = pref.getString(_profileLevelKey);
    final expectedLevel = pref.getString(_profileExpectedLevelKey);

    return User(
      id: id,
      userName: userName,
      isAdmin: isAdmin,
      idToken: idToken,
      profile: Profile(
        name: name ?? userName,
        avatar: avatar,
        gender: gender,
        expectedGender: expectedGender,
        level: level,
        expectedLevel: expectedLevel,
      ),
    );
  }

  Future<void> putCurrentUser(User user) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_idKey, user.id);
    await pref.setString(_nameKey, user.userName);
    await pref.setBool(_isAdminKey, user.isAdmin);
    await pref.setString(_tokenKey, user.idToken);

    // Set profile
    final profile = user.profile;
    await pref.setString(_profileNameKey, profile.name);
    if (profile.avatar != null) {
      await pref.setString(_profileAvatarKey, profile.avatar!);
    }
    if (profile.gender != null) {
      await pref.setString(_profileGenderKey, profile.gender!);
    }
    if (profile.expectedGender != null) {
      await pref.setString(_profileExpectedGenderKey, profile.expectedGender!);
    }
    if (profile.level != null) {
      await pref.setString(_profileLevelKey, profile.level!);
    }
    if (profile.expectedLevel != null) {
      await pref.setString(_profileExpectedLevelKey, profile.expectedLevel!);
    }
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

  Future<void> updateUser(UpdateProfileDto dto) async {
    final token = await getToken();
    final body = jsonEncode(dto.toJson());
    ApiClient.I.put(
      '/profile',
      body: body,
      idToken: token,
    );
  }
}
