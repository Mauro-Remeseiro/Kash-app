import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Muestra un [AlertDialog] de confirmación de borrado.
/// Devuelve `true` si el usuario confirma la eliminación.
Future<bool> confirmarEliminacion(
  BuildContext context, {
  String? mensaje,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final resultado = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.eliminar),
      content: Text(mensaje ?? l10n.eliminarElementoConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.cancelar),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.eliminar, style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
        ),
      ],
    ),
  );
  return resultado ?? false;
}
