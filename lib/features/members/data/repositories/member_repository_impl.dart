import 'dart:async';

import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/features/members/data/datasources/invite_remote_data_source.dart';
import 'package:tripmate/features/members/data/datasources/member_dao.dart';
import 'package:tripmate/features/members/data/datasources/member_remote_data_source.dart';
import 'package:tripmate/features/members/data/member_error_mapper.dart';
import 'package:tripmate/features/members/data/models/member_dto.dart';
import 'package:tripmate/features/members/domain/entities/invitation.dart';
import 'package:tripmate/features/members/domain/entities/member.dart';
import 'package:tripmate/features/members/domain/repositories/member_repository.dart';

/// [MemberRepository] implementation. Roster reads stream from the local cache;
/// invitations and removal are online operations (offline rules §14). No
/// exceptions cross this boundary (CLAUDE.md §6).
class MemberRepositoryImpl implements MemberRepository {
  MemberRepositoryImpl({
    required MemberDao dao,
    required MemberRemoteDataSource remote,
    required InviteRemoteDataSource invites,
    required AppLogger logger,
  })  : _dao = dao,
        _remote = remote,
        _invites = invites,
        _logger = logger;

  static const _tag = 'members';

  final MemberDao _dao;
  final MemberRemoteDataSource _remote;
  final InviteRemoteDataSource _invites;
  final AppLogger _logger;

  final Map<String, StreamSubscription<void>> _rosterSubs = {};

  @override
  Stream<List<Member>> watchMembers(String tripId) {
    return _dao
        .watchMembers(tripId)
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<void> refreshMembers(String tripId) async {
    await _pull(tripId);
    _rosterSubs[tripId] ??= _remote.watchRosterChanges(tripId).listen(
          (_) => unawaited(_pull(tripId)),
          onError: (Object error, StackTrace _) =>
              _logger.warning(_tag, 'roster stream error: $error'),
        );
  }

  Future<void> _pull(String tripId) async {
    try {
      final dtos = await _remote.fetchMembers(tripId);
      await _dao.replaceForTrip(tripId, dtos.map((d) => d.toRow()).toList());
    } catch (error) {
      _logger.warning(_tag, 'refreshMembers unavailable: $error');
    }
  }

  @override
  Future<Result<void>> removeMember({
    required String tripId,
    required String memberId,
  }) async {
    try {
      await _remote.removeMember(tripId: tripId, memberId: memberId);
      await _pull(tripId);
      return const Result.success(null);
    } catch (error, stackTrace) {
      return _fail('removeMember', error, stackTrace);
    }
  }

  @override
  Future<Result<Invitation>> createInvite({
    required String tripId,
    InviteTarget? target,
  }) async {
    try {
      final dto = await _invites.createInvite(
        tripId: tripId,
        email: target?.email,
        phone: target?.phone,
      );
      return Result.success(dto.toEntity());
    } catch (error, stackTrace) {
      return _fail('createInvite', error, stackTrace);
    }
  }

  @override
  Future<Result<InvitePreview>> previewInvite(String code) async {
    try {
      final dto = await _invites.previewInvite(code);
      return Result.success(dto.toEntity());
    } catch (error, stackTrace) {
      return _fail('previewInvite', error, stackTrace);
    }
  }

  @override
  Future<Result<String>> acceptInvite(String code) async {
    try {
      final tripId = await _invites.acceptInvite(code);
      unawaited(refreshMembers(tripId));
      return Result.success(tripId);
    } catch (error, stackTrace) {
      return _fail('acceptInvite', error, stackTrace);
    }
  }

  @override
  Future<Result<void>> rejectInvite(String code) async {
    try {
      await _invites.rejectInvite(code);
      return const Result.success(null);
    } catch (error, stackTrace) {
      return _fail('rejectInvite', error, stackTrace);
    }
  }

  Future<void> dispose() async {
    for (final sub in _rosterSubs.values) {
      await sub.cancel();
    }
    _rosterSubs.clear();
  }

  Result<T> _fail<T>(String action, Object error, StackTrace stackTrace) {
    final failure = mapMemberError(error);
    _logger.error(_tag, '$action failed', error: error, stackTrace: stackTrace);
    return Result.failure(failure);
  }
}
