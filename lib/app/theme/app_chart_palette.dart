import 'package:flutter/material.dart';

/// Categorical chart palette (Design System §14.1), in a fixed color-blind-aware
/// order. Consume these tokens in charts — never raw hex in widgets
/// (CLAUDE.md §11). Beyond 10 series, colors repeat and must be differentiated
/// by label (charts are always paired with a text/table equivalent).
abstract final class AppChartPalette {
  static const List<Color> categorical = <Color>[
    Color(0xFF0E7C7B),
    Color(0xFF4A5B8C),
    Color(0xFF9A5B00),
    Color(0xFF1E6E3A),
    Color(0xFF7A4FC2),
    Color(0xFFB5562B),
    Color(0xFF2E7DA1),
    Color(0xFF8A8D2E),
    Color(0xFFB03060),
    Color(0xFF5E5E5E),
  ];

  /// The palette color for series [index] (wraps after 10).
  static Color at(int index) =>
      categorical[index % categorical.length];
}
