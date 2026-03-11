import 'package:test/test.dart';
import 'package:compact_number_formatter/compact_number_formatter.dart';

void main() {
  test('formats compact numbers', () {
    expect(150000.toCompact(), '1.5 L');
    expect(1500000.toCompact(decimal: 0), '15 L');
    expect(200000.toCompact(format: CompactFormat.long), '2.0 Lakhs');
    expect(120000000.toCompact(format: CompactFormat.long), '12.0 Crores');
    expect(1200000.toCompact(system: CompactSystem.international), '1.2 M');
  });

  test('formats ordinal numbers', () {
    expect(1.toOrdinal(), '1st');
    expect(22.toOrdinal(), '22nd');
    expect(11.toOrdinal(), '11th');
    expect(33.toOrdinal(), '33rd');
  });

  test('formats numbers with commas', () {
    expect(1234567.toCurrencyFormat(), '12,34,567.00');
    expect(1234567.toCurrencyFormat(decimalDigits: 0), '12,34,567');
    expect(1234567.toCurrencyFormat(system: CompactSystem.international),
        '1,234,567.00');
    expect(
        1234567.toCurrencyFormat(
            system: CompactSystem.international, decimalDigits: 0),
        '1,234,567');

    // Test small numbers
    expect(100.toCurrencyFormat(decimalDigits: 0), '100');
    expect((-1500).toCurrencyFormat(decimalDigits: 0), '-1,500');
    expect(
        1500.toCurrencyFormat(
            decimalDigits: 0, system: CompactSystem.international),
        '1,500');

    // Test symbol
    expect(1234567.toCurrencyFormat(decimalDigits: 0, symbol: '₹ '),
        '₹ 12,34,567');
    expect(
        1234567.toCurrencyFormat(
            decimalDigits: 0,
            system: CompactSystem.international,
            symbol: '\$'),
        '\$1,234,567');
  });
}
