/// Tipos de caja soportados.
class TipoCaja {
  static const String efectivo = 'efectivo';
  static const String banco = 'banco';
  static const String ahorros = 'ahorros';
  static const String custom = 'custom';
}

/// Modo de la app/registro: personal o empresa.
class ModoApp {
  static const String personal = 'personal';
  static const String empresa = 'empresa';
}

class Caja {
  final int? id;
  final String nombre;
  final String tipo;
  final double saldo;
  final String modo;
  final String? icono;
  final String? color;
  final DateTime creadoEn;

  const Caja({
    this.id,
    required this.nombre,
    required this.tipo,
    this.saldo = 0,
    required this.modo,
    this.icono,
    this.color,
    required this.creadoEn,
  });

  factory Caja.fromMap(Map<String, Object?> map) {
    return Caja(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      tipo: map['tipo'] as String,
      saldo: (map['saldo'] as num).toDouble(),
      modo: map['modo'] as String,
      icono: map['icono'] as String?,
      color: map['color'] as String?,
      creadoEn: DateTime.parse(map['creado_en'] as String),
    );
  }

  Map<String, Object?> toMap({bool incluirId = false}) {
    final map = <String, Object?>{
      'nombre': nombre,
      'tipo': tipo,
      'saldo': saldo,
      'modo': modo,
      'icono': icono,
      'color': color,
      'creado_en': creadoEn.toIso8601String(),
    };
    if (incluirId && id != null) {
      map['id'] = id;
    }
    return map;
  }

  Caja copyWith({
    int? id,
    String? nombre,
    String? tipo,
    double? saldo,
    String? modo,
    String? icono,
    String? color,
    DateTime? creadoEn,
  }) {
    return Caja(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      saldo: saldo ?? this.saldo,
      modo: modo ?? this.modo,
      icono: icono ?? this.icono,
      color: color ?? this.color,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }
}
