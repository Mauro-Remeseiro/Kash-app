import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/ajustes_provider.dart';
import 'providers/cajas_provider.dart';
import 'providers/empleados_provider.dart';
import 'providers/movimientos_provider.dart';
import 'screens/personal/home_screen.dart';
import 'theme/app_theme.dart';

class KashApp extends StatefulWidget {
  const KashApp({super.key});

  @override
  State<KashApp> createState() => _KashAppState();
}

class _KashAppState extends State<KashApp> {
  late final AjustesProvider _ajustesProvider;
  late final CajasProvider _cajasProvider;
  late final EmpleadosProvider _empleadosProvider;
  late final MovimientosProvider _movimientosProvider;

  @override
  void initState() {
    super.initState();
    _ajustesProvider = AjustesProvider();
    _cajasProvider = CajasProvider();
    _empleadosProvider = EmpleadosProvider();
    _movimientosProvider = MovimientosProvider();
    _cargarDatosIniciales();
  }

  Future<void> _cargarDatosIniciales() async {
    await _ajustesProvider.cargar();
    final modo = _ajustesProvider.modoApp;
    await Future.wait([
      _cajasProvider.cargar(modo),
      _empleadosProvider.cargar(),
      _movimientosProvider.cargar(modo: modo),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _ajustesProvider),
        ChangeNotifierProvider.value(value: _cajasProvider),
        ChangeNotifierProvider.value(value: _empleadosProvider),
        ChangeNotifierProvider.value(value: _movimientosProvider),
      ],
      child: Consumer<AjustesProvider>(
        builder: (context, ajustes, _) {
          return MaterialApp(
            title: 'Kash',
            debugShowCheckedModeBanner: false,
            themeMode: ajustes.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: const _KashRoot(),
          );
        },
      ),
    );
  }
}

class _KashRoot extends StatelessWidget {
  const _KashRoot();

  @override
  Widget build(BuildContext context) {
    final ajustes = context.watch<AjustesProvider>();

    if (!ajustes.cargado) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (ajustes.esModoEmpresa) {
      return const _ModoEmpresaPendiente();
    }

    return const HomeScreen();
  }
}

/// El modo Empresa se implementa en una fase posterior del orden de
/// desarrollo (paso 9): de momento solo el modo Personal está disponible.
class _ModoEmpresaPendiente extends StatelessWidget {
  const _ModoEmpresaPendiente();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ajustes = context.read<AjustesProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Modo Empresa', style: theme.textTheme.displayLarge),
                const SizedBox(height: 8),
                Text(
                  'PRÓXIMAMENTE',
                  style: theme.textTheme.labelSmall,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ajustes.setModoApp('personal'),
                  child: const Text('Volver a modo Personal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
