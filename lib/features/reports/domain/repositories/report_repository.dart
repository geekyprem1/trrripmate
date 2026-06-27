import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';

/// Domain boundary for report export (REQ-REP-01). PDF generation is local and
/// offline-capable; no exceptions cross this boundary.
//
// Kept as a repository interface for layering + test fakes (Architecture §3,
// CLAUDE.md §5) even though v1.0 exposes a single method.
// ignore: one_member_abstracts
abstract interface class ReportRepository {
  /// Renders [data] to a PDF off the UI isolate and opens the share sheet
  /// (UI/UX §3.15). Returns a typed failure on generation/share error.
  Future<Result<void>> exportPdf({
    required ReportData data,
    required String tripName,
    required String currency,
  });
}
