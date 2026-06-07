import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/caja.dart';

class CajasProvider extends ChangeNotifier {
  CajasProvider({DatabaseHelper? db}) : _db = db ?? DatabaseHelper.instance;

  final DatabaseHelper _db;

  List<Caja> _cajas = [];
  bool _cargando = false;
  String _modoActual = ModoApp.personal;

  List<Caja> get cajas => List.unmodifiable(_cajas);
  bool get cargando => _cargando;

  double get patrimonioTotal =>
      _cajas.fold<double>(0, (suma, caja) => suma + caja.saldo);

  Caja? porId(int id) {
    for (final caja in _cajas) {
      if (caja.id == id) return caja;
    }
    return null;
  }

  Future<void> cargar(String modo) async {
    _modoActual = modo;
    _cargando = true;
    notifyListeners();

    final filas = await _db.getCajas(modo);
    _cajas = filas.map(Caja.fromMap).toList();

    _cargando = false;
    notifyListeners();
  }

  Future<void> recargar() => cargar(_modoActual);

  Future<Caja> agregarCaja(Caja caja) async {
    final id = await _db.insertCaja(caja.toMap());
    final nueva = caja.copyWith(id: id);
    _cajas = [..._cajas, nueva];
    notifyListeners();
    return nueva;
  }

  Future<void> actualizarCaja(Caja caja) async {
    final id = caja.id;
    if (id == null) return;
    await _db.updateCaja(id, caja.toMap());
    _cajas = _cajas.map((c) => c.id == id ? caja : c).toList();
    notifyListeners();
  }

  Future<void> eliminarCaja(int id) async {
    await _db.deleteCaja(id);
    _cajas = _cajas.where((c) => c.id != id).toList();
    notifyListeners();
  }

  /// Refleja en memoria el cambio de saldo ya persistido en base de datos
  /// (por ejemplo, tras registrar un movimiento desde [MovimientosProvider]).
  void aplicarDeltaSaldoLocal(int cajaId, double delta) {
    final indice = _cajas.indexWhere((c) => c.id == cajaId);
    if (indice == -1) return;
    final actual = _cajas[indice];
    final actualizada = actual.copyWith(saldo: actual.saldo + delta);
    _cajas = [..._cajas]..[indice] = actualizada;
    notifyListeners();
  }
}
