import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';
import 'package:tripmate/features/reports/presentation/widgets/category_pie_chart.dart';
import 'package:tripmate/features/reports/presentation/widgets/report_data_table.dart';

const _data = ReportData(
  totalMinor: 200000,
  expenseCount: 3,
  categories: [
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
);

void main() {
  testWidgets('pie chart ships a text/table equivalent (a11y)',
      (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: CategoryPieChart(data: _data, currency: 'INR'),
          ),
        ),
      ),
    );

    // The accessible data table is present with readable rows.
    expect(find.byType(ReportDataTable), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Fuel'), findsOneWidget);
    expect(find.text('70.0%'), findsOneWidget);
    expect(find.text('30.0%'), findsOneWidget);

    // A non-visual summary of the chart is announced.
    expect(
      find.bySemanticsLabel(RegExp('Category breakdown')),
      findsOneWidget,
    );

    handle.dispose();
  });
}
