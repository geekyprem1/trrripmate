import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_balance.freezed.dart';

/// A member's net position in a trip (PRD REQ-SET-01), in integer minor units.
///
/// [netMinor] > 0 → the member is **owed** money (creditor); < 0 → the member
/// **owes** money (debtor); 0 → settled. By the zero-sum invariant the net of
/// all members sums to exactly zero.
@freezed
class MemberBalance with _$MemberBalance {
  const factory MemberBalance({
    required String memberId,
    required int netMinor,
  }) = _MemberBalance;

  const MemberBalance._();

  bool get isCreditor => netMinor > 0;

  bool get isDebtor => netMinor < 0;

  bool get isSettled => netMinor == 0;
}
