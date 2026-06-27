import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/core/error/failure.dart';

/// Maps member/invite RPC errors to typed [Failure]s (CLAUDE.md §6, API §13).
/// The RPCs raise application codes (e.g. `INVITE_EXPIRED`) as exception text.
Failure mapMemberError(Object error) {
  if (error is PostgrestException) {
    final message = error.message.toUpperCase();
    if (message.contains('INVITE_EXPIRED')) {
      return const Failure.validation(
        message: 'This invitation has expired. Ask for a new one.',
        field: 'invite',
      );
    }
    if (message.contains('INVITE_INVALID') || message.contains('NOT_FOUND')) {
      return const Failure.validation(
        message: 'This invitation is no longer valid.',
        field: 'invite',
      );
    }
    if (message.contains('INVITE_DUPLICATE')) {
      return const Failure.validation(
        message: 'That person already has a pending invite.',
        field: 'invite',
      );
    }
    if (message.contains('ALREADY_MEMBER')) {
      return const Failure.validation(
          message: 'Already a member of this trip.');
    }
    if (message.contains('MEMBER_HAS_DUES')) {
      return const Failure.validation(
        message: "Settle this member's balance before removing them.",
      );
    }
    if (message.contains('TRIP_ARCHIVED')) {
      return const Failure.validation(message: 'This trip is archived.');
    }
    if (message.contains('PERMISSION') || error.code == '42501') {
      return const Failure.permission();
    }
    return Failure.unknown(message: error.message);
  }
  return const Failure.network();
}
