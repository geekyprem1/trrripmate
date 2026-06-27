import 'package:flutter/material.dart';

/// Brand seed and color schemes (Design System §2, §13).
///
/// The schemes are generated from the TripMate teal seed; semantic financial
/// colors live in [AppSemanticColors] and remain fixed across dynamic color.
abstract final class AppColors {
  /// TripMate Teal — the brand seed for Material You palettes.
  static const Color seed = Color(0xFF0E7C7B);

  /// Light color scheme (Design System §2.3).
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0E7C7B),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF9FF3F0),
    onPrimaryContainer: Color(0xFF00201F),
    secondary: Color(0xFF4A5B8C),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDCE4FF),
    onSecondaryContainer: Color(0xFF141B2C),
    tertiary: Color(0xFF9A5B00),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDDB8),
    onTertiaryContainer: Color(0xFF2B1700),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFAFDFC),
    onSurface: Color(0xFF191C1C),
    onSurfaceVariant: Color(0xFF3F4948),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF2F5F4),
    surfaceContainer: Color(0xFFECEFEE),
    surfaceContainerHigh: Color(0xFFE6E9E8),
    surfaceContainerHighest: Color(0xFFE0E3E2),
    outline: Color(0xFF6F7978),
    outlineVariant: Color(0xFFBEC9C7),
    inverseSurface: Color(0xFF2D3130),
    onInverseSurface: Color(0xFFEFF1F0),
    inversePrimary: Color(0xFF4FD8D5),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
  );

  /// Dark color scheme (Design System §13.1).
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF4FD8D5),
    onPrimary: Color(0xFF003735),
    primaryContainer: Color(0xFF00504E),
    onPrimaryContainer: Color(0xFF9FF3F0),
    secondary: Color(0xFFB4C2F0),
    onSecondary: Color(0xFF1B2A4B),
    secondaryContainer: Color(0xFF324063),
    onSecondaryContainer: Color(0xFFDCE4FF),
    tertiary: Color(0xFFFFB868),
    onTertiary: Color(0xFF4A2A00),
    tertiaryContainer: Color(0xFF6B3F00),
    onTertiaryContainer: Color(0xFFFFDDB8),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF0E1514),
    onSurface: Color(0xFFDFE3E2),
    onSurfaceVariant: Color(0xFFBEC9C7),
    surfaceContainerLowest: Color(0xFF090F0E),
    surfaceContainerLow: Color(0xFF151D1C),
    surfaceContainer: Color(0xFF1A2221),
    surfaceContainerHigh: Color(0xFF243130),
    surfaceContainerHighest: Color(0xFF2F3C3B),
    outline: Color(0xFF899392),
    outlineVariant: Color(0xFF3F4948),
    inverseSurface: Color(0xFFDFE3E2),
    onInverseSurface: Color(0xFF2D3130),
    inversePrimary: Color(0xFF0E7C7B),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
  );
}

/// Semantic financial colors (Design System §2.4).
///
/// Exposed as a [ThemeExtension] so widgets read them via the theme. Status is
/// never color-only — always pair with icon + label (CLAUDE.md §11).
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.moneyPositive,
    required this.moneyNegative,
    required this.moneyNeutral,
  });

  final Color success;
  final Color warning;
  final Color moneyPositive;
  final Color moneyNegative;
  final Color moneyNeutral;

  static const light = AppSemanticColors(
    success: Color(0xFF1E6E3A),
    warning: Color(0xFF9A5B00),
    moneyPositive: Color(0xFF1E6E3A),
    moneyNegative: Color(0xFFBA1A1A),
    moneyNeutral: Color(0xFF3F4948),
  );

  static const dark = AppSemanticColors(
    success: Color(0xFF7BDB9B),
    warning: Color(0xFFFFB868),
    moneyPositive: Color(0xFF7BDB9B),
    moneyNegative: Color(0xFFFFB4AB),
    moneyNeutral: Color(0xFFBEC9C7),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? moneyPositive,
    Color? moneyNegative,
    Color? moneyNeutral,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      moneyPositive: moneyPositive ?? this.moneyPositive,
      moneyNegative: moneyNegative ?? this.moneyNegative,
      moneyNeutral: moneyNeutral ?? this.moneyNeutral,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      moneyPositive: Color.lerp(moneyPositive, other.moneyPositive, t)!,
      moneyNegative: Color.lerp(moneyNegative, other.moneyNegative, t)!,
      moneyNeutral: Color.lerp(moneyNeutral, other.moneyNeutral, t)!,
    );
  }
}
