import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/auth_service.dart';

// ─── Colores fijos (pantalla siempre oscura) ──────────────────────────────────
const _bg        = Color(0xFF111111);
const _bgKeypad  = Color(0xFF1A1A1A);
const _keyBg     = Color(0xFF222222);
const _accent    = Color(0xFFAAFF00);
const _subTitle  = Color(0xFF555555);
const _hint      = Color(0xFFAAAAAA);
const _dotEmpty  = Color(0xFF2A2A2A);
const _errorRed  = Color(0xFFFF4D4D);

class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.onUnlocked});

  final VoidCallback onUnlocked;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> with TickerProviderStateMixin {
  final List<int> _pin = [];
  String _errorText = '';
  int _lockSeconds = 0;
  Timer? _lockTimer;
  bool _checking = false;

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: 0.0), weight: 1),
    ]).animate(_shakeCtrl);

    // Auto-intentar biometría al abrir
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());

    // Revisar si ya está bloqueado por intentos fallidos
    _checkInitialLock();
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    _lockTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkInitialLock() async {
    final result = await AuthService.verifyPin('__probe__check__');
    if (result.locked && result.lockedSeconds != null) {
      _startLockTimer(result.lockedSeconds!);
    }
  }

  Future<void> _tryBiometric() async {
    final ok = await AuthService.authenticateWithBiometrics();
    if (ok && mounted) widget.onUnlocked();
  }

  void _startLockTimer(int seconds) {
    setState(() => _lockSeconds = seconds);
    _lockTimer?.cancel();
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_lockSeconds <= 1) {
        t.cancel();
        setState(() { _lockSeconds = 0; _errorText = ''; });
      } else {
        setState(() => _lockSeconds--);
      }
    });
  }

  void _onKey(String key) {
    if (_lockSeconds > 0 || _checking) return;
    if (key == '⌫') {
      if (_pin.isNotEmpty) setState(() { _pin.removeLast(); _errorText = ''; });
      return;
    }
    if (_pin.length >= 6) return;
    setState(() { _pin.add(int.parse(key)); _errorText = ''; });
    if (_pin.length == 6) _verify();
  }

  Future<void> _verify() async {
    setState(() => _checking = true);
    final pinStr = _pin.join();
    final result = await AuthService.verifyPin(pinStr);
    if (!mounted) return;
    setState(() => _checking = false);

    if (result.ok) {
      HapticFeedback.lightImpact();
      widget.onUnlocked();
      return;
    }

    setState(() => _pin.clear());
    _shakeCtrl.forward(from: 0);

    if (result.locked) {
      _startLockTimer(result.lockedSeconds ?? 30);
      setState(() => _errorText = 'Bloqueado ${result.lockedSeconds}s');
    } else {
      setState(() => _errorText = 'PIN incorrecto');
      // Desaparece en 1.5s
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() => _errorText = '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Zona superior (logo + auth) ──────────────────────
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Kash',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tus finanzas, protegidas',
                    style: TextStyle(color: _subTitle, fontSize: 13),
                  ),
                  const SizedBox(height: 48),
                  GestureDetector(
                    onTap: _tryBiometric,
                    child: const Icon(Icons.fingerprint, color: _accent, size: 56),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Usar biometría',
                    style: TextStyle(color: _hint, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  const Text('o', style: TextStyle(color: _subTitle, fontSize: 14)),
                  const SizedBox(height: 20),
                  // ── PIN circles ────────────────────────────────
                  AnimatedBuilder(
                    animation: _shakeAnim,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(_shakeAnim.value, 0),
                      child: child,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (i) {
                        final filled = i < _pin.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filled ? _accent : Colors.transparent,
                            border: filled ? null : Border.all(color: _dotEmpty, width: 1.5),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Error / lockout text
                  SizedBox(
                    height: 18,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _lockSeconds > 0
                          ? Text(
                              'Bloqueado ${_lockSeconds}s',
                              key: const ValueKey('lock'),
                              style: const TextStyle(color: _errorRed, fontSize: 12),
                            )
                          : _errorText.isNotEmpty
                              ? Text(
                                  _errorText,
                                  key: ValueKey(_errorText),
                                  style: const TextStyle(color: _errorRed, fontSize: 12),
                                )
                              : const SizedBox(key: ValueKey('empty')),
                    ),
                  ),
                ],
              ),
            ),
            // ── Teclado numérico ─────────────────────────────────
            Container(
              color: _bgKeypad,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                children: [
                  _keyRow(['1', '2', '3']),
                  const SizedBox(height: 12),
                  _keyRow(['4', '5', '6']),
                  const SizedBox(height: 12),
                  _keyRow(['7', '8', '9']),
                  const SizedBox(height: 12),
                  _keyRow(['', '0', '⌫']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _keyRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((k) => _Key(label: k, onTap: _onKey)).toList(),
    );
  }
}

// ─── Tecla individual ─────────────────────────────────────────────────────────

class _Key extends StatelessWidget {
  const _Key({required this.label, required this.onTap});

  final String label;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox(width: 88, height: 62);

    final isBackspace = label == '⌫';
    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        width: 88,
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _keyBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: isBackspace
            ? const Icon(Icons.backspace_outlined, color: _hint, size: 22)
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
