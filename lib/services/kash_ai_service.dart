import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// Un mensaje dentro de una conversación con Kash AI.
class KashAiMessage {
  const KashAiMessage({required this.role, required this.content});

  /// `'user'` o `'assistant'`.
  final String role;
  final String content;
}

/// Error controlado al hablar con Kash AI (clave no configurada, fallo de
/// red, respuesta inesperada de la API, etc.).
class KashAiException implements Exception {
  KashAiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Resumen de una categoría de gasto, usado para dar contexto a Kash AI.
typedef KashAiCategoria = ({String nombre, double total});

/// Cliente de la API de Anthropic (Claude) para el asistente "Kash AI".
///
/// La clave de API la introduce el propio usuario en Ajustes y se guarda
/// cifrada en el dispositivo con [FlutterSecureStorage]: nunca se incluye una
/// clave en el código fuente ni en el binario de la app.
class KashAiService {
  KashAiService._();

  static const _storage = FlutterSecureStorage();
  static const _apiKeyKey = 'kash_ai_api_key';

  static const String _endpoint = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-haiku-4-5-20251001';
  static const String _anthropicVersion = '2023-06-01';
  static const int _maxTokens = 512;

  /// Devuelve la clave de API guardada por el usuario, o `null` si no hay.
  static Future<String?> getApiKey() => _storage.read(key: _apiKeyKey);

  /// Indica si el usuario ya configuró su clave de API.
  static Future<bool> tieneApiKey() async {
    final clave = await getApiKey();
    return clave != null && clave.trim().isNotEmpty;
  }

  /// Guarda (o borra, si [apiKey] está vacía) la clave de API del usuario.
  static Future<void> setApiKey(String apiKey) async {
    final limpia = apiKey.trim();
    if (limpia.isEmpty) {
      await _storage.delete(key: _apiKeyKey);
    } else {
      await _storage.write(key: _apiKeyKey, value: limpia);
    }
  }

  /// Construye el prompt de sistema con el contexto financiero del usuario.
  static String buildSystemPrompt({
    required double saldoTotal,
    required double gastadoMes,
    required double ingresadoMes,
    required List<KashAiCategoria> topCategorias,
    double? montoSeleccionado,
    required String moneda,
  }) {
    final categoriasTexto = topCategorias.isEmpty
        ? '- (sin gastos registrados este mes)'
        : topCategorias
            .map((c) => '- ${c.nombre}: ${c.total.toStringAsFixed(2)} $moneda')
            .join('\n');

    final lineaSeleccion = montoSeleccionado != null
        ? '\nEl usuario está consultando sobre un movimiento de ${montoSeleccionado.toStringAsFixed(2)} $moneda.'
        : '';

    return '''
Eres Kash AI, el asistente financiero personal integrado en la app Kash.
Hablas en español, en un tono cercano, directo y sin tecnicismos innecesarios.
Tus respuestas son breves (2-4 frases o una lista corta) y siempre prácticas.
No inventes datos: usa únicamente la información financiera proporcionada.

Datos financieros del usuario:
- Saldo total: ${saldoTotal.toStringAsFixed(2)} $moneda
- Gastado este mes: ${gastadoMes.toStringAsFixed(2)} $moneda
- Ingresado este mes: ${ingresadoMes.toStringAsFixed(2)} $moneda
- Categorías con más gasto este mes:
$categoriasTexto$lineaSeleccion
''';
  }

  /// Envía el historial de la conversación a Claude y devuelve la respuesta.
  ///
  /// Lanza [KashAiException] si no hay clave configurada, si falla la red o
  /// si la API devuelve un error.
  static Future<String> enviarMensaje({
    required String systemPrompt,
    required List<KashAiMessage> historial,
  }) async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.trim().isEmpty) {
      throw KashAiException(
        'Configura tu clave de API de Anthropic en Ajustes › Kash AI para usar el asistente.',
      );
    }

    http.Response response;
    try {
      response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey.trim(),
          'anthropic-version': _anthropicVersion,
        },
        body: jsonEncode({
          'model': _model,
          'max_tokens': _maxTokens,
          'system': systemPrompt,
          'messages': historial
              .map((m) => {'role': m.role, 'content': m.content})
              .toList(),
        }),
      );
    } catch (_) {
      throw KashAiException('No se pudo conectar con Kash AI. Revisa tu conexión.');
    }

    if (response.statusCode == 401) {
      throw KashAiException('La clave de API no es válida. Revísala en Ajustes › Kash AI.');
    }
    if (response.statusCode != 200) {
      throw KashAiException('Kash AI no está disponible ahora (error ${response.statusCode}).');
    }

    final Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw KashAiException('Kash AI devolvió una respuesta inesperada.');
    }

    final bloques = data['content'];
    if (bloques is! List) {
      throw KashAiException('Kash AI devolvió una respuesta inesperada.');
    }

    final texto = bloques
        .whereType<Map<String, dynamic>>()
        .where((b) => b['type'] == 'text')
        .map((b) => b['text']?.toString() ?? '')
        .join()
        .trim();

    if (texto.isEmpty) {
      throw KashAiException('Kash AI no devolvió ninguna respuesta.');
    }

    return texto;
  }
}
