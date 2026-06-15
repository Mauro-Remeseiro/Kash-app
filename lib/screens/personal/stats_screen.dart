import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/database_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../models/categoria.dart';
import '../../models/movimiento.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/categorias_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/kash_colors.dart';
import '../../utils/formatters.dart';
import '../../widgets/bar_chart_widget.dart';
import '../../widgets/progress_bar.dart';

/// Total gastado en una categoría junto con su peso relativo sobre el total
/// del mes (para la barra de progreso y el porcentaje mostrados).
typedef DesgloseCategoria = ({Categoria categoria, double total, double porcentaje});

class _DatosEstadisticas {
  const _DatosEstadisticas({
    required this.totalMes,
    required this.barras,
    required this.categorias,
  });

  final double totalMes;
  final List<BarraSemana> barras;
  final List<DesgloseCategoria> categorias;
}

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<_DatosEstadisticas> _datosFuture;

  @override
  void initState() {
    super.initState();
    _datosFuture = _cargarDatos();
  }

  DateTime _inicioDeSemana(DateTime fecha) {
    final dia = DateTime(fecha.year, fecha.month, fecha.day);
    return dia.subtract(Duration(days: dia.weekday - 1));
  }

  Future<_DatosEstadisticas> _cargarDatos() async {
    final ajustes = context.read<AjustesProvider>();
    final categoriasProvider = context.read<CategoriasProvider>();
    final modo = ajustes.modoApp;
    final db = DatabaseHelper.instance;
    final ahora = DateTime.now();

    final inicioMes = DateTime(ahora.year, ahora.month, 1);
    final finMes = DateTime(ahora.year, ahora.month + 1, 1).subtract(const Duration(milliseconds: 1));

    final totalMes = await db.sumaPorTipo(
      modo: modo,
      tipo: TipoMovimiento.gasto,
      desde: inicioMes,
      hasta: finMes,
    );

    // Últimas 6 semanas (lunes a domingo), con la semana actual al final.
    final inicioSemanaActual = _inicioDeSemana(ahora);
    final barras = <BarraSemana>[];
    for (var i = 5; i >= 0; i--) {
      final inicioSemana = inicioSemanaActual.subtract(Duration(days: i * 7));
      final finSemana = inicioSemana
          .add(const Duration(days: 7))
          .subtract(const Duration(milliseconds: 1));
      final total = await db.sumaPorTipo(
        modo: modo,
        tipo: TipoMovimiento.gasto,
        desde: inicioSemana,
        hasta: finSemana,
      );
      barras.add((
        etiqueta: formatearFechaCorta(inicioSemana),
        valor: total,
        actual: i == 0,
      ));
    }

    final filasCategoria = await db.totalesPorCategoria(
      modo: modo,
      tipo: TipoMovimiento.gasto,
      desde: inicioMes,
      hasta: finMes,
    );
    final categorias = filasCategoria.map((fila) {
      final total = (fila['total'] as num).toDouble();
      return (
        categoria: categoriasProvider.categoriaPorId(fila['categoria_id'] as int?),
        total: total,
        porcentaje: totalMes > 0 ? total / totalMes : 0.0,
      );
    }).toList();

    return _DatosEstadisticas(totalMes: totalMes, barras: barras, categorias: categorias);
  }

  Future<void> _recargar() async {
    final nuevos = _cargarDatos();
    await nuevos;
    if (!mounted) return;
    setState(() => _datosFuture = nuevos);
  }

  void _mostrarDialogoPro() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exportarPdfProTitle),
        content: Text(l10n.exportarPdfProMsg),
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.estadisticasTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _recargar,
          child: FutureBuilder<_DatosEstadisticas>(
            future: _datosFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return ListView(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 64),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                );
              }

              final datos = snapshot.data!;

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  Text(l10n.totalDelMes, style: theme.textTheme.labelSmall),
                  const SizedBox(height: 6),
                  Text(
                    formatearImporte(datos.totalMes, moneda: ajustes.moneda),
                    style: theme.textTheme.displayLarge,
                  ),
                  const SizedBox(height: 32),
                  Text(l10n.gastosPorSemana, style: theme.textTheme.labelSmall),
                  const SizedBox(height: 16),
                  BarChartWidget(barras: datos.barras),
                  const SizedBox(height: 32),
                  Text(l10n.desgloseCategorias, style: theme.textTheme.labelSmall),
                  const SizedBox(height: 16),
                  if (datos.categorias.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          l10n.sinGastosEsteMes,
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ...datos.categorias.map(
                      (item) => _DesgloseCategoriaTile(
                        item: item,
                        moneda: ajustes.moneda,
                        colors: colors,
                      ),
                    ),
                  const SizedBox(height: 24),
                  _ExportarPdfTile(onTap: _mostrarDialogoPro),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DesgloseCategoriaTile extends StatelessWidget {
  const _DesgloseCategoriaTile({
    required this.item,
    required this.moneda,
    required this.colors,
  });

  final DesgloseCategoria item;
  final String moneda;
  final KashColors colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final porcentajeTexto = '${(item.porcentaje * 100).round()}%';

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(item.categoria.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    item.categoria.nombre,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                '$porcentajeTexto · ${formatearImporte(item.total, moneda: moneda)}',
                style: theme.textTheme.bodySmall?.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ProgressBar(progreso: item.porcentaje),
        ],
      ),
    );
  }
}

class _ExportarPdfTile extends StatelessWidget {
  const _ExportarPdfTile({required this.onTap});

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
                l10n.exportarPdf,
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
