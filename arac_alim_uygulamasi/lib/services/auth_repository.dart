// lib/services/auth_repository.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:/lib/services/auth_service.dart';

class AuthRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Attempts to log in using AuthService.
  Future<bool> login(String email, String password) async {
    final success = await AuthService.login(email, password);
    return success;
  }

  /// Logs out by clearing stored tokens.
  Future<void> logout() async {
    await AuthService.logout();
  }

  /// Reads the access token from secure storage.
  Future<String?> getToken() async {
    return await _storage.read(key: 'access');
  }

  /// Checks if a valid token exists.
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}