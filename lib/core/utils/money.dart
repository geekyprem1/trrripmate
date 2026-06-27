/// Money helpers operating on integer **minor units** (e.g. paise/cents).
///
/// Money arithmetic is done in integers — never floats (CLAUDE.md §13, DB
/// Design §13). Conversion to/from major units happens only at the UI and
/// transport edges.
abstract final class Money {
  static const _minorPerMajor = 100;

  /// Common currency symbols; falls back to the ISO code.
  static const _symbols = <String, String>{
    'INR': '₹',
    'USD': r'$',
    'EUR': '€',
    'GBP': '£',
    'THB': '฿',
    'JPY': '¥',
    'AUD': r'A$',
    'CAD': r'C$',
  };

  /// Converts a numeric major value (number or numeric string) to minor units.
  static int? majorToMinor(Object? value) {
    if (value == null) return null;
    final asNum = value is num ? value : num.tryParse(value.toString());
    if (asNum == null) return null;
    return (asNum * _minorPerMajor).round();
  }

  /// Serializes minor units as a 2-dp major string for transport (avoids float
  /// drift, CLAUDE.md §13).
  static String minorToMajorString(int minorUnits) {
    final major = minorUnits ~/ _minorPerMajor;
    final paise =
        (minorUnits % _minorPerMajor).abs().toString().padLeft(2, '0');
    return '$major.$paise';
  }

  /// Parses user input in major units (e.g. "1,250.50") to minor units, or
  /// `null` if blank/invalid.
  static int? tryParseMajorToMinor(String input) {
    final cleaned = input.replaceAll(',', '').trim();
    if (cleaned.isEmpty) return null;
    final value = double.tryParse(cleaned);
    if (value == null || value < 0) return null;
    return (value * _minorPerMajor).round();
  }

  /// Grouped major-unit amount prefixed with the ISO code (no symbol), e.g.
  /// `INR 1,250.50`. Used where the rendering surface lacks symbol glyphs
  /// (e.g. standard PDF fonts).
  static String formatCode(int minorUnits, String currencyCode) {
    final major = minorUnits ~/ _minorPerMajor;
    final minor = minorUnits % _minorPerMajor;
    final grouped = _group(major.abs());
    final sign = minorUnits < 0 ? '-' : '';
    final body = minor == 0
        ? grouped
        : '$grouped.${minor.abs().toString().padLeft(2, '0')}';
    return '$currencyCode $sign$body';
  }

  /// Formats minor units as a grouped amount with currency symbol, e.g.
  /// `₹50,000` (whole) or `₹1,250.50` (with paise).
  static String format(int minorUnits, String currencyCode) {
    final symbol = _symbols[currencyCode] ?? '$currencyCode ';
    final major = minorUnits ~/ _minorPerMajor;
    final minor = minorUnits % _minorPerMajor;
    final grouped = _group(major.abs());
    final sign = minorUnits < 0 ? '-' : '';
    if (minor == 0) {
      return '$sign$symbol$grouped';
    }
    final paise = minor.abs().toString().padLeft(2, '0');
    return '$sign$symbol$grouped.$paise';
  }

  static String _group(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
