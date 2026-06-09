import 'package:intl/intl.dart';

import '../services/currency_service.dart';

String formatearImporte(double importe, {String? moneda}) {
  if (moneda == null) return CurrencyService.format(importe);
  // Ruta legacy (compatibilidad con call sites que aún pasan moneda:)
  final fmt = NumberFormat.currency(
    locale: CurrencyService.locale,
    name: moneda,
    symbol: _simboloMoneda(moneda),
    decimalDigits: 2,
  );
  return fmt.format(importe);
}

String _simboloMoneda(String moneda) {
  switch (moneda) {
    case 'USD': return r'$';
    case 'GBP': return '£';
    case 'EUR':
    default:    return '€';
  }
}

String formatearFechaCorta(DateTime fecha) {
  return DateFormat('d MMM', CurrencyService.locale).format(fecha);
}

String formatearFechaLarga(DateTime fecha) {
  return DateFormat('d MMMM y', CurrencyService.locale).format(fecha);
}

String formatearMesAnio(DateTime fecha) {
  return DateFormat('MMMM y', CurrencyService.locale).format(fecha);
}
