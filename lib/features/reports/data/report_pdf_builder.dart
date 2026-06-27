import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';

/// Self-contained input for [buildReportPdf]. Plain/immutable so it can be sent
/// to a background isolate via `compute` (CLAUDE.md §10 — no heavy work on the
/// UI isolate).
class ReportPdfRequest {
  const ReportPdfRequest({
    required this.data,
    required this.tripName,
    required this.currency,
    required this.generatedAt,
  });

  final ReportData data;
  final String tripName;
  final String currency;
  final DateTime generatedAt;
}

/// Renders a report PDF to bytes. Top-level + offline (no network, no fonts
/// beyond the PDF standard set) so it runs inside `compute`. Uses a paginated
/// document so very large trips don't overflow a page (REQ-REP-01 edge case).
Future<Uint8List> buildReportPdf(ReportPdfRequest request) async {
  final doc = pw.Document();
  final data = request.data;
  String money(int minor) => Money.formatCode(minor, request.currency);

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        _header(request),
        pw.SizedBox(height: 16),
        _totals(data, money),
        pw.SizedBox(height: 20),
        _categorySection(data, money),
        pw.SizedBox(height: 20),
        _memberSection(data, money),
        pw.SizedBox(height: 20),
        _timelineSection(data, money),
      ],
      footer: (context) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
        ),
      ),
    ),
  );

  return doc.save();
}

pw.Widget _header(ReportPdfRequest request) {
  final date = request.generatedAt;
  final stamp = '${date.year}-${_pad2(date.month)}-${_pad2(date.day)}';
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        request.tripName,
        style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 2),
      pw.Text('Expense report - generated $stamp',
          style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
    ],
  );
}

pw.Widget _totals(ReportData data, String Function(int) money) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      _totalCell('Total spend', money(data.totalMinor)),
      _totalCell('Expenses', '${data.expenseCount}'),
      _totalCell('Categories', '${data.categories.length}'),
    ],
  );
}

pw.Widget _totalCell(String label, String value) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(label,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
      pw.SizedBox(height: 2),
      pw.Text(value,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
    ],
  );
}

pw.Widget _categorySection(ReportData data, String Function(int) money) {
  return _section(
    'Category breakdown',
    pw.TableHelper.fromTextArray(
      headers: ['Category', 'Amount', 'Share'],
      cellAlignments: {1: pw.Alignment.centerRight, 2: pw.Alignment.centerRight},
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 10),
      data: [
        for (final slice in data.categories)
          [
            slice.category.label,
            money(slice.amountMinor),
            '${(slice.fraction * 100).toStringAsFixed(1)}%',
          ],
      ],
    ),
  );
}

pw.Widget _memberSection(ReportData data, String Function(int) money) {
  return _section(
    'Spend by member',
    pw.TableHelper.fromTextArray(
      headers: ['Member', 'Paid', 'Owed'],
      cellAlignments: {1: pw.Alignment.centerRight, 2: pw.Alignment.centerRight},
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 10),
      data: [
        for (final m in data.members)
          [m.memberName, money(m.paidMinor), money(m.owedMinor)],
      ],
    ),
  );
}

pw.Widget _timelineSection(ReportData data, String Function(int) money) {
  return _section(
    'Daily timeline',
    pw.TableHelper.fromTextArray(
      headers: ['Date', 'Daily', 'Cumulative'],
      cellAlignments: {1: pw.Alignment.centerRight, 2: pw.Alignment.centerRight},
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 10),
      data: [
        for (final point in data.timeline)
          [
            '${point.date.year}-${_pad2(point.date.month)}-${_pad2(point.date.day)}',
            money(point.dailyMinor),
            money(point.cumulativeMinor),
          ],
      ],
    ),
  );
}

pw.Widget _section(String title, pw.Widget body) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(title,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 6),
      body,
    ],
  );
}

String _pad2(int value) => value.toString().padLeft(2, '0');
