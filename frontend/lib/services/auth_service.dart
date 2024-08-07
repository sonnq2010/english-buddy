import 'package:frontend/repositories/auth_repo.dart';
import 'package:frontend/repositories/user_repo.dart';

class AuthService {
  AuthService._();
  static final _instance = AuthService._();
  static AuthService get I => _instance;

  final _repo = const AuthRepo();
  final _userRepo = const UserRepo();

  Future<String?> getIdToken() async {
    final user = await _userRepo.getCurrentUser();
    return user?.idToken;
  }

  Future<bool> signUp({
    required String userName,
    required String password,
    required String confirmPassword,
  }) async {
    userName = userName.trim();
    if (userName.isEmpty) return false;
    if (userName.contains(' ')) return false;

    password = password.trim();
    if (password.isEmpty) return false;
    if (password.contains(' ')) return false;

    if (confirmPassword != password) return false;

    final user = await _repo.signUp(userName: userName, password: password);
    if (user == null) return false;
    return true;
  }

  Future<bool> signIn({
    required String userName,
    required String password,
  }) async {
    userName = userName.trim();
    if (userName.isEmpty) return false;

    password = password.trim();
    if (password.isEmpty) return false;

    final user = await _repo.signIn(userName: userName, password: password);
    if (user == null) return false;

    await _userRepo.putCurrentUser(user);
    return true;
  }

  Future<void> signOut() async {
    await _userRepo.deleteToken();
  }
}
