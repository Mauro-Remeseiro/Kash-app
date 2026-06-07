import '../models/caja.dart';

class Categoria {
  final String id;
  final String emoji;
  final String nombre;

  const Categoria({required this.id, required this.emoji, required this.nombre});
}

const List<Categoria> categoriasBase = [
  Categoria(id: 'comida', emoji: '🍔', nombre: 'Comida'),
  Categoria(id: 'transporte', emoji: '🚌', nombre: 'Transporte'),
  Categoria(id: 'ocio', emoji: '🎬', nombre: 'Ocio'),
  Categoria(id: 'casa', emoji: '🏠', nombre: 'Casa'),
  Categoria(id: 'salud', emoji: '💊', nombre: 'Salud'),
  Categoria(id: 'otro', emoji: '❓', nombre: 'Otro'),
];

const List<Categoria> categoriasExtraEmpresa = [
  Categoria(id: 'clientes', emoji: '💼', nombre: 'Clientes'),
  Categoria(id: 'oficina', emoji: '🏢', nombre: 'Oficina'),
  Categoria(id: 'empleados', emoji: '🤝', nombre: 'Empleados'),
  Categoria(id: 'suministros', emoji: '🔧', nombre: 'Suministros'),
];

List<Categoria> categoriasParaModo(String modo) {
  if (modo == ModoApp.empresa) {
    return [...categoriasBase, ...categoriasExtraEmpresa];
  }
  return categoriasBase;
}

Categoria categoriaPorId(String id) {
  for (final categoria in [...categoriasBase, ...categoriasExtraEmpresa]) {
    if (categoria.id == id) return categoria;
  }
  return const Categoria(id: 'otro', emoji: '❓', nombre: 'Otro');
}

/// Pills de filtro de periodo mostradas en la pantalla de inicio.
const List<String> etiquetasFiltroPeriodo = ['Semana', 'Mes', 'Todo'];
