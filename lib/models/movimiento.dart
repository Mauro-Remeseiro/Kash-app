class TipoMovimiento {
  static const String gasto = 'gasto';
  static const String ingreso = 'ingreso';
}

class Movimiento {
  final int? id;
  final String tipo;
  final double importe;
  final String? nota;
  final String categoria;
  final int cuentaId;
  final int? empleadoId;
  final DateTime fecha;
  final String modo;
  final bool aprobado;

  const Movimiento({
    this.id,
    required this.tipo,
    required this.importe,
    this.nota,
    required this.categoria,
    required this.cuentaId,
    this.empleadoId,
    required this.fecha,
    required this.modo,
    this.aprobado = true,
  });

  bool get esGasto => tipo == TipoMovimiento.gasto;
  bool get esIngreso => tipo == TipoMovimiento.ingreso;

  double get importeConSigno => esGasto ? -importe : importe;

  factory Movimiento.fromMap(Map<String, Object?> map) {
    return Movimiento(
      id: map['id'] as int?,
      tipo: map['tipo'] as String,
      importe: (map['importe'] as num).toDouble(),
      nota: map['nota'] as String?,
      categoria: map['categoria'] as String,
      cuentaId: map['cuenta_id'] as int,
      empleadoId: map['empleado_id'] as int?,
      fecha: DateTime.parse(map['fecha'] as String),
      modo: map['modo'] as String,
      aprobado: ((map['aprobado'] as int?) ?? 1) == 1,
    );
  }

  Map<String, Object?> toMap({bool incluirId = false}) {
    final map = <String, Object?>{
      'tipo': tipo,
      'importe': importe,
      'nota': nota,
      'categoria': categoria,
      'cuenta_id': cuentaId,
      'empleado_id': empleadoId,
      'fecha': fecha.toIso8601String(),
      'modo': modo,
      'aprobado': aprobado ? 1 : 0,
    };
    if (incluirId && id != null) map['id'] = id;
    return map;
  }

  Movimiento copyWith({
    int? id,
    String? tipo,
    double? importe,
    String? nota,
    String? categoria,
    int? cuentaId,
    int? empleadoId,
    DateTime? fecha,
    String? modo,
    bool? aprobado,
  }) {
    return Movimiento(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      importe: importe ?? this.importe,
      nota: nota ?? this.nota,
      categoria: categoria ?? this.categoria,
      cuentaId: cuentaId ?? this.cuentaId,
      empleadoId: empleadoId ?? this.empleadoId,
      fecha: fecha ?? this.fecha,
      modo: modo ?? this.modo,
      aprobado: aprobado ?? this.aprobado,
    );
  }
}
