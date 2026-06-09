import 'package:intl/intl.dart';

import '../utils/countries.dart';

class CurrencyService {
  static String _locale  = 'es_ES';
  static String _simbolo = '€';
  static String _moneda  = 'EUR';

  static void configure(KashCountry pais) {
    _locale  = pais.locale;
    _simbolo = pais.simbolo;
    _moneda  = pais.moneda;
  }

  static String format(double amount) {
    final decimals = (_moneda == 'JPY' || _moneda == 'CLP') ? 0 : 2;
    final fmt = NumberFormat.currency(
      locale: _locale,
      symbol: _simbolo,
      decimalDigits: decimals,
    );
    return fmt.format(amount);
  }

  static String formatNumber(double amount) {
    return NumberFormat.decimalPattern(_locale).format(amount);
  }

  static String get simbolo => _simbolo;
  static String get moneda  => _moneda;
  static String get locale  => _locale;
}
