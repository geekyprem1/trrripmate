import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/sync/sync_handler.dart';
import 'package:tripmate/core/sync/sync_types.dart';
import 'package:tripmate/features/settlement/data/datasources/settlement_dao.dart';
import 'package:tripmate/features/settlement/data/datasources/settlement_remote_data_source.dart';
import 'package:tripmate/features/settlement/data/mappers/settlement_mappers.dart';

/// Pushes queued settlement operations to the backend (Architecture §6).
///
/// v1.0 only records completed payments: the mark-paid op upserts the ledger
/// entry server-side via RPC, keyed by the client-generated row id, so replays
/// are idempotent (CLAUDE.md §14).
class SettlementSyncHandler implements SyncHandler {
  SettlementSyncHandler({
    required SettlementDao dao,
    required SettlementRemoteDataSource remote,
  })  : _dao = dao,
        _remote = remote;

  final SettlementDao _dao;
  final SettlementRemoteDataSource _remote;

  @override
  String get entityType => SyncEntityType.settlement;

  @override
  Future<void> push(SyncQueueRow item) async {
    final row = await _dao.getSettlement(item.entityId);
    if (row == null) return;

    switch (item.operation) {
      case SettlementSyncOp.markPaid:
        final saved = await _remote.markPaid(row.toMarkPaidParams());
        await _dao.markSynced(row.id, version: saved.version);
    }
  }
}
