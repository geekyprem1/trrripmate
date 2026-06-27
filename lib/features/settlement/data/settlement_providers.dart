import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/core/sync/sync_providers.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/members/data/member_providers.dart';
import 'package:tripmate/features/settlement/data/datasources/settlement_dao.dart';
import 'package:tripmate/features/settlement/data/datasources/settlement_remote_data_source.dart';
import 'package:tripmate/features/settlement/data/repositories/settlement_repository_impl.dart';
import 'package:tripmate/features/settlement/data/settlement_sync_handler.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement_summary.dart';
import 'package:tripmate/features/settlement/domain/repositories/settlement_repository.dart';
import 'package:tripmate/features/settlement/domain/settlement_calculator.dart';

part 'settlement_providers.g.dart';

@Riverpod(keepAlive: true)
SettlementDao settlementDao(Ref ref) {
  return SettlementDao(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
SettlementRemoteDataSource settlementRemoteDataSource(Ref ref) {
  return SettlementRemoteDataSource(ref.watch(supabaseClientProvider));
}

/// Settlement sync handler, registered with the engine via [syncHandlersProvider]
/// override in the composition root (Architecture §6).
@Riverpod(keepAlive: true)
SettlementSyncHandler settlementSyncHandler(Ref ref) {
  return SettlementSyncHandler(
    dao: ref.watch(settlementDaoProvider),
    remote: ref.watch(settlementRemoteDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
SettlementRepository settlementRepository(Ref ref) {
  final repository = SettlementRepositoryImpl(
    dao: ref.watch(settlementDaoProvider),
    memberDao: ref.watch(memberDaoProvider),
    queueDao: ref.watch(syncQueueDaoProvider),
    remote: ref.watch(settlementRemoteDataSourceProvider),
    syncEngine: ref.watch(syncEngineProvider),
    authRepository: ref.watch(authRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
  ref.onDispose(repository.dispose);
  return repository;
}

/// Completed payments (the settlement ledger) for a trip.
@riverpod
Stream<List<Settlement>> completedSettlements(Ref ref, String tripId) {
  final repo = ref.watch(settlementRepositoryProvider);
  Future.microtask(() => repo.refreshFromRemote(tripId));
  return repo.watchCompleted(tripId);
}

/// The reactive settlement picture (balances + outstanding transactions),
/// recomputed whenever approved expenses, members, or completed payments change
/// (PRD REQ-SET-01 — recompute on changes; auto-reopen). Composes other
/// features' public providers (the accepted cross-feature API).
@riverpod
SettlementSummary tripSettlementSummary(Ref ref, String tripId) {
  final expenses =
      ref.watch(approvedExpensesDetailedProvider(tripId)).valueOrNull ??
          const [];
  final completed =
      ref.watch(completedSettlementsProvider(tripId)).valueOrNull ?? const [];
  final members = ref.watch(tripMembersProvider(tripId)).valueOrNull ?? const [];
  final userId = ref.watch(authStateProvider).valueOrNull?.id;

  final currentMemberId = userId == null
      ? null
      : members
          .where((m) => m.userId == userId)
          .map((m) => m.id)
          .cast<String?>()
          .firstWhere((_) => true, orElse: () => null);

  return SettlementCalculator.summarize(
    approvedExpenses: expenses,
    completedSettlements: completed,
    activeMemberIds: members.map((m) => m.id).toList(),
    currentMemberId: currentMemberId,
  );
}
