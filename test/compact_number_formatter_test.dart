import 'package:test/test.dart';
import 'package:compact_number_formatter/compact_number_formatter.dart';

void main() {
  setUp(() {
    CompactNumberConfig.reset();
  });

  test('formats compact numbers', () {
    expect(150000.toCompact(), '1.5 L');
    expect(1500000.toCompact(decimal: 0), '15 L');
    expect(200000.toCompact(format: CompactFormat.long), '2.0 Lakhs');
    expect(120000000.toCompact(format: CompactFormat.long), '12.0 Crores');
    expect(1200000.toCompact(system: CompactSystem.international), '1.2 M');

    // Negative numbers
    expect((-150000).toCompact(), '-1.5 L');
    expect((-1200000).toCompact(system: CompactSystem.international), '-1.2 M');
    expect((-5.02).toCompact(decimal: 2), '-5.02');
    expect((-5.02).toCompact(decimal: 2, roundOff: true), '-5.02');

    // roundOff: false (truncate)
    expect(
        (-4.979999999999999).toCompact(
          decimal: 0,
          roundOff: false,
          system: CompactSystem.international,
        ),
        '-4');
    expect(1590.toCompact(decimal: 0, roundOff: false), '1 K');
    expect(1590.toCompact(decimal: 1, roundOff: false), '1.5 K');
    expect(1590.toCompact(decimal: 1, roundOff: true), '1.6 K');

    // Symbol prefix
    expect(150000.toCompact(symbol: '₹'), '₹1.5 L');
    expect(
        1200000.toCompact(symbol: '\$', system: CompactSystem.international),
        '\$1.2 M');
    expect(500.toCompact(decimal: 0, symbol: '₹'), '₹500');

    // Negative numbers with symbol
    expect((-150000).toCompact(symbol: '₹'), '₹-1.5 L');
    expect(
        (-1200000).toCompact(symbol: '\$', system: CompactSystem.international),
        '\$-1.2 M');
  });

  test('compact edge cases', () {
    // Zero
    expect(0.toCompact(), '0.0');
    expect(0.toCompact(decimal: 0), '0');
    expect(0.toCompact(symbol: '₹'), '₹0.0');

    // Boundary values — just below thresholds
    expect(999.toCompact(decimal: 0), '999');
    expect(999.toCompact(), '999.0');
    expect(1000.toCompact(), '1.0 K');

    // Exact threshold values — Indian
    expect(100000.toCompact(), '1.0 L');
    expect(10000000.toCompact(), '1.0 Cr');

    // Exact threshold values — International
    expect(1000.toCompact(system: CompactSystem.international), '1.0 K');
    expect(1000000.toCompact(system: CompactSystem.international), '1.0 M');
    expect(1000000000.toCompact(system: CompactSystem.international), '1.0 B');
    expect(1000000000000.toCompact(system: CompactSystem.international), '1.0 T');

    // Long format — singular vs plural
    expect(100000.toCompact(format: CompactFormat.long), '1.0 Lakh');
    expect(200000.toCompact(format: CompactFormat.long), '2.0 Lakhs');
    expect(10000000.toCompact(format: CompactFormat.long), '1.0 Crore');
    expect(20000000.toCompact(format: CompactFormat.long), '2.0 Crores');
    expect(1000.toCompact(format: CompactFormat.long), '1.0 Thousand');
    expect(2000.toCompact(format: CompactFormat.long), '2.0 Thousands');

    // International long format
    expect(
        1000000.toCompact(
            system: CompactSystem.international, format: CompactFormat.long),
        '1.0 Million');
    expect(
        2000000.toCompact(
            system: CompactSystem.international, format: CompactFormat.long),
        '2.0 Millions');
    expect(
        1000000000.toCompact(
            system: CompactSystem.international, format: CompactFormat.long),
        '1.0 Billion');
    expect(
        1000000000000.toCompact(
            system: CompactSystem.international, format: CompactFormat.long),
        '1.0 Trillion');

    // Small decimals / doubles
    expect(0.5.toCompact(decimal: 2), '0.50');
    expect(99.99.toCompact(decimal: 1), '99.9');
    expect(99.99.toCompact(decimal: 1, roundOff: true), '100.0');

    // Very large numbers
    expect(999999999999999.toCompact(system: CompactSystem.international),
        '999.9 T');
  });

  test('ordinal edge cases', () {
    expect(0.toOrdinal(), '0th');
    expect(100.toOrdinal(), '100th');
    expect(101.toOrdinal(), '101st');
    expect(102.toOrdinal(), '102nd');
    expect(103.toOrdinal(), '103rd');
  });

  test('formats ordinal numbers', () {
    expect(1.toOrdinal(), '1st');
    expect(2.toOrdinal(), '2nd');
    expect(3.toOrdinal(), '3rd');
    expect(4.toOrdinal(), '4th');
    expect(11.toOrdinal(), '11th');
    expect(12.toOrdinal(), '12th');
    expect(13.toOrdinal(), '13th');
    expect(22.toOrdinal(), '22nd');
    expect(33.toOrdinal(), '33rd');
    expect(111.toOrdinal(), '111th');
    expect(112.toOrdinal(), '112th');
    expect(113.toOrdinal(), '113th');
    expect(211.toOrdinal(), '211th');
    expect(1011.toOrdinal(), '1011th');
    expect(1001.toOrdinal(), '1001st');
  });

  test('global config applies defaults', () {
    // Set global config
    CompactNumberConfig.set(
      system: CompactSystem.international,
      symbol: '\$',
      compactDecimal: 2,
      currencyDecimal: 0,
    );

    // toCompact uses compactDecimal
    expect(1200000.toCompact(), '\$1.20 M');
    expect(5000.toCompact(), '\$5.00 K');
    expect((-150000).toCompact(), '\$-150.00 K');

    // toCurrencyFormat uses currencyDecimal
    expect(1234567.toCurrencyFormat(), '\$1,234,567');

    // Per-call override takes priority
    expect(150000.toCompact(system: CompactSystem.indian), '\$1.50 L');
    expect(1500.toCompact(symbol: '₹'), '₹1.50 K');
    expect(1200000.toCompact(decimal: 0), '\$1 M');
    expect(1234567.toCurrencyFormat(decimal: 2), '\$1,234,567.00');

    // Reset clears all globals
    CompactNumberConfig.reset();
    expect(150000.toCompact(), '1.5 L');
    expect(1234567.toCurrencyFormat(), '12,34,567.00');
  });

  test('formats numbers with commas', () {
    expect(1234567.toCurrencyFormat(), '12,34,567.00');
    expect(1234567.toCurrencyFormat(decimal: 0), '12,34,567');
    expect(1234567.toCurrencyFormat(system: CompactSystem.international),
        '1,234,567.00');
    expect(
        1234567.toCurrencyFormat(
            system: CompactSystem.international, decimal: 0),
        '1,234,567');

    // Test small numbers
    expect(100.toCurrencyFormat(decimal: 0), '100');
    expect((-1500).toCurrencyFormat(decimal: 0), '-1,500');
    expect(
        1500.toCurrencyFormat(
            decimal: 0, system: CompactSystem.international),
        '1,500');

    // Test symbol
    expect(1234567.toCurrencyFormat(decimal: 0, symbol: '₹ '),
        '₹ 12,34,567');
    expect(
        1234567.toCurrencyFormat(
            decimal: 0,
            system: CompactSystem.international,
            symbol: '\$'),
        '\$1,234,567');
  });

  test('currency format edge cases', () {
    // Zero
    expect(0.toCurrencyFormat(), '0.00');
    expect(0.toCurrencyFormat(symbol: '₹'), '₹0.00');

    // Negative with symbol
    expect((-1500).toCurrencyFormat(decimal: 0, symbol: '₹'),
        '₹-1,500');
    expect((-100).toCurrencyFormat(decimal: 0, symbol: '\$'), '\$-100');

    // Large Indian numbers
    expect(10000000.toCurrencyFormat(decimal: 0), '1,00,00,000');
    expect(100000000.toCurrencyFormat(decimal: 0), '10,00,00,000');

    // Large International numbers
    expect(
        10000000.toCurrencyFormat(
            decimal: 0, system: CompactSystem.international),
        '10,000,000');

    // Doubles
    expect(1234.567.toCurrencyFormat(), '1,234.57');
    expect(1234.567.toCurrencyFormat(decimal: 3), '1,234.567');
    expect(0.99.toCurrencyFormat(decimal: 1), '1.0');
  });
}
