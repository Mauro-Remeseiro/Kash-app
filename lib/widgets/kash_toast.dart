import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/kash_colors.dart';

/// Muestra un toast de confirmación que entra desde abajo con
/// [SlideTransition] y se oculta automáticamente tras 2.5 segundos.
void mostrarKashToast(
  BuildContext context,
  String mensaje, {
  IconData icon = Icons.check_circle_outline,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _KashToast(
      mensaje: mensaje,
      icon: icon,
      onDismiss: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

class _KashToast extends StatefulWidget {
  const _KashToast({required this.mensaje, required this.icon, required this.onDismiss});

  final String mensaje;
  final IconData icon;
  final VoidCallback onDismiss;

  @override
  State<_KashToast> createState() => _KashToastState();
}

class _KashToastState extends State<_KashToast> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _offset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);

    return Positioned(
      left: 20,
      right: 20,
      bottom: 100,
      child: SlideTransition(
        position: _offset,
        child: FadeTransition(
          opacity: _opacity,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                border: Border.all(color: colors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(widget.mensaje, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
