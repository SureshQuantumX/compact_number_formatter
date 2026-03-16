enum CompactFormat { short, long }

enum CompactSystem { indian, international }

/// Global configuration for compact number formatting.
///
/// Set defaults once and all calls to `.toCompact()` and `.toCurrencyFormat()`
/// will use them unless overridden per call.
///
/// ```dart
/// CompactNumberConfig.set(
///   system: CompactSystem.international,
///   symbol: '\$',
///   decimal: 2,
/// );
/// print(1200000.toCompact()); // "\$1.20 M"
/// ```
class CompactNumberConfig {
  static CompactSystem? _system;
  static CompactFormat? _format;
  static int? _decimal;
  static bool? _roundOff;
  static String? _symbol;
  static int? _decimalDigits;

  /// Set global defaults. Only provided values are changed.
  static void set({
    CompactSystem? system,
    CompactFormat? format,
    int? decimal,
    bool? roundOff,
    String? symbol,
    int? decimalDigits,
  }) {
    if (system != null) _system = system;
    if (format != null) _format = format;
    if (decimal != null) _decimal = decimal;
    if (roundOff != null) _roundOff = roundOff;
    if (symbol != null) _symbol = symbol;
    if (decimalDigits != null) _decimalDigits = decimalDigits;
  }

  /// Reset all global defaults.
  static void reset() {
    _system = null;
    _format = null;
    _decimal = null;
    _roundOff = null;
    _symbol = null;
    _decimalDigits = null;
  }

  static CompactSystem get system => _system ?? CompactSystem.indian;
  static CompactFormat get format => _format ?? CompactFormat.short;
  static int get decimal => _decimal ?? 1;
  static bool get roundOff => _roundOff ?? true;
  static String get symbol => _symbol ?? '';
  static int get decimalDigits => _decimalDigits ?? 2;
}

extension CompactNum on num {
  /// Transforms numbers into human-readable compact strings.
  ///
  /// [system] - Choose [CompactSystem.indian] (Lakh/Cr) or [CompactSystem.international] (M/B/T).
  /// [format] - Choose [CompactFormat.short] (L, Cr) or [CompactFormat.long] (Lakh, Crore).
  /// [decimal] - Number of decimal places (default is 1).
  /// [roundOff] - Whether to round the number (default is true). When false, truncates instead.
  /// [symbol] - Optional prefix symbol (e.g., '₹', '$').
  ///
  /// All parameters fall back to [CompactNumberConfig] globals if not provided.
  String toCompact({
    CompactSystem? system,
    CompactFormat? format,
    int? decimal,
    bool? roundOff,
    String? symbol,
  }) {
    final s = system ?? CompactNumberConfig.system;
    final f = format ?? CompactNumberConfig.format;
    final d = decimal ?? CompactNumberConfig.decimal;
    final r = roundOff ?? CompactNumberConfig.roundOff;
    final sym = symbol ?? CompactNumberConfig.symbol;

    String result;
    if (s == CompactSystem.indian) {
      result = _formatIndian(f, d, r);
    } else {
      result = _formatInternational(f, d, r);
    }
    if (sym.isEmpty) return result;
    if (result.startsWith('-')) {
      return '$sym-${result.substring(1)}';
    }
    return '$sym$result';
  }

  /// Converts a number to its ordinal string (e.g., 1st, 2nd, 3rd).
  String toOrdinal() {
    int n = toInt();
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  /// Formats the number with comma separators.
  ///
  /// [system] - Choose between [CompactSystem.indian] (1,00,000) or [CompactSystem.international] (100,000).
  /// [decimalDigits] - Number of decimal digits to display (default is 2).
  /// [symbol] - Optional prefix symbol (e.g., '₹', '$').
  /// All parameters fall back to [CompactNumberConfig] globals if not provided.
  String toCurrencyFormat({
    CompactSystem? system,
    int? decimalDigits,
    String? symbol,
  }) {
    final system_ = system ?? CompactNumberConfig.system;
    final decimalDigits_ = decimalDigits ?? CompactNumberConfig.decimalDigits;
    final symbol_ = symbol ?? CompactNumberConfig.symbol;
    String numStr = toStringAsFixed(decimalDigits_);
    List<String> parts = numStr.split('.');
    String intPart = parts[0];
    String decPart = parts.length > 1 ? '.${parts[1]}' : '';

    String sign = '';
    if (intPart.startsWith('-')) {
      sign = '-';
      intPart = intPart.substring(1);
    }

    if (intPart.length <= 3) {
      return '$symbol_$sign$intPart$decPart';
    }

    String formattedInt = '';

    if (system_ == CompactSystem.indian) {
      String lastThree = intPart.substring(intPart.length - 3);
      String remaining = intPart.substring(0, intPart.length - 3);

      StringBuffer buffer = StringBuffer();
      int count = 0;
      for (int i = remaining.length - 1; i >= 0; i--) {
        buffer.write(remaining[i]);
        count++;
        if (count == 2 && i != 0) {
          buffer.write(',');
          count = 0;
        }
      }
      String reversedRemaining = buffer.toString().split('').reversed.join('');
      formattedInt = '$reversedRemaining,$lastThree';
    } else {
      StringBuffer buffer = StringBuffer();
      int count = 0;
      for (int i = intPart.length - 1; i >= 0; i--) {
        buffer.write(intPart[i]);
        count++;
        if (count == 3 && i != 0) {
          buffer.write(',');
          count = 0;
        }
      }
      formattedInt = buffer.toString().split('').reversed.join('');
    }

    return '$symbol_$sign$formattedInt$decPart';
  }

  String _toFixed(num value, int decimal, bool roundOff) {
    if (roundOff) {
      return value.toStringAsFixed(decimal);
    }
    // Truncate by shifting decimal point, truncating to int, then shifting back
    final factor = _pow10(decimal);
    final truncated = (value * factor).toInt() / factor;
    return truncated.toStringAsFixed(decimal);
  }

  int _pow10(int exp) {
    int result = 1;
    for (int i = 0; i < exp; i++) {
      result *= 10;
    }
    return result;
  }

  String _formatIndian(CompactFormat format, int decimal, bool roundOff) {
    final String sign = this < 0 ? '-' : '';
    final num abs = this < 0 ? -this : this;

    if (abs >= 10000000) {
      double val = abs / 10000000;
      String label = (format == CompactFormat.short)
          ? 'Cr'
          : (val == 1.0 ? 'Crore' : 'Crores');
      return '$sign${_toFixed(val, decimal, roundOff)} $label';
    }
    if (abs >= 100000) {
      double val = abs / 100000;
      String label = (format == CompactFormat.short)
          ? 'L'
          : (val == 1.0 ? 'Lakh' : 'Lakhs');
      return '$sign${_toFixed(val, decimal, roundOff)} $label';
    }
    if (abs >= 1000) {
      double val = abs / 1000;
      String label = (format == CompactFormat.short)
          ? 'K'
          : (val == 1.0 ? 'Thousand' : 'Thousands');
      return '$sign${_toFixed(val, decimal, roundOff)} $label';
    }
    return _toFixed(toDouble(), decimal, roundOff);
  }

  String _formatInternational(CompactFormat format, int decimal, bool roundOff) {
    final String sign = this < 0 ? '-' : '';
    final num abs = this < 0 ? -this : this;

    final units = [
      {'val': 1e12, 's': 'T', 'l': 'Trillion'},
      {'val': 1e9, 's': 'B', 'l': 'Billion'},
      {'val': 1e6, 's': 'M', 'l': 'Million'},
      {'val': 1e3, 's': 'K', 'l': 'Thousand'},
    ];

    for (var unit in units) {
      double divisor = unit['val'] as double;
      if (abs >= divisor) {
        double val = abs / divisor;
        String label = (format == CompactFormat.short)
            ? unit['s'] as String
            : (val == 1.0 ? unit['l'] as String : '${unit['l']}s');
        return '$sign${_toFixed(val, decimal, roundOff)} $label';
      }
    }
    return _toFixed(toDouble(), decimal, roundOff);
  }
}
