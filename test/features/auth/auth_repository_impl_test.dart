import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tripmate/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:tripmate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tripmate/features/auth/domain/entities/auth_user.dart';

class _MockAuthRemote extends Mock implements AuthRemoteDataSource {}

class _MockProfileRemote extends Mock implements ProfileRemoteDataSource {}

void main() {
  late _MockAuthRemote remote;
  late _MockProfileRemote profileRemote;
  late AuthRepositoryImpl repository;

  const user = AuthUser(id: 'u1', email: 'user@example.com');

  setUp(() {
    remote = _MockAuthRemote();
    profileRemote = _MockProfileRemote();
    repository = AuthRepositoryImpl(
      remote: remote,
      profileRemote: profileRemote,
      logger: AppLogger('off'),
    );
  });

  group('signInWithEmail', () {
    test('returns Success when the remote succeeds', () async {
      when(() => remote.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => user);

      final result = await repository.signInWithEmail(
        email: 'user@example.com',
        password: 'password1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, user);
    });

    test('maps AuthException to a typed AuthFailure (no throw)', () async {
      when(() => remote.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const AuthException('Invalid login credentials'));

      final result = await repository.signInWithEmail(
        email: 'user@example.com',
        password: 'wrong',
      );

      expect(result.isFailure, isTrue);
      final failure = result.failureOrNull;
      expect(failure, isA<AuthFailure>());
      expect((failure! as AuthFailure).code, 'AUTH_INVALID_CREDENTIALS');
    });
  });

  group('fetchMyProfile', () {
    test('fails with session-expired when there is no current user', () async {
      when(() => remote.currentUser).thenReturn(null);

      final result = await repository.fetchMyProfile();

      expect(result.isFailure, isTrue);
      expect(
          (result.failureOrNull! as AuthFailure).code, 'AUTH_SESSION_EXPIRED');
    });
  });
}
