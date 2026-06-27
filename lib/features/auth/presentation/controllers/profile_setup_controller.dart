import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';

part 'profile_setup_controller.g.dart';

/// Drives the Profile Setup / onboarding screen (UI/UX §3.4). On success it
/// invalidates [profileStatusProvider] so the router advances to Home.
@riverpod
class ProfileSetupController extends _$ProfileSetupController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> submit({
    required String displayName,
    required String username,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref.read(authRepositoryProvider).upsertProfile(
          displayName: displayName,
          username: username,
        );
    return result.fold(
      onSuccess: (_) {
        ref.invalidate(profileStatusProvider);
        ref.invalidate(myProfileProvider);
        state = const AsyncValue.data(null);
        return true;
      },
      onFailure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
    );
  }
}
