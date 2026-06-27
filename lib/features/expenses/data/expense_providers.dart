import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/core/sync/sync_providers.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/expenses/data/datasources/expense_dao.dart';
import 'package:tripmate/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:tripmate/features/expenses/data/datasources/receipt_capture_service.dart';
import 'package:tripmate/features/expenses/data/datasources/receipt_remote_data_source.dart';
import 'package:tripmate/features/expenses/data/expense_sync_handler.dart';
import 'package:tripmate/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/domain/repositories/expense_repository.dart';
import 'package:tripmate/features/members/data/member_providers.dart';

part 'expense_providers.g.dart';

@Riverpod(keepAlive: true)
ExpenseDao expenseDao(Ref ref) => ExpenseDao(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
ExpenseRemoteDataSource expenseRemoteDataSource(Ref ref) {
  return ExpenseRemoteDataSource(ref.watch(supabaseClientProvider));
}

@Riverpod(keepAlive: true)
ReceiptRemoteDataSource receiptRemoteDataSource(Ref ref) {
  return ReceiptRemoteDataSource(ref.watch(supabaseClientProvider));
}

@Riverpod(keepAlive: true)
ReceiptCaptureService receiptCaptureService(Ref ref) {
  return ReceiptCaptureService();
}

/// Expense sync handler, registered with the engine via [syncHandlersProvider]
/// override in the composition root (Architecture §6).
@Riverpod(keepAlive: true)
ExpenseSyncHandler expenseSyncHandler(Ref ref) {
  return ExpenseSyncHandler(
    dao: ref.watch(expenseDaoProvider),
    remote: ref.watch(expenseRemoteDataSourceProvider),
    receipts: ref.watch(receiptRemoteDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
ExpenseRepository expenseRepository(Ref ref) {
  final repository = ExpenseRepositoryImpl(
    dao: ref.watch(expenseDaoProvider),
    memberDao: ref.watch(memberDaoProvider),
    queueDao: ref.watch(syncQueueDaoProvider),
    remote: ref.watch(expenseRemoteDataSourceProvider),
    receipts: ref.watch(receiptRemoteDataSourceProvider),
    syncEngine: ref.watch(syncEngineProvider),
    authRepository: ref.watch(authRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
  ref.onDispose(repository.dispose);
  return repository;
}

/// All non-deleted expenses for a trip (UI/UX §3.8).
@riverpod
Stream<List<Expense>> tripExpenses(Ref ref, String tripId) {
  final repo = ref.watch(expenseRepositoryProvider);
  Future.microtask(() => repo.refreshFromRemote(tripId));
  return repo.watchExpenses(tripId);
}

/// Pending expenses awaiting approval (Approval Queue, UI/UX §3.11).
@riverpod
Stream<List<Expense>> pendingExpenses(Ref ref, String tripId) {
  return ref.watch(expenseRepositoryProvider).watchPending(tripId);
}

/// A single expense with its splits (Expense Detail, UI/UX §3.10).
@riverpod
Stream<Expense?> expenseById(Ref ref, String expenseId) {
  return ref.watch(expenseRepositoryProvider).watchExpense(expenseId);
}

/// Reactive approved spend in minor units, feeding the budget (PRD REQ-BUD-01).
@riverpod
Stream<int> approvedSpentMinor(Ref ref, String tripId) {
  return ref.watch(expenseRepositoryProvider).watchApprovedSpentMinor(tripId);
}

/// Approved expenses with splits — the public input to settlement balance
/// computation (PRD REQ-SET-01). Cross-feature reads go through this provider
/// (a feature's public API), not the expenses data layer.
@riverpod
Stream<List<Expense>> approvedExpensesDetailed(Ref ref, String tripId) {
  return ref.watch(expenseRepositoryProvider).watchApprovedWithSplits(tripId);
}
