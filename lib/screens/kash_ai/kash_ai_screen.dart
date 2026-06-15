import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/database_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../models/movimiento.dart';
import '../../providers/ajustes_provider.dart';
import '../../providers/categorias_provider.dart';
import '../../providers/cuentas_provider.dart';
import '../../providers/kash_ai_provider.dart';
import '../../services/kash_ai_service.dart';
import '../../theme/app_colors.dart';
import '../paywall_screen.dart';

List<String> _sugerencias(AppLocalizations l10n) => [
      l10n.sugerenciaAhorro,
      l10n.sugerenciaGastoMayor,
      l10n.sugerenciaQuePasaSi,
      l10n.sugerenciaAnalizaMes,
    ];

/// Pantalla de chat con el asistente financiero "Kash AI".
class KashAiScreen extends StatefulWidget {
  const KashAiScreen({super.key, this.montoSeleccionado});

  /// Importe de un movimiento concreto sobre el que el usuario quiere
  /// preguntar (opcional).
  final double? montoSeleccionado;

  @override
  State<KashAiScreen> createState() => _KashAiScreenState();
}

class _KashAiScreenState extends State<KashAiScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool? _tieneApiKey;

  @override
  void initState() {
    super.initState();
    KashAiService.tieneApiKey().then((tiene) {
      if (mounted) setState(() => _tieneApiKey = tiene);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollAbajo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<String> _construirSystemPrompt() async {
    final ajustes = context.read<AjustesProvider>();
    final cuentas = context.read<CuentasProvider>();
    final categorias = context.read<CategoriasProvider>();
    final db = DatabaseHelper.instance;

    final ahora = DateTime.now();
    final inicioMes = DateTime(ahora.year, ahora.month, 1);
    final finMes = DateTime(ahora.year, ahora.month + 1, 1)
        .subtract(const Duration(milliseconds: 1));

    final gastadoMes = await db.sumaPorTipo(
      modo: ajustes.modoApp,
      tipo: TipoMovimiento.gasto,
      desde: inicioMes,
      hasta: finMes,
    );
    final ingresadoMes = await db.sumaPorTipo(
      modo: ajustes.modoApp,
      tipo: TipoMovimiento.ingreso,
      desde: inicioMes,
      hasta: finMes,
    );
    final filasCategoria = await db.totalesPorCategoria(
      modo: ajustes.modoApp,
      tipo: TipoMovimiento.gasto,
      desde: inicioMes,
      hasta: finMes,
    );

    final topCategorias = filasCategoria.take(3).map((fila) {
      final categoria = categorias.categoriaPorId(fila['categoria_id'] as int?);
      final total = (fila['total'] as num).toDouble();
      return (nombre: categoria.nombre, total: total);
    }).toList();

    return KashAiService.buildSystemPrompt(
      saldoTotal: cuentas.patrimonioTotal,
      gastadoMes: gastadoMes,
      ingresadoMes: ingresadoMes,
      topCategorias: topCategorias,
      montoSeleccionado: widget.montoSeleccionado,
      moneda: ajustes.moneda,
    );
  }

  Future<void> _enviar(String texto) async {
    final mensaje = texto.trim();
    if (mensaje.isEmpty) return;

    final ajustes = context.read<AjustesProvider>();
    final permitido = await ajustes.registrarConsultaKashAi();
    if (!permitido) {
      if (mounted) mostrarPaywallPro(context);
      return;
    }

    _controller.clear();
    final systemPrompt = await _construirSystemPrompt();
    if (!mounted) return;

    await context.read<KashAiProvider>().enviar(
          systemPrompt: systemPrompt,
          texto: mensaje,
        );
    _scrollAbajo();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KashAiProvider>();
    final ajustes = context.watch<AjustesProvider>();
    final mensajes = provider.mensajes;

    if (mensajes.isNotEmpty || provider.enviando) _scrollAbajo();

    return Scaffold(
      backgroundColor: AppColorsDark.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              consultasRestantes: ajustes.kashAiConsultasRestantes,
              onClose: () => Navigator.of(context).pop(),
            ),
            if (_tieneApiKey == false) const _AvisoSinApiKey(),
            Expanded(
              child: mensajes.isEmpty
                  ? const _EstadoVacio()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      itemCount: mensajes.length + (provider.enviando ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (i == mensajes.length) {
                          return const _TypingBubble();
                        }
                        final m = mensajes[i];
                        return _ChatBubble(mensaje: m);
                      },
                    ),
            ),
            _SugerenciasRow(onSeleccionar: _enviar),
            _InputBar(controller: _controller, onEnviar: _enviar),
          ],
        ),
      ),
    );
  }
}

// ─── Cabecera ───────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.consultasRestantes, required this.onClose});

  final int consultasRestantes;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.kashAiTitleSparkle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColorsDark.textPrimary,
              ),
            ),
          ),
          Text(
            consultasRestantes > 0
                ? l10n.consultasEsteMes(consultasRestantes)
                : l10n.limiteMensualAlcanzado,
            style: TextStyle(
              fontSize: 11,
              color: consultasRestantes > 0
                  ? AppColorsDark.textTertiary
                  : AppColorsDark.negative,
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: AppColorsDark.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _AvisoSinApiKey extends StatelessWidget {
  const _AvisoSinApiKey();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColorsDark.accentDim,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColorsDark.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.kashAiSinApiKey,
              style: const TextStyle(fontSize: 12, color: AppColorsDark.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Estado vacío ─────────────────────────────────────────────────────────────

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✨', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 16),
            Text(
              l10n.kashAiEmptyState,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColorsDark.textPrimary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Burbujas de chat ───────────────────────────────────────────────────────

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.mensaje});

  final KashAiMessage mensaje;

  @override
  Widget build(BuildContext context) {
    final esUsuario = mensaje.role == 'user';
    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: esUsuario ? AppColorsDark.accent : AppColorsDark.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          mensaje.content,
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: esUsuario ? AppColorsDark.background : AppColorsDark.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Burbuja con el indicador de "escribiendo" (3 puntos animados).
class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppColorsDark.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final t = (_controller.value - i * 0.2) % 1.0;
                final scale = 0.6 + 0.4 * (0.5 - (t - 0.5).abs()) * 2;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Transform.scale(
                    scale: scale.clamp(0.6, 1.0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColorsDark.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

// ─── Sugerencias rápidas ────────────────────────────────────────────────────

class _SugerenciasRow extends StatelessWidget {
  const _SugerenciasRow({required this.onSeleccionar});

  final ValueChanged<String> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    final sugerencias = _sugerencias(AppLocalizations.of(context)!);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: sugerencias.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final texto = sugerencias[i];
          return GestureDetector(
            onTap: () => onSeleccionar(texto),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColorsDark.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColorsDark.border),
              ),
              child: Text(
                texto,
                style: const TextStyle(fontSize: 12, color: AppColorsDark.textSecondary),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Barra de entrada ───────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onEnviar});

  final TextEditingController controller;
  final ValueChanged<String> onEnviar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: AppColorsDark.textPrimary, fontSize: 14),
              textInputAction: TextInputAction.send,
              onSubmitted: onEnviar,
              decoration: InputDecoration(
                hintText: l10n.preguntaKashAiHint,
                hintStyle: const TextStyle(color: AppColorsDark.textTertiary, fontSize: 14),
                filled: true,
                fillColor: AppColorsDark.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: AppColorsDark.accent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => onEnviar(controller.text),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.arrow_upward, color: AppColorsDark.background, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
