# compact_number_formatter

A high-performance, **zero-dependency** Dart utility to transform large numbers into human-readable compact formats. Supports both the **Indian Numbering System (Lakh/Crore)** and the **International System (Million/Billion/Trillion)** with currency formatting, ordinals, and global configuration.

## 🚀 Key Features

* 🇮🇳 **Indian System:** Smart conversion to Lakhs (L) and Crores (Cr).
* 🌍 **International System:** Standard Millions (M), Billions (B), and Trillions (T).
* 💰 **Currency Formatting:** Built-in comma separation (e.g., 1,00,000 or 100,000) with optional symbols (`₹`, `$`).
* 👥 **Plurality Support:** Automatically handles "Lakh" vs "Lakhs" and "Crore" vs "Crores".
* 🏅 **Ordinals:** Built-in extension for ordinal suffixes (1st, 2nd, 3rd).
* ➖ **Negative Numbers:** Full support for negative values.
* 🔢 **Round Off Control:** Choose between rounding or truncation.
* 💲 **Symbol Prefix:** Optional prefix symbol (e.g., `₹`, `$`) on compact numbers.
* ⚙️ **Global Config:** Set defaults once with `CompactNumberConfig.set()` — no need to repeat params on every call.
* ⚡ **Pure Dart:** No Flutter dependency. Use it in Flutter, AngularDart, or Server-side Dart.

## 📖 Usage

### Compact Numbers

The `.toCompact()` extension works on any `num` (int or double).

```dart
import 'package:compact_number_formatter/compact_number_formatter.dart';

// Indian Short (Default)
print(150000.toCompact()); // "1.5 L"

// Indian Long with Plurality
print(200000.toCompact(format: CompactFormat.long)); // "2.0 Lakhs"
print(10000000.toCompact(format: CompactFormat.long)); // "1.0 Crore"

// International
print(1200000.toCompact(system: CompactSystem.international)); // "1.2 M"

// Negative Numbers
print((-150000).toCompact()); // "-1.5 L"
print((-5.02).toCompact(decimal: 2)); // "-5.02"

// With Symbol Prefix
print(150000.toCompact(symbol: '₹')); // "₹1.5 L"
print(1200000.toCompact(symbol: '\$', system: CompactSystem.international)); // "\$1.2 M"

// Truncate Instead of Rounding
print(1590.toCompact(decimal: 1, roundOff: false)); // "1.5 K"
print(1590.toCompact(decimal: 1, roundOff: true));  // "1.6 K"

```

### Global Configuration

Set defaults once instead of passing parameters every time:

```dart
// Set once in main() or app init
CompactNumberConfig.set(
  system: CompactSystem.international,
  symbol: '\$',
  compactDecimal: 2,
  currencyDecimal: 0,
);

// All calls now use those defaults
print(1200000.toCompact());           // "\$1.20 M"
print(5000.toCompact());              // "\$5.00 K"
print(1234567.toCurrencyFormat());    // "\$1,234,567.00"

// Per-call params still override the global config
print(150000.toCompact(symbol: '₹')); // "₹1.50 L"

// Reset all back to library defaults
CompactNumberConfig.reset();
print(150000.toCompact()); // "1.5 L"

```

| Global Setting | Affects | Default |
| --- | --- | --- |
| `system` | `toCompact` + `toCurrencyFormat` | `CompactSystem.indian` |
| `format` | `toCompact` | `CompactFormat.short` |
| `compactDecimal` | `toCompact` | `1` |
| `currencyDecimal` | `toCurrencyFormat` | `2` |
| `roundOff` | `toCompact` | `true` |
| `symbol` | `toCompact` + `toCurrencyFormat` | `''` |

### Ordinal Numbers

```dart
print(1.toOrdinal());  // "1st"
print(22.toOrdinal()); // "22nd"

```


### Currency / Comma Formatting

```dart
// Indian System Commas (Default)
print(1234567.toCurrencyFormat()); // "12,34,567.00"

// International System Commas
print(1234567.toCurrencyFormat(system: CompactSystem.international, decimal: 0)); // "1,234,567"

// With Currency Symbol
print(1500000.toCurrencyFormat(decimal: 0, symbol: '₹ ')); // "₹ 15,00,000"

```

---

## 🛠 Configuration

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `CompactSystem` | `.indian` | `indian` or `international` |
| `format` | `CompactFormat` | `.short` | `short` (L, Cr) or `long` (Lakh, Crore) |
| `decimal` | `int` | `1` (toCompact) / `2` (toCurrencyFormat) | Precision after the decimal point |
| `roundOff` | `bool` | `true` | `true` to round, `false` to truncate |
| `symbol` | `String` | `''` | Optional prefix symbol (e.g., `₹`, `$`) |
