import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/empleado.dart';

class EmpleadosProvider extends ChangeNotifier {
  EmpleadosProvider({DatabaseHelper? db}) : _db = db ?? DatabaseHelper.instance;

  final DatabaseHelper _db;

  List<Empleado> _empleados = [];
  bool _cargando = false;

  List<Empleado> get empleados => List.unmodifiable(_empleados);
  List<Empleado> get empleadosActivos =>
      _empleados.where((e) => e.activo).toList(growable: false);
  bool get cargando => _cargando;
  int get total => _empleados.length;

  Empleado? porId(int id) {
    for (final empleado in _empleados) {
      if (empleado.id == id) return empleado;
    }
    return null;
  }

  Future<void> cargar() async {
    _cargando = true;
    notifyListeners();

    final filas = await _db.getEmpleados();
    _empleados = filas.map(Empleado.fromMap).toList();

    _cargando = false;
    notifyListeners();
  }

  Future<Empleado> agregarEmpleado(Empleado empleado) async {
    final id = await _db.insertEmpleado(empleado.toMap());
    final nuevo = empleado.copyWith(id: id);
    _empleados = [..._empleados, nuevo];
    notifyListeners();
    return nuevo;
  }

  Future<void> actualizarEmpleado(Empleado empleado) async {
    final id = empleado.id;
    if (id == null) return;
    await _db.updateEmpleado(id, empleado.toMap());
    _empleados = _empleados.map((e) => e.id == id ? empleado : e).toList();
    notifyListeners();
  }

  Future<void> eliminarEmpleado(int id) async {
    await _db.deleteEmpleado(id);
    _empleados = _empleados.where((e) => e.id != id).toList();
    notifyListeners();
  }
}
