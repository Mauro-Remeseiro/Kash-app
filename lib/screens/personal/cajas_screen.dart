import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/database_helper.dart';
import '../../models/caja.dart';
import '../../models/movimiento.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/cajas_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/kash_colors.dart';
import '../../utils/formatters.dart';
import '../../widgets/caja_card.dart';

/// Resumen de movimientos de una caja durante el mes en curso.
typedef ResumenCaja = ({double gastado, double ingresado});

class CajasScreen extends StatefulWidget {
  const CajasScreen({super.key});

  @override
  State<CajasScreen> createState() => _CajasScreenState();
}

class _CajasScreenState extends State<CajasScreen> {
  late Future<Map<int, ResumenCaja>> _resumenFuture;

  @override
  void initState() {
    super.initState();
    _resumenFuture = _cargarResumenMensual();
  }

  Future<Map<int, ResumenCaja>> _cargarResumenMensual() async {
    final ajustes = context.read<AjustesProvider>();
    final ahora = DateTime.now();
    final desde = DateTime(ahora.year, ahora.month, 1);
    final hasta = DateTime(ahora.year, ahora.month + 1, 1).subtract(const Duration(milliseconds: 1));

    final filas = await DatabaseHelper.instance.getMovimientos(
      modo: ajustes.modoApp,
      desde: desde,
      hasta: hasta,
    );

    final resumen = <int, ResumenCaja>{};
    for (final fila in filas) {
      final movimiento = Movimiento.fromMap(fila);
      final actual = resumen[movimiento.cajaId] ?? (gastado: 0.0, ingresado: 0.0);
      resumen[movimiento.cajaId] = movimiento.esGasto
          ? (gastado: actual.gastado + movimiento.importe, ingresado: actual.ingresado)
          : (gastado: actual.gastado, ingresado: actual.ingresado + movimiento.importe);
    }
    return resumen;
  }

  Future<void> _recargar() async {
    final cajasProvider = context.read<CajasProvider>();
    final nuevoResumen = _cargarResumenMensual();
    await Future.wait([cajasProvider.recargar(), nuevoResumen]);
    if (!mounted) return;
    setState(() => _resumenFuture = nuevoResumen);
  }

  Future<void> _abrirFormularioNuevaCaja() async {
    final ajustes = context.read<AjustesProvider>();
    final cajasProvider = context.read<CajasProvider>();

    final caja = await showModalBottomSheet<Caja>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NuevaCajaSheet(modo: ajustes.modoApp),
    );

    if (caja == null) return;
    await cajasProvider.agregarCaja(caja);
    if (!mounted) return;
    setState(() => _resumenFuture = _cargarResumenMensual());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final ajustes = context.watch<AjustesProvider>();
    final cajasProvider = context.watch<CajasProvider>();
    final cajas = cajasProvider.cajas;

    return Scaffold(
      appBar: AppBar(title: const Text('Cajas')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _recargar,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _PatrimonioCard(
                patrimonio: cajasProvider.patrimonioTotal,
                moneda: ajustes.moneda,
              ),
              const SizedBox(height: 28),
              Text('TUS CAJAS', style: theme.textTheme.labelSmall),
              const SizedBox(height: 12),
              if (cajasProvider.cargando && cajas.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.25,
                  children: [
                    ...cajas.map(
                      (caja) => CajaCard(caja: caja, moneda: ajustes.moneda),
                    ),
                    NuevaCajaCard(onTap: _abrirFormularioNuevaCaja),
                  ],
                ),
              const SizedBox(height: 28),
              Text('MOVIMIENTOS DE ESTE MES', style: theme.textTheme.labelSmall),
              const SizedBox(height: 12),
              FutureBuilder<Map<int, ResumenCaja>>(
                future: _resumenFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (cajas.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'Crea una caja para empezar a registrar movimientos.',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final resumen = snapshot.data!;
                  final hayMovimientos = resumen.values.any(
                    (r) => r.gastado > 0 || r.ingresado > 0,
                  );

                  if (!hayMovimientos) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'Todavía no hay movimientos este mes.',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: cajas.map((caja) {
                      final r = resumen[caja.id] ?? (gastado: 0.0, ingresado: 0.0);
                      return _ResumenCajaTile(
                        caja: caja,
                        resumen: r,
                        moneda: ajustes.moneda,
                        colors: colors,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatrimonioCard extends StatelessWidget {
  const _PatrimonioCard({required this.patrimonio, required this.moneda});

  final double patrimonio;
  final String moneda;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: theme.colorScheme.primary, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PATRIMONIO TOTAL', style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          Text(
            formatearImporte(patrimonio, moneda: moneda),
            style: theme.textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}

class _ResumenCajaTile extends StatelessWidget {
  const _ResumenCajaTile({
    required this.caja,
    required this.resumen,
    required this.moneda,
    required this.colors,
  });

  final Caja caja;
  final ResumenCaja resumen;
  final String moneda;
  final KashColors colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            child: Text(
              caja.nombre,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '− ${formatearImporte(resumen.gastado, moneda: moneda)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.negative,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '+ ${formatearImporte(resumen.ingresado, moneda: moneda)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.positive,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NuevaCajaSheet extends StatefulWidget {
  const _NuevaCajaSheet({required this.modo});

  final String modo;

  @override
  State<_NuevaCajaSheet> createState() => _NuevaCajaSheetState();
}

class _NuevaCajaSheetState extends State<_NuevaCajaSheet> {
  final _nombreController = TextEditingController();
  final _saldoController = TextEditingController();

  String _tipo = TipoCaja.efectivo;

  static const _tiposDisponibles = [
    (id: TipoCaja.efectivo, etiqueta: 'Efectivo'),
    (id: TipoCaja.banco, etiqueta: 'Banco'),
    (id: TipoCaja.ahorros, etiqueta: 'Ahorros'),
    (id: TipoCaja.custom, etiqueta: 'Personalizada'),
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _saldoController.dispose();
    super.dispose();
  }

  bool get _formularioValido => _nombreController.text.trim().isNotEmpty;

  void _guardar() {
    final nombre = _nombreController.text.trim();
    if (nombre.isEmpty) return;

    final saldo = double.tryParse(_saldoController.text.replaceAll(',', '.')) ?? 0;

    Navigator.of(context).pop(
      Caja(
        nombre: nombre,
        tipo: _tipo,
        saldo: saldo,
        modo: widget.modo,
        creadoEn: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.cardRadius)),
          border: Border.all(color: colors.border),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nueva caja', style: theme.textTheme.titleMedium),
            const SizedBox(height: 20),
            Text('NOMBRE', style: theme.textTheme.labelSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _nombreController,
              textCapitalization: TextCapitalization.sentences,
              style: theme.textTheme.bodyMedium,
              decoration: const InputDecoration(hintText: 'p. ej. Cuenta corriente'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Text('TIPO', style: theme.textTheme.labelSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tiposDisponibles.map((opcion) {
                final activo = _tipo == opcion.id;
                return ChoiceChip(
                  label: Text(opcion.etiqueta),
                  selected: activo,
                  onSelected: (_) => setState(() => _tipo = opcion.id),
                  labelStyle: theme.textTheme.bodySmall?.copyWith(
                    color: activo
                        ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
                        : theme.textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w600,
                  ),
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: theme.cardTheme.color,
                  side: BorderSide(color: colors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text('SALDO INICIAL (OPCIONAL)', style: theme.textTheme.labelSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _saldoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: theme.textTheme.bodyMedium,
              decoration: const InputDecoration(hintText: '0,00'),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _formularioValido ? _guardar : null,
                child: const Text('Crear caja'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
