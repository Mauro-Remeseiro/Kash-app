import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/concepto_empleado.dart';
import '../../models/empleado.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/conceptos_empleado_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/kash_colors.dart';
import '../../utils/formatters.dart';
import '../../widgets/concepto_empleado_form_sheet.dart';

class EmpleadoDetalleScreen extends StatefulWidget {
  const EmpleadoDetalleScreen({super.key, required this.empleado});

  final Empleado empleado;

  @override
  State<EmpleadoDetalleScreen> createState() => _EmpleadoDetalleScreenState();
}

class _EmpleadoDetalleScreenState extends State<EmpleadoDetalleScreen> {
  @override
  void initState() {
    super.initState();
    final id = widget.empleado.id;
    if (id != null) {
      context.read<ConceptosEmpleadoProvider>().cargar(id);
    }
  }

  Future<void> _agregarConcepto() async {
    final id = widget.empleado.id;
    if (id == null) return;
    final nuevo = await mostrarFormularioConcepto(context, empleadoId: id);
    if (nuevo == null || !mounted) return;
    await context.read<ConceptosEmpleadoProvider>().agregarConcepto(nuevo);
  }

  Future<void> _editarConcepto(ConceptoEmpleado concepto) async {
    final editado = await mostrarFormularioConcepto(
      context,
      empleadoId: concepto.empleadoId,
      concepto: concepto,
    );
    if (editado == null || !mounted) return;
    await context.read<ConceptosEmpleadoProvider>().actualizarConcepto(editado);
  }

  Future<void> _eliminarConcepto(ConceptoEmpleado concepto) async {
    final l10n = AppLocalizations.of(context)!;
    final id = concepto.id;
    if (id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.eliminarConceptoTitle),
        content: Text(l10n.eliminarConceptoConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelar),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.eliminar, style: TextStyle(color: kashColorsOf(ctx).negative)),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    await context.read<ConceptosEmpleadoProvider>().eliminarConcepto(concepto.empleadoId, id);
  }

  void _mostrarOpciones(ConceptoEmpleado concepto) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OpcionesConceptoSheet(
        concepto: concepto,
        onEditar: () => _editarConcepto(concepto),
        onEliminar: () => _eliminarConcepto(concepto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final ajustes = context.watch<AjustesProvider>();
    final empleado = widget.empleado;
    final id = empleado.id;
    final provider = context.watch<ConceptosEmpleadoProvider>();
    final conceptos = id != null ? provider.conceptosDe(id) : const <ConceptoEmpleado>[];
    final cargando = id != null && provider.cargando(id) && conceptos.isEmpty;
    final totalMes = id != null ? provider.totalDelMes(id) : 0.0;
    final tienePendientes = id != null && provider.tienePendientes(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(empleado.nombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _agregarConcepto,
          ),
        ],
      ),
      body: SafeArea(
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  _HeaderEmpleado(empleado: empleado, total: totalMes, moneda: ajustes.moneda),
                  const SizedBox(height: 20),
                  if (tienePendientes) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => provider.aprobarTodos(id),
                        child: Text(l10n.aprobarTodos),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Text(l10n.conceptosLabel, style: theme.textTheme.labelSmall),
                  const SizedBox(height: 12),
                  if (conceptos.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          l10n.sinConceptosAun,
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ...conceptos.map(
                      (c) => _ConceptoTile(
                        concepto: c,
                        moneda: ajustes.moneda,
                        onMasOpciones: () => _mostrarOpciones(c),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

// ─── Header: avatar + nombre + total del mes ─────────────────────────────────

class _HeaderEmpleado extends StatelessWidget {
  const _HeaderEmpleado({required this.empleado, required this.total, required this.moneda});

  final Empleado empleado;
  final double total;
  final String moneda;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Text(
              empleado.iniciales,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  empleado.nombre,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(l10n.totalEsteMes, style: theme.textTheme.labelSmall),
                const SizedBox(height: 2),
                Text(
                  formatearImporte(total, moneda: moneda),
                  style: theme.textTheme.displayLarge?.copyWith(fontSize: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Concepto tile ─────────────────────────────────────────────────────────

String? _nombreTipo(AppLocalizations l10n, String? tipo) {
  switch (tipo) {
    case TipoConcepto.sueldo:
      return l10n.tipoSueldo;
    case TipoConcepto.comision:
      return l10n.tipoComision;
    case TipoConcepto.bonus:
      return l10n.tipoBonus;
    case TipoConcepto.dieta:
      return l10n.tipoDieta;
    case TipoConcepto.otro:
      return l10n.tipoOtro;
    default:
      return null;
  }
}

Widget? _badgeTipo(BuildContext context, String? tipo) {
  final theme = Theme.of(context);
  final colors = kashColorsOf(context);
  final l10n = AppLocalizations.of(context)!;
  final Color color;
  switch (tipo) {
    case TipoConcepto.sueldo:
      color = colors.infoBlue;
    case TipoConcepto.comision:
      color = theme.colorScheme.primary;
    case TipoConcepto.bonus:
      color = Colors.amber;
    case TipoConcepto.dieta:
      color = colors.textTertiary;
    default:
      return null;
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      _nombreTipo(l10n, tipo)!,
      style: theme.textTheme.bodySmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
        fontSize: 10,
      ),
    ),
  );
}

class _ConceptoTile extends StatelessWidget {
  const _ConceptoTile({
    required this.concepto,
    required this.moneda,
    required this.onMasOpciones,
  });

  final ConceptoEmpleado concepto;
  final String moneda;
  final VoidCallback onMasOpciones;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;
    final badge = _badgeTipo(context, concepto.tipo);
    final etiqueta = concepto.descripcion ?? _nombreTipo(l10n, concepto.tipo) ?? l10n.concepto;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (badge != null) ...[badge, const SizedBox(width: 8)],
                    Flexible(
                      child: Text(
                        etiqueta,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!concepto.aprobado) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.pendiente,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.amber,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  formatearFechaCorta(concepto.fecha),
                  style: theme.textTheme.bodySmall?.copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatearImporte(concepto.importe, moneda: moneda),
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onMasOpciones,
            child: Icon(Icons.more_horiz, size: 18, color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom sheet: opciones de concepto ──────────────────────────────────────

class _OpcionesConceptoSheet extends StatelessWidget {
  const _OpcionesConceptoSheet({
    required this.concepto,
    required this.onEditar,
    required this.onEliminar,
  });

  final ConceptoEmpleado concepto;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;
    final etiqueta = concepto.descripcion ?? _nombreTipo(l10n, concepto.tipo) ?? l10n.concepto;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            etiqueta,
            style: theme.textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Divider(color: colors.border),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit_outlined, color: theme.colorScheme.primary),
            title: Text(l10n.editar),
            onTap: () {
              Navigator.of(context).pop();
              onEditar();
            },
          ),
          Divider(color: colors.border),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline, color: colors.negative),
            title: Text(l10n.eliminar, style: TextStyle(color: colors.negative)),
            onTap: () {
              Navigator.of(context).pop();
              onEliminar();
            },
          ),
        ],
      ),
    );
  }
}
