import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/movimiento.dart';
import 'cuentas_provider.dart';

enum FiltroPeriodo { semana, mes, todo }

class MovimientosProvider extends ChangeNotifier {
  MovimientosProvider({DatabaseHelper? db}) : _db = db ?? DatabaseHelper.instance;

  final DatabaseHelper _db;

  List<Movimiento> _movimientos = [];
  bool _cargando = false;
  String _modoActual = 'personal';
  FiltroPeriodo _filtro = FiltroPeriodo.mes;
  int? _cuentaFiltroId;

  List<Movimiento> get movimientos => List.unmodifiable(_movimientos);
  bool get cargando => _cargando;
  FiltroPeriodo get filtro => _filtro;
  int? get cuentaFiltroId => _cuentaFiltroId;

  double get totalGastos => _movimientos
      .where((m) => m.esGasto)
      .fold<double>(0, (s, m) => s + m.importe);

  double get totalIngresos => _movimientos
      .where((m) => m.esIngreso)
      .fold<double>(0, (s, m) => s + m.importe);

  double get balance => totalIngresos - totalGastos;

  List<Movimiento> get pendientesDeAprobar =>
      _movimientos.where((m) => !m.aprobado).toList(growable: false);

  double get importePendienteDeAprobar =>
      pendientesDeAprobar.fold<double>(0, (s, m) => s + m.importe);

  ({DateTime desde, DateTime hasta}) _rangoParaFiltro(FiltroPeriodo f) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final hasta = hoy.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    switch (f) {
      case FiltroPeriodo.semana:
        return (desde: hoy.subtract(Duration(days: hoy.weekday - 1)), hasta: hasta);
      case FiltroPeriodo.mes:
        return (desde: DateTime(hoy.year, hoy.month, 1), hasta: hasta);
      case FiltroPeriodo.todo:
        return (desde: DateTime(2000, 1, 1), hasta: hasta);
    }
  }

  Future<void> cargar({
    required String modo,
    FiltroPeriodo? filtro,
    int? cuentaId,
    bool resetCuentaFiltro = false,
  }) async {
    _modoActual = modo;
    _filtro = filtro ?? _filtro;
    if (resetCuentaFiltro) _cuentaFiltroId = null;
    if (cuentaId != null) _cuentaFiltroId = cuentaId;

    _cargando = true;
    notifyListeners();

    final rango = _rangoParaFiltro(_filtro);
    final filas = await _db.getMovimientos(
      modo: modo,
      desde: rango.desde,
      hasta: rango.hasta,
      cuentaId: _cuentaFiltroId,
    );
    _movimientos = filas.map(Movimiento.fromMap).toList();

    _cargando = false;
    notifyListeners();
  }

  Future<void> cambiarFiltro(FiltroPeriodo filtro) =>
      cargar(modo: _modoActual, filtro: filtro);

  Future<void> cambiarCuentaFiltro(int? cuentaId) async {
    _cuentaFiltroId = cuentaId;
    return cargar(modo: _modoActual);
  }

  Future<void> recargar() => cargar(modo: _modoActual, filtro: _filtro);

  Future<Movimiento> agregarMovimiento(
    Movimiento movimiento, {
    CuentasProvider? cuentasProvider,
  }) async {
    final id = await _db.insertMovimiento(movimiento.toMap());
    await _db.ajustarSaldoCuenta(movimiento.cuentaId, movimiento.importeConSigno);
    cuentasProvider?.aplicarDeltaSaldoLocal(movimiento.cuentaId, movimiento.importeConSigno);

    final nuevo = movimiento.copyWith(id: id);
    if (_cuentaFiltroId == null || _cuentaFiltroId == movimiento.cuentaId) {
      _movimientos = [nuevo, ..._movimientos];
    }
    notifyListeners();
    return nuevo;
  }

  Future<void> actualizarMovimiento(
    Movimiento movimiento, {
    CuentasProvider? cuentasProvider,
  }) async {
    final id = movimiento.id;
    if (id == null) return;

    final anterior = await _db.getMovimiento(id);
    if (anterior == null) return;
    final original = Movimiento.fromMap(anterior);

    await _db.ajustarSaldoCuenta(original.cuentaId, -original.importeConSigno);
    cuentasProvider?.aplicarDeltaSaldoLocal(original.cuentaId, -original.importeConSigno);

    await _db.updateMovimiento(id, movimiento.toMap());

    await _db.ajustarSaldoCuenta(movimiento.cuentaId, movimiento.importeConSigno);
    cuentasProvider?.aplicarDeltaSaldoLocal(movimiento.cuentaId, movimiento.importeConSigno);

    _movimientos = _movimientos.map((m) => m.id == id ? movimiento : m).toList();
    notifyListeners();
  }

  Future<void> eliminarMovimiento(
    int id, {
    CuentasProvider? cuentasProvider,
  }) async {
    final fila = await _db.getMovimiento(id);
    if (fila == null) return;
    final movimiento = Movimiento.fromMap(fila);

    await _db.deleteMovimiento(id);
    await _db.ajustarSaldoCuenta(movimiento.cuentaId, -movimiento.importeConSigno);
    cuentasProvider?.aplicarDeltaSaldoLocal(movimiento.cuentaId, -movimiento.importeConSigno);

    _movimientos = _movimientos.where((m) => m.id != id).toList();
    notifyListeners();
  }

  Future<void> aprobarMovimiento(int id) async {
    final fila = await _db.getMovimiento(id);
    if (fila == null) return;
    final movimiento = Movimiento.fromMap(fila).copyWith(aprobado: true);
    await _db.updateMovimiento(id, movimiento.toMap());
    _movimientos = _movimientos.map((m) => m.id == id ? movimiento : m).toList();
    notifyListeners();
  }
}
