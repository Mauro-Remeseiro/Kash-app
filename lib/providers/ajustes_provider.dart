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

  bool get cargado => _cargado;
  String get modoApp => _modoApp;
  String get tema => _tema;
  double get presupuestoMensual => _presupuestoMensual;
  String get moneda => _moneda;

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
    _cargado = true;
    notifyListeners();
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
