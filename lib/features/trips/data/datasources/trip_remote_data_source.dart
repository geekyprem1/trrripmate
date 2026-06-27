import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/features/trips/data/models/trip_dto.dart';

/// Supabase access for trips (API §3.2/§4). Only this source touches the SDK
/// (CLAUDE.md §12). Throws on error; the caller maps to typed failures.
class TripRemoteDataSource {
  TripRemoteDataSource(this._client);

  static const _table = 'trips';

  final SupabaseClient _client;

  /// Creates a trip via the `create_trip` RPC (enforces quota + owner
  /// membership server-side, API §4.1). Returns the saved row.
  Future<TripDto> createTrip(Map<String, dynamic> params) async {
    final result = await _client.rpc<dynamic>('create_trip', params: params);
    return TripDto.fromJson(_asRow(result));
  }

  /// Edits / archives a trip via PostgREST under RLS (API §3.2).
  Future<TripDto> updateTrip(String id, Map<String, dynamic> fields) async {
    final row = await _client
        .from(_table)
        .update(fields)
        .eq('id', id)
        .select()
        .single();
    return TripDto.fromJson(row);
  }

  /// Soft-deletes a trip via the `delete_trip` RPC (API §4.2).
  Future<void> deleteTrip(String id) async {
    await _client.rpc<dynamic>('delete_trip', params: {'p_trip_id': id});
  }

  /// Realtime stream of the current user's trips (Architecture §9). Emits an
  /// initial snapshot, then every change visible under RLS.
  Stream<List<TripDto>> watchTrips() {
    return _client.from(_table).stream(
        primaryKey: ['id']).map((rows) => rows.map(TripDto.fromJson).toList());
  }

  Map<String, dynamic> _asRow(dynamic result) {
    if (result is Map<String, dynamic>) return result;
    if (result is List && result.isNotEmpty) {
      return result.first as Map<String, dynamic>;
    }
    throw const PostgrestException(message: 'Unexpected create_trip response');
  }
}
