import 'package:flutter_test/flutter_test.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';
import 'package:tripmate/features/reports/data/report_pdf_builder.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';

ReportData _data() => ReportData(
      totalMinor: 200000,
      expenseCount: 3,
      categories: const [
        CategorySlice(
          category: ExpenseCategory.food,
          amountMinor: 140000,
          fraction: 0.7,
        ),
        CategorySlice(
          category: ExpenseCategory.fuel,
          amountMinor: 60000,
          fraction: 0.3,
        ),
      ],
      members: const [
        MemberSpend(
          memberId: 'm1',
          memberName: 'Amit',
          paidMinor: 140000,
          owedMinor: 100000,
        ),
      ],
      timeline: [
        TimelinePoint(
          date: DateTime(2026, 7),
          dailyMinor: 100000,
          cumulativeMinor: 100000,
        ),
        TimelinePoint(
          date: DateTime(2026, 7, 2),
          dailyMinor: 100000,
          cumulativeMinor: 200000,
        ),
      ],
    );

void main() {
  test('builds a valid, non-empty PDF document', () async {
    final bytes = await buildReportPdf(
      ReportPdfRequest(
        data: _data(),
        tripName: 'Goa Trip',
        currency: 'INR',
        generatedAt: DateTime(2026, 7, 3),
      ),
    );

    expect(bytes, isNotEmpty);
    // PDF files start with the "%PDF-" magic header.
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('handles a single-category report without error', () async {
    final bytes = await buildReportPdf(
      ReportPdfRequest(
        data: const ReportData(
          totalMinor: 50000,
          expenseCount: 1,
          categories: [
            CategorySlice(
              category: ExpenseCategory.misc,
              amountMinor: 50000,
              fraction: 1,
            ),
          ],
        ),
        tripName: 'Solo',
        currency: 'USD',
        generatedAt: DateTime(2026, 7, 3),
      ),
    );
    expect(bytes, isNotEmpty);
  });
}
