import 'package:flutter/material.dart';

import '../models/caja.dart';
import '../theme/app_theme.dart';
import '../theme/kash_colors.dart';
import '../utils/formatters.dart';

/// Información visual asociada a cada [TipoCaja]: color de acento y
/// subtítulo descriptivo, según la paleta definida en el documento de diseño
/// (Efectivo = neutro, Banco = azul info, Ahorros = verde acento).
({Color color, String subtitulo}) _infoTipoCaja(String tipo, BuildContext context) {
  final theme = Theme.of(context);
  final colors = kashColorsOf(context);

  switch (tipo) {
    case TipoCaja.banco:
      return (color: colors.infoBlue, subtitulo: 'Cuenta bancaria');
    case TipoCaja.ahorros:
      return (color: theme.colorScheme.primary, subtitulo: 'Ahorros');
    case TipoCaja.custom:
      return (color: theme.textTheme.bodyMedium?.color ?? colors.textTertiary, subtitulo: 'Caja personalizada');
    case TipoCaja.efectivo:
    default:
      return (color: theme.textTheme.bodyMedium?.color ?? colors.textTertiary, subtitulo: 'Efectivo');
  }
}

class CajaCard extends StatelessWidget {
  const CajaCard({super.key, required this.caja, required this.moneda, this.onTap});

  final Caja caja;
  final String moneda;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final info = _infoTipoCaja(caja.tipo, context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: info.color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 16),
            Text(
              caja.nombre,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              formatearImporte(caja.saldo, moneda: moneda),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              info.subtitulo,
              style: theme.textTheme.bodySmall?.copyWith(color: colors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}

class NuevaCajaCard extends StatelessWidget {
  const NuevaCajaCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: CustomPaint(
        painter: _DashedBorderPainter(color: colors.border, radius: AppTheme.cardRadius),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                'Nueva caja',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    const dashWidth = 6.0;
    const gapWidth = 4.0;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = distance + dashWidth > metric.length ? metric.length - distance : dashWidth;
        canvas.drawPath(metric.extractPath(distance, distance + length), paint);
        distance += dashWidth + gapWidth;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
