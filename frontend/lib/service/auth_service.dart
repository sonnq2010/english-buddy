import 'package:frontend/models/user.dart';
import 'package:frontend/repository/auth_repo.dart';

class AuthService {
  AuthService._();
  static final _instance = AuthService._();
  static AuthService get I => _instance;

  final _repo = const AuthRepo();
  User? _currentUser;

  Future<User?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;

    final token = await _repo.getToken();
    if (token == null) return null;

    _currentUser = User(id: '', userName: 'test', idToken: token);
    return _currentUser;
  }

  Future<bool> signIn({
    required String userName,
    required String password,
  }) async {
    userName = userName.trim();
    if (userName.isEmpty) return false;

    password = password.trim();
    if (password.isEmpty) return false;

    // TODO: Call API to sign in
    return true;
  }

  Future<bool> signUp({
    required String userName,
    required String password,
    required String confirmPassword,
  }) async {
    userName = userName.trim();
    if (userName.isEmpty) return false;

    password = password.trim();
    if (password.isEmpty) return false;

    if (confirmPassword != password) return false;

    // TODO: Call API to sign in
    return true;
  }
}
