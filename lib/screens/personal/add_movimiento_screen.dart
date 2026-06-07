import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/caja.dart';
import '../../models/movimiento.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/cajas_provider.dart';
import '../../providers/movimientos_provider.dart';
import '../../theme/kash_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/category_grid.dart';

class AddMovimientoScreen extends StatefulWidget {
  const AddMovimientoScreen({super.key});

  @override
  State<AddMovimientoScreen> createState() => _AddMovimientoScreenState();
}

class _AddMovimientoScreenState extends State<AddMovimientoScreen> {
  final _importeController = TextEditingController();
  final _notaController = TextEditingController();

  String _tipo = TipoMovimiento.gasto;
  String? _categoriaId;
  int? _cajaId;
  bool _guardando = false;

  @override
  void dispose() {
    _importeController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  double? get _importe => double.tryParse(_importeController.text.replaceAll(',', '.'));

  bool get _formularioValido =>
      (_importe ?? 0) > 0 && _categoriaId != null && _cajaId != null && !_guardando;

  Future<void> _guardar() async {
    final importe = _importe;
    final categoriaId = _categoriaId;
    final cajaId = _cajaId;
    if (importe == null || importe <= 0 || categoriaId == null || cajaId == null) return;

    setState(() => _guardando = true);

    final ajustes = context.read<AjustesProvider>();
    final movimientosProvider = context.read<MovimientosProvider>();
    final cajasProvider = context.read<CajasProvider>();

    final nota = _notaController.text.trim();
    final movimiento = Movimiento(
      tipo: _tipo,
      importe: importe,
      nota: nota.isEmpty ? null : nota,
      categoria: categoriaId,
      cajaId: cajaId,
      fecha: DateTime.now(),
      modo: ajustes.modoApp,
      aprobado: true,
    );

    await movimientosProvider.agregarMovimiento(movimiento, cajasProvider: cajasProvider);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final ajustes = context.watch<AjustesProvider>();
    final cajas = context.watch<CajasProvider>().cajas;
    final categorias = categoriasParaModo(ajustes.modoApp);

    _cajaId ??= cajas.isNotEmpty ? cajas.first.id : null;

    final esGasto = _tipo == TipoMovimiento.gasto;

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo movimiento')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _ToggleTipo(
              esGasto: esGasto,
              onChanged: (gasto) => setState(() {
                _tipo = gasto ? TipoMovimiento.gasto : TipoMovimiento.ingreso;
              }),
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
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '0,00',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notaController,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
              decoration: const InputDecoration(
                hintText: 'Añadir una nota (opcional)',
              ),
            ),
            const SizedBox(height: 28),
            Text('CATEGORÍA', style: theme.textTheme.labelSmall),
            const SizedBox(height: 12),
            CategoryGrid(
              categorias: categorias,
              seleccionada: _categoriaId,
              onSeleccionar: (id) => setState(() => _categoriaId = id),
            ),
            const SizedBox(height: 28),
            Text('CAJA DE DESTINO', style: theme.textTheme.labelSmall),
            const SizedBox(height: 12),
            if (cajas.isEmpty)
              Text(
                'Crea primero una caja para poder guardar movimientos.',
                style: theme.textTheme.bodySmall,
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cajas.map((caja) => _buildCajaPill(theme, colors, caja)).toList(),
              ),
            const SizedBox(height: 36),
            ElevatedButton(
              onPressed: _formularioValido ? _guardar : null,
              child: _guardando
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.black),
                    )
                  : const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCajaPill(ThemeData theme, KashColors colors, Caja caja) {
    final activa = caja.id == _cajaId;
    return ChoiceChip(
      label: Text(caja.nombre),
      selected: activa,
      onSelected: (_) => setState(() => _cajaId = caja.id),
      labelStyle: theme.textTheme.bodySmall?.copyWith(
        color: activa
            ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
            : theme.textTheme.bodySmall?.color,
        fontWeight: FontWeight.w600,
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

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(child: _opcion(theme, colors, 'Gasto', esGasto, () => onChanged(true))),
          Expanded(child: _opcion(theme, colors, 'Ingreso', !esGasto, () => onChanged(false))),
        ],
      ),
    );
  }

  Widget _opcion(ThemeData theme, KashColors colors, String texto, bool activa, VoidCallback onTap) {
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
                : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}
