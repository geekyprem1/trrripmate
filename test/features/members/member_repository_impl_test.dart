import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/features/members/data/datasources/invite_remote_data_source.dart';
import 'package:tripmate/features/members/data/datasources/member_dao.dart';
import 'package:tripmate/features/members/data/datasources/member_remote_data_source.dart';
import 'package:tripmate/features/members/data/models/invitation_dto.dart';
import 'package:tripmate/features/members/data/repositories/member_repository_impl.dart';

class _MockMemberDao extends Mock implements MemberDao {}

class _MockMemberRemote extends Mock implements MemberRemoteDataSource {}

class _MockInviteRemote extends Mock implements InviteRemoteDataSource {}

void main() {
  late _MockMemberDao dao;
  late _MockMemberRemote remote;
  late _MockInviteRemote invites;
  late MemberRepositoryImpl repo;

  setUp(() {
    dao = _MockMemberDao();
    remote = _MockMemberRemote();
    invites = _MockInviteRemote();

    // Default stubs for the refresh that follows successful mutations.
    when(() => remote.fetchMembers(any())).thenAnswer((_) async => []);
    when(() => remote.watchRosterChanges(any()))
        .thenAnswer((_) => const Stream<void>.empty());
    when(() => dao.replaceForTrip(any(), any())).thenAnswer((_) async {});

    repo = MemberRepositoryImpl(
      dao: dao,
      remote: remote,
      invites: invites,
      logger: AppLogger('off'),
    );
  });

  group('removeMember', () {
    test('returns success and refreshes when the RPC succeeds', () async {
      when(() => remote.removeMember(
            tripId: any(named: 'tripId'),
            memberId: any(named: 'memberId'),
          )).thenAnswer((_) async {});

      final result = await repo.removeMember(tripId: 't1', memberId: 'm2');

      expect(result.isSuccess, isTrue);
      verify(() => remote.removeMember(tripId: 't1', memberId: 'm2')).called(1);
    });

    test('maps a dues block to a validation failure', () async {
      when(() => remote.removeMember(
            tripId: any(named: 'tripId'),
            memberId: any(named: 'memberId'),
          )).thenThrow(const PostgrestException(message: 'MEMBER_HAS_DUES'));

      final result = await repo.removeMember(tripId: 't1', memberId: 'm2');

      expect(result.failureOrNull, isA<ValidationFailure>());
    });
  });

  group('acceptInvite', () {
    test('returns the joined trip id on success', () async {
      when(() => invites.acceptInvite('code123'))
          .thenAnswer((_) async => 'trip-1');

      final result = await repo.acceptInvite('code123');

      expect(result.valueOrNull, 'trip-1');
    });

    test('maps an expired invite to a validation failure', () async {
      when(() => invites.acceptInvite(any()))
          .thenThrow(const PostgrestException(message: 'INVITE_EXPIRED'));

      final result = await repo.acceptInvite('old');

      expect(result.failureOrNull, isA<ValidationFailure>());
    });
  });

  group('createInvite', () {
    test('returns the invitation on success', () async {
      when(() => invites.createInvite(
            tripId: any(named: 'tripId'),
            email: any(named: 'email'),
            phone: any(named: 'phone'),
          )).thenAnswer(
        (_) async => InvitationDto(
          id: 'i1',
          tripId: 't1',
          code: 'XYZ',
          status: 'pending',
          expiresAt: DateTime(2026, 7, 8),
        ),
      );

      final result = await repo.createInvite(tripId: 't1');

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.code, 'XYZ');
    });
  });
}
