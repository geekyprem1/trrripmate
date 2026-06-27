import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/auth/domain/entities/auth_user.dart';
import 'package:tripmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:tripmate/features/auth/presentation/controllers/sign_in_controller.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repo;

  const user = AuthUser(id: 'u1', email: 'user@example.com');

  setUp(() => repo = _MockAuthRepository());

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('starts in data state', () {
    final container = makeContainer();
    expect(
      container.read(signInControllerProvider),
      const AsyncData<void>(null),
    );
  });

  test('signInWithEmail resolves to data on success', () async {
    when(() => repo.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Result.success(user));

    final container = makeContainer();
    await container
        .read(signInControllerProvider.notifier)
        .signInWithEmail('user@example.com', 'password1');

    expect(container.read(signInControllerProvider).hasError, isFalse);
    expect(container.read(signInControllerProvider).isLoading, isFalse);
  });

  test('signInWithEmail surfaces failure as AsyncError', () async {
    when(() => repo.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer(
      (_) async => const Result.failure(
        Failure.auth(message: 'bad', code: 'AUTH_INVALID_CREDENTIALS'),
      ),
    );

    final container = makeContainer();
    await container
        .read(signInControllerProvider.notifier)
        .signInWithEmail('user@example.com', 'wrong');

    final state = container.read(signInControllerProvider);
    expect(state.hasError, isTrue);
    expect(state.error, isA<AuthFailure>());
  });

  test('requestPhoneOtp returns true on success', () async {
    when(() => repo.requestPhoneOtp(phone: any(named: 'phone')))
        .thenAnswer((_) async => const Result.success(null));

    final container = makeContainer();
    final sent = await container
        .read(signInControllerProvider.notifier)
        .requestPhoneOtp('+14155550123');

    expect(sent, isTrue);
  });
}
