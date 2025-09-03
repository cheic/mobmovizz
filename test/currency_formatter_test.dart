import 'package:flutter_test/flutter_test.dart';
import 'package:mobmovizz/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter Tests', () {
    test('should format null amount as N/A', () {
      expect(CurrencyFormatter.formatCurrency(null), 'N/A');
    });

    test('should format zero amount as N/A', () {
      expect(CurrencyFormatter.formatCurrency(0), 'N/A');
    });

    test('should format thousands with K suffix', () {
      expect(CurrencyFormatter.formatCurrency(500000), '\$500K');
      expect(CurrencyFormatter.formatCurrency(1500000), '\$1.5M');
    });

    test('should format millions with M suffix', () {
      expect(CurrencyFormatter.formatCurrency(45000000), '\$45M');
      expect(CurrencyFormatter.formatCurrency(150000000), '\$150M');
    });

    test('should format billions with B suffix', () {
      expect(CurrencyFormatter.formatCurrency(2300000000), '\$2.3B');
      expect(CurrencyFormatter.formatCurrency(1000000000), '\$1B');
    });

    test('should format small amounts with full notation', () {
      expect(CurrencyFormatter.formatCurrency(999), '\$999');
    });

    test('should format full currency without abbreviation', () {
      expect(CurrencyFormatter.formatFullCurrency(1500000), '\$1,500,000');
      expect(CurrencyFormatter.formatFullCurrency(2300000000), '\$2,300,000,000');
    });
  });
}
