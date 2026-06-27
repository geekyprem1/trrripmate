/// Spacing scale on a 4dp base grid (Design System §4).
///
/// Consume these tokens in widgets — never raw dp literals (CLAUDE.md §11).
abstract final class AppSpacing {
  /// 4dp — icon/text gap, dense.
  static const double xs = 4;

  /// 8dp — intra-component.
  static const double sm = 8;

  /// 12dp — list item vertical, card gap.
  static const double md = 12;

  /// 16dp — screen padding, card padding.
  static const double lg = 16;

  /// 24dp — section spacing.
  static const double xl = 24;

  /// 32dp — major section breaks.
  static const double xxl = 32;

  /// 48dp — empty-state spacing.
  static const double huge = 48;
}

/// Corner-radius scale (Design System §5).
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 28;
  static const double full = 999;
}
