import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/categoria.dart';
import '../../models/cuenta.dart';
import '../../models/movimiento.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/categorias_provider.dart';
import '../../providers/cuentas_provider.dart';
import '../../providers/empleados_provider.dart';
import '../../providers/movimientos_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/kash_colors.dart';
import '../../utils/formatters.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/kash_toast.dart';
import '../../widgets/swipe_delete_background.dart';
import '../kash_ai/kash_ai_screen.dart';
import 'empleados_screen.dart';
import 'empresa_add_screen.dart';

class EmpresaHomeScreen extends StatelessWidget {
  const EmpresaHomeScreen({super.key});

  String _labelFiltro(AppLocalizations l10n, FiltroPeriodo f) {
    switch (f) {
      case FiltroPeriodo.semana: return l10n.filtroSemana;
      case FiltroPeriodo.todo:   return l10n.filtroTodo;
      case FiltroPeriodo.mes:    return l10n.filtroMes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;
    final ajustes = context.watch<AjustesProvider>();
    final movimientosProvider = context.watch<MovimientosProvider>();
    final cuentasProvider = context.watch<CuentasProvider>();
    final empleadosProvider = context.watch<EmpleadosProvider>();
    final categoriasProvider = context.watch<CategoriasProvider>();

    final movimientos = movimientosProvider.movimientos;
    final balance = movimientosProvider.balance;
    final colorBalance = balance >= 0 ? colors.positive : colors.negative;
    final signoBalance = balance >= 0 ? '+' : '−';

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EmpresaAddScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              movimientosProvider.recargar(),
              cuentasProvider.recargar(),
              empleadosProvider.cargar(),
            ]);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(formatearMesAnio(DateTime.now()), style: theme.textTheme.bodySmall),
                      const SizedBox(width: 12),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EmpleadosScreen()),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.people_outline, size: 18, color: colors.textTertiary),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const KashAiScreen()),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('✨', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Kash',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(l10n.balanceEsteMes, style: theme.textTheme.labelSmall),
              const SizedBox(height: 6),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(end: balance.abs()),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                builder: (context, value, _) => Text(
                  '$signoBalance ${formatearImporte(value, moneda: ajustes.moneda)}',
                  style: theme.textTheme.displayLarge?.copyWith(color: colorBalance),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _ResumenCard(
                      etiqueta: l10n.ingresos.toUpperCase(),
                      valor: formatearImporte(movimientosProvider.totalIngresos, moneda: ajustes.moneda),
                      color: colors.positive,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ResumenCard(
                      etiqueta: l10n.gastos.toUpperCase(),
                      valor: formatearImporte(movimientosProvider.totalGastos, moneda: ajustes.moneda),
                      color: colors.negative,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _CuentaPills(
                cuentas: cuentasProvider.cuentas,
                seleccionadaId: movimientosProvider.cuentaFiltroId,
                onSeleccionar: movimientosProvider.cambiarCuentaFiltro,
              ),
              const SizedBox(height: 20),
              Row(
                children: FiltroPeriodo.values.map((filtro) {
                  final activo = movimientosProvider.filtro == filtro;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_labelFiltro(l10n, filtro)),
                      selected: activo,
                      onSelected: (_) => movimientosProvider.cambiarFiltro(filtro),
                      labelStyle: theme.textTheme.bodySmall?.copyWith(
                        color: activo
                            ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
                            : null,
                        fontWeight: FontWeight.w500,
                      ),
                      selectedColor: theme.colorScheme.primary,
                      backgroundColor: theme.cardTheme.color,
                      side: BorderSide(color: colors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(l10n.ultimosMovimientos, style: theme.textTheme.labelSmall),
              const SizedBox(height: 8),
              if (movimientosProvider.cargando)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (movimientos.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      l10n.sinMovimientos,
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ...movimientos.map(
                  (m) => Dismissible(
                    key: ValueKey('movimiento-${m.id}'),
                    direction: DismissDirection.endToStart,
                    background: const SwipeDeleteBackground(),
                    confirmDismiss: (_) => confirmarEliminacion(
                      context,
                      mensaje: l10n.confirmarEliminarMovimiento,
                    ),
                    onDismissed: (_) async {
                      await movimientosProvider.eliminarMovimiento(
                        m.id!,
                        cuentasProvider: cuentasProvider,
                      );
                      if (context.mounted) {
                        mostrarKashToast(context, l10n.movimientoEliminado, icon: Icons.delete_outline);
                      }
                    },
                    child: _MovimientoEmpresaRow(
                      movimiento: m,
                      categoria: categoriasProvider.categoriaPorId(m.categoriaId),
                      moneda: ajustes.moneda,
                      empleadosProvider: empleadosProvider,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Account pills (shared logic) ────────────────────────────────────────────

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
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Pill(
            label: l10n.filtroTodo,
            activa: seleccionadaId == null,
            onTap: () => onSeleccionar(null),
            theme: theme,
            colors: colors,
          ),
          ...cuentas.map((c) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _Pill(
                  label: '${c.icono} ${c.nombre}',
                  activa: seleccionadaId == c.id,
                  onTap: () => onSeleccionar(c.id),
                  theme: theme,
                  colors: colors,
                ),
              )),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.activa,
    required this.onTap,
    required this.theme,
    required this.colors,
  });

  final String label;
  final bool activa;
  final VoidCallback onTap;
  final ThemeData theme;
  final KashColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: activa ? theme.colorScheme.primary : theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: activa ? theme.colorScheme.primary : colors.border),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: activa
                ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
                : null,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ─── Resumen card ─────────────────────────────────────────────────────────────

class _ResumenCard extends StatelessWidget {
  const _ResumenCard({required this.etiqueta, required this.valor, required this.color});

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
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Movimiento row empresa ───────────────────────────────────────────────────

class _MovimientoEmpresaRow extends StatelessWidget {
  const _MovimientoEmpresaRow({
    required this.movimiento,
    required this.categoria,
    required this.moneda,
    required this.empleadosProvider,
  });

  final Movimiento movimiento;
  final Categoria categoria;
  final String moneda;
  final EmpleadosProvider empleadosProvider;

  String _etiquetaTipo(AppLocalizations l10n) {
    final empleadoId = movimiento.empleadoId;
    if (empleadoId != null) {
      final empleado = empleadosProvider.porId(empleadoId);
      return empleado != null ? '${l10n.empleadoLabel} · ${empleado.nombre}' : l10n.empleadoLabel;
    }
    if (categoria.nombre.toLowerCase() == 'clientes') return l10n.clienteLabel;
    return l10n.gastoFijoLabel;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;
    final colorImporte = movimiento.esIngreso ? colors.positive : colors.negative;
    final signo = movimiento.esIngreso ? '+' : '−';

    return Padding(
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
                  '${_etiquetaTipo(l10n)} · ${formatearFechaCorta(movimiento.fecha)}',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
    );
  }
}
