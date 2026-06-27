import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/features/auth/domain/entities/auth_user.dart';
import 'package:tripmate/features/auth/domain/entities/user_profile.dart';

/// Domain boundary for authentication (PRD REQ-AUTH-01/02, API §2).
///
/// Implementations live in `data/`. No exceptions cross this boundary — every
/// mutating method returns a [Result] (CLAUDE.md §5/§6).
abstract interface class AuthRepository {
  /// Emits the current [AuthUser] (or `null` when signed out) and every change.
  Stream<AuthUser?> authStateChanges();

  /// The currently authenticated user, if any (synchronous, from cache).
  AuthUser? get currentUser;

  /// Email + password sign-in.
  Future<Result<AuthUser>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Email + password account creation.
  Future<Result<AuthUser>> signUpWithEmail({
    required String email,
    required String password,
  });

  /// Requests an SMS OTP for [phone] (E.164).
  Future<Result<void>> requestPhoneOtp({required String phone});

  /// Verifies the SMS [token] for [phone] and signs in.
  Future<Result<AuthUser>> verifyPhoneOtp({
    required String phone,
    required String token,
  });

  /// Native Google sign-in via OpenID id-token exchange.
  Future<Result<AuthUser>> signInWithGoogle();

  /// Native Apple sign-in via OpenID id-token exchange (iOS).
  Future<Result<AuthUser>> signInWithApple();

  /// Signs the user out and clears the persisted session.
  Future<Result<void>> signOut();

  /// Loads the current user's profile, or `null` if none exists yet
  /// (i.e. onboarding is required).
  Future<Result<UserProfile?>> fetchMyProfile();

  /// Creates or updates the current user's profile (post-auth obligation,
  /// API §2.2).
  Future<Result<UserProfile>> upsertProfile({
    required String displayName,
    required String username,
    String? avatarUrl,
  });

  /// Finds a user profile by their unique [username] (case-insensitive).
  /// Returns `null` wrapped in success when no user matches.
  Future<Result<UserProfile?>> findUserByUsername(String username);
}
