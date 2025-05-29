import 'local_db_service.dart';

class AuthService {
  final _db = LocalDbService();

  /// Registers locally; throws if the user already exists.
  Future<void> register(String email, String password) async {
    final existing = await _db.getUser(email);
    if (existing != null) {
      throw Exception('User already exists');
    }
    final id = await _db.createUser(email, password);
    await _db.saveSession(id);
  }

  /// Logs in locally; throws on bad credentials.
  Future<void> login(String email, String password) async {
    final user = await _db.getUser(email);
    if (user == null || user['password'] != password) {
      throw Exception('Invalid email or password');
    }
    await _db.saveSession(user['id'] as int);
  }

  /// True if someone is “logged in” in our session table.
  Future<bool> isLoggedIn() async {
    return (await _db.getSession()) != null;
  }

  /// Clears the local session.
  Future<void> logout() async {
    await _db.clearSession();
  }
}
