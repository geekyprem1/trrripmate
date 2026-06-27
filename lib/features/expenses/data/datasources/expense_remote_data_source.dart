import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/features/expenses/data/models/expense_dto.dart';

/// Supabase access for expenses (API §3.3/§4.3-§4.6). Invariant-bearing writes
/// go through RPCs (CLAUDE.md §12). Only this source touches the SDK.
class ExpenseRemoteDataSource {
  ExpenseRemoteDataSource(this._client);

  static const _table = 'expenses';

  final SupabaseClient _client;

  Future<ExpenseDto> createExpense(Map<String, dynamic> params) async {
    final result = await _client.rpc<dynamic>('create_expense', params: params);
    return ExpenseDto.fromJson(_asRow(result));
  }

  Future<ExpenseDto> updateExpense(Map<String, dynamic> params) async {
    final result = await _client.rpc<dynamic>('update_expense', params: params);
    return ExpenseDto.fromJson(_asRow(result));
  }

  Future<void> deleteExpense(String id) async {
    await _client.rpc<dynamic>('delete_expense', params: {'p_id': id});
  }

  Future<ExpenseDto> setStatus(String id, String status) async {
    final result = await _client.rpc<dynamic>(
      'set_expense_status',
      params: {'p_id': id, 'p_status': status},
    );
    return ExpenseDto.fromJson(_asRow(result));
  }

  Future<void> setReceipt(String id, String path) async {
    await _client.rpc<dynamic>(
      'set_expense_receipt',
      params: {'p_expense_id': id, 'p_path': path},
    );
  }

  /// Pulls all non-deleted expenses for a trip with embedded splits.
  Future<List<ExpenseDto>> fetchExpenses(String tripId) async {
    final rows = await _client
        .from(_table)
        .select('*, expense_splits(member_id, share_amount)')
        .eq('trip_id', tripId)
        .isFilter('deleted_at', null);
    return rows.map(ExpenseDto.fromJson).toList();
  }

  /// Realtime signal for expense changes on a trip (Architecture §9).
  Stream<void> watchExpenseChanges(String tripId) {
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
    throw const PostgrestException(message: 'Unexpected expense RPC response');
  }
}
