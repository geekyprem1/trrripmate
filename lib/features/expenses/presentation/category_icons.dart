import 'package:flutter/material.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';

/// Maps each category to its Material Symbol (Design System §12).
IconData categoryIcon(ExpenseCategory category) {
  return switch (category) {
    ExpenseCategory.food => Icons.restaurant,
    ExpenseCategory.fuel => Icons.local_gas_station,
    ExpenseCategory.accommodation => Icons.hotel,
    ExpenseCategory.transport => Icons.directions_car,
    ExpenseCategory.toll => Icons.toll,
    ExpenseCategory.drinks => Icons.local_bar,
    ExpenseCategory.shopping => Icons.shopping_bag,
    ExpenseCategory.activities => Icons.confirmation_number,
    ExpenseCategory.parking => Icons.local_parking,
    ExpenseCategory.misc => Icons.category,
  };
}
