import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/kash_colors.dart';

/// Fondo rojo con icono de papelera mostrado al deslizar un elemento
/// de una lista para eliminarlo (swipe-to-delete).
class SwipeDeleteBackground extends StatelessWidget {
  const SwipeDeleteBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = kashColorsOf(context);
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: colors.negative,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white),
    );
  }
}
