import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/categoria.dart';
import '../theme/kash_colors.dart';
import 'bounce_button.dart';
import 'spring_sheet.dart';

const _emojisDisponibles = [
  '🍔', '🚌', '🎬', '🏠', '💊', '❓', '💼', '🏢', '🤝', '🔧',
  '🛒', '✈️', '🎮', '📱', '💡', '🎓', '🐾', '🎁', '⚽', '🎵',
  '☕', '🍻', '👕', '💻', '🚗', '🏥', '📚', '🌱', '🧾', '💰',
];

/// Muestra un BottomSheet para crear o editar una [Categoria].
///
/// Devuelve la categoría resultante (sin persistir) o `null` si se cancela.
Future<Categoria?> mostrarFormularioCategoria(
  BuildContext context, {
  Categoria? categoria,
  required String modo,
}) {
  return showModalBottomSheet<Categoria>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => SpringSheet(child: CategoriaFormSheet(categoria: categoria, modo: modo)),
  );
}

class CategoriaFormSheet extends StatefulWidget {
  const CategoriaFormSheet({super.key, this.categoria, required this.modo});

  final Categoria? categoria;
  final String modo;

  @override
  State<CategoriaFormSheet> createState() => _CategoriaFormSheetState();
}

class _CategoriaFormSheetState extends State<CategoriaFormSheet> {
  late final TextEditingController _nombreController;
  late String _emoji;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.categoria?.nombre ?? '');
    _emoji = widget.categoria?.emoji ?? _emojisDisponibles.first;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _guardar() {
    final nombre = _nombreController.text.trim();
    if (nombre.isEmpty) return;

    final existente = widget.categoria;
    final resultado = existente != null
        ? existente.copyWith(nombre: nombre, emoji: _emoji)
        : Categoria(nombre: nombre, emoji: _emoji, modo: widget.modo, esCustom: true);

    Navigator.of(context).pop(resultado);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;
    final esEdicion = widget.categoria != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            esEdicion ? l10n.editarCategoria : l10n.nuevaCategoria,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nombreController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: l10n.nombreHint),
            onSubmitted: (_) => _guardar(),
          ),
          const SizedBox(height: 16),
          Text(l10n.emojiLabel, style: theme.textTheme.labelSmall),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _emojisDisponibles.map((e) {
              final activo = e == _emoji;
              return InkWell(
                onTap: () => setState(() => _emoji = e),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: activo ? colors.accentDim : theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: activo ? theme.colorScheme.primary : colors.border,
                      width: activo ? 1.5 : 1,
                    ),
                  ),
                  child: Text(e, style: const TextStyle(fontSize: 18)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          KashBounceButton(
            onPressed: _guardar,
            child: Text(l10n.guardar),
          ),
        ],
      ),
    );
  }
}
