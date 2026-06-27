import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/core/error/failure.dart';

/// Maps expense RPC/data errors to typed [Failure]s (CLAUDE.md §6, API §13).
Failure mapExpenseError(Object error) {
  if (error is PostgrestException) {
    final message = error.message.toUpperCase();
    if (message.contains('EXPENSE_AMOUNT_INVALID')) {
      return const Failure.validation(
        message: 'Amount must be greater than zero.',
        field: 'amount',
      );
    }
    if (message.contains('EXPENSE_SPLIT_MISMATCH')) {
      return const Failure.validation(
        message: 'Splits must add up to the total amount.',
        field: 'splits',
      );
    }
    if (message.contains('EXPENSE_STATUS_INVALID')) {
      return const Failure.conflict(
        message: 'This expense was already reviewed.',
      );
    }
    if (message.contains('EXPENSE_SETTLED_LOCKED')) {
      return const Failure.conflict(
        message: 'This expense is part of a completed settlement.',
      );
    }
    if (message.contains('CONFLICT_VERSION')) {
      return const Failure.conflict();
    }
    if (message.contains('PERMISSION') || error.code == '42501') {
      return const Failure.permission();
    }
    return Failure.unknown(message: error.message);
  }
  if (error is StorageException) {
    return Failure.storage(message: error.message);
  }
  return const Failure.network();
}
