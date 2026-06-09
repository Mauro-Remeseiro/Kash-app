class Cuenta {
  final int? id;
  final String nombre;
  final String icono;
  final double saldo;
  final bool incluirEnTotal;
  final bool esPrincipal;
  final String modo;
  final String? color;
  final DateTime actualizadoEn;
  final DateTime creadoEn;

  const Cuenta({
    this.id,
    required this.nombre,
    this.icono = '💵',
    this.saldo = 0,
    this.incluirEnTotal = true,
    this.esPrincipal = false,
    required this.modo,
    this.color,
    required this.actualizadoEn,
    required this.creadoEn,
  });

  factory Cuenta.fromMap(Map<String, Object?> map) {
    return Cuenta(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      icono: map['icono'] as String? ?? '💵',
      saldo: (map['saldo'] as num).toDouble(),
      incluirEnTotal: ((map['incluir_en_total'] as int?) ?? 1) == 1,
      esPrincipal: ((map['es_principal'] as int?) ?? 0) == 1,
      modo: map['modo'] as String,
      color: map['color'] as String?,
      actualizadoEn: DateTime.parse(map['actualizado_en'] as String),
      creadoEn: DateTime.parse(map['creado_en'] as String),
    );
  }

  Map<String, Object?> toMap({bool incluirId = false}) {
    final map = <String, Object?>{
      'nombre': nombre,
      'icono': icono,
      'saldo': saldo,
      'incluir_en_total': incluirEnTotal ? 1 : 0,
      'es_principal': esPrincipal ? 1 : 0,
      'modo': modo,
      'color': color,
      'actualizado_en': actualizadoEn.toIso8601String(),
      'creado_en': creadoEn.toIso8601String(),
    };
    if (incluirId && id != null) map['id'] = id;
    return map;
  }

  Cuenta copyWith({
    int? id,
    String? nombre,
    String? icono,
    double? saldo,
    bool? incluirEnTotal,
    bool? esPrincipal,
    String? modo,
    String? color,
    DateTime? actualizadoEn,
    DateTime? creadoEn,
  }) {
    return Cuenta(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      icono: icono ?? this.icono,
      saldo: saldo ?? this.saldo,
      incluirEnTotal: incluirEnTotal ?? this.incluirEnTotal,
      esPrincipal: esPrincipal ?? this.esPrincipal,
      modo: modo ?? this.modo,
      color: color ?? this.color,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }
}
