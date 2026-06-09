import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kash/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'models/caja.dart';
import 'providers/ajustes_provider.dart';
import 'providers/cuentas_provider.dart';
import 'providers/empleados_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/movimientos_provider.dart';
import 'screens/ajustes/ajustes_screen.dart';
import 'screens/empresa/empresa_home_screen.dart';
import 'screens/lock_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/personal/cuentas_screen.dart';
import 'screens/personal/home_screen.dart';
import 'screens/personal/stats_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';
import 'theme/kash_colors.dart';

class KashApp extends StatefulWidget {
  const KashApp({super.key});

  @override
  State<KashApp> createState() => _KashAppState();
}

class _KashAppState extends State<KashApp> with WidgetsBindingObserver {
  late final AjustesProvider _ajustesProvider;
  late final CuentasProvider _cuentasProvider;
  late final EmpleadosProvider _empleadosProvider;
  late final MovimientosProvider _movimientosProvider;
  late final LocaleProvider _localeProvider;

  bool _isLocked = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ajustesProvider = AjustesProvider();
    _cuentasProvider = CuentasProvider();
    _empleadosProvider = EmpleadosProvider();
    _movimientosProvider = MovimientosProvider();
    _localeProvider = LocaleProvider();
    _cargarDatosIniciales();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      final enabled = await AuthService.isEnabled;
      if (enabled && mounted) setState(() => _isLocked = true);
    }
  }

  Future<void> _cargarDatosIniciales() async {
    final authEnabled = await AuthService.isEnabled;
    if (!authEnabled && mounted) setState(() => _isLocked = false);

    await Future.wait([
      _localeProvider.init(),
      _ajustesProvider.cargar(),
    ]);

    final modo = _ajustesProvider.modoApp;
    await Future.wait([
      _cuentasProvider.cargar(modo),
      _empleadosProvider.cargar(),
      _movimientosProvider.cargar(modo: modo),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _ajustesProvider),
        ChangeNotifierProvider.value(value: _cuentasProvider),
        ChangeNotifierProvider.value(value: _empleadosProvider),
        ChangeNotifierProvider.value(value: _movimientosProvider),
        ChangeNotifierProvider.value(value: _localeProvider),
      ],
      child: Consumer2<AjustesProvider, LocaleProvider>(
        builder: (context, ajustes, locale, _) {
          return MaterialApp(
            title: 'Kash',
            debugShowCheckedModeBanner: false,
            themeMode: ajustes.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            locale: locale.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es'),
              Locale('en'),
              Locale('pt'),
              Locale('fr'),
              Locale('de'),
              Locale('it'),
            ],
            home: _isLocked
                ? LockScreen(onUnlocked: () => setState(() => _isLocked = false))
                : const _KashRoot(),
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

    if (!ajustes.onboardingCompletado) {
      return OnboardingScreen(
        onComplete: () => context.read<AjustesProvider>().completarOnboarding(),
      );
    }

    return _KashShell(modo: ajustes.modoApp);
  }
}

class _KashShell extends StatefulWidget {
  const _KashShell({required this.modo});

  final String modo;

  @override
  State<_KashShell> createState() => _KashShellState();
}

class _KashShellState extends State<_KashShell> {
  int _tabIndex = 0;

  @override
  void didUpdateWidget(covariant _KashShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modo != widget.modo) _tabIndex = 0;
  }

  List<Widget> get _screens => widget.modo == ModoApp.empresa
      ? const [EmpresaHomeScreen(), StatsScreen(), CuentasScreen(), AjustesScreen()]
      : const [HomeScreen(), StatsScreen(), CuentasScreen(), AjustesScreen()];

  @override
  Widget build(BuildContext context) {
    final colors = kashColorsOf(context);

    return Scaffold(
      body: IndexedStack(index: _tabIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _tabIndex,
          onTap: (i) => setState(() => _tabIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Cuentas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Ajustes',
            ),
          ],
        ),
      ),
    );
  }
}
