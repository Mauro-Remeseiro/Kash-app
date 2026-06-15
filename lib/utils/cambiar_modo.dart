import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ajustes_provider.dart';
import '../providers/categorias_provider.dart';
import '../providers/cuentas_provider.dart';
import '../providers/movimientos_provider.dart';

Future<void> cambiarModoApp(BuildContext context, String nuevoModo) async {
  final ajustes = context.read<AjustesProvider>();
  final categoriasProvider = context.read<CategoriasProvider>();
  final cuentasProvider = context.read<CuentasProvider>();
  final movimientosProvider = context.read<MovimientosProvider>();

  await ajustes.setModoApp(nuevoModo);
  await Future.wait([
    categoriasProvider.cargar(nuevoModo),
    cuentasProvider.cargar(nuevoModo),
    movimientosProvider.cargar(modo: nuevoModo, resetCuentaFiltro: true),
  ]);
}
