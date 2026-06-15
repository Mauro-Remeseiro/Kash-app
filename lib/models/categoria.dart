import 'caja.dart';

/// Tipos de movimiento a los que aplica una categoría.
class TipoCategoria {
  static const String gasto = 'gasto';
  static const String ingreso = 'ingreso';
  static const String ambos = 'ambos';
}

class Categoria {
  final int? id;
  final String nombre;
  final String emoji;
  final String tipo;
  final String modo;
  final bool esCustom;
  final int orden;

  const Categoria({
    this.id,
    required this.nombre,
    required this.emoji,
    this.tipo = TipoCategoria.ambos,
    this.modo = ModoApp.personal,
    this.esCustom = false,
    this.orden = 0,
  });

  /// Categoría de respaldo para movimientos sin categoría asignada.
  static const Categoria sinCategoria = Categoria(nombre: 'Sin categoría', emoji: '❓');

  factory Categoria.fromMap(Map<String, Object?> map) {
    return Categoria(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      emoji: map['emoji'] as String,
      tipo: map['tipo'] as String? ?? TipoCategoria.ambos,
      modo: map['modo'] as String? ?? ModoApp.personal,
      esCustom: ((map['es_custom'] as int?) ?? 0) == 1,
      orden: (map['orden'] as int?) ?? 0,
    );
  }

  Map<String, Object?> toMap({bool incluirId = false}) {
    final map = <String, Object?>{
      'nombre': nombre,
      'emoji': emoji,
      'tipo': tipo,
      'modo': modo,
      'es_custom': esCustom ? 1 : 0,
      'orden': orden,
    };
    if (incluirId && id != null) map['id'] = id;
    return map;
  }

  Categoria copyWith({
    int? id,
    String? nombre,
    String? emoji,
    String? tipo,
    String? modo,
    bool? esCustom,
    int? orden,
  }) {
    return Categoria(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      emoji: emoji ?? this.emoji,
      tipo: tipo ?? this.tipo,
      modo: modo ?? this.modo,
      esCustom: esCustom ?? this.esCustom,
      orden: orden ?? this.orden,
    );
  }
}
