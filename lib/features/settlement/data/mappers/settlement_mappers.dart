import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/features/settlement/data/models/settlement_dto.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement.dart';

/// Mapping between Drift rows, DTOs, and the domain [Settlement] (CLAUDE.md §5).
extension SettlementRowMapper on SettlementRow {
  Settlement toEntity() {
    return Settlement(
      id: id,
      tripId: tripId,
      fromMemberId: fromMemberId,
      toMemberId: toMemberId,
      amountMinor: amountMinor,
      status: _statusFromString(status),
      markedByMemberId: markedByMemberId,
      completedAt: completedAt,
      version: version,
      syncState: _syncStateFromString(syncStatus),
    );
  }

  /// Params for the `mark_settlement_paid` RPC (API §4.8). The client creates
  /// the ledger entry, so the upsert carries its full identity.
  Map<String, dynamic> toMarkPaidParams() {
    return {
      'p_id': id,
      'p_trip_id': tripId,
      'p_from_member_id': fromMemberId,
      'p_to_member_id': toMemberId,
      'p_amount': Money.minorToMajorString(amountMinor),
      'p_marked_by': markedByMemberId,
      'p_expected_version': version - 1,
    };
  }
}

SettlementRow settlementDtoToRow(SettlementDto dto) {
  return SettlementRow(
    id: dto.id,
    tripId: dto.tripId,
    fromMemberId: dto.fromMemberId,
    toMemberId: dto.toMemberId,
    amountMinor: dto.amountMinor,
    status: dto.status,
    markedByMemberId: dto.markedByMemberId,
    completedAt: dto.completedAt,
    createdAt: dto.updatedAt,
    updatedAt: dto.updatedAt,
    deletedAt: dto.deletedAt,
    version: dto.version,
    syncStatus: 'synced',
  );
}

SettlementStatus _statusFromString(String value) {
  return switch (value) {
    'pending' => SettlementStatus.pending,
    _ => SettlementStatus.completed,
  };
}

String settlementStatusToString(SettlementStatus status) => status.name;

SettlementSyncState _syncStateFromString(String value) {
  return switch (value) {
    'pending' => SettlementSyncState.pending,
    'failed' => SettlementSyncState.failed,
    _ => SettlementSyncState.synced,
  };
}
