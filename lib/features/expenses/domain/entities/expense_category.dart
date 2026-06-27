/// Fixed expense category enum (DB Design §4.5). AI categorization (v1.5) is
/// constrained to this same set — no free-text categories (CLAUDE.md §15).
enum ExpenseCategory {
  food,
  fuel,
  accommodation,
  transport,
  toll,
  drinks,
  shopping,
  activities,
  parking,
  misc;

  static ExpenseCategory fromName(String name) {
    return ExpenseCategory.values.firstWhere(
      (c) => c.name == name,
      orElse: () => ExpenseCategory.misc,
    );
  }

  /// Human-readable label.
  String get label => switch (this) {
        ExpenseCategory.food => 'Food',
        ExpenseCategory.fuel => 'Fuel',
        ExpenseCategory.accommodation => 'Stay',
        ExpenseCategory.transport => 'Transport',
        ExpenseCategory.toll => 'Toll',
        ExpenseCategory.drinks => 'Drinks',
        ExpenseCategory.shopping => 'Shopping',
        ExpenseCategory.activities => 'Activities',
        ExpenseCategory.parking => 'Parking',
        ExpenseCategory.misc => 'Misc',
      };
}
