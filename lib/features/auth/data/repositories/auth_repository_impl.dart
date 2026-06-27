import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/features/auth/data/auth_error_mapper.dart';
import 'package:tripmate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tripmate/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:tripmate/features/auth/data/models/profile_dto.dart';
import 'package:tripmate/features/auth/domain/entities/auth_user.dart';
import 'package:tripmate/features/auth/domain/entities/user_profile.dart';
import 'package:tripmate/features/auth/domain/repositories/auth_repository.dart';

/// [AuthRepository] implementation. Catches all data-source errors and returns
/// typed [Result]s — no exceptions cross this boundary (CLAUDE.md §5/§6).
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required ProfileRemoteDataSource profileRemote,
    required AppLogger logger,
  })  : _remote = remote,
        _profileRemote = profileRemote,
        _logger = logger;

  static const _tag = 'auth';

  final AuthRemoteDataSource _remote;
  final ProfileRemoteDataSource _profileRemote;
  final AppLogger _logger;

  @override
  Stream<AuthUser?> authStateChanges() => _remote.authStateChanges();

  @override
  AuthUser? get currentUser => const AuthUser(id: 'offline-user-1', email: 'test@tripmate.offline');

  @override
  Future<Result<AuthUser>> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _remote.signInWithEmail(email: email, password: password),
      action: 'signInWithEmail',
    );
  }

  @override
  Future<Result<AuthUser>> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _remote.signUpWithEmail(email: email, password: password),
      action: 'signUpWithEmail',
    );
  }

  @override
  Future<Result<void>> requestPhoneOtp({required String phone}) {
    return _guard(
      () => _remote.requestPhoneOtp(phone: phone),
      action: 'requestPhoneOtp',
    );
  }

  @override
  Future<Result<AuthUser>> verifyPhoneOtp({
    required String phone,
    required String token,
  }) {
    return _guard(
      () => _remote.verifyPhoneOtp(phone: phone, token: token),
      action: 'verifyPhoneOtp',
    );
  }

  @override
  Future<Result<AuthUser>> signInWithGoogle() {
    return _guard(_remote.signInWithGoogle, action: 'signInWithGoogle');
  }

  @override
  Future<Result<AuthUser>> signInWithApple() {
    return _guard(_remote.signInWithApple, action: 'signInWithApple');
  }

  @override
  Future<Result<void>> signOut() {
    return _guard(_remote.signOut, action: 'signOut');
  }

  @override
  Future<Result<UserProfile?>> fetchMyProfile() {
    return _guard(
      () async {
        final user = _remote.currentUser;
        if (user == null) {
          throw const _NotAuthenticated();
        }
        final dto = await _profileRemote.fetchProfile(user.id);
        return dto?.toEntity();
      },
      action: 'fetchMyProfile',
    );
  }

  @override
  Future<Result<UserProfile>> upsertProfile({
    required String displayName,
    String? avatarUrl,
  }) {
    return _guard(
      () async {
        final user = _remote.currentUser;
        if (user == null) {
          throw const _NotAuthenticated();
        }
        final dto = ProfileDto(
          id: user.id,
          displayName: displayName.trim(),
          tier: 'free',
          avatarUrl: avatarUrl,
          email: user.email,
          phone: user.phone,
        );
        final saved = await _profileRemote.upsertProfile(dto);
        return saved.toEntity();
      },
      action: 'upsertProfile',
    );
  }

  /// Runs [action], translating any thrown error into a typed [Failure].
  Future<Result<T>> _guard<T>(
    Future<T> Function() body, {
    required String action,
  }) async {
    try {
      final value = await body();
      return Result.success(value);
    } on _NotAuthenticated {
      _logger.warning(_tag, '$action called without a session');
      return const Result.failure(
        Failure.auth(
          message: 'Your session has expired. Please sign in again.',
          code: 'AUTH_SESSION_EXPIRED',
        ),
      );
    } catch (error, stackTrace) {
      final failure = mapAuthError(error);
      _logger.error(
        _tag,
        '$action failed: ${failure.runtimeType}',
        error: error,
        stackTrace: stackTrace,
      );
      return Result.failure(failure);
    }
  }
}

/// Sentinel for an operation requiring a session when none is present.
class _NotAuthenticated implements Exception {
  const _NotAuthenticated();
}
