enum CompactFormat { short, long }

enum CompactSystem { indian, international }

extension CompactNum on num {
  /// Transforms numbers into human-readable compact strings.
  ///
  /// [system] - Choose [CompactSystem.indian] (Lakh/Cr) or [CompactSystem.international] (M/B/T).
  /// [format] - Choose [CompactFormat.short] (L, Cr) or [CompactFormat.long] (Lakh, Crore).
  /// [decimal] - Number of decimal places (default is 1).
  String toCompact({
    CompactSystem system = CompactSystem.indian,
    CompactFormat format = CompactFormat.short,
    int decimal = 1,
  }) {
    if (system == CompactSystem.indian) {
      return _formatIndian(format, decimal);
    } else {
      return _formatInternational(format, decimal);
    }
  }

  /// Converts a number to its ordinal string (e.g., 1st, 2nd, 3rd).
  String toOrdinal() {
    int n = toInt();
    if (n >= 11 && n <= 13) return '${n}th';
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
  String toCurrencyFormat({
    CompactSystem system = CompactSystem.indian,
    int decimalDigits = 2,
    String symbol = '',
  }) {
    String numStr = toStringAsFixed(decimalDigits);
    List<String> parts = numStr.split('.');
    String intPart = parts[0];
    String decPart = parts.length > 1 ? '.${parts[1]}' : '';

    String sign = '';
    if (intPart.startsWith('-')) {
      sign = '-';
      intPart = intPart.substring(1);
    }

    if (intPart.length <= 3) {
      return '$sign$symbol$intPart$decPart';
    }

    String formattedInt = '';

    if (system == CompactSystem.indian) {
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

    return '$sign$symbol$formattedInt$decPart';
  }

  String _formatIndian(CompactFormat format, int decimal) {
    final String sign = this < 0 ? '-' : '';
    final num abs = this < 0 ? -this : this;

    if (abs >= 10000000) {
      double val = abs / 10000000;
      String label = (format == CompactFormat.short)
          ? 'Cr'
          : (val == 1.0 ? 'Crore' : 'Crores');
      return '$sign${val.toStringAsFixed(decimal)} $label';
    }
    if (abs >= 100000) {
      double val = abs / 100000;
      String label = (format == CompactFormat.short)
          ? 'L'
          : (val == 1.0 ? 'Lakh' : 'Lakhs');
      return '$sign${val.toStringAsFixed(decimal)} $label';
    }
    if (abs >= 1000) {
      double val = abs / 1000;
      String label = (format == CompactFormat.short)
          ? 'K'
          : (val == 1.0 ? 'Thousand' : 'Thousands');
      return '$sign${val.toStringAsFixed(decimal)} $label';
    }
    return toStringAsFixed(decimal);
  }

  String _formatInternational(CompactFormat format, int decimal) {
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
        return '$sign${val.toStringAsFixed(decimal)} $label';
      }
    }
    return toStringAsFixed(decimal);
  }
}
