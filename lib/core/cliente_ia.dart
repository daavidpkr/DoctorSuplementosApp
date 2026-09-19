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
  static const String workerPredeterminado =
      'https://doctor-suplementos-gemini-proxy.octor-uplementos.workers.dev';
  static const String _workerConfigurado = String.fromEnvironment(
    'GEMINI_PROXY_URL',
    defaultValue: workerPredeterminado,
  );
  static const Set<String> _hostsProxyAutorizados = {
    'doctor-suplementos-gemini-proxy.octor-uplementos.workers.dev',
    'localhost',
    '127.0.0.1',
  };
  static const int _maximoBytesPrompt = 60000;
  static const int maximoAdjuntos = 5;
  static const int maximoBytesPorAdjunto = 8 * 1024 * 1024;
  static const int maximoBytesAdjuntos = 12 * 1024 * 1024;
  static const Set<String> _mimeAdmitidos = {
    'image/jpeg',
    'image/png',
    'image/webp',
    'application/pdf',
    'audio/mp4',
  };

  static Future<String> generarTexto(
    String prompt, {
    List<ArchivoAdjuntoIA> adjuntos = const [],
    Dio? clienteHttp,
    Future<String?> Function()? obtenerToken,
    String? urlProxy,
  }) async {
    try {
      final bytesPrompt = utf8.encode(prompt).length;
      if (prompt.trim().isEmpty || bytesPrompt > _maximoBytesPrompt) {
        throw const IaProxyException('PAYLOAD_INVALIDO', estadoHttp: 400);
      }
      _validarAdjuntos(adjuntos);

      final uri = resolverEndpoint(urlProxy: urlProxy);

      final tokenProvider = obtenerToken ?? _obtenerFirebaseIdToken;
      final token = (await tokenProvider())?.trim() ?? '';
      if (token.isEmpty) {
        throw const IaProxyException('AUTENTICACION_REQUERIDA',
            estadoHttp: 401);
      }

      final dio = clienteHttp ??
          Dio(BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 60),
          ));
      final response = await dio.postUri<Map<String, dynamic>>(
        uri,
        data: {
          'prompt': prompt,
          if (adjuntos.isNotEmpty)
            'attachments': [
              for (final adjunto in adjuntos)
                {
                  'mimeType': adjunto.mimeType,
                  'data': base64Encode(adjunto.bytes),
                },
            ],
        },
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
    } catch (_) {
      throw const IaProxyException('ERROR_CLIENTE');
    }
  }

  static Uri resolverEndpoint({String? urlProxy}) {
    final valor = (urlProxy ?? _workerConfigurado).trim();
    final uri = Uri.tryParse(valor);
    if (valor.isEmpty ||
        uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        !_hostsProxyAutorizados.contains(uri.host.toLowerCase()) ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        (uri.host ==
                'doctor-suplementos-gemini-proxy.octor-uplementos.workers.dev' &&
            uri.hasPort &&
            uri.port != 443) ||
        (uri.path.isNotEmpty &&
            uri.path != '/' &&
            uri.path != '/v1/generate')) {
      throw const IaProxyException('PROXY_NO_CONFIGURADO');
    }
    return uri.replace(path: '/v1/generate');
  }

  static void _validarAdjuntos(List<ArchivoAdjuntoIA> adjuntos) {
    if (adjuntos.length > maximoAdjuntos) {
      throw const IaProxyException('DEMASIADOS_ADJUNTOS', estadoHttp: 400);
    }
    var total = 0;
    for (final adjunto in adjuntos) {
      if (!_mimeAdmitidos.contains(adjunto.mimeType)) {
        throw const IaProxyException('MIME_NO_ADMITIDO', estadoHttp: 415);
      }
      final cantidad = adjunto.bytes.length;
      if (cantidad == 0 || cantidad > maximoBytesPorAdjunto) {
        throw const IaProxyException(
          'ADJUNTO_DEMASIADO_GRANDE',
          estadoHttp: 413,
        );
      }
      if (!_firmaCoincide(adjunto.mimeType, adjunto.bytes)) {
        throw const IaProxyException('MIME_NO_COINCIDE', estadoHttp: 415);
      }
      total += cantidad;
      if (total > maximoBytesAdjuntos) {
        throw const IaProxyException(
          'ADJUNTOS_DEMASIADO_GRANDES',
          estadoHttp: 413,
        );
      }
    }
  }

  static bool _firmaCoincide(String mimeType, Uint8List bytes) {
    // Comparaciones directas para no interpretar ni conservar el contenido.
    bool coincideEn(int inicio, List<int> firma) {
      if (bytes.length < inicio + firma.length) return false;
      for (var i = 0; i < firma.length; i++) {
        if (bytes[inicio + i] != firma[i]) return false;
      }
      return true;
    }

    return switch (mimeType) {
      'image/jpeg' => coincideEn(0, const [0xFF, 0xD8, 0xFF]),
      'image/png' => coincideEn(0, const [
          0x89,
          0x50,
          0x4E,
          0x47,
          0x0D,
          0x0A,
          0x1A,
          0x0A,
        ]),
      'image/webp' => coincideEn(0, const [0x52, 0x49, 0x46, 0x46]) &&
          coincideEn(8, const [0x57, 0x45, 0x42, 0x50]),
      'application/pdf' => coincideEn(0, const [0x25, 0x50, 0x44, 0x46, 0x2D]),
      'audio/mp4' => coincideEn(4, const [0x66, 0x74, 0x79, 0x70]),
      _ => false,
    };
  }

  static Future<String?> _obtenerFirebaseIdToken() async {
    final usuario =
        await AutenticacionFirebaseService.autenticarSilenciosamente();
    return usuario?.getIdToken();
  }
}
