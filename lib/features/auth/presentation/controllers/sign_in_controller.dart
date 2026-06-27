import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/auth/domain/entities/auth_user.dart';
import 'package:tripmate/features/auth/domain/repositories/auth_repository.dart';

part 'sign_in_controller.g.dart';

/// Drives the Sign In screen (UI/UX §3.2). Holds an [AsyncValue] for the submit
/// state (loading/error); on success the GoRouter redirect reacts to the auth
/// state change automatically (Architecture §8).
@riverpod
class SignInController extends _$SignInController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> signInWithEmail(String email, String password) {
    return _run(
      () => _repo.signInWithEmail(email: email.trim(), password: password),
    );
  }

  Future<void> signUpWithEmail(String email, String password) {
    return _run(
      () => _repo.signUpWithEmail(email: email.trim(), password: password),
    );
  }

  Future<void> signInWithGoogle() => _run(_repo.signInWithGoogle);

  Future<void> signInWithApple() => _run(_repo.signInWithApple);

  /// Requests an OTP; returns `true` so the screen can navigate to OTP entry.
  Future<bool> requestPhoneOtp(String phone) async {
    state = const AsyncValue.loading();
    final result = await _repo.requestPhoneOtp(phone: phone.trim());
    return result.fold(
      onSuccess: (_) {
        state = const AsyncValue.data(null);
        return true;
      },
      onFailure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
    );
  }

  Future<void> _run(Future<Result<AuthUser>> Function() body) async {
    state = const AsyncValue.loading();
    final result = await body();
    state = result.fold(
      onSuccess: (_) => const AsyncValue.data(null),
      onFailure: (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }
}
