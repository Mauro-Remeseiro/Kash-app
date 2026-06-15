import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/categoria.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/categorias_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/kash_colors.dart';
import '../../widgets/categoria_form_sheet.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  Map<int, int> _contadores = {};
  bool _cargandoContadores = true;

  @override
  void initState() {
    super.initState();
    _cargarContadores();
  }

  Future<void> _cargarContadores() async {
    final categoriasProvider = context.read<CategoriasProvider>();
    final contadores = <int, int>{};
    for (final categoria in categoriasProvider.categorias) {
      final id = categoria.id;
      if (id == null) continue;
      contadores[id] = await categoriasProvider.contarMovimientos(id);
    }
    if (!mounted) return;
    setState(() {
      _contadores = contadores;
      _cargandoContadores = false;
    });
  }

  Future<void> _crearCategoria() async {
    final ajustes = context.read<AjustesProvider>();
    final categoriasProvider = context.read<CategoriasProvider>();
    final nueva = await mostrarFormularioCategoria(context, modo: ajustes.modoApp);
    if (nueva == null || !mounted) return;
    final creada = await categoriasProvider.agregarCategoria(nueva);
    final id = creada.id;
    if (id == null) return;
    setState(() => _contadores[id] = 0);
  }

  Future<void> _editarCategoria(Categoria categoria) async {
    final ajustes = context.read<AjustesProvider>();
    final categoriasProvider = context.read<CategoriasProvider>();
    final editada = await mostrarFormularioCategoria(
      context,
      categoria: categoria,
      modo: ajustes.modoApp,
    );
    if (editada == null) return;
    await categoriasProvider.actualizarCategoria(editada);
  }

  Future<void> _eliminarCategoria(Categoria categoria) async {
    final l10n = AppLocalizations.of(context)!;
    final id = categoria.id;
    if (id == null) return;
    final categoriasProvider = context.read<CategoriasProvider>();
    final contador = await categoriasProvider.contarMovimientos(id);
    if (!mounted) return;

    if (contador > 0) {
      final opciones = categoriasProvider.categorias.where((c) => c.id != id).toList();
      final destino = await showModalBottomSheet<Categoria>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _ReasignarSheet(categoriaOrigen: categoria, opciones: opciones),
      );
      if (destino == null || !mounted) return;
      await categoriasProvider.eliminarCategoria(id, moverMovimientosA: destino.id);
    } else {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.eliminarCategoriaTitle),
          content: Text(l10n.eliminarCategoriaConfirm(categoria.nombre)),
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
      await categoriasProvider.eliminarCategoria(id);
    }

    if (!mounted) return;
    setState(() => _contadores.remove(id));
  }

  void _mostrarOpciones(Categoria categoria) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OpcionesCategoriaSheet(
        categoria: categoria,
        onEditar: () => _editarCategoria(categoria),
        onEliminar: () => _eliminarCategoria(categoria),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final categoriasProvider = context.watch<CategoriasProvider>();
    final categorias = categoriasProvider.categorias;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.misCategorias),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _crearCategoria,
          ),
        ],
      ),
      body: SafeArea(
        child: (categoriasProvider.cargando || _cargandoContadores) && categorias.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  if (categorias.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          l10n.sinCategoriasAun,
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ...categorias.map(
                      (c) => _CategoriaTile(
                        categoria: c,
                        contador: _contadores[c.id] ?? 0,
                        onMasOpciones: () => _mostrarOpciones(c),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

// ─── Categoria tile ───────────────────────────────────────────────────────────

class _CategoriaTile extends StatelessWidget {
  const _CategoriaTile({
    required this.categoria,
    required this.contador,
    required this.onMasOpciones,
  });

  final Categoria categoria;
  final int contador;
  final VoidCallback onMasOpciones;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;

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
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
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
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        categoria.nombre,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (categoria.esCustom) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.categoriaPersonalizada,
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
                  contador == 0
                      ? l10n.sinMovimientosCategoria
                      : contador == 1
                          ? l10n.unMovimiento
                          : l10n.nMovimientos(contador),
                  style: theme.textTheme.bodySmall?.copyWith(color: colors.textTertiary),
                ),
              ],
            ),
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

// ─── Bottom sheet: opciones de categoría ─────────────────────────────────────

class _OpcionesCategoriaSheet extends StatelessWidget {
  const _OpcionesCategoriaSheet({
    required this.categoria,
    required this.onEditar,
    required this.onEliminar,
  });

  final Categoria categoria;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

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
          Row(
            children: [
              Text(categoria.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  categoria.nombre,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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

// ─── Bottom sheet: reasignar movimientos ─────────────────────────────────────

class _ReasignarSheet extends StatelessWidget {
  const _ReasignarSheet({required this.categoriaOrigen, required this.opciones});

  final Categoria categoriaOrigen;
  final List<Categoria> opciones;

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
          const SizedBox(height: 20),
          Text(l10n.moverMovimientosTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            l10n.reasignarMovimientosMsg(categoriaOrigen.nombre),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          ...opciones.map(
            (c) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(c.emoji, style: const TextStyle(fontSize: 20)),
              title: Text(c.nombre, style: theme.textTheme.bodyMedium),
              onTap: () => Navigator.of(context).pop(c),
            ),
          ),
        ],
      ),
    );
  }
}
