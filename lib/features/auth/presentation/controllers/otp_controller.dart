import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';

part 'otp_controller.g.dart';

/// Drives the OTP verification screen (UI/UX §3.3). On success the router
/// redirect reacts to the auth state change.
@riverpod
class OtpController extends _$OtpController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> verify({required String phone, required String token}) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(authRepositoryProvider)
        .verifyPhoneOtp(phone: phone, token: token.trim());
    state = result.fold(
      onSuccess: (_) => const AsyncValue.data(null),
      onFailure: (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }

  /// Resends the OTP. Returns `true` on success.
  Future<bool> resend(String phone) async {
    final result =
        await ref.read(authRepositoryProvider).requestPhoneOtp(phone: phone);
    return result.isSuccess;
  }
}
