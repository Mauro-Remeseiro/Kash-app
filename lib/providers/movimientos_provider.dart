import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/movimiento.dart';
import 'cajas_provider.dart';

/// Rango de fechas para filtrar movimientos en pantalla.
enum FiltroPeriodo { semana, mes, todo }

class MovimientosProvider extends ChangeNotifier {
  MovimientosProvider({DatabaseHelper? db}) : _db = db ?? DatabaseHelper.instance;

  final DatabaseHelper _db;

  List<Movimiento> _movimientos = [];
  bool _cargando = false;
  String _modoActual = 'personal';
  FiltroPeriodo _filtro = FiltroPeriodo.mes;

  List<Movimiento> get movimientos => List.unmodifiable(_movimientos);
  bool get cargando => _cargando;
  FiltroPeriodo get filtro => _filtro;

  double get totalGastos => _movimientos
      .where((m) => m.esGasto)
      .fold<double>(0, (suma, m) => suma + m.importe);

  double get totalIngresos => _movimientos
      .where((m) => m.esIngreso)
      .fold<double>(0, (suma, m) => suma + m.importe);

  double get balance => totalIngresos - totalGastos;

  List<Movimiento> get pendientesDeAprobar =>
      _movimientos.where((m) => !m.aprobado).toList(growable: false);

  double get importePendienteDeAprobar => pendientesDeAprobar.fold<double>(
        0,
        (suma, m) => suma + m.importe,
      );

  ({DateTime desde, DateTime hasta}) _rangoParaFiltro(FiltroPeriodo filtro) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final hasta = hoy.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

    switch (filtro) {
      case FiltroPeriodo.semana:
        final desde = hoy.subtract(Duration(days: hoy.weekday - 1));
        return (desde: desde, hasta: hasta);
      case FiltroPeriodo.mes:
        final desde = DateTime(hoy.year, hoy.month, 1);
        return (desde: desde, hasta: hasta);
      case FiltroPeriodo.todo:
        return (desde: DateTime(2000, 1, 1), hasta: hasta);
    }
  }

  Future<void> cargar({
    required String modo,
    FiltroPeriodo? filtro,
  }) async {
    _modoActual = modo;
    _filtro = filtro ?? _filtro;
    _cargando = true;
    notifyListeners();

    final rango = _rangoParaFiltro(_filtro);
    final filas = await _db.getMovimientos(
      modo: modo,
      desde: rango.desde,
      hasta: rango.hasta,
    );
    _movimientos = filas.map(Movimiento.fromMap).toList();

    _cargando = false;
    notifyListeners();
  }

  Future<void> cambiarFiltro(FiltroPeriodo filtro) => cargar(
        modo: _modoActual,
        filtro: filtro,
      );

  Future<void> recargar() => cargar(modo: _modoActual, filtro: _filtro);

  Future<Movimiento> agregarMovimiento(
    Movimiento movimiento, {
    CajasProvider? cajasProvider,
  }) async {
    final id = await _db.insertMovimiento(movimiento.toMap());
    await _db.ajustarSaldoCaja(movimiento.cajaId, movimiento.importeConSigno);
    cajasProvider?.aplicarDeltaSaldoLocal(movimiento.cajaId, movimiento.importeConSigno);

    final nuevo = movimiento.copyWith(id: id);
    _movimientos = [nuevo, ..._movimientos];
    notifyListeners();
    return nuevo;
  }

  Future<void> actualizarMovimiento(
    Movimiento movimiento, {
    CajasProvider? cajasProvider,
  }) async {
    final id = movimiento.id;
    if (id == null) return;

    final anterior = await _db.getMovimiento(id);
    if (anterior == null) return;
    final original = Movimiento.fromMap(anterior);

    // Revertir el efecto del movimiento original sobre su caja.
    await _db.ajustarSaldoCaja(original.cajaId, -original.importeConSigno);
    cajasProvider?.aplicarDeltaSaldoLocal(original.cajaId, -original.importeConSigno);

    await _db.updateMovimiento(id, movimiento.toMap());

    // Aplicar el efecto del movimiento actualizado sobre su (nueva) caja.
    await _db.ajustarSaldoCaja(movimiento.cajaId, movimiento.importeConSigno);
    cajasProvider?.aplicarDeltaSaldoLocal(movimiento.cajaId, movimiento.importeConSigno);

    _movimientos = _movimientos.map((m) => m.id == id ? movimiento : m).toList();
    notifyListeners();
  }

  Future<void> eliminarMovimiento(
    int id, {
    CajasProvider? cajasProvider,
  }) async {
    final fila = await _db.getMovimiento(id);
    if (fila == null) return;
    final movimiento = Movimiento.fromMap(fila);

    await _db.deleteMovimiento(id);
    await _db.ajustarSaldoCaja(movimiento.cajaId, -movimiento.importeConSigno);
    cajasProvider?.aplicarDeltaSaldoLocal(movimiento.cajaId, -movimiento.importeConSigno);

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
