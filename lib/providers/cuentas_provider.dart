import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/cuenta.dart';
import '../models/caja.dart';

class CuentasProvider extends ChangeNotifier {
  CuentasProvider({DatabaseHelper? db}) : _db = db ?? DatabaseHelper.instance;

  final DatabaseHelper _db;

  List<Cuenta> _cuentas = [];
  bool _cargando = false;
  String _modoActual = ModoApp.personal;

  List<Cuenta> get cuentas => List.unmodifiable(_cuentas);
  bool get cargando => _cargando;

  double get patrimonioTotal =>
      _cuentas.where((c) => c.incluirEnTotal).fold<double>(0, (s, c) => s + c.saldo);

  Cuenta? get cuentaPrincipal {
    for (final c in _cuentas) {
      if (c.esPrincipal) return c;
    }
    return _cuentas.isNotEmpty ? _cuentas.first : null;
  }

  Cuenta? porId(int id) {
    for (final c in _cuentas) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<void> cargar(String modo) async {
    _modoActual = modo;
    _cargando = true;
    notifyListeners();

    // Auto-seed empresa cuentas on first use
    await _db.seedCuentasEmpresaIfEmpty(modo);

    final filas = await _db.getCuentas(modo);
    _cuentas = filas.map(Cuenta.fromMap).toList();

    _cargando = false;
    notifyListeners();
  }

  Future<void> recargar() => cargar(_modoActual);

  Future<Cuenta> agregarCuenta(Cuenta cuenta) async {
    final id = await _db.insertCuenta(cuenta.toMap());
    final nueva = cuenta.copyWith(id: id);
    _cuentas = [..._cuentas, nueva];
    notifyListeners();
    return nueva;
  }

  Future<void> actualizarCuenta(Cuenta cuenta) async {
    final id = cuenta.id;
    if (id == null) return;
    await _db.updateCuenta(id, cuenta.toMap());
    _cuentas = _cuentas.map((c) => c.id == id ? cuenta : c).toList();
    notifyListeners();
  }

  Future<void> eliminarCuenta(int id) async {
    await _db.deleteCuenta(id);
    _cuentas = _cuentas.where((c) => c.id != id).toList();
    notifyListeners();
  }

  Future<void> toggleIncluirEnTotal(int id) async {
    final idx = _cuentas.indexWhere((c) => c.id == id);
    if (idx == -1) return;
    final actual = _cuentas[idx];
    final actualizada = actual.copyWith(
      incluirEnTotal: !actual.incluirEnTotal,
      actualizadoEn: DateTime.now(),
    );
    await _db.updateCuenta(id, actualizada.toMap());
    _cuentas = [..._cuentas]..[idx] = actualizada;
    notifyListeners();
  }

  Future<void> marcarComoPrincipal(int id) async {
    final ahora = DateTime.now();
    final actualizadas = <Cuenta>[];
    for (final c in _cuentas) {
      if (c.id == id) {
        final nueva = c.copyWith(esPrincipal: true, actualizadoEn: ahora);
        await _db.updateCuenta(c.id!, nueva.toMap());
        actualizadas.add(nueva);
      } else if (c.esPrincipal) {
        final desmarcada = c.copyWith(esPrincipal: false, actualizadoEn: ahora);
        await _db.updateCuenta(c.id!, desmarcada.toMap());
        actualizadas.add(desmarcada);
      } else {
        actualizadas.add(c);
      }
    }
    _cuentas = actualizadas;
    notifyListeners();
  }

  Future<void> actualizarSaldoDirecto(int id, double nuevoSaldo) async {
    final idx = _cuentas.indexWhere((c) => c.id == id);
    if (idx == -1) return;
    final actual = _cuentas[idx];
    final actualizada = actual.copyWith(saldo: nuevoSaldo, actualizadoEn: DateTime.now());
    await _db.updateCuenta(id, actualizada.toMap());
    _cuentas = [..._cuentas]..[idx] = actualizada;
    notifyListeners();
  }

  void aplicarDeltaSaldoLocal(int cuentaId, double delta) {
    final idx = _cuentas.indexWhere((c) => c.id == cuentaId);
    if (idx == -1) return;
    final actual = _cuentas[idx];
    final actualizada = actual.copyWith(
      saldo: actual.saldo + delta,
      actualizadoEn: DateTime.now(),
    );
    _cuentas = [..._cuentas]..[idx] = actualizada;
    notifyListeners();
  }
}
