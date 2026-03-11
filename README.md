# compact_number_formatter

A high-performance, **zero-dependency** Dart utility to transform large numbers into human-readable compact formats. Specifically built to handle the **Indian Numbering System (Lakh/Crore)** which is often missing in standard libraries.

## 🚀 Key Features

* 🇮🇳 **Indian System:** Smart conversion to Lakhs (L) and Crores (Cr).
* 🌍 **International System:** Standard Millions (M), Billions (B), and Trillions (T).
* 👥 **Plurality Support:** Automatically handles "Lakh" vs "Lakhs" and "Crore" vs "Crores".
* 🏅 **Ordinals:** Built-in extension for ordinal suffixes (1st, 2nd, 3rd).
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

```

### Ordinal Numbers

```dart
print(1.toOrdinal());  // "1st"
print(22.toOrdinal()); // "22nd"

```


### Comma Separated Numbers

```dart
// Indian System Commas (Default)
print(1234567.toCurrencyFormat()); // "12,34,567.00"

// International System Commas
print(1234567.toCurrencyFormat(system: CompactSystem.international, decimalDigits: 0)); // "1,234,567"

// With Currency Symbol
print(1500000.toCurrencyFormat(decimalDigits: 0, symbol: '₹ ')); // "₹ 15,00,000"

```

---

## 🛠 Configuration

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `CompactSystem` | `.indian` | `indian` or `international` |
| `format` | `CompactFormat` | `.short` | `short` (L, Cr) or `long` (Lakh, Crore) |
| `decimal` | `int` | `1` | Precision after the decimal point |
