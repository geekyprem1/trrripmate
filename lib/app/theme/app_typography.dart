import 'package:flutter/material.dart';

/// Material 3 type scale (Design System §3).
///
/// Money is rendered with tabular figures via [moneyFeatures] so amounts align
/// in columns (Design System §3.2).
abstract final class AppTypography {
  /// Tabular-figure feature for monetary text.
  static const List<FontFeature> moneyFeatures = [FontFeature.tabularFigures()];

  /// Builds the app text theme on top of the default Material text theme.
  static TextTheme textTheme(TextTheme base) {
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(fontWeight: FontWeight.w400),
      headlineMedium:
          base.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
      headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      labelMedium: base.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      labelSmall: base.labelSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
