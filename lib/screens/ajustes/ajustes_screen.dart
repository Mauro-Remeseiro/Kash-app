import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/ajuste.dart';
import '../../models/caja.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/auth_service.dart';
import '../../services/kash_ai_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/kash_colors.dart';
import '../../utils/cambiar_modo.dart';
import '../../utils/countries.dart';
import '../../utils/formatters.dart';
import '../../widgets/bounce_button.dart';
import 'categorias_screen.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  void _editarPresupuesto(BuildContext context, AjustesProvider ajustes) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(
      text: ajustes.presupuestoMensual > 0
          ? ajustes.presupuestoMensual.toStringAsFixed(2).replaceAll('.', ',')
          : '',
    );
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.presupuestoMensual),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(hintText: l10n.hintImporte),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancelar),
          ),
          TextButton(
            onPressed: () {
              final texto = controller.text.trim().replaceAll(',', '.');
              final valor = double.tryParse(texto) ?? 0;
              ajustes.setPresupuestoMensual(valor);
              Navigator.of(ctx).pop();
            },
            child: Text(l10n.guardar),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    final ajustes = context.watch<AjustesProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ajustes)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(l10n.tema, style: theme.textTheme.labelSmall),
            const SizedBox(height: 12),
            _OpcionesChip(
              opciones: [
                (id: TemaAjuste.system, etiqueta: l10n.sistemaTema),
                (id: TemaAjuste.light, etiqueta: l10n.claroTema),
                (id: TemaAjuste.dark, etiqueta: l10n.oscuroTema),
              ],
              valorActual: ajustes.tema,
              onSeleccionar: ajustes.setTema,
            ),
            const SizedBox(height: 28),
            Text(l10n.modoApp, style: theme.textTheme.labelSmall),
            const SizedBox(height: 12),
            _OpcionesChip(
              opciones: [
                (id: ModoApp.personal, etiqueta: l10n.modoPersonal),
                (id: ModoApp.empresa, etiqueta: l10n.modoEmpresa),
              ],
              valorActual: ajustes.modoApp,
              onSeleccionar: (modo) => cambiarModoApp(context, modo),
            ),
            const SizedBox(height: 28),
            Text(l10n.preferencias, style: theme.textTheme.labelSmall),
            const SizedBox(height: 12),
            const _PreferenciasSection(),
            const SizedBox(height: 28),
            Text(l10n.presupuesto, style: theme.textTheme.labelSmall),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              onTap: () => _editarPresupuesto(context, ajustes),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ajustes.presupuestoMensual > 0
                                ? formatearImporte(ajustes.presupuestoMensual, moneda: ajustes.moneda)
                                : l10n.sinPresupuestoDefinido,
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(l10n.tocarParaEditar, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Icon(Icons.edit_outlined, size: 18, color: colors.textTertiary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(l10n.categoriasLabel, style: theme.textTheme.labelSmall),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CategoriasScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.misCategorias,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 18, color: colors.textTertiary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(l10n.kashAiLabel, style: theme.textTheme.labelSmall),
            const SizedBox(height: 12),
            _KashAiSection(consultasRestantes: ajustes.kashAiConsultasRestantes),
            const SizedBox(height: 28),
            Text(l10n.seguridad, style: theme.textTheme.labelSmall),
            const SizedBox(height: 12),
            const _SeguridadSection(),
          ],
        ),
      ),
    );
  }
}

// ─── Sección de preferencias ─────────────────────────────────────────────────

class _PreferenciasSection extends StatelessWidget {
  const _PreferenciasSection();

  static const _idiomas = [
    (code: 'es', label: 'Español',   flag: '🇪🇸'),
    (code: 'en', label: 'English',   flag: '🇬🇧'),
    (code: 'pt', label: 'Português', flag: '🇧🇷'),
    (code: 'fr', label: 'Français',  flag: '🇫🇷'),
    (code: 'de', label: 'Deutsch',   flag: '🇩🇪'),
    (code: 'it', label: 'Italiano',  flag: '🇮🇹'),
  ];

  void _elegirIdioma(BuildContext context, LocaleProvider localeProvider) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          maxChildSize: 0.7,
          builder: (_, sc) => ListView(
            controller: sc,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Center(
                child: Container(
                  width: 36, height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(l10n.idioma, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              ..._idiomas.map((idioma) {
                final sel = localeProvider.locale.languageCode == idioma.code;
                return ListTile(
                  leading: Text(idioma.flag, style: const TextStyle(fontSize: 22)),
                  title: Text(idioma.label),
                  trailing: sel ? const Icon(Icons.check, color: Color(0xFFAAFF00)) : null,
                  onTap: () {
                    localeProvider.setLocale(Locale(idioma.code));
                    Navigator.of(ctx).pop();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _elegirPais(BuildContext context, LocaleProvider localeProvider) {
    final l10n = AppLocalizations.of(context)!;
    String query = '';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          final filtered = kPaises.where((p) =>
            p.nombre.toLowerCase().contains(query.toLowerCase()) ||
            p.moneda.toLowerCase().contains(query.toLowerCase()),
          ).toList();

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            maxChildSize: 0.9,
            builder: (_, sc) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 36, height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(l10n.paisYMoneda, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          hintText: l10n.buscarPais,
                          prefixIcon: Icon(Icons.search, size: 20),
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          isDense: true,
                        ),
                        onChanged: (v) => setS(() => query = v),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: sc,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final pais = filtered[i];
                      final activo = pais.code == localeProvider.pais.code;
                      return ListTile(
                        leading: Text(pais.emoji, style: const TextStyle(fontSize: 20)),
                        title: Text(pais.nombre),
                        trailing: activo ? const Icon(Icons.check, color: Color(0xFFAAFF00)) : Text(pais.moneda, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        onTap: () {
                          localeProvider.setPais(pais);
                          Navigator.of(ctx).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final colors = kashColorsOf(context);
    final locale = context.watch<LocaleProvider>();
    final l10n   = AppLocalizations.of(context)!;

    final idiomaActual = _idiomas.firstWhere(
      (i) => i.code == locale.locale.languageCode,
      orElse: () => _idiomas.first,
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: colors.border),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: Column(
          children: [
            ListTile(
              title: Text(l10n.idioma),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${idiomaActual.flag} ${idiomaActual.label}', style: theme.textTheme.bodySmall),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18, color: colors.textTertiary),
                ],
              ),
              onTap: () => _elegirIdioma(context, locale),
            ),
            Divider(height: 1, color: colors.border),
            ListTile(
              title: Text(l10n.pais),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${locale.pais.emoji} ${locale.pais.nombre}', style: theme.textTheme.bodySmall),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18, color: colors.textTertiary),
                ],
              ),
              onTap: () => _elegirPais(context, locale),
            ),
            Divider(height: 1, color: colors.border),
            ListTile(
              title: Text(l10n.moneda),
              trailing: Text(
                '${locale.pais.simbolo}  ${locale.pais.moneda}',
                style: theme.textTheme.bodySmall?.copyWith(color: colors.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sección de Kash AI ─────────────────────────────────────────────────────

class _KashAiSection extends StatefulWidget {
  const _KashAiSection({required this.consultasRestantes});

  final int consultasRestantes;

  @override
  State<_KashAiSection> createState() => _KashAiSectionState();
}

class _KashAiSectionState extends State<_KashAiSection> {
  final _controller = TextEditingController();
  bool _loading = true;
  bool _tieneClave = false;
  bool _mostrarClave = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final clave = await KashAiService.getApiKey();
    if (!mounted) return;
    setState(() {
      _controller.text = clave ?? '';
      _tieneClave = clave != null && clave.isNotEmpty;
      _loading = false;
    });
  }

  Future<void> _guardar() async {
    final l10n = AppLocalizations.of(context)!;
    await KashAiService.setApiKey(_controller.text);
    if (!mounted) return;
    setState(() => _tieneClave = _controller.text.trim().isNotEmpty);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_tieneClave ? l10n.apiKeyGuardada : l10n.apiKeyEliminada)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n   = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: colors.border),
      ),
      child: _loading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.claveApiAnthropic,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  _tieneClave
                      ? l10n.kashAiActivo(widget.consultasRestantes)
                      : l10n.kashAiInactivo,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  obscureText: !_mostrarClave,
                  decoration: InputDecoration(
                    hintText: l10n.skAntHint,
                    suffixIcon: IconButton(
                      icon: Icon(_mostrarClave ? Icons.visibility_off : Icons.visibility, size: 18),
                      onPressed: () => setState(() => _mostrarClave = !_mostrarClave),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: KashBounceButton(
                    onPressed: _guardar,
                    child: Text(l10n.guardar),
                  ),
                ),
              ],
            ),
    );
  }
}

// ─── Sección de seguridad ─────────────────────────────────────────────────────

class _SeguridadSection extends StatefulWidget {
  const _SeguridadSection();

  @override
  State<_SeguridadSection> createState() => _SeguridadSectionState();
}

class _SeguridadSectionState extends State<_SeguridadSection> {
  bool _authEnabled = false;
  bool _blockCapture = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final auth = await AuthService.isEnabled;
    final cap  = await AuthService.blockCapture;
    if (!mounted) return;
    setState(() { _authEnabled = auth; _blockCapture = cap; _loading = false; });
  }

  // ── Habilitar auth ─────────────────────────────────────────────────────────

  Future<void> _habilitarAuth() async {
    final pin = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const _SetPinScreen(requireCurrentPin: false)),
    );
    if (pin == null || !mounted) return;
    await AuthService.savePin(pin);
    setState(() => _authEnabled = true);
  }

  // ── Deshabilitar auth ──────────────────────────────────────────────────────

  Future<void> _deshabilitarAuth() async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.desactivarProteccion),
        content: Text(l10n.desactivarProteccionMsg),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l10n.cancelar)),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.desactivar, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await AuthService.disable();
    setState(() => _authEnabled = false);
  }

  // ── Cambiar PIN ────────────────────────────────────────────────────────────

  Future<void> _cambiarPin() async {
    final l10n = AppLocalizations.of(context)!;
    final pin = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const _SetPinScreen(requireCurrentPin: true)),
    );
    if (pin == null || !mounted) return;
    await AuthService.savePin(pin);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.pinActualizado)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final colors = kashColorsOf(context);
    final l10n   = AppLocalizations.of(context)!;

    if (_loading) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ));
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          // Bloqueo con biometría
          SwitchListTile(
            title: Text(l10n.bloqueoApp),
            subtitle: Text(l10n.huellaOFaceId),
            value: _authEnabled,
            activeThumbColor: Colors.black,
            activeTrackColor: theme.colorScheme.primary,
            onChanged: (v) => v ? _habilitarAuth() : _deshabilitarAuth(),
          ),
          if (_authEnabled) ...[
            Divider(height: 1, color: colors.border),
            ListTile(
              title: Text(l10n.cambiarPin),
              trailing: Icon(Icons.chevron_right, color: colors.textTertiary),
              onTap: _cambiarPin,
            ),
          ],
          Divider(height: 1, color: colors.border),
          SwitchListTile(
            title: Text(l10n.bloqueoCapturas),
            subtitle: Text(l10n.pantallaNegraMultitarea),
            value: _blockCapture,
            activeThumbColor: Colors.black,
            activeTrackColor: theme.colorScheme.primary,
            onChanged: (v) async {
              await AuthService.setBlockCapture(v);
              setState(() => _blockCapture = v);
            },
          ),
        ],
      ),
    );
  }
}

// ─── Pantalla para crear / cambiar PIN ────────────────────────────────────────

class _SetPinScreen extends StatefulWidget {
  const _SetPinScreen({required this.requireCurrentPin});

  final bool requireCurrentPin;

  @override
  State<_SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<_SetPinScreen> with TickerProviderStateMixin {
  // Paso: 0 = verificar PIN actual (si requireCurrentPin), 1 = nuevo PIN, 2 = confirmar
  int _step = 0;
  final List<int> _input = [];
  String? _newPin;
  String _errorText = '';

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _step = widget.requireCurrentPin ? 0 : 1;

    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(_shakeCtrl);
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  String get _title {
    final l10n = AppLocalizations.of(context)!;
    switch (_step) {
      case 0: return l10n.pinActual;
      case 1: return l10n.nuevoPin;
      case 2: return l10n.confirmarPin;
      default: return '';
    }
  }

  void _onKey(String key) {
    if (key == '⌫') {
      if (_input.isNotEmpty) setState(() { _input.removeLast(); _errorText = ''; });
      return;
    }
    if (_input.length >= 6) return;
    setState(() { _input.add(int.parse(key)); _errorText = ''; });
    if (_input.length == 6) _advance();
  }

  Future<void> _advance() async {
    final l10n = AppLocalizations.of(context)!;
    final pinStr = _input.join();

    if (_step == 0) {
      // Verificar PIN actual
      final result = await AuthService.verifyPin(pinStr);
      if (!mounted) return;
      if (result.ok) {
        setState(() { _input.clear(); _step = 1; _errorText = ''; });
      } else {
        setState(() { _input.clear(); _errorText = result.locked ? l10n.bloqueado : l10n.pinIncorrecto; });
        _shakeCtrl.forward(from: 0);
      }
      return;
    }

    if (_step == 1) {
      // Guardar nuevo PIN, pedir confirmación
      setState(() { _newPin = pinStr; _input.clear(); _step = 2; _errorText = ''; });
      return;
    }

    if (_step == 2) {
      // Confirmar
      if (pinStr == _newPin) {
        Navigator.of(context).pop(_newPin);
      } else {
        setState(() { _input.clear(); _errorText = l10n.pinesNoCoinciden; });
        _shakeCtrl.forward(from: 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final colors = kashColorsOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: _shakeAnim,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(_shakeAnim.value, 0),
                      child: child,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (i) {
                        final filled = i < _input.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filled ? theme.colorScheme.primary : Colors.transparent,
                            border: filled
                                ? null
                                : Border.all(color: colors.border, width: 1.5),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 16,
                    child: Text(
                      _errorText,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            // Teclado
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                children: [
                  _keyRow(['1', '2', '3'], theme),
                  const SizedBox(height: 12),
                  _keyRow(['4', '5', '6'], theme),
                  const SizedBox(height: 12),
                  _keyRow(['7', '8', '9'], theme),
                  const SizedBox(height: 12),
                  _keyRow(['', '0', '⌫'], theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _keyRow(List<String> keys, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((k) {
        if (k.isEmpty) return const SizedBox(width: 88, height: 56);
        return GestureDetector(
          onTap: () => _onKey(k),
          child: Container(
            width: 88,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
            ),
            child: k == '⌫'
                ? Icon(Icons.backspace_outlined, size: 20, color: theme.textTheme.bodySmall?.color)
                : Text(
                    k,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
                  ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Chips de opciones ────────────────────────────────────────────────────────

class _OpcionesChip extends StatelessWidget {
  const _OpcionesChip({
    required this.opciones,
    required this.valorActual,
    required this.onSeleccionar,
  });

  final List<({String id, String etiqueta})> opciones;
  final String valorActual;
  final ValueChanged<String> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final colors = kashColorsOf(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: opciones.map((opcion) {
        final activo = valorActual == opcion.id;
        return ChoiceChip(
          label: Text(opcion.etiqueta),
          selected: activo,
          onSelected: (_) => onSeleccionar(opcion.id),
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
    );
  }
}
