import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _brazilianCurrency = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static String format(double value) {
    return _brazilianCurrency.format(value);
  }
}
