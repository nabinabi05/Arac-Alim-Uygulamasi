// File: lib/services/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

/// Yetkilendirme durumları
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? error;
  AuthState({required this.status, this.error});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(status: AuthStatus.initial));

  /// Giriş akışı: AuthService.login hem API isteğini yapar hem token'ı güvenli şekilde saklar.
  Future<void> login(String email, String password) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final success = await AuthService.login(email, password);
      if (success) {
        state = AuthState(status: AuthStatus.authenticated);
      } else {
        state = AuthState(status: AuthStatus.error, error: 'Giriş başarısız.');
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: e.toString());
    }
  }

  /// Kayıt akışı: yalnızca API çağrısı, token saklama login adımında olacak
  Future<void> register(String email, String password) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final success = await AuthService.register(email, password);
      if (success) {
        state = AuthState(status: AuthStatus.unauthenticated);
      } else {
        state = AuthState(status: AuthStatus.error, error: 'Kayıt başarısız.');
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: e.toString());
    }
  }

  /// Çıkış akışı: AuthService.logout token'ı siler
  Future<void> logout() async {
    await AuthService.logout();
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
