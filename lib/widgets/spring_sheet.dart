import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Envuelve el contenido de un [BottomSheet] con una animación de entrada
/// tipo "spring" (masa 1.0, stiffness 300, damping 28).
class SpringSheet extends StatefulWidget {
  const SpringSheet({super.key, required this.child});

  final Widget child;

  @override
  State<SpringSheet> createState() => _SpringSheetState();
}

class _SpringSheetState extends State<SpringSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.animateWith(
      SpringSimulation(const SpringDescription(mass: 1, stiffness: 300, damping: 28), 0, 1, 0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 24),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
