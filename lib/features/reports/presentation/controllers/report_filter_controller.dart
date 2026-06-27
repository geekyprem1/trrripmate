import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';
import 'package:tripmate/features/reports/domain/entities/report_filter.dart';

part 'report_filter_controller.g.dart';

/// Holds the current [ReportFilter] for a trip's Reports screen (UI/UX §3.15).
/// Transient screen state, scoped per trip and auto-disposed.
@riverpod
class ReportFilterController extends _$ReportFilterController {
  @override
  ReportFilter build(String tripId) => const ReportFilter();

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(start: start, end: end);
  }

  void setMember(String? memberId) {
    state = state.copyWith(memberId: memberId);
  }

  void setCategory(ExpenseCategory? category) {
    state = state.copyWith(category: category);
  }

  void clear() => state = const ReportFilter();
}
