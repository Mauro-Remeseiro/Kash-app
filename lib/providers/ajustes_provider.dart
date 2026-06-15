import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/ajuste.dart';
import '../models/caja.dart';

class AjustesProvider extends ChangeNotifier {
  AjustesProvider({DatabaseHelper? db}) : _db = db ?? DatabaseHelper.instance;

  final DatabaseHelper _db;

  bool _cargado = false;
  String _modoApp = ModoApp.personal;
  String _tema = TemaAjuste.system;
  double _presupuestoMensual = 0;
  String _moneda = 'EUR';
  bool _onboardingCompletado = false;
  String _kashAiUso = '';

  bool get cargado => _cargado;
  String get modoApp => _modoApp;
  String get tema => _tema;
  double get presupuestoMensual => _presupuestoMensual;
  String get moneda => _moneda;
  bool get onboardingCompletado => _onboardingCompletado;

  /// Consultas a Kash AI permitidas por mes en el plan gratuito.
  static const int kashAiLimiteMensual = 10;

  String get _mesActual {
    final ahora = DateTime.now();
    return '${ahora.year}-${ahora.month.toString().padLeft(2, '0')}';
  }

  /// Consultas a Kash AI ya realizadas en el mes en curso.
  int get kashAiConsultasUsadas {
    final partes = _kashAiUso.split(':');
    if (partes.length != 2 || partes[0] != _mesActual) return 0;
    return int.tryParse(partes[1]) ?? 0;
  }

  /// Consultas a Kash AI restantes en el mes en curso (plan gratuito).
  int get kashAiConsultasRestantes =>
      (kashAiLimiteMensual - kashAiConsultasUsadas).clamp(0, kashAiLimiteMensual);

  bool get esModoEmpresa => _modoApp == ModoApp.empresa;

  ThemeMode get themeMode {
    switch (_tema) {
      case TemaAjuste.dark:
        return ThemeMode.dark;
      case TemaAjuste.light:
        return ThemeMode.light;
      case TemaAjuste.system:
      default:
        return ThemeMode.system;
    }
  }

  Future<void> cargar() async {
    final valores = await _db.getTodosLosAjustes();
    _modoApp = valores[ClaveAjuste.modoApp] ?? _modoApp;
    _tema = valores[ClaveAjuste.tema] ?? _tema;
    _presupuestoMensual = double.tryParse(
          valores[ClaveAjuste.presupuestoMensual] ?? '',
        ) ??
        _presupuestoMensual;
    _moneda = valores[ClaveAjuste.moneda] ?? _moneda;
    _onboardingCompletado =
        (valores[ClaveAjuste.onboardingCompletado] ?? '0') == '1';
    _kashAiUso = valores[ClaveAjuste.kashAiUso] ?? '';
    _cargado = true;
    notifyListeners();
  }

  /// Registra una consulta a Kash AI. Devuelve `false` si ya se alcanzó el
  /// límite mensual del plan gratuito y la consulta no debe enviarse.
  Future<bool> registrarConsultaKashAi() async {
    final usadas = kashAiConsultasUsadas;
    if (usadas >= kashAiLimiteMensual) return false;
    _kashAiUso = '$_mesActual:${usadas + 1}';
    notifyListeners();
    await _db.setAjuste(ClaveAjuste.kashAiUso, _kashAiUso);
    return true;
  }

  Future<void> completarOnboarding() async {
    if (_onboardingCompletado) return;
    _onboardingCompletado = true;
    notifyListeners();
    await _db.setAjuste(ClaveAjuste.onboardingCompletado, '1');
  }

  Future<void> setModoApp(String modo) async {
    if (_modoApp == modo) return;
    _modoApp = modo;
    notifyListeners();
    await _db.setAjuste(ClaveAjuste.modoApp, modo);
  }

  Future<void> setTema(String tema) async {
    if (_tema == tema) return;
    _tema = tema;
    notifyListeners();
    await _db.setAjuste(ClaveAjuste.tema, tema);
  }

  Future<void> setPresupuestoMensual(double valor) async {
    if (_presupuestoMensual == valor) return;
    _presupuestoMensual = valor;
    notifyListeners();
    await _db.setAjuste(ClaveAjuste.presupuestoMensual, valor.toString());
  }

  Future<void> setMoneda(String moneda) async {
    if (_moneda == moneda) return;
    _moneda = moneda;
    notifyListeners();
    await _db.setAjuste(ClaveAjuste.moneda, moneda);
  }
}
