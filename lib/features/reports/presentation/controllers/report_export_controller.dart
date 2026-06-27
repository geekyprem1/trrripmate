import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/features/reports/data/report_providers.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';

part 'report_export_controller.g.dart';

/// Drives the "Export PDF" action (UI/UX §3.15). Exposes loading via the
/// AsyncValue (the button shows a spinner) and returns the [Failure] on error
/// (null on success) so the screen can offer retry.
@riverpod
class ReportExportController extends _$ReportExportController {
  @override
  Future<void> build() async {}

  Future<Failure?> export({
    required ReportData data,
    required String tripName,
    required String currency,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(reportRepositoryProvider).exportPdf(
          data: data,
          tripName: tripName,
          currency: currency,
        );
    state = const AsyncData(null);
    return result.failureOrNull;
  }
}
