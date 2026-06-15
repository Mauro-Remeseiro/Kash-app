import 'package:flutter/foundation.dart';

import '../db/database_helper.dart';
import '../models/concepto_empleado.dart';

class ConceptosEmpleadoProvider extends ChangeNotifier {
  ConceptosEmpleadoProvider({DatabaseHelper? db}) : _db = db ?? DatabaseHelper.instance;

  final DatabaseHelper _db;

  final Map<int, List<ConceptoEmpleado>> _porEmpleado = {};
  final Set<int> _cargando = {};

  List<ConceptoEmpleado> conceptosDe(int empleadoId) =>
      List.unmodifiable(_porEmpleado[empleadoId] ?? const []);

  bool cargando(int empleadoId) => _cargando.contains(empleadoId);

  Future<void> cargar(int empleadoId) async {
    _cargando.add(empleadoId);
    notifyListeners();

    final filas = await _db.getConceptosEmpleado(empleadoId);
    _porEmpleado[empleadoId] = filas.map(ConceptoEmpleado.fromMap).toList();

    _cargando.remove(empleadoId);
    notifyListeners();
  }

  Future<ConceptoEmpleado> agregarConcepto(ConceptoEmpleado concepto) async {
    final id = await _db.insertConceptoEmpleado(concepto.toMap());
    final nuevo = concepto.copyWith(id: id);
    final lista = <ConceptoEmpleado>[nuevo, ...?_porEmpleado[concepto.empleadoId]];
    _porEmpleado[concepto.empleadoId] = lista;
    notifyListeners();
    return nuevo;
  }

  Future<void> actualizarConcepto(ConceptoEmpleado concepto) async {
    final id = concepto.id;
    if (id == null) return;
    await _db.updateConceptoEmpleado(id, concepto.toMap());
    final lista = _porEmpleado[concepto.empleadoId];
    if (lista != null) {
      _porEmpleado[concepto.empleadoId] =
          lista.map((c) => c.id == id ? concepto : c).toList();
    }
    notifyListeners();
  }

  Future<void> eliminarConcepto(int empleadoId, int id) async {
    await _db.deleteConceptoEmpleado(id);
    final lista = _porEmpleado[empleadoId];
    if (lista != null) {
      _porEmpleado[empleadoId] = lista.where((c) => c.id != id).toList();
    }
    notifyListeners();
  }

  Future<void> aprobarTodos(int empleadoId) async {
    await _db.aprobarTodosConceptosEmpleado(empleadoId);
    final lista = _porEmpleado[empleadoId];
    if (lista != null) {
      _porEmpleado[empleadoId] = lista.map((c) => c.copyWith(aprobado: true)).toList();
    }
    notifyListeners();
  }

  /// Suma de los importes de los conceptos del mes en curso para [empleadoId].
  double totalDelMes(int empleadoId) {
    final ahora = DateTime.now();
    return conceptosDe(empleadoId)
        .where((c) => c.fecha.year == ahora.year && c.fecha.month == ahora.month)
        .fold(0.0, (suma, c) => suma + c.importe);
  }

  bool tienePendientes(int empleadoId) =>
      conceptosDe(empleadoId).any((c) => !c.aprobado);
}
