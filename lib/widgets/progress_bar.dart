import 'package:flutter/material.dart';

/// Barra de progreso minimalista usada para presupuesto y estadísticas.
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.progreso,
    this.height = 6,
    this.color,
    this.colorFondo,
  });

  /// Valor entre 0.0 y 1.0 (se recorta fuera de ese rango).
  final double progreso;
  final double height;
  final Color? color;
  final Color? colorFondo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valor = progreso.clamp(0.0, 1.0);
    final colorBarra = color ?? theme.colorScheme.primary;
    final fondo = colorFondo ?? theme.dividerTheme.color ?? theme.colorScheme.outline;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(height: height, color: fondo),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                height: height,
                width: constraints.maxWidth * valor,
                color: colorBarra,
              ),
            ],
          );
        },
      ),
    );
  }
}
