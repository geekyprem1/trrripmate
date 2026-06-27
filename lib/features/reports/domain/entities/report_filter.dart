import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';

part 'report_filter.freezed.dart';

/// Report filters (UI/UX §3.15, PRD §12): an optional inclusive date range, a
/// single member, and a single category. All null = no filtering.
@freezed
class ReportFilter with _$ReportFilter {
  const factory ReportFilter({
    DateTime? start,
    DateTime? end,
    String? memberId,
    ExpenseCategory? category,
  }) = _ReportFilter;

  const ReportFilter._();

  bool get isActive =>
      start != null || end != null || memberId != null || category != null;
}
