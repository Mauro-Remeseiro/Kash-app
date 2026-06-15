import 'package:flutter/material.dart';
import 'package:kash/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/ajustes_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/auth_service.dart';
import '../../utils/countries.dart';

// ─── Colores fijos del onboarding (siempre oscuro) ───────────────────────────
const _bg     = Color(0xFF111111);
const _accent = Color(0xFFAAFF00);
const _card   = Color(0xFF1C1C1C);
const _border = Color(0xFF2A2A2A);
const _muted  = Color(0xFF666666);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _page = 0;

  void _next() {
    if (_page < 3) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // indicador de página
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: List.generate(4, (i) => Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: i <= _page ? _accent : _border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _PageIdioma(onNext: _next),
                  _PagePais(onNext: _next),
                  _PageModo(onNext: _next),
                  _PageSeguridad(onComplete: widget.onComplete),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Página 1: Idioma ─────────────────────────────────────────────────────────

class _PageIdioma extends StatelessWidget {
  const _PageIdioma({required this.onNext});

  final VoidCallback onNext;

  static const _idiomas = [
    (code: 'es', label: 'Español',    flag: '🇪🇸'),
    (code: 'en', label: 'English',    flag: '🇬🇧'),
    (code: 'pt', label: 'Português',  flag: '🇧🇷'),
    (code: 'fr', label: 'Français',   flag: '🇫🇷'),
    (code: 'de', label: 'Deutsch',    flag: '🇩🇪'),
    (code: 'it', label: 'Italiano',   flag: '🇮🇹'),
  ];

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kash', style: TextStyle(color: _accent, fontSize: 28, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          Text(l10n.elegirIdioma, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: _idiomas.map((idioma) {
                final seleccionado = localeProvider.locale.languageCode == idioma.code;
                return GestureDetector(
                  onTap: () => localeProvider.setLocale(Locale(idioma.code)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: seleccionado ? _accent.withValues(alpha: 0.1) : _card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: seleccionado ? _accent : _border,
                        width: seleccionado ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(idioma.flag, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            idioma.label,
                            style: TextStyle(
                              color: seleccionado ? _accent : Colors.white,
                              fontSize: 16,
                              fontWeight: seleccionado ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (seleccionado)
                          const Icon(Icons.check_circle, color: _accent, size: 20),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onNext,
              child: Text(l10n.continuar, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Página 2: País ───────────────────────────────────────────────────────────

class _PagePais extends StatefulWidget {
  const _PagePais({required this.onNext});

  final VoidCallback onNext;

  @override
  State<_PagePais> createState() => _PagePaisState();
}

class _PagePaisState extends State<_PagePais> {
  String _query = '';

  List<KashCountry> get _filtered => kPaises
      .where((p) => p.nombre.toLowerCase().contains(_query.toLowerCase()) ||
                    p.moneda.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context)!;
    final seleccionado = localeProvider.pais;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.elegirPais, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(l10n.ajustaMoneda, style: const TextStyle(color: _muted, fontSize: 13)),
          const SizedBox(height: 16),
          // Buscador
          Container(
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: l10n.buscarPais,
                hintStyle: const TextStyle(color: _muted),
                prefixIcon: const Icon(Icons.search, color: _muted, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 12),
          // Preview moneda seleccionada
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _accent.withValues(alpha: 0.3)),
            ),
            child: Text(
              '${l10n.tuMonedaSera} ${seleccionado.simbolo} ${seleccionado.moneda}  •  ${seleccionado.emoji} ${seleccionado.nombre}',
              style: const TextStyle(color: _accent, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final pais = _filtered[i];
                final activo = pais.code == seleccionado.code;
                return GestureDetector(
                  onTap: () => localeProvider.setPais(pais),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: activo ? _accent.withValues(alpha: 0.1) : _card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: activo ? _accent : _border),
                    ),
                    child: Row(
                      children: [
                        Text(pais.emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            pais.nombre,
                            style: TextStyle(
                              color: activo ? _accent : Colors.white,
                              fontWeight: activo ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(pais.moneda, style: TextStyle(color: activo ? _accent : _muted, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: widget.onNext,
              child: Text(l10n.continuar, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Página 3: Modo ───────────────────────────────────────────────────────────

class _PageModo extends StatefulWidget {
  const _PageModo({required this.onNext});

  final VoidCallback onNext;

  @override
  State<_PageModo> createState() => _PageModoState();
}

class _PageModoState extends State<_PageModo> {
  String? _modo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.comoUsarasKash, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 32),
          _ModoCard(
            icono: Icons.person_outline,
            titulo: l10n.modoPersonal,
            descripcion: l10n.modoPersonalDesc,
            seleccionado: _modo == 'personal',
            onTap: () => setState(() => _modo = 'personal'),
          ),
          const SizedBox(height: 12),
          _ModoCard(
            icono: Icons.business_outlined,
            titulo: l10n.modoEmpresa,
            descripcion: l10n.modoEmpresaDesc,
            seleccionado: _modo == 'empresa',
            onTap: () => setState(() => _modo = 'empresa'),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _modo != null ? _accent : _border,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _modo == null
                  ? null
                  : () async {
                      await context.read<AjustesProvider>().setModoApp(_modo!);
                      widget.onNext();
                    },
              child: Text(l10n.empezar, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModoCard extends StatelessWidget {
  const _ModoCard({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.seleccionado,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: seleccionado ? _accent.withValues(alpha: 0.1) : _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: seleccionado ? _accent : _border,
            width: seleccionado ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icono, color: seleccionado ? _accent : Colors.white, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: TextStyle(color: seleccionado ? _accent : Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(descripcion, style: const TextStyle(color: _muted, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Página 4: Seguridad ──────────────────────────────────────────────────────

class _PageSeguridad extends StatefulWidget {
  const _PageSeguridad({required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<_PageSeguridad> createState() => _PageSeguridadState();
}

class _PageSeguridadState extends State<_PageSeguridad> with TickerProviderStateMixin {
  bool _biometricAvailable = false;
  bool _biometricEnabled = true;

  // PIN setup
  int _pinStep = 0; // 0=idle, 1=nuevo, 2=confirmar
  final List<int> _input = [];
  String? _newPin;
  String _pinError = '';
  bool _pinGuardado = false;

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(_shakeCtrl);
    _checkBiometric();
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkBiometric() async {
    final ok = await AuthService.biometricAvailable;
    if (mounted) setState(() => _biometricAvailable = ok);
  }

  void _onKey(String key) {
    if (_pinGuardado) return;
    if (key == '⌫') {
      if (_input.isNotEmpty) setState(() { _input.removeLast(); _pinError = ''; });
      return;
    }
    if (_input.length >= 6) return;
    setState(() { _input.add(int.parse(key)); _pinError = ''; });
    if (_input.length == 6) _advance();
  }

  Future<void> _advance() async {
    final pinStr = _input.join();
    if (_pinStep == 1) {
      setState(() { _newPin = pinStr; _input.clear(); _pinStep = 2; });
      return;
    }
    if (_pinStep == 2) {
      if (pinStr == _newPin) {
        await AuthService.savePin(_newPin!);
        setState(() { _pinGuardado = true; _pinError = ''; });
      } else {
        final l10n = AppLocalizations.of(context)!;
        setState(() { _input.clear(); _pinError = l10n.pinesNoCoinciden; });
        _shakeCtrl.forward(from: 0);
      }
    }
  }

  Future<void> _finalizar() async {
    final ajustes = context.read<AjustesProvider>();
    await ajustes.completarOnboarding();
    widget.onComplete();
  }

  String get _pinTitle {
    final l10n = AppLocalizations.of(context)!;
    if (_pinGuardado) return l10n.pinGuardadoCheck;
    if (_pinStep == 2) return l10n.confirmarPin;
    return l10n.nuevoPin;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mostrarTeclado = _pinStep > 0 && !_pinGuardado;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.protegeApp, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(l10n.soloTuPodras, style: const TextStyle(color: _muted, fontSize: 13)),
                const SizedBox(height: 28),
                if (_biometricAvailable) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _card, borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.fingerprint, color: _accent, size: 28),
                        const SizedBox(width: 12),
                        Expanded(child: Text(l10n.activarHuella, style: const TextStyle(color: Colors.white))),
                        Switch(
                          value: _biometricEnabled,
                          activeThumbColor: Colors.black,
                          activeTrackColor: _accent,
                          onChanged: (v) => setState(() => _biometricEnabled = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // PIN setup
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _card, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _pinGuardado ? _accent : _border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lock_outline, color: _accent, size: 22),
                          const SizedBox(width: 10),
                          Text(l10n.crearPin, style: const TextStyle(color: Colors.white)),
                          const Spacer(),
                          if (_pinStep == 0 && !_pinGuardado)
                            GestureDetector(
                              onTap: () => setState(() { _pinStep = 1; _input.clear(); }),
                              child: Text(l10n.crear, style: const TextStyle(color: _accent, fontWeight: FontWeight.w600)),
                            ),
                        ],
                      ),
                      if (mostrarTeclado) ...[
                        const SizedBox(height: 16),
                        Text(_pinTitle, style: const TextStyle(color: _muted, fontSize: 12)),
                        const SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: _shakeAnim,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(_shakeAnim.value, 0), child: child,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (i) {
                              final filled = i < _input.length;
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                width: 14, height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: filled ? _accent : Colors.transparent,
                                  border: filled ? null : Border.all(color: _border, width: 1.5),
                                ),
                              );
                            }),
                          ),
                        ),
                        if (_pinError.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Center(child: Text(_pinError, style: const TextStyle(color: Colors.red, fontSize: 12))),
                        ],
                      ],
                      if (_pinGuardado)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('✓ PIN configurado', style: TextStyle(color: _accent, fontSize: 12)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (mostrarTeclado)
          _MiniKeypad(onKey: _onKey)
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _finalizar,
                    child: Text(l10n.finalizarConfig, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _finalizar,
                  child: Text(l10n.ahoraNO, style: const TextStyle(color: _muted)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MiniKeypad extends StatelessWidget {
  const _MiniKeypad({required this.onKey});

  final ValueChanged<String> onKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        children: [
          _keyRow(['1', '2', '3']),
          const SizedBox(height: 8),
          _keyRow(['4', '5', '6']),
          const SizedBox(height: 8),
          _keyRow(['7', '8', '9']),
          const SizedBox(height: 8),
          _keyRow(['', '0', '⌫']),
        ],
      ),
    );
  }

  Widget _keyRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((k) {
        if (k.isEmpty) return const SizedBox(width: 88, height: 48);
        return GestureDetector(
          onTap: () => onKey(k),
          child: Container(
            width: 88, height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF222222),
              borderRadius: BorderRadius.circular(10),
            ),
            child: k == '⌫'
                ? const Icon(Icons.backspace_outlined, color: Color(0xFFAAAAAA), size: 18)
                : Text(k, style: const TextStyle(color: Colors.white, fontSize: 20)),
          ),
        );
      }).toList(),
    );
  }
}
