import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripmate/features/settlement/domain/entities/member_balance.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement.dart';

part 'settlement_summary.freezed.dart';

/// The full settlement picture for a trip (UI/UX §3.14): per-member net
/// balances, the minimal outstanding "who pays who" transactions, and the
/// current user's net for the headline summary.
@freezed
class SettlementSummary with _$SettlementSummary {
  const factory SettlementSummary({
    @Default(<MemberBalance>[]) List<MemberBalance> balances,
    @Default(<Settlement>[]) List<Settlement> transactions,

    /// The current user's net (minor units); 0 if they are not a member or are
    /// fully settled.
    @Default(0) int yourNetMinor,

    /// Whether any approved expense exists yet — distinguishes "nothing to
    /// settle" from "all settled".
    @Default(false) bool hasActivity,
  }) = _SettlementSummary;

  const SettlementSummary._();

  /// True once there are expenses but no outstanding transactions remain.
  bool get isAllSettled => hasActivity && transactions.isEmpty;

  /// True before any expense activity exists.
  bool get isEmpty => !hasActivity;
}
