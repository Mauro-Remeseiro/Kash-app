import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:kash/app.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
    await initializeDateFormatting('es_ES');
  });

  testWidgets('Kash app shows the home placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const KashApp());

    // La carga inicial (BD + providers) hace E/S real (sqflite FFI), que el
    // reloj simulado de los tests no avanza por sí solo: hay que ejecutar esa
    // espera dentro de `runAsync` para que los Future reales se completen.
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    await tester.pump();

    expect(find.text('Kash'), findsOneWidget);
  });
}
