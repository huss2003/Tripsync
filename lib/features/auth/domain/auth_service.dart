import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Single auth facade — Firebase phone auth → Supabase session.
final class AuthService {
  final fb.FirebaseAuth _firebaseAuth;
  final SupabaseClient _supabase;

  AuthService({fb.FirebaseAuth? firebaseAuth, SupabaseClient? supabase})
      : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _supabase = supabase ?? Supabase.instance.client;

  bool get isSignedIn => _firebaseAuth.currentUser != null;

  /// Send OTP to [phone]. Returns verificationId for the next step.
  Future<String> sendOtp(String phone) async {
    final completer = Completer<String>();
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (_) {},
      verificationFailed: (e) => completer.completeError(e),
      codeSent: (id, _) => completer.complete(id),
      codeAutoRetrievalTimeout: (_) {},
    );
    return completer.future;
  }

  /// Verify [smsCode] against [verificationId], then exchange
  /// Firebase ID token for a Supabase session via auth-bridge.
  Future<void> verifyOtp(String verificationId, String smsCode) async {
    final credential = fb.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final result = await _firebaseAuth.signInWithCredential(credential);
    final idToken = await result.user!.getIdToken();
    final res = await _supabase.functions.invoke('auth-bridge',
        body: {'firebase_id_token': idToken});
    final session = Map<String, dynamic>.from(res.data);
    // Store the Supabase session.
    await _supabase.auth.setSession(session['refresh_token'] as String,
        accessToken: session['access_token'] as String);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await _firebaseAuth.signOut();
  }
}
