import 'package:flutter/material.dart';

import '../theme/kash_colors.dart';

/// Una barra individual del gráfico semanal: etiqueta, valor y si pertenece
/// al periodo actual (se resalta en color de acento).
typedef BarraSemana = ({String etiqueta, double valor, bool actual});

/// Gráfico de barras minimalista para comparar totales por semana, con la
/// semana actual resaltada en el color de acento.
class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key, required this.barras, this.altura = 120});

  final List<BarraSemana> barras;
  final double altura;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final maximo = barras.fold<double>(0, (m, b) => b.valor > m ? b.valor : m);

    return SizedBox(
      height: altura + 28,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: barras.map((barra) {
          final proporcion = maximo > 0 ? (barra.valor / maximo).clamp(0.0, 1.0) : 0.0;
          final color = barra.actual ? theme.colorScheme.primary : colors.border;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: altura,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        height: altura * proporcion,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    barra.etiqueta,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: barra.actual ? theme.colorScheme.primary : colors.textTertiary,
                      fontWeight: barra.actual ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
