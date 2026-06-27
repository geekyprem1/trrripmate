import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/features/members/data/datasources/invite_remote_data_source.dart';
import 'package:tripmate/features/members/data/datasources/member_dao.dart';
import 'package:tripmate/features/members/data/datasources/member_remote_data_source.dart';
import 'package:tripmate/features/members/data/repositories/member_repository_impl.dart';
import 'package:tripmate/features/members/domain/entities/member.dart';
import 'package:tripmate/features/members/domain/repositories/member_repository.dart';

part 'member_providers.g.dart';

@Riverpod(keepAlive: true)
MemberDao memberDao(Ref ref) => MemberDao(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
MemberRemoteDataSource memberRemoteDataSource(Ref ref) {
  return MemberRemoteDataSource(ref.watch(supabaseClientProvider));
}

@Riverpod(keepAlive: true)
InviteRemoteDataSource inviteRemoteDataSource(Ref ref) {
  return InviteRemoteDataSource(ref.watch(supabaseClientProvider));
}

@Riverpod(keepAlive: true)
MemberRepository memberRepository(Ref ref) {
  final repository = MemberRepositoryImpl(
    dao: ref.watch(memberDaoProvider),
    remote: ref.watch(memberRemoteDataSourceProvider),
    invites: ref.watch(inviteRemoteDataSourceProvider),
    logger: ref.watch(appLoggerProvider),
  );
  ref.onDispose(repository.dispose);
  return repository;
}

/// Roster stream for a trip (UI/UX §3.12).
@riverpod
Stream<List<Member>> tripMembers(Ref ref, String tripId) {
  final repo = ref.watch(memberRepositoryProvider);
  // Start roster ingest for this trip upon observation (Architecture §9).
  Future.microtask(() => repo.refreshMembers(tripId));
  return repo.watchMembers(tripId);
}
