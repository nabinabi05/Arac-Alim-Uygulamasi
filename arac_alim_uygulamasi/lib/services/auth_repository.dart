import 'auth_service.dart';

class AuthRepository {
  final _svc = AuthService();

  Future<bool> register(String email, String password) async {
    try {
      await _svc.register(email, password);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _svc.login(email, password);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isLoggedIn() => _svc.isLoggedIn();
  Future<void> logout() => _svc.logout();
}
