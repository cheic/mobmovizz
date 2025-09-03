import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// Formate un montant en devise avec les séparateurs appropriés
  /// 
  /// Exemples :
  /// - formatCurrency(1500000) → "1,500,000"
  /// - formatCurrency(2300000000) → "2.3B"
  /// - formatCurrency(45000000) → "45M"
  /// - formatCurrency(500000) → "500K"
  static String formatCurrency(int? amount, {String currency = '\$', String locale = 'en_US'}) {
    if (amount == null || amount == 0) {
      return 'N/A';
    }

    // Pour les montants très élevés, utilise une notation abrégée
    if (amount >= 1000000000) {
      final billions = amount / 1000000000;
      return '$currency${_formatDecimal(billions)}B';
    } else if (amount >= 1000000) {
      final millions = amount / 1000000;
      return '$currency${_formatDecimal(millions)}M';
    } else if (amount >= 1000) {
      final thousands = amount / 1000;
      return '$currency${_formatDecimal(thousands)}K';
    }

    // Pour les montants plus petits, utilise la notation complète
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: currency,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Formate un nombre décimal avec 1 chiffre après la virgule si nécessaire
  static String _formatDecimal(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(1);
    }
  }

  /// Formate un montant avec le format complet (sans abréviation)
  static String formatFullCurrency(int? amount, {String currency = '\$', String locale = 'en_US'}) {
    if (amount == null || amount == 0) {
      return 'N/A';
    }

    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: currency,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
