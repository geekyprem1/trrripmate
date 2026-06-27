import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/members/data/member_providers.dart';
import 'package:tripmate/features/reports/data/repositories/report_repository_impl.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';
import 'package:tripmate/features/reports/domain/entities/report_filter.dart';
import 'package:tripmate/features/reports/domain/report_aggregator.dart';
import 'package:tripmate/features/reports/domain/repositories/report_repository.dart';

part 'report_providers.g.dart';

@Riverpod(keepAlive: true)
ReportRepository reportRepository(Ref ref) {
  return ReportRepositoryImpl(logger: ref.watch(appLoggerProvider));
}

/// The aggregated report for a trip under [filter], recomputed reactively as
/// approved expenses or members change (REQ-REP-01 realtime). Composes other
/// features' public providers (the accepted cross-feature API).
@riverpod
ReportData reportData(Ref ref, String tripId, ReportFilter filter) {
  final expenses =
      ref.watch(approvedExpensesDetailedProvider(tripId)).valueOrNull ??
          const [];
  final members = ref.watch(tripMembersProvider(tripId)).valueOrNull ?? const [];
  return ReportAggregator.aggregate(
    approvedExpenses: expenses,
    members: members,
    filter: filter,
  );
}
