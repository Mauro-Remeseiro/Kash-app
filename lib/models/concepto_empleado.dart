/// Tipos de concepto para los pagos a empleados.
class TipoConcepto {
  static const String sueldo = 'sueldo';
  static const String comision = 'comision';
  static const String bonus = 'bonus';
  static const String dieta = 'dieta';
  static const String otro = 'otro';
}

class ConceptoEmpleado {
  final int? id;
  final int empleadoId;
  final String? tipo;
  final String? descripcion;
  final double importe;
  final DateTime fecha;
  final bool aprobado;

  const ConceptoEmpleado({
    this.id,
    required this.empleadoId,
    this.tipo,
    this.descripcion,
    required this.importe,
    required this.fecha,
    this.aprobado = true,
  });

  factory ConceptoEmpleado.fromMap(Map<String, Object?> map) {
    return ConceptoEmpleado(
      id: map['id'] as int?,
      empleadoId: map['empleado_id'] as int,
      tipo: map['tipo'] as String?,
      descripcion: map['descripcion'] as String?,
      importe: (map['importe'] as num).toDouble(),
      fecha: DateTime.parse(map['fecha'] as String),
      aprobado: (map['aprobado'] as int? ?? 1) == 1,
    );
  }

  Map<String, Object?> toMap({bool incluirId = false}) {
    final map = <String, Object?>{
      'empleado_id': empleadoId,
      'tipo': tipo,
      'descripcion': descripcion,
      'importe': importe,
      'fecha': fecha.toIso8601String(),
      'aprobado': aprobado ? 1 : 0,
    };
    if (incluirId && id != null) map['id'] = id;
    return map;
  }

  ConceptoEmpleado copyWith({
    int? id,
    int? empleadoId,
    String? tipo,
    bool limpiarTipo = false,
    String? descripcion,
    bool limpiarDescripcion = false,
    double? importe,
    DateTime? fecha,
    bool? aprobado,
  }) {
    return ConceptoEmpleado(
      id: id ?? this.id,
      empleadoId: empleadoId ?? this.empleadoId,
      tipo: limpiarTipo ? null : (tipo ?? this.tipo),
      descripcion: limpiarDescripcion ? null : (descripcion ?? this.descripcion),
      importe: importe ?? this.importe,
      fecha: fecha ?? this.fecha,
      aprobado: aprobado ?? this.aprobado,
    );
  }
}
