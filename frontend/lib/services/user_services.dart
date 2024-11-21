import 'package:frontend/models/dto/update_profile_dto.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repositories/user_repo.dart';

class UserService {
  UserService._singleton();
  static final _instance = UserService._singleton();
  static UserService get I => _instance;

  final _repo = const UserRepo();

  Future<User?> getCurrentUser() async {
    final user = await _repo.getCurrentUser();
    return user;
  }

  Future<void> updateProfile(User user) async {
    final profile = user.profile;
    final dto = UpdateProfileDto(
      name: profile.name,
      avatar: profile.avatar,
      gender: profile.gender,
      expectedGender: profile.expectedGender,
      level: profile.level,
      expectedLevel: profile.expectedLevel,
    );

    _repo.putCurrentUser(user);
    await _repo.updateUser(dto);
  }
}
