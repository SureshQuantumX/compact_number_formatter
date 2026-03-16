
## [1.0.0] - 2026-03-16

### Added
* **Core Engine**: Initial release of the zero-dependency Dart utility for high-performance number transformation.
* **Numbering Systems**:
    * **Indian System**: Smart conversion for Thousands, Lakhs, and Crores.
    * **International System**: Standardized Millions, Billions, and Trillions.
* **Extension Methods**:
    * `num.toCompact()`: Transform numbers into human-readable strings (e.g., `1.5 L`, `1.2 M`).
    * `num.toCurrencyFormat()`: Locale-aware comma separation and decimal control.
    * `num.toOrdinal()`: Appends ordinal suffixes (e.g., `1st`, `22nd`, `303rd`).
* **Formatting Features**:
    * **Plurality Logic**: Automated handling of "Lakh" vs "Lakhs" and "Crore" vs "Crores" in long formats.
    * **Precision Control**: Toggle between **Truncation** (default) and **Rounding** via the `roundOff` parameter.
    * **Negative Number Support**: Full support for negative values across all formatting types.
    * **Prefix Support**: Integrated currency symbol prefixing (e.g., `$`, `₹`).
* **Global Configuration**:
    * Introduced `CompactNumberConfig.set()` to define application-wide defaults for systems, symbols, and precision.
    * Added `CompactNumberConfig.reset()` to return to library defaults.

### Performance
* **Zero Dependencies**: Optimized for a lightweight footprint; compatible with Flutter, Web, and Server-side Dart.
