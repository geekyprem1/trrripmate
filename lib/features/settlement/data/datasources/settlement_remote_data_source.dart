import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/features/settlement/data/models/settlement_dto.dart';

/// Supabase access for settlements (API §3.4/§4.8). The invariant-bearing
/// mark-paid write goes through an RPC (CLAUDE.md §12). Only this source touches
/// the SDK.
class SettlementRemoteDataSource {
  SettlementRemoteDataSource(this._client);

  static const _table = 'settlements';

  final SupabaseClient _client;

  /// Records a payment as completed (owner or debtor); upserts so an offline
  /// client-created ledger entry materializes server-side. Idempotent.
  Future<SettlementDto> markPaid(Map<String, dynamic> params) async {
    final result = await _client.rpc<dynamic>(
      'mark_settlement_paid',
      params: params,
    );
    return SettlementDto.fromJson(_asRow(result));
  }

  /// Pulls all completed (non-deleted) settlements for a trip.
  Future<List<SettlementDto>> fetchCompleted(String tripId) async {
    final rows = await _client
        .from(_table)
        .select()
        .eq('trip_id', tripId)
        .eq('status', 'completed')
        .isFilter('deleted_at', null);
    return rows.map(SettlementDto.fromJson).toList();
  }

  /// Realtime signal for settlement changes on a trip (Architecture §9).
  Stream<void> watchSettlementChanges(String tripId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('trip_id', tripId)
        .map((_) {});
  }

  Map<String, dynamic> _asRow(dynamic result) {
    if (result is Map<String, dynamic>) return result;
    if (result is List && result.isNotEmpty) {
      return result.first as Map<String, dynamic>;
    }
    throw const PostgrestException(message: 'Unexpected settlement RPC response');
  }
}
