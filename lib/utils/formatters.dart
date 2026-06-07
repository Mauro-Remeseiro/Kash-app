import 'package:intl/intl.dart';

String formatearImporte(double importe, {String moneda = 'EUR'}) {
  final formato = NumberFormat.currency(
    locale: 'es_ES',
    name: moneda,
    symbol: _simboloMoneda(moneda),
    decimalDigits: 2,
  );
  return formato.format(importe);
}

String _simboloMoneda(String moneda) {
  switch (moneda) {
    case 'USD':
      return r'$';
    case 'GBP':
      return '£';
    case 'EUR':
    default:
      return '€';
  }
}

String formatearFechaCorta(DateTime fecha) {
  return DateFormat('d MMM', 'es_ES').format(fecha);
}

String formatearFechaLarga(DateTime fecha) {
  return DateFormat('d MMMM y', 'es_ES').format(fecha);
}

String formatearMesAnio(DateTime fecha) {
  return DateFormat('MMMM y', 'es_ES').format(fecha);
}
