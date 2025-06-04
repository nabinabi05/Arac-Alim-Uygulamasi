/// lib/repositories/iauth.dart

abstract class IAuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String email, String password);
  Future<void> logout();
}
