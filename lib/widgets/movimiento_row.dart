import 'package:flutter/material.dart';

import '../models/categoria.dart';
import '../models/movimiento.dart';
import '../theme/app_theme.dart';
import '../theme/kash_colors.dart';
import '../utils/formatters.dart';

class MovimientoRow extends StatelessWidget {
  const MovimientoRow({
    super.key,
    required this.movimiento,
    required this.categoria,
    required this.moneda,
    this.onTap,
  });

  final Movimiento movimiento;
  final Categoria categoria;
  final String moneda;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final colorImporte = movimiento.esIngreso ? colors.positive : colors.negative;
    final signo = movimiento.esIngreso ? '+' : '−';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: Text(categoria.emoji, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movimiento.nota?.trim().isNotEmpty == true
                        ? movimiento.nota!.trim()
                        : categoria.nombre,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${categoria.nombre} · ${formatearFechaCorta(movimiento.fecha)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$signo ${formatearImporte(movimiento.importe, moneda: moneda)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorImporte,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
