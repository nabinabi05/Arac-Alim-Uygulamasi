import 'local_db_service.dart';

class AuthApiService {
  final _db = LocalDbService();

  /// Yeni kullanıcı kaydı. Dönen id > 0 ise başarılı.
  Future<bool> register(String email, String password) async {
    final exists = await _db.getUser(email);
    if (exists != null) return false;
    final id = await _db.createUser(email, password);
    if (id > 0) {
      await _db.saveSession(id);
      return true;
    }
    return false;
  }

  /// Giriş: email & şifre eşleşirse session kaydedilir.
  Future<bool> login(String email, String password) async {
    final u = await _db.getUser(email);
    if (u != null && u['password'] == password) {
      await _db.saveSession(u['id'] as int);
      return true;
    }
    return false;
  }

  /// Aktif oturum var mı?
  Future<bool> isLoggedIn() async {
    return (await _db.getSession()) != null;
  }

  /// Çıkış yap (session temizle)
  Future<void> logout() async {
    await _db.clearSession();
  }
}
