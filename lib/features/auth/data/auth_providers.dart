import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tripmate/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:tripmate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tripmate/features/auth/domain/entities/auth_user.dart';
import 'package:tripmate/features/auth/domain/entities/user_profile.dart';
import 'package:tripmate/features/auth/domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final config = ref.watch(appConfigProvider);
  return AuthRemoteDataSource(
    client: ref.watch(supabaseClientProvider),
    googleServerClientId: config.googleServerClientId,
  );
}

@Riverpod(keepAlive: true)
ProfileRemoteDataSource profileRemoteDataSource(Ref ref) {
  return ProfileRemoteDataSource(ref.watch(supabaseClientProvider));
}

/// The auth repository — the only auth entry point for presentation
/// (CLAUDE.md §3/§5).
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    profileRemote: ref.watch(profileRemoteDataSourceProvider),
    logger: ref.watch(appLoggerProvider),
  );
}

/// Reactive auth state for the router and UI (Architecture §8).
@Riverpod(keepAlive: true)
Stream<AuthUser?> authState(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}

/// Whether the signed-in user already has a profile. Drives onboarding routing
/// (PRD §3.4 / UI/UX §3.4). Recomputes whenever auth state changes.
@Riverpod(keepAlive: true)
Future<bool> profileStatus(Ref ref) async {
  final user = await ref.watch(authStateProvider.future);
  if (user == null) return false;
  final result = await ref.read(authRepositoryProvider).fetchMyProfile();
  return result.fold(onSuccess: (p) => p != null, onFailure: (_) => false);
}

/// Current user's full profile — used in Settings for QR display and
/// anywhere the display name or username is needed.
@Riverpod(keepAlive: true)
Future<UserProfile?> myProfile(Ref ref) async {
  // Re-fetch when auth state changes.
  await ref.watch(authStateProvider.future);
  final result = await ref.read(authRepositoryProvider).fetchMyProfile();
  return result.fold(onSuccess: (p) => p, onFailure: (_) => null);
}
