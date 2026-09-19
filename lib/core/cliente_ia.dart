part of '../main.dart';

class IaProxyException implements Exception {
  final String codigo;
  final int? estadoHttp;

  const IaProxyException(this.codigo, {this.estadoHttp});

  bool get esTransitorio =>
      estadoHttp == 429 ||
      estadoHttp == 502 ||
      estadoHttp == 503 ||
      estadoHttp == 504;

  @override
  String toString() => 'IaProxyException($codigo, $estadoHttp)';
}

class ClienteIa {
  static const String modelo = 'gemini-3.1-flash-lite';
  static const String _urlProxy = String.fromEnvironment('IA_PROXY_URL');
  static const int _maximoBytesPrompt = 60000;

  static Future<String> generarTexto(
    String prompt, {
    List<Content>? contenidoNativo,
    Dio? clienteHttp,
    Future<String?> Function()? obtenerToken,
    String? urlProxy,
    bool? usarProxy,
  }) async {
    try {
      final usarProxyWeb = usarProxy ?? kIsWeb;
      if (!usarProxyWeb) {
        final model = GenerativeModel(model: modelo, apiKey: geminiApiKey);
        final response = await model.generateContent(
          contenidoNativo ?? [Content.text(prompt)],
        );
        return response.text ?? '';
      }

      if (contenidoNativo != null) {
        throw const IaProxyException('ADJUNTOS_NO_ADMITIDOS', estadoHttp: 400);
      }
      final bytesPrompt = utf8.encode(prompt).length;
      if (prompt.trim().isEmpty || bytesPrompt > _maximoBytesPrompt) {
        throw const IaProxyException('PAYLOAD_INVALIDO', estadoHttp: 400);
      }

      final endpoint = (urlProxy ?? _urlProxy).trim();
      final uri = Uri.tryParse(endpoint);
      final origenLocal = uri != null &&
          (uri.host == 'localhost' || uri.host == '127.0.0.1');
      if (uri == null ||
          !uri.hasScheme ||
          (!origenLocal && uri.scheme != 'https') ||
          (origenLocal && uri.scheme != 'http' && uri.scheme != 'https')) {
        throw const IaProxyException('PROXY_NO_CONFIGURADO');
      }

      final tokenProvider = obtenerToken ?? _obtenerFirebaseIdToken;
      final token = (await tokenProvider())?.trim() ?? '';
      if (token.isEmpty) {
        throw const IaProxyException('AUTENTICACION_REQUERIDA', estadoHttp: 401);
      }

      final dio = clienteHttp ??
          Dio(BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 60),
          ));
      final response = await dio.postUri<Map<String, dynamic>>(
        uri,
        data: {'prompt': prompt},
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      final data = response.data;
      if (response.statusCode == 200) {
        final texto = data?['text'];
        if (texto is String && texto.trim().isNotEmpty) return texto;
        throw const RespuestaIaVaciaException();
      }
      final error = data?['error'];
      final codigo = error is Map ? error['code']?.toString() : null;
      throw IaProxyException(
        codigo?.trim().isNotEmpty == true ? codigo! : 'ERROR_PROXY',
        estadoHttp: response.statusCode,
      );
    } on IaProxyException {
      rethrow;
    } on RespuestaIaVaciaException {
      rethrow;
    } on DioException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } on GenerativeAIException {
      rethrow;
    } catch (_) {
      throw const IaProxyException('ERROR_CLIENTE');
    }
  }

  static Future<String?> _obtenerFirebaseIdToken() async {
    final usuario =
        await AutenticacionFirebaseService.autenticarSilenciosamente();
    return usuario?.getIdToken();
  }
}
