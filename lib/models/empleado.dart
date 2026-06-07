class Empleado {
  final int? id;
  final String nombre;
  final String iniciales;
  final bool activo;

  const Empleado({
    this.id,
    required this.nombre,
    required this.iniciales,
    this.activo = true,
  });

  factory Empleado.fromMap(Map<String, Object?> map) {
    return Empleado(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      iniciales: map['iniciales'] as String,
      activo: (map['activo'] as int) == 1,
    );
  }

  Map<String, Object?> toMap({bool incluirId = false}) {
    final map = <String, Object?>{
      'nombre': nombre,
      'iniciales': iniciales,
      'activo': activo ? 1 : 0,
    };
    if (incluirId && id != null) {
      map['id'] = id;
    }
    return map;
  }

  Empleado copyWith({
    int? id,
    String? nombre,
    String? iniciales,
    bool? activo,
  }) {
    return Empleado(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      iniciales: iniciales ?? this.iniciales,
      activo: activo ?? this.activo,
    );
  }
}
