import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:kash/app.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
    await initializeDateFormatting('es_ES');
    SharedPreferences.setMockInitialValues({});

    // El plugin flutter_secure_storage no tiene implementación en el entorno
    // de test: simulamos su canal para que AuthService.isEnabled/verifyPin
    // no lancen MissingPluginException.
    const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'readAll':
          return <String, String>{};
        default:
          return null;
      }
    });
  });

  testWidgets('Kash app shows the home placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const KashApp());

    // La carga inicial (BD + providers) hace E/S real (sqflite FFI), que el
    // reloj simulado de los tests no avanza por sí solo: hay que ejecutar esa
    // espera dentro de `runAsync` para que los Future reales se completen.
    // Se sondea en intervalos cortos en lugar de una única espera fija, ya que
    // el tiempo de carga varía según la carga de la máquina.
    for (var intento = 0; intento < 20; intento++) {
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 250)));
      await tester.pump();
      if (find.text('Kash').evaluate().isNotEmpty) break;
    }

    expect(find.text('Kash'), findsOneWidget);
  });
}
