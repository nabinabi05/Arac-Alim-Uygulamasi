// lib/services/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';

/// Represents the current authentication status.
enum AuthStatus { initial, loading, authenticated, error }

/// Holds auth state including possible error message.
class AuthState {
  final AuthStatus status;
  final String? error;

  AuthState({this.status = AuthStatus.initial, this.error});
}

/// Manages authentication flow and state via Riverpod.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository = AuthRepository();

  AuthNotifier() : super(AuthState());

  /// Performs login and updates state accordingly.
  Future<void> login(String email, String password) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final success = await _repository.login(email, password);
      if (success) {
        state = AuthState(status: AuthStatus.authenticated);
      } else {
        state = AuthState(status: AuthStatus.error, error: 'Geçersiz kullanıcı bilgileri');
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: e.toString());
    }
  }

  /// Logs out and resets state.
  Future<void> logout() async {
    await _repository.logout();
    state = AuthState(status: AuthStatus.initial);
  }

  /// Checks existing login on startup.
  Future<void> checkAuth() async {
    final loggedIn = await _repository.isLoggedIn();
    if (loggedIn) {
      state = AuthState(status: AuthStatus.authenticated);
    }
  }
}

/// Riverpod provider for auth.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
