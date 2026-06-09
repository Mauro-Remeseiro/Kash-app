import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cuenta.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/cuentas_provider.dart';
import '../../providers/movimientos_provider.dart';
import '../../theme/kash_colors.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/movimiento_row.dart';
import 'add_movimiento_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  FiltroPeriodo _filtroPorEtiqueta(String e) {
    switch (e) {
      case 'Semana': return FiltroPeriodo.semana;
      case 'Todo':   return FiltroPeriodo.todo;
      default:       return FiltroPeriodo.mes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final colors  = kashColorsOf(context);
    final ajustes = context.watch<AjustesProvider>();
    final movProv = context.watch<MovimientosProvider>();
    final cxProv  = context.watch<CuentasProvider>();

    final totalGastado = movProv.totalGastos;
    final presupuesto  = ajustes.presupuestoMensual;
    final progreso     = presupuesto > 0 ? (totalGastado / presupuesto).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _Fab(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddMovimientoScreen()),
        ),
        color: theme.colorScheme.primary,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => Future.wait([
            movProv.recargar(),
            cxProv.recargar(),
          ]),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            children: [

              // ── Header ────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _capitalize(formatearMesAnio(DateTime.now())),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colors.textTertiary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    'Kash',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // ── Número protagonista ───────────────────────────────────────
              Text(
                'GASTADO ESTE MES',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.6,
                  color: colors.textTertiary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                formatearImporte(totalGastado),
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1.5,
                  color: theme.colorScheme.onSurface,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 12),

              // ── Progreso / presupuesto ────────────────────────────────────
              if (presupuesto > 0) ...[
                _ThinProgressBar(
                  progreso: progreso,
                  color: progreso >= 1.0 ? colors.negative : theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  '${formatearImporte(totalGastado)} de ${formatearImporte(presupuesto)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textTertiary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ] else
                Text(
                  'Sin presupuesto definido',
                  style: TextStyle(fontSize: 11, color: colors.textTertiary),
                ),

              const SizedBox(height: 28),

              // ── Pills de cuenta ────────────────────────────────────────────
              _CuentaPills(
                cuentas: cxProv.cuentas,
                seleccionadaId: movProv.cuentaFiltroId,
                onSeleccionar: movProv.cambiarCuentaFiltro,
              ),

              const SizedBox(height: 16),

              // ── Filtro de periodo ─────────────────────────────────────────
              Row(
                children: etiquetasFiltroPeriodo.map((etiqueta) {
                  final filtro = _filtroPorEtiqueta(etiqueta);
                  final activo = movProv.filtro == filtro;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterPill(
                      label: etiqueta,
                      activa: activo,
                      accentColor: theme.colorScheme.primary,
                      textTertiary: colors.textTertiary,
                      onTap: () => movProv.cambiarFiltro(filtro),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // ── Sección movimientos ────────────────────────────────────────
              Text(
                'ÚLTIMOS MOVIMIENTOS',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.6,
                  color: colors.textTertiary,
                ),
              ),

              const SizedBox(height: 16),

              if (movProv.cargando)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
                )
              else if (movProv.movimientos.isEmpty)
                _EmptyState(textTertiary: colors.textTertiary)
              else
                ...movProv.movimientos.map(
                  (m) => MovimientoRow(movimiento: m, moneda: ajustes.moneda),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ─── FAB personalizado ────────────────────────────────────────────────────────

class _Fab extends StatelessWidget {
  const _Fab({required this.onTap, required this.color});

  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: isDark
            ? Colors.black.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.25),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(
            Icons.add,
            size: 22,
            color: isDark ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}

// ─── Barra de progreso delgada ────────────────────────────────────────────────

class _ThinProgressBar extends StatelessWidget {
  const _ThinProgressBar({required this.progreso, required this.color});

  final double progreso;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final bg = kashColorsOf(context).border;
    return LayoutBuilder(
      builder: (_, constraints) => Container(
        height: 2,
        width: constraints.maxWidth,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(2),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progreso.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Pills de cuenta ──────────────────────────────────────────────────────────

class _CuentaPills extends StatelessWidget {
  const _CuentaPills({
    required this.cuentas,
    required this.seleccionadaId,
    required this.onSeleccionar,
  });

  final List<Cuenta> cuentas;
  final int? seleccionadaId;
  final void Function(int?) onSeleccionar;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final colors = kashColorsOf(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _AccountPill(
            label: 'Todo',
            activa: seleccionadaId == null,
            accentColor: theme.colorScheme.primary,
            textTertiary: colors.textTertiary,
            onTap: () => onSeleccionar(null),
          ),
          ...cuentas.map((c) => Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _AccountPill(
              label: '${c.icono} ${c.nombre}',
              activa: seleccionadaId == c.id,
              accentColor: theme.colorScheme.primary,
              textTertiary: colors.textTertiary,
              onTap: () => onSeleccionar(c.id),
            ),
          )),
        ],
      ),
    );
  }
}

// ─── Pill base (sin checkmark, sin fondo gris) ────────────────────────────────

class _AccountPill extends StatelessWidget {
  const _AccountPill({
    required this.label,
    required this.activa,
    required this.accentColor,
    required this.textTertiary,
    required this.onTap,
  });

  final String label;
  final bool activa;
  final Color accentColor;
  final Color textTertiary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: activa ? accentColor.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: activa ? accentColor : textTertiary.withValues(alpha: 0.3),
            width: activa ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: activa ? FontWeight.w600 : FontWeight.w400,
            color: activa ? accentColor : textTertiary,
          ),
        ),
      ),
    );
  }
}

// ─── Pill de filtro de periodo ────────────────────────────────────────────────

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.activa,
    required this.accentColor,
    required this.textTertiary,
    required this.onTap,
  });

  final String label;
  final bool activa;
  final Color accentColor;
  final Color textTertiary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: activa ? accentColor : textTertiary.withValues(alpha: 0.3),
            width: activa ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: activa ? FontWeight.w600 : FontWeight.w400,
            color: activa ? accentColor : textTertiary,
          ),
        ),
      ),
    );
  }
}

// ─── Estado vacío ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.textTertiary});

  final Color textTertiary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 36,
            color: textTertiary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 14),
          Text(
            'Sin movimientos en este periodo',
            style: TextStyle(
              fontSize: 13,
              color: textTertiary,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
