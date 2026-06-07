import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ajustes_provider.dart';
import '../../providers/cajas_provider.dart';
import '../../providers/movimientos_provider.dart';
import '../../theme/kash_colors.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/movimiento_row.dart';
import '../../widgets/progress_bar.dart';
import 'add_movimiento_screen.dart';
import 'cajas_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  FiltroPeriodo _filtroPorEtiqueta(String etiqueta) {
    switch (etiqueta) {
      case 'Semana':
        return FiltroPeriodo.semana;
      case 'Todo':
        return FiltroPeriodo.todo;
      case 'Mes':
      default:
        return FiltroPeriodo.mes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final ajustes = context.watch<AjustesProvider>();
    final movimientosProvider = context.watch<MovimientosProvider>();
    final cajasProvider = context.watch<CajasProvider>();

    final movimientos = movimientosProvider.movimientos;
    final totalGastado = movimientosProvider.totalGastos;
    final presupuesto = ajustes.presupuestoMensual;
    final progreso = presupuesto > 0 ? totalGastado / presupuesto : 0.0;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddMovimientoScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              movimientosProvider.recargar(),
              cajasProvider.recargar(),
            ]);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CajasScreen()),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 18,
                            color: colors.textTertiary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatearMesAnio(DateTime.now()),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Text(
                    'Kash',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('GASTADO ESTE MES', style: theme.textTheme.labelSmall),
              const SizedBox(height: 6),
              Text(
                formatearImporte(totalGastado, moneda: ajustes.moneda),
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 16),
              ProgressBar(
                progreso: progreso,
                color: progreso > 1 ? colors.negative : theme.colorScheme.primary,
              ),
              const SizedBox(height: 6),
              Text(
                presupuesto > 0
                    ? '${formatearImporte(totalGastado, moneda: ajustes.moneda)} de ${formatearImporte(presupuesto, moneda: ajustes.moneda)}'
                    : 'Sin presupuesto mensual definido',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              Row(
                children: etiquetasFiltroPeriodo.map((etiqueta) {
                  final filtro = _filtroPorEtiqueta(etiqueta);
                  final activo = movimientosProvider.filtro == filtro;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(etiqueta),
                      selected: activo,
                      onSelected: (_) => movimientosProvider.cambiarFiltro(filtro),
                      labelStyle: theme.textTheme.bodySmall?.copyWith(
                        color: activo
                            ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
                            : theme.textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w600,
                      ),
                      selectedColor: theme.colorScheme.primary,
                      backgroundColor: theme.cardTheme.color,
                      side: BorderSide(color: colors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('ÚLTIMOS MOVIMIENTOS', style: theme.textTheme.labelSmall),
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
                      'Todavía no hay movimientos en este periodo.',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ...movimientos.map(
                  (movimiento) => MovimientoRow(
                    movimiento: movimiento,
                    moneda: ajustes.moneda,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
