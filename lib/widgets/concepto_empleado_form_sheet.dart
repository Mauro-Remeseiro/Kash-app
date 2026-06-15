import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/concepto_empleado.dart';
import '../theme/kash_colors.dart';
import 'bounce_button.dart';
import 'spring_sheet.dart';

List<(String?, String)> _tiposDisponibles(AppLocalizations l10n) => [
      (TipoConcepto.sueldo, l10n.tipoSueldo),
      (TipoConcepto.comision, l10n.tipoComision),
      (TipoConcepto.bonus, l10n.tipoBonus),
      (TipoConcepto.dieta, l10n.tipoDieta),
      (TipoConcepto.otro, l10n.tipoOtro),
      (null, l10n.sinTipo),
    ];

/// Muestra un BottomSheet para crear o editar un [ConceptoEmpleado].
///
/// Devuelve el concepto resultante (sin persistir) o `null` si se cancela.
Future<ConceptoEmpleado?> mostrarFormularioConcepto(
  BuildContext context, {
  required int empleadoId,
  ConceptoEmpleado? concepto,
}) {
  return showModalBottomSheet<ConceptoEmpleado>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => SpringSheet(
      child: ConceptoEmpleadoFormSheet(empleadoId: empleadoId, concepto: concepto),
    ),
  );
}

class ConceptoEmpleadoFormSheet extends StatefulWidget {
  const ConceptoEmpleadoFormSheet({super.key, required this.empleadoId, this.concepto});

  final int empleadoId;
  final ConceptoEmpleado? concepto;

  @override
  State<ConceptoEmpleadoFormSheet> createState() => _ConceptoEmpleadoFormSheetState();
}

class _ConceptoEmpleadoFormSheetState extends State<ConceptoEmpleadoFormSheet> {
  late final TextEditingController _descripcionController;
  late final TextEditingController _importeController;
  String? _tipo;
  late bool _aprobado;

  @override
  void initState() {
    super.initState();
    final concepto = widget.concepto;
    _descripcionController = TextEditingController(text: concepto?.descripcion ?? '');
    _importeController = TextEditingController(
      text: concepto != null ? concepto.importe.toStringAsFixed(2) : '',
    );
    _tipo = concepto?.tipo;
    _aprobado = concepto?.aprobado ?? true;
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _importeController.dispose();
    super.dispose();
  }

  void _guardar() {
    final importe = double.tryParse(_importeController.text.replaceAll(',', '.'));
    if (importe == null || importe <= 0) return;

    final descripcion = _descripcionController.text.trim();
    final existente = widget.concepto;
    final resultado = existente != null
        ? existente.copyWith(
            tipo: _tipo,
            limpiarTipo: _tipo == null,
            descripcion: descripcion,
            limpiarDescripcion: descripcion.isEmpty,
            importe: importe,
            aprobado: _aprobado,
          )
        : ConceptoEmpleado(
            empleadoId: widget.empleadoId,
            tipo: _tipo,
            descripcion: descripcion.isEmpty ? null : descripcion,
            importe: importe,
            fecha: DateTime.now(),
            aprobado: _aprobado,
          );

    Navigator.of(context).pop(resultado);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n = AppLocalizations.of(context)!;
    final esEdicion = widget.concepto != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            esEdicion ? l10n.editarConcepto : l10n.nuevoConcepto,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(l10n.tipoLabel, style: theme.textTheme.labelSmall),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tiposDisponibles(l10n).map((opcion) {
              final (valor, etiqueta) = opcion;
              final activo = _tipo == valor;
              return ChoiceChip(
                label: Text(etiqueta),
                selected: activo,
                onSelected: (_) => setState(() => _tipo = valor),
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: activo
                      ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
                      : null,
                  fontWeight: FontWeight.w500,
                ),
                selectedColor: theme.colorScheme.primary,
                backgroundColor: theme.cardTheme.color,
                side: BorderSide(color: colors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _descripcionController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: l10n.descripcionConceptoHint,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextField(
              controller: _importeController,
              autofocus: !esEdicion,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: theme.textTheme.displayLarge,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: l10n.hintImporte,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.aprobado),
            value: _aprobado,
            onChanged: (value) => setState(() => _aprobado = value),
          ),
          const SizedBox(height: 8),
          KashBounceButton(
            onPressed: _guardar,
            child: Text(l10n.guardarConcepto),
          ),
        ],
      ),
    );
  }
}
