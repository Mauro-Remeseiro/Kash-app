import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/cuenta.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/cuentas_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/kash_colors.dart';
import '../../utils/formatters.dart';
import '../../widgets/bounce_button.dart';
import '../../widgets/kash_toast.dart';
import '../../widgets/spring_sheet.dart';

class CuentasScreen extends StatelessWidget {
  const CuentasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final ajustes = context.watch<AjustesProvider>();
    final provider = context.watch<CuentasProvider>();
    final cuentas = provider.cuentas;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.misCuentas),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _mostrarNuevaCuenta(context, ajustes.modoApp),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.recargar,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _PatrimonioCard(
                patrimonio: provider.patrimonioTotal,
                moneda: ajustes.moneda,
              ),
              const SizedBox(height: 28),
              Text(l10n.tusCuentas, style: theme.textTheme.labelSmall),
              const SizedBox(height: 12),
              if (provider.cargando && cuentas.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                ...cuentas.map((c) => _CuentaTile(
                      cuenta: c,
                      moneda: ajustes.moneda,
                      onMasOpciones: () => _mostrarOpciones(context, c),
                    )),
                const SizedBox(height: 12),
                _NuevaCuentaCard(
                  onTap: () => _mostrarNuevaCuenta(context, ajustes.modoApp),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarNuevaCuenta(BuildContext context, String modo) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpringSheet(child: _NuevaCuentaSheet(modo: modo)),
    );
  }

  void _mostrarOpciones(BuildContext context, Cuenta cuenta) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OpcionesCuentaSheet(cuenta: cuenta),
    );
  }
}

// ─── Patrimonio card ─────────────────────────────────────────────────────────

class _PatrimonioCard extends StatelessWidget {
  const _PatrimonioCard({required this.patrimonio, required this.moneda});

  final double patrimonio;
  final String moneda;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.accentDim,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: theme.colorScheme.primary, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.patrimonio.toUpperCase(), style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          Text(
            formatearImporte(patrimonio, moneda: moneda),
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: 4),
          Text(l10n.soloCuentasIncluidas, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

// ─── Cuenta tile ─────────────────────────────────────────────────────────────

class _CuentaTile extends StatelessWidget {
  const _CuentaTile({
    required this.cuenta,
    required this.moneda,
    required this.onMasOpciones,
  });

  final Cuenta cuenta;
  final String moneda;
  final VoidCallback onMasOpciones;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;
    final colorSaldo = cuenta.saldo >= 0 ? colors.positive : colors.negative;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: cuenta.esPrincipal ? theme.colorScheme.primary : colors.border,
        ),
      ),
      child: Row(
        children: [
          Text(cuenta.icono, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      cuenta.nombre,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    if (cuenta.esPrincipal) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.principal,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 9,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  cuenta.incluirEnTotal ? l10n.incluidaEnTotal : l10n.noIncluidaEnTotal,
                  style: theme.textTheme.bodySmall?.copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatearImporte(cuenta.saldo, moneda: moneda),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorSaldo,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onMasOpciones,
                child: Icon(Icons.more_horiz, size: 18, color: colors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Nueva cuenta card ────────────────────────────────────────────────────────

class _NuevaCuentaCard extends StatelessWidget {
  const _NuevaCuentaCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: CustomPaint(
        painter: _DashedBorderPainter(color: colors.border, radius: AppTheme.cardRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                l10n.nuevaCuenta,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
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
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final len = (d + 6.0 > metric.length) ? metric.length - d : 6.0;
        canvas.drawPath(metric.extractPath(d, d + len), paint);
        d += 10.0;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}

// ─── Bottom sheet: opciones de cuenta ────────────────────────────────────────

class _OpcionesCuentaSheet extends StatefulWidget {
  const _OpcionesCuentaSheet({required this.cuenta});

  final Cuenta cuenta;

  @override
  State<_OpcionesCuentaSheet> createState() => _OpcionesCuentaSheetState();
}

class _OpcionesCuentaSheetState extends State<_OpcionesCuentaSheet> {
  late String _iconoSeleccionado;
  late TextEditingController _nombreController;
  late TextEditingController _saldoController;
  bool _guardandoNombre = false;
  bool _guardandoSaldo = false;

  static const _emojis = ['💵', '💳', '🏦', '💴', '💶', '💰', '🪙', '💎', '🏧', '📊'];

  @override
  void initState() {
    super.initState();
    _iconoSeleccionado = widget.cuenta.icono;
    _nombreController = TextEditingController(text: widget.cuenta.nombre);
    _saldoController = TextEditingController(
      text: widget.cuenta.saldo.toStringAsFixed(2).replaceAll('.', ','),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _saldoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<CuentasProvider>();

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 32),
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
          const SizedBox(height: 20),
          Text(l10n.icono, style: theme.textTheme.labelSmall),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _emojis.map((e) {
                final sel = e == _iconoSeleccionado;
                return GestureDetector(
                  onTap: () => setState(() => _iconoSeleccionado = e),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    margin: const EdgeInsets.only(right: 8),
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sel ? theme.colorScheme.primary.withValues(alpha: 0.15) : theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: sel ? theme.colorScheme.primary : colors.border,
                      ),
                    ),
                    child: Text(e, style: const TextStyle(fontSize: 22)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.nombre, style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nombreController,
                  textCapitalization: TextCapitalization.sentences,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(hintText: l10n.nombreCuentaHint),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _guardandoNombre
                    ? null
                    : () async {
                        final nombre = _nombreController.text.trim();
                        if (nombre.isEmpty) return;
                        setState(() => _guardandoNombre = true);
                        await provider.actualizarCuenta(
                          widget.cuenta.copyWith(
                            nombre: nombre,
                            icono: _iconoSeleccionado,
                            actualizadoEn: DateTime.now(),
                          ),
                        );
                        if (context.mounted) setState(() => _guardandoNombre = false);
                      },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _guardandoNombre
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : Text(l10n.guardar),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: colors.border),
          const SizedBox(height: 12),
          Text(l10n.actualizarSaldo, style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _saldoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(hintText: l10n.hintImporte),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _guardandoSaldo
                    ? null
                    : () async {
                        final valor = double.tryParse(
                              _saldoController.text.replaceAll(',', '.'),
                            ) ??
                            widget.cuenta.saldo;
                        setState(() => _guardandoSaldo = true);
                        await provider.actualizarSaldoDirecto(widget.cuenta.id!, valor);
                        if (context.mounted) setState(() => _guardandoSaldo = false);
                      },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _guardandoSaldo
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : Text(l10n.ok),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: colors.border),
          const SizedBox(height: 4),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.incluirEnPatrimonio, style: theme.textTheme.bodyMedium),
            value: widget.cuenta.incluirEnTotal,
            activeThumbColor: theme.colorScheme.primary,
            onChanged: (_) async {
              await provider.toggleIncluirEnTotal(widget.cuenta.id!);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          if (!widget.cuenta.esPrincipal) ...[
            Divider(color: colors.border),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.star_outline, color: theme.colorScheme.primary),
              title: Text(
                l10n.marcarComoPrincipal,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
              ),
              onTap: () async {
                await provider.marcarComoPrincipal(widget.cuenta.id!);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
          Divider(color: colors.border),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline, color: colors.negative),
            title: Text(
              l10n.eliminarCuentaTitle,
              style: theme.textTheme.bodyMedium?.copyWith(color: colors.negative),
            ),
            onTap: () => _confirmarEliminar(context, provider),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, CuentasProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    Navigator.of(context).pop();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.eliminarCuentaTitle),
        content: Text(l10n.eliminarCuentaConfirm(widget.cuenta.nombre)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancelar),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await provider.eliminarCuenta(widget.cuenta.id!);
            },
            child: Text(
              l10n.eliminar,
              style: TextStyle(color: kashColorsOf(context).negative),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom sheet: nueva cuenta ──────────────────────────────────────────────

class _NuevaCuentaSheet extends StatefulWidget {
  const _NuevaCuentaSheet({required this.modo});

  final String modo;

  @override
  State<_NuevaCuentaSheet> createState() => _NuevaCuentaSheetState();
}

class _NuevaCuentaSheetState extends State<_NuevaCuentaSheet> {
  String _icono = '💵';
  final _nombreController = TextEditingController();
  final _saldoController = TextEditingController();
  bool _incluirEnTotal = true;

  static const _emojis = ['💵', '💳', '🏦', '💴', '💶', '💰', '🪙', '💎', '🏧', '📊'];

  @override
  void dispose() {
    _nombreController.dispose();
    _saldoController.dispose();
    super.dispose();
  }

  bool get _valido => _nombreController.text.trim().isNotEmpty;

  void _guardar(BuildContext context) {
    final nombre = _nombreController.text.trim();
    if (nombre.isEmpty) return;

    final saldo = double.tryParse(_saldoController.text.replaceAll(',', '.')) ?? 0;
    final now = DateTime.now();
    final provider = context.read<CuentasProvider>();

    provider.agregarCuenta(Cuenta(
      nombre: nombre,
      icono: _icono,
      saldo: saldo,
      incluirEnTotal: _incluirEnTotal,
      esPrincipal: provider.cuentas.isEmpty,
      modo: widget.modo,
      actualizadoEn: now,
      creadoEn: now,
    ));

    mostrarKashToast(context, AppLocalizations.of(context)!.cuentaCreada);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration:
                  BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.nuevaCuenta, style: theme.textTheme.titleMedium),
          const SizedBox(height: 20),
          Text(l10n.icono, style: theme.textTheme.labelSmall),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _emojis.map((e) {
                final sel = e == _icono;
                return GestureDetector(
                  onTap: () => setState(() => _icono = e),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    margin: const EdgeInsets.only(right: 8),
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sel ? theme.colorScheme.primary.withValues(alpha: 0.15) : theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: sel ? theme.colorScheme.primary : colors.border),
                    ),
                    child: Text(e, style: const TextStyle(fontSize: 22)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.nombre, style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          TextField(
            controller: _nombreController,
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(hintText: l10n.cuentaCorrienteEjemplo),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text(l10n.saldoInicialOpcional, style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          TextField(
            controller: _saldoController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(hintText: l10n.hintImporte),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.incluirEnPatrimonio, style: theme.textTheme.bodyMedium),
            value: _incluirEnTotal,
            activeThumbColor: theme.colorScheme.primary,
            onChanged: (v) => setState(() => _incluirEnTotal = v),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: KashBounceButton(
              onPressed: _valido ? () => _guardar(context) : null,
              child: Text(l10n.crearCuentaBtn),
            ),
          ),
        ],
      ),
    );
  }
}
