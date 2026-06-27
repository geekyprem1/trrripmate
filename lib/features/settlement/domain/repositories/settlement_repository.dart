import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement.dart';

/// Domain boundary for settlements (PRD REQ-SET-01/02, API §4.7/§4.8).
///
/// The outstanding who-pays-who graph is computed (not stored); only completed
/// payments are persisted. Marking paid commits locally and returns before
/// syncing (CLAUDE.md §5/§14). No exceptions cross this boundary.
abstract interface class SettlementRepository {
  /// Completed payments recorded for a trip — the ledger that net balances are
  /// adjusted by. Reactive from the local store.
  Stream<List<Settlement>> watchCompleted(String tripId);

  /// Records a [transaction] as paid: writes a completed ledger entry locally
  /// and queues it for sync. Idempotent by row id (CLAUDE.md §14). Permission
  /// (owner or the debtor) is enforced server-side; the client checks for UX.
  Future<Result<void>> markPaid(Settlement transaction);

  /// Pulls completed settlements from the backend into the cache and keeps it
  /// in sync via realtime (Architecture §9). Safe to call offline.
  Future<void> refreshFromRemote(String tripId);
}
