import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';
import 'package:tripmate/features/reports/data/report_pdf_builder.dart';
import 'package:tripmate/features/reports/data/repositories/report_repository_impl.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';

ReportData _data() => const ReportData(
      totalMinor: 50000,
      expenseCount: 1,
      categories: [
        CategorySlice(
          category: ExpenseCategory.food,
          amountMinor: 50000,
          fraction: 1,
        ),
      ],
    );

void main() {
  test('empty data is rejected without building or sharing', () async {
    var built = false;
    var shared = false;
    final repo = ReportRepositoryImpl(
      logger: AppLogger('off'),
      builder: (_) async {
        built = true;
        return Uint8List(0);
      },
      sharer: (_, __) async => shared = true,
    );

    final result = await repo.exportPdf(
      data: const ReportData(),
      tripName: 'Goa',
      currency: 'INR',
    );

    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(built, isFalse);
    expect(shared, isFalse);
  });

  test('builds off-isolate then shares; filename slugged from trip', () async {
    ReportPdfRequest? captured;
    String? sharedName;
    final repo = ReportRepositoryImpl(
      logger: AppLogger('off'),
      builder: (request) async {
        captured = request;
        return Uint8List.fromList([1, 2, 3]);
      },
      sharer: (_, name) async => sharedName = name,
      clock: () => DateTime(2026, 7, 3),
    );

    final result = await repo.exportPdf(
      data: _data(),
      tripName: 'Goa Trip 2026!',
      currency: 'INR',
    );

    expect(result.isSuccess, isTrue);
    expect(captured?.tripName, 'Goa Trip 2026!');
    expect(captured?.currency, 'INR');
    expect(sharedName, 'goa-trip-2026-report.pdf');
  });

  test('a generation error maps to a StorageFailure (retryable)', () async {
    final repo = ReportRepositoryImpl(
      logger: AppLogger('off'),
      builder: (_) async => throw Exception('boom'),
      sharer: (_, __) async {},
    );

    final result = await repo.exportPdf(
      data: _data(),
      tripName: 'Goa',
      currency: 'INR',
    );

    expect(result.failureOrNull, isA<StorageFailure>());
  });
}
