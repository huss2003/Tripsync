import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_service.dart';

// Singleton auth service provider.
final authServiceProvider = Provider<AuthService>((_) => AuthService());

/// Auth state — idle / loading / logged-in / error.
enum AuthStatus { idle, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  const AuthState({this.status = AuthStatus.idle, this.errorMessage});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _auth;

  AuthNotifier(this._auth) : super(const AuthState());

  String? _verificationId;

  String? get verificationId => _verificationId;

  Future<void> sendOtp(String phone) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      _verificationId = await _auth.sendOtp(phone);
      state = const AuthState();
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    if (_verificationId == null) return;
    state = const AuthState(status: AuthStatus.loading);
    try {
      await _auth.verifyOtp(_verificationId!, smsCode);
      state = const AuthState(status: AuthStatus.authenticated);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});
