import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/database_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../models/empleado.dart';
import '../../models/movimiento.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/empleados_provider.dart';
import '../../providers/movimientos_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/kash_colors.dart';
import '../../utils/formatters.dart';
import 'empleado_detalle_screen.dart';

/// Total gastado por un empleado en el mes en curso, junto con si tiene algún
/// movimiento pendiente de aprobar.
typedef ResumenEmpleado = ({double totalGastado, bool tienePendientes});

class EmpleadosScreen extends StatefulWidget {
  const EmpleadosScreen({super.key});

  @override
  State<EmpleadosScreen> createState() => _EmpleadosScreenState();
}

class _EmpleadosScreenState extends State<EmpleadosScreen> {
  late Future<Map<int, ResumenEmpleado>> _resumenFuture;

  @override
  void initState() {
    super.initState();
    _resumenFuture = _cargarResumenMensual();
  }

  Future<Map<int, ResumenEmpleado>> _cargarResumenMensual() async {
    final ajustes = context.read<AjustesProvider>();
    final ahora = DateTime.now();
    final desde = DateTime(ahora.year, ahora.month, 1);
    final hasta = DateTime(ahora.year, ahora.month + 1, 1).subtract(const Duration(milliseconds: 1));

    final filas = await DatabaseHelper.instance.getMovimientos(
      modo: ajustes.modoApp,
      desde: desde,
      hasta: hasta,
    );

    final gastado = <int, double>{};
    final pendientes = <int, bool>{};
    for (final fila in filas) {
      final movimiento = Movimiento.fromMap(fila);
      final empleadoId = movimiento.empleadoId;
      if (empleadoId == null || !movimiento.esGasto) continue;
      gastado[empleadoId] = (gastado[empleadoId] ?? 0) + movimiento.importe;
      if (!movimiento.aprobado) pendientes[empleadoId] = true;
    }

    final resumen = <int, ResumenEmpleado>{};
    for (final id in gastado.keys) {
      resumen[id] = (totalGastado: gastado[id]!, tienePendientes: pendientes[id] ?? false);
    }
    return resumen;
  }

  Future<void> _recargar() async {
    final empleadosProvider = context.read<EmpleadosProvider>();
    final movimientosProvider = context.read<MovimientosProvider>();
    final nuevoResumen = _cargarResumenMensual();
    await Future.wait([empleadosProvider.cargar(), movimientosProvider.recargar(), nuevoResumen]);
    if (!mounted) return;
    setState(() => _resumenFuture = nuevoResumen);
  }

  void _mostrarDialogoPro() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exportarInformeProTitle),
        content: Text(l10n.exportarInformeProMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.entendido),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;
    final ajustes = context.watch<AjustesProvider>();
    final empleadosProvider = context.watch<EmpleadosProvider>();
    final movimientosProvider = context.watch<MovimientosProvider>();
    final empleados = empleadosProvider.empleados;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.empleados)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _recargar,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ResumenMiniCard(
                      etiqueta: l10n.empleados.toUpperCase(),
                      valor: '${empleadosProvider.total}',
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ResumenMiniCard(
                      etiqueta: l10n.pendienteDeAprobar,
                      valor: formatearImporte(
                        movimientosProvider.importePendienteDeAprobar,
                        moneda: ajustes.moneda,
                      ),
                      color: colors.negative,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(l10n.tuEquipo, style: theme.textTheme.labelSmall),
              const SizedBox(height: 12),
              if (empleadosProvider.cargando && empleados.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (empleados.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      l10n.sinEmpleadosAun,
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                FutureBuilder<Map<int, ResumenEmpleado>>(
                  future: _resumenFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final resumen = snapshot.data!;
                    return Column(
                      children: empleados.map((empleado) {
                        final r = resumen[empleado.id] ??
                            (totalGastado: 0.0, tienePendientes: false);
                        return _EmpleadoTile(
                          empleado: empleado,
                          resumen: r,
                          moneda: ajustes.moneda,
                          colors: colors,
                        );
                      }).toList(),
                    );
                  },
                ),
              const SizedBox(height: 28),
              _ExportarInformeTile(onTap: _mostrarDialogoPro),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumenMiniCard extends StatelessWidget {
  const _ResumenMiniCard({required this.etiqueta, required this.valor, required this.color});

  final String etiqueta;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etiqueta, style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          Text(
            valor,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _EmpleadoTile extends StatelessWidget {
  const _EmpleadoTile({
    required this.empleado,
    required this.resumen,
    required this.moneda,
    required this.colors,
  });

  final Empleado empleado;
  final ResumenEmpleado resumen;
  final String moneda;
  final KashColors colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final estadoColor = resumen.tienePendientes ? Colors.amber : colors.positive;
    final estadoTexto = resumen.tienePendientes ? l10n.pendiente : l10n.aprobado;

    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EmpleadoDetalleScreen(empleado: empleado)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Text(
                empleado.iniciales,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    empleado.nombre,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.valorEsteMes(formatearImporte(resumen.totalGastado, moneda: moneda)),
                    style: theme.textTheme.bodySmall?.copyWith(color: colors.textTertiary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: estadoColor.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                estadoTexto,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: estadoColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 18, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _ExportarInformeTile extends StatelessWidget {
  const _ExportarInformeTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline, size: 18, color: colors.textTertiary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.exportarInforme,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.accentDim,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.proTag,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
