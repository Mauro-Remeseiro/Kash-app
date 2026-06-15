import 'package:flutter/foundation.dart';

import '../services/kash_ai_service.dart';

/// Mantiene el historial de la conversación con Kash AI durante la sesión.
class KashAiProvider extends ChangeNotifier {
  final List<KashAiMessage> _mensajes = [];
  bool _enviando = false;

  List<KashAiMessage> get mensajes => List.unmodifiable(_mensajes);
  bool get enviando => _enviando;

  /// Envía [texto] como mensaje del usuario y añade la respuesta de Kash AI.
  Future<void> enviar({
    required String systemPrompt,
    required String texto,
  }) async {
    _mensajes.add(KashAiMessage(role: 'user', content: texto));
    _enviando = true;
    notifyListeners();

    try {
      final respuesta = await KashAiService.enviarMensaje(
        systemPrompt: systemPrompt,
        historial: _mensajes,
      );
      _mensajes.add(KashAiMessage(role: 'assistant', content: respuesta));
    } on KashAiException catch (e) {
      _mensajes.add(KashAiMessage(role: 'assistant', content: e.message));
    } catch (_) {
      _mensajes.add(const KashAiMessage(
        role: 'assistant',
        content: 'Ha ocurrido un error inesperado. Inténtalo de nuevo.',
      ));
    } finally {
      _enviando = false;
      notifyListeners();
    }
  }

  void limpiar() {
    _mensajes.clear();
    notifyListeners();
  }
}
