import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';

part 'report_data.freezed.dart';

/// One category's share of the total (PRD §12 Category Breakdown). [fraction] is
/// in [0, 1]; money is integer minor units.
@freezed
class CategorySlice with _$CategorySlice {
  const factory CategorySlice({
    required ExpenseCategory category,
    required int amountMinor,
    required double fraction,
  }) = _CategorySlice;
}

/// A member's spend position (PRD §12 Spend by Member): what they [paidMinor]
/// out of pocket vs what they [owedMinor] as their split shares.
@freezed
class MemberSpend with _$MemberSpend {
  const factory MemberSpend({
    required String memberId,
    required String memberName,
    required int paidMinor,
    required int owedMinor,
  }) = _MemberSpend;
}

/// A single day's spend on the timeline (PRD §12 Timeline). [cumulativeMinor] is
/// the running total up to and including [date].
@freezed
class TimelinePoint with _$TimelinePoint {
  const factory TimelinePoint({
    required DateTime date,
    required int dailyMinor,
    required int cumulativeMinor,
  }) = _TimelinePoint;
}

/// Aggregated report over the filtered, approved expenses (REQ-REP-01). Plain
/// immutable data — safe to send to a background isolate for PDF generation.
@freezed
class ReportData with _$ReportData {
  const factory ReportData({
    @Default(0) int totalMinor,
    @Default(0) int expenseCount,
    @Default(<CategorySlice>[]) List<CategorySlice> categories,
    @Default(<MemberSpend>[]) List<MemberSpend> members,
    @Default(<TimelinePoint>[]) List<TimelinePoint> timeline,
  }) = _ReportData;

  const ReportData._();

  bool get isEmpty => expenseCount == 0;
}
