import 'package:frontend/models/user.dart';
import 'package:frontend/repositories/auth_repo.dart';

class AuthService {
  AuthService._();
  static final _instance = AuthService._();
  static AuthService get I => _instance;

  final _repo = const AuthRepo();
  User? _currentUser;
  String? _currentToken;

  Future<String?> getIdToken() async {
    if (_currentToken != null) return _currentToken;

    final token = await AuthRepo.getToken();
    if (token == null) return null;

    _currentToken = token;
    return _currentToken;
  }

  Future<User?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;

    final token = await AuthRepo.getToken();
    if (token == null) return null;

    _currentUser = User(id: '', userName: 'test', idToken: token);
    return _currentUser;
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
    return true;
  }
}
