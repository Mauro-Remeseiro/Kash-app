import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/cuenta.dart';
import '../../models/movimiento.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/categorias_provider.dart';
import '../../providers/cuentas_provider.dart';
import '../../providers/movimientos_provider.dart';
import '../../theme/kash_colors.dart';
import '../../widgets/bounce_button.dart';
import '../../widgets/categoria_form_sheet.dart';
import '../../widgets/category_grid.dart';
import '../../widgets/kash_toast.dart';

class AddMovimientoScreen extends StatefulWidget {
  const AddMovimientoScreen({super.key});

  @override
  State<AddMovimientoScreen> createState() => _AddMovimientoScreenState();
}

class _AddMovimientoScreenState extends State<AddMovimientoScreen> {
  final _importeController = TextEditingController();
  final _notaController = TextEditingController();

  String _tipo = TipoMovimiento.gasto;
  int? _categoriaId;
  int? _cuentaId;
  bool _guardando = false;

  @override
  void dispose() {
    _importeController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  double? get _importe => double.tryParse(_importeController.text.replaceAll(',', '.'));

  bool get _formularioValido =>
      (_importe ?? 0) > 0 && _categoriaId != null && _cuentaId != null && !_guardando;

  Future<void> _guardar() async {
    final importe = _importe;
    final categoriaId = _categoriaId;
    final cuentaId = _cuentaId;
    if (importe == null || importe <= 0 || categoriaId == null || cuentaId == null) return;

    setState(() => _guardando = true);

    final ajustes = context.read<AjustesProvider>();
    final movimientosProvider = context.read<MovimientosProvider>();
    final cuentasProvider = context.read<CuentasProvider>();

    final nota = _notaController.text.trim();
    await movimientosProvider.agregarMovimiento(
      Movimiento(
        tipo: _tipo,
        importe: importe,
        nota: nota.isEmpty ? null : nota,
        categoriaId: categoriaId,
        cuentaId: cuentaId,
        fecha: DateTime.now(),
        modo: ajustes.modoApp,
      ),
      cuentasProvider: cuentasProvider,
    );

    if (!mounted) return;
    mostrarKashToast(context, AppLocalizations.of(context)!.movimientoGuardado);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;
    final ajustes = context.watch<AjustesProvider>();
    final cuentas = context.watch<CuentasProvider>().cuentas;
    final categoriasProvider = context.watch<CategoriasProvider>();
    final categorias = categoriasProvider.paraTipo(_tipo);

    _cuentaId ??= context.read<CuentasProvider>().cuentaPrincipal?.id ??
        (cuentas.isNotEmpty ? cuentas.first.id : null);

    final esGasto = _tipo == TipoMovimiento.gasto;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nuevoMovimiento)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _ToggleTipo(
              esGasto: esGasto,
              onChanged: (gasto) => setState(
                  () => _tipo = gasto ? TipoMovimiento.gasto : TipoMovimiento.ingreso),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextField(
                controller: _importeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge?.copyWith(
                  color: esGasto ? colors.negative : colors.positive,
                ),
                decoration: InputDecoration(border: InputBorder.none, hintText: l10n.hintImporte),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notaController,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(hintText: l10n.notaOpcionalHint),
            ),
            const SizedBox(height: 28),
            Text(l10n.categoriaLabel, style: theme.textTheme.labelSmall),
            const SizedBox(height: 12),
            CategoryGrid(
              categorias: categorias,
              seleccionada: _categoriaId,
              onSeleccionar: (id) => setState(() => _categoriaId = id),
              onAgregar: () async {
                final nueva = await mostrarFormularioCategoria(context, modo: ajustes.modoApp);
                if (nueva == null || !mounted) return;
                final creada = await categoriasProvider.agregarCategoria(nueva);
                setState(() => _categoriaId = creada.id);
              },
            ),
            const SizedBox(height: 28),
            Text(l10n.cuentaLabel, style: theme.textTheme.labelSmall),
            const SizedBox(height: 12),
            if (cuentas.isEmpty)
              Text(
                l10n.crearCuentaPrimero,
                style: theme.textTheme.bodySmall,
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cuentas.map((c) => _buildCuentaPill(theme, colors, c)).toList(),
              ),
            const SizedBox(height: 36),
            KashBounceButton(
              onPressed: _formularioValido ? _guardar : null,
              child: _guardando
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.black),
                    )
                  : Text(l10n.guardar),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuentaPill(ThemeData theme, KashColors colors, Cuenta cuenta) {
    final activa = cuenta.id == _cuentaId;
    return ChoiceChip(
      label: Text('${cuenta.icono} ${cuenta.nombre}'),
      selected: activa,
      onSelected: (_) => setState(() => _cuentaId = cuenta.id),
      labelStyle: theme.textTheme.bodySmall?.copyWith(
        color: activa
            ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
            : null,
        fontWeight: FontWeight.w500,
      ),
      selectedColor: theme.colorScheme.primary,
      backgroundColor: theme.cardTheme.color,
      side: BorderSide(color: colors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _ToggleTipo extends StatelessWidget {
  const _ToggleTipo({required this.esGasto, required this.onChanged});

  final bool esGasto;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(child: _opcion(theme, l10n.gasto, esGasto, () => onChanged(true))),
          Expanded(child: _opcion(theme, l10n.ingreso, !esGasto, () => onChanged(false))),
        ],
      ),
    );
  }

  Widget _opcion(ThemeData theme, String texto, bool activa, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: activa ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          texto,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: activa
                ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
                : null,
          ),
        ),
      ),
    );
  }
}
