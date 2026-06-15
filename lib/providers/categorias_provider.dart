import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/caja.dart';
import '../models/categoria.dart';

class CategoriasProvider extends ChangeNotifier {
  CategoriasProvider({DatabaseHelper? db}) : _db = db ?? DatabaseHelper.instance;

  final DatabaseHelper _db;

  List<Categoria> _categorias = [];
  bool _cargando = false;
  String _modoActual = ModoApp.personal;

  List<Categoria> get categorias => List.unmodifiable(_categorias);
  bool get cargando => _cargando;

  /// Categorías aplicables a un tipo de movimiento ('gasto' o 'ingreso').
  List<Categoria> paraTipo(String tipo) => _categorias
      .where((c) => c.tipo == TipoCategoria.ambos || c.tipo == tipo)
      .toList(growable: false);

  Categoria categoriaPorId(int? id) {
    if (id == null) return Categoria.sinCategoria;
    for (final c in _categorias) {
      if (c.id == id) return c;
    }
    return Categoria.sinCategoria;
  }

  Future<void> cargar(String modo) async {
    _modoActual = modo;
    _cargando = true;
    notifyListeners();

    final filas = await _db.getCategorias(modo);
    _categorias = filas.map(Categoria.fromMap).toList();

    _cargando = false;
    notifyListeners();
  }

  Future<void> recargar() => cargar(_modoActual);

  Future<Categoria> agregarCategoria(Categoria categoria) async {
    final id = await _db.insertCategoria(categoria.toMap());
    final nueva = categoria.copyWith(id: id);
    _categorias = [..._categorias, nueva];
    notifyListeners();
    return nueva;
  }

  Future<void> actualizarCategoria(Categoria categoria) async {
    final id = categoria.id;
    if (id == null) return;
    await _db.updateCategoria(id, categoria.toMap());
    _categorias = _categorias.map((c) => c.id == id ? categoria : c).toList();
    notifyListeners();
  }

  Future<int> contarMovimientos(int categoriaId) =>
      _db.contarMovimientosPorCategoria(categoriaId);

  Future<void> eliminarCategoria(int id, {int? moverMovimientosA}) async {
    await _db.reasignarMovimientos(id, moverMovimientosA);
    await _db.deleteCategoria(id);
    _categorias = _categorias.where((c) => c.id != id).toList();
    notifyListeners();
  }
}
