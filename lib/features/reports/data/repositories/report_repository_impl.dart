import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/features/reports/data/report_pdf_builder.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';
import 'package:tripmate/features/reports/domain/repositories/report_repository.dart';

/// Builds report PDF bytes from a [ReportPdfRequest]. Defaults to running
/// [buildReportPdf] on a background isolate (CLAUDE.md §10).
typedef PdfBytesBuilder = Future<Uint8List> Function(ReportPdfRequest request);

/// Opens the platform share sheet for the generated [bytes].
typedef PdfSharer = Future<void> Function(Uint8List bytes, String filename);

Future<Uint8List> _isolateBuilder(ReportPdfRequest request) =>
    compute(buildReportPdf, request);

Future<void> _printingSharer(Uint8List bytes, String filename) =>
    Printing.sharePdf(bytes: bytes, filename: filename);

/// Offline PDF export (REQ-REP-01). Generation happens off the UI isolate; the
/// share sheet surfaces the result. No network — works fully offline.
class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl({
    required AppLogger logger,
    PdfBytesBuilder builder = _isolateBuilder,
    PdfSharer sharer = _printingSharer,
    DateTime Function() clock = DateTime.now,
  })  : _logger = logger,
        _builder = builder,
        _sharer = sharer,
        _clock = clock;

  static const _tag = 'reports';

  final AppLogger _logger;
  final PdfBytesBuilder _builder;
  final PdfSharer _sharer;
  final DateTime Function() _clock;

  @override
  Future<Result<void>> exportPdf({
    required ReportData data,
    required String tripName,
    required String currency,
  }) async {
    if (data.isEmpty) {
      return const Result.failure(
        Failure.validation(message: 'There is nothing to export yet.'),
      );
    }

    try {
      final bytes = await _builder(
        ReportPdfRequest(
          data: data,
          tripName: tripName,
          currency: currency,
          generatedAt: _clock(),
        ),
      );
      await _sharer(bytes, _fileName(tripName));
      return const Result.success(null);
    } catch (error, stackTrace) {
      _logger.error(_tag, 'PDF export failed',
          error: error, stackTrace: stackTrace);
      return const Result.failure(
        Failure.storage(message: 'Could not create the PDF. Please retry.'),
      );
    }
  }

  String _fileName(String tripName) {
    final slug = tripName
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final base = slug.isEmpty ? 'trip' : slug;
    return '$base-report.pdf';
  }
}
