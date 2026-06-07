import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/kash_colors.dart';
import '../utils/constants.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.categorias,
    required this.seleccionada,
    required this.onSeleccionar,
  });

  final List<Categoria> categorias;
  final String? seleccionada;
  final ValueChanged<String> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categorias.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        final activa = categoria.id == seleccionada;
        final colorBorde = activa ? theme.colorScheme.primary : colors.border;
        final colorFondo = activa ? colors.accentDim : theme.cardTheme.color;

        return InkWell(
          onTap: () => onSeleccionar(categoria.id),
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Container(
            decoration: BoxDecoration(
              color: colorFondo,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(color: colorBorde, width: activa ? 1.5 : 1),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(categoria.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 4),
                Text(
                  categoria.nombre,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: activa ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color,
                    fontWeight: activa ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
