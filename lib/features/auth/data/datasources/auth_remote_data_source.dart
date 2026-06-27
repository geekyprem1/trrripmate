import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// Hide Supabase's AuthUser so the domain entity name is unambiguous.
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import 'package:tripmate/features/auth/domain/entities/auth_user.dart';

/// Wraps Supabase Auth and the native social SDKs (API §2).
///
/// Only this remote source touches the Supabase/Google/Apple SDKs
/// (CLAUDE.md §12). It throws on error; the repository maps to typed failures.
class AuthRemoteDataSource {
  AuthRemoteDataSource({
    required SupabaseClient client,
    required String googleServerClientId,
    GoogleSignIn? googleSignIn,
  })  : _client = client,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: const ['email', 'profile'],
              serverClientId:
                  googleServerClientId.isEmpty ? null : googleServerClientId,
            );

  final SupabaseClient _client;
  final GoogleSignIn _googleSignIn;

  GoTrueClient get _auth => _client.auth;

  AuthUser? get currentUser => _mapUser(_auth.currentUser);

  /// Emits the mapped user on every auth state change.
  Stream<AuthUser?> authStateChanges() {
    return _auth.onAuthStateChange.map(
      (state) => _mapUser(state.session?.user),
    );
  }

  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final res =
        await _auth.signInWithPassword(email: email, password: password);
    return _requireUser(res.user);
  }

  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final res = await _auth.signUp(email: email, password: password);
    return _requireUser(res.user);
  }

  Future<void> requestPhoneOtp({required String phone}) {
    return _auth.signInWithOtp(phone: phone);
  }

  Future<AuthUser> verifyPhoneOtp({
    required String phone,
    required String token,
  }) async {
    final res = await _auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
    return _requireUser(res.user);
  }

  Future<AuthUser> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthException('Google sign-in was cancelled.');
    }
    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw const AuthException('Missing Google ID token.');
    }
    final res = await _auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );
    return _requireUser(res.user);
  }

  Future<AuthUser> signInWithApple() async {
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );
    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException('Missing Apple identity token.');
    }
    final res = await _auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
    return _requireUser(res.user);
  }

  Future<void> signOut() async {
    // Best-effort native sign-out so the next attempt shows the picker.
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  AuthUser _requireUser(User? user) {
    final mapped = _mapUser(user);
    if (mapped == null) {
      throw const AuthException('Authentication did not return a user.');
    }
    return mapped;
  }

  AuthUser? _mapUser(User? user) {
    if (user == null) return null;
    return AuthUser(id: user.id, email: user.email, phone: user.phone);
  }

  String _generateNonce([int length = 32]) {
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
