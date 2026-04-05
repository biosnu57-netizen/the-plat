/// PINC Finance - Currency Utilities

import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _usdFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  static final _compactFormat = NumberFormat.compact();
  static final _percentFormat = NumberFormat.percentPattern();

  static String format(double amount) => _usdFormat.format(amount);
  static String formatCompact(double amount) => _compactFormat.format(amount);
  static String formatPercent(double value) => _percentFormat.format(value);
  
  static String formatWithSign(double amount) {
    final formatted = format(amount.abs());
    return amount >= 0 ? '+$formatted' : '-$formatted';
  }

  static double? parse(String value) {
    try {
      final cleaned = value.replaceAll(RegExp(r'[^\d.-]'), '');
      return double.parse(cleaned);
    } catch (_) {
      return null;
    }
  }
}

class CurrencySymbols {
  static const usd = '\$';
  static const eur = '€';
  static const gbp = '£';
  static const ksh = 'KSh';
  static const ngn = '₦';
  static const kes = 'KES';
}

class CurrencyFlags {
  static const usd = '🇺🇸';
  static const eur = '🇪🇺';
  static const gbp = '🇬🇧';
  static const kenya = '🇰🇪';
  static const nigeria = '🇳🇬';
}