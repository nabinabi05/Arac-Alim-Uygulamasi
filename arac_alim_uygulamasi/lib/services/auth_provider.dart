import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? error;
  AuthState(this.status, [this.error]);
  @override
  String toString() => 'AuthState($status, err=$error)';
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo = AuthRepository();

  AuthNotifier() : super(AuthState(AuthStatus.initial)) {
    _init();
  }

  Future<void> _init() async {
    state = AuthState(AuthStatus.loading);
    try {
      final ok = await _repo.isLoggedIn();
      state = AuthState(ok ? AuthStatus.authenticated : AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(AuthStatus.error, e.toString());
    }
  }

  Future<void> register(String email, String password) async {
    state = AuthState(AuthStatus.loading);
    try {
      final success = await _repo.register(email, password);
      state = AuthState(success ? AuthStatus.authenticated : AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(AuthStatus.error, e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState(AuthStatus.loading);
    try {
      final success = await _repo.login(email, password);
      state = AuthState(success ? AuthStatus.authenticated : AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(AuthStatus.error, e.toString());
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = AuthState(AuthStatus.unauthenticated);
  }
}

/// Riverpod provider for your AuthNotifier
final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
