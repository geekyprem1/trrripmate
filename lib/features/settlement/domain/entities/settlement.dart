import 'package:freezed_annotation/freezed_annotation.dart';

part 'settlement.freezed.dart';

/// Payment status of a settlement transaction (DB Design §4.7).
enum SettlementStatus { pending, completed }

/// Local sync state (Drift-only, DB Design §8).
enum SettlementSyncState { synced, pending, failed }

/// One "who pays who" transaction (DB Design §4.7). Money is integer minor
/// units. Outstanding transactions are computed (no [id] until marked paid);
/// completed payments are persisted and carry their stored [id]/[version].
@freezed
class Settlement with _$Settlement {
  const factory Settlement({
    required String tripId,
    required String fromMemberId,
    required String toMemberId,
    required int amountMinor,
    required SettlementStatus status,
    String? id,
    String? markedByMemberId,
    DateTime? completedAt,
    @Default(SettlementSyncState.synced) SettlementSyncState syncState,
    @Default(1) int version,
  }) = _Settlement;

  const Settlement._();

  bool get isCompleted => status == SettlementStatus.completed;

  bool get isPendingSync => syncState != SettlementSyncState.synced;
}
