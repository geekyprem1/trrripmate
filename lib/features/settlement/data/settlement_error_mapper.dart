import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/core/error/failure.dart';

/// Maps settlement RPC/data errors to typed [Failure]s (CLAUDE.md §6, API §13).
Failure mapSettlementError(Object error) {
  if (error is PostgrestException) {
    final message = error.message.toUpperCase();
    if (message.contains('CONFLICT_VERSION')) {
      return const Failure.conflict();
    }
    if (message.contains('SETTLEMENT_STATUS_INVALID')) {
      return const Failure.conflict(
        message: 'This payment was already recorded.',
      );
    }
    if (message.contains('PERMISSION') || error.code == '42501') {
      return const Failure.permission(
        message: 'Only the payer or trip owner can mark this paid.',
      );
    }
    return Failure.unknown(message: error.message);
  }
  return const Failure.network();
}
