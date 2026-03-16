import 'package:compact_number_formatter/compact_number_formatter.dart';

void main() {
  print('=== Compact Number Formatter Examples ===\n');

  // 1. Indian System (Default)
  print('--- Indian System ---');
  print('150,000         -> ${150000.toCompact()}');
  print('200,000 (Long)  -> ${200000.toCompact(format: CompactFormat.long)}');
  print('10,000,000 (Long) -> ${10000000.toCompact(format: CompactFormat.long)}');
  print('');

  // 2. International System
  print('--- International System ---');
  print('1,200,000       -> ${1200000.toCompact(system: CompactSystem.international)}');
  print('1,200,000 (long) -> ${1200000.toCompact(system: CompactSystem.international, format: CompactFormat.long)}');
  print('');

  // 3. Negative Numbers & Decimals
  print('--- Negative Numbers & Decimals ---');
  print('-150,000        -> ${(-150000).toCompact()}');
  print('-5.02           -> ${(-5.02).toCompact(decimal: 2)}');
  print('');

  // 4. Currency / Symbol Prefix
  print('--- Currency Symbols ---');
  print('150,000 (₹)     -> ${150000.toCompact(symbol: '₹')}');
  print('1,200,000 (\$)   -> ${1200000.toCompact(symbol: '\$', system: CompactSystem.international)}');
  print('');

  // 5. Truncation vs Rounding
  print('--- Truncation vs Rounding ---');
  print('1,590 (Truncated) -> ${1590.toCompact(decimal: 1)}');
  print('1,590 (Rounded)   -> ${1590.toCompact(decimal: 1, roundOff: true)}');
  print('');

  // 6. Currency / Comma Formatting
  print('--- Currency / Comma Formatting ---');
  print('1,234,567 (Indian)        -> ${1234567.toCurrencyFormat()}');
  print('1,234,567 (International) -> ${1234567.toCurrencyFormat(system: CompactSystem.international, decimal: 0)}');
  print('1,500,000 (With Symbol)   -> ${1500000.toCurrencyFormat(decimal: 0, symbol: '₹ ')}');
  print('');

  // 7. Ordinal Numbers
  print('--- Ordinal Numbers ---');
  print('1               -> ${1.toOrdinal()}');
  print('22              -> ${22.toOrdinal()}');
  print('');

  // 8. Global Configuration
  print('--- Global Configuration ---');
  CompactNumberConfig.set(
    system: CompactSystem.international,
    symbol: '\$',
    compactDecimal: 2,
    currencyDecimal: 0,
  );
  
  print('Config set to International, \$, 2 compact decimals, 0 currency decimals.');
  print('1,200,000       -> ${1200000.toCompact()}');
  print('5,000           -> ${5000.toCompact()}');
  print('1,234,567       -> ${1234567.toCurrencyFormat()}');
  
  // Per-call override still works
  print('Override config (₹) -> ${150000.toCompact(symbol: '₹')}');

  // Reset back to library default
  CompactNumberConfig.reset();
  print('\nConfig reset.');
  print('150,000         -> ${150000.toCompact()} (Back to default Indian system)');
}
