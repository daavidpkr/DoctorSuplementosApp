import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_suplementos/main.dart';

const _proxyPrueba = 'https://localhost:8787/v1/generate';

class _AdaptadorPrueba implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) responder;

  _AdaptadorPrueba(this.responder);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) =>
      responder(options);

  @override
  void close({bool force = false}) {}
}

Dio _dioCon(
  Future<ResponseBody> Function(RequestOptions options) responder,
) {
  final dio = Dio();
  dio.httpClientAdapter = _AdaptadorPrueba(responder);
  return dio;
}

void main() {
  test('build sin dart-define usa el Worker de produccion', () {
    expect(
      ClienteIa.resolverEndpoint(),
      Uri.parse('${ClienteIa.workerPredeterminado}/v1/generate'),
    );
  });

  test('valor personalizado HTTPS y autorizado se acepta', () {
    expect(
      ClienteIa.resolverEndpoint(urlProxy: 'https://localhost:9443'),
      Uri.parse('https://localhost:9443/v1/generate'),
    );
    expect(
      ClienteIa.resolverEndpoint(
        urlProxy: '${ClienteIa.workerPredeterminado}/v1/generate',
      ),
      Uri.parse('${ClienteIa.workerPredeterminado}/v1/generate'),
    );
  });

  test('URL vacia, HTTP o host no autorizado se rechazan', () {
    for (final valor in [
      '',
      'http://localhost:8787',
      'http://doctor-suplementos-gemini-proxy.octor-uplementos.workers.dev',
      'https://proxy.example/v1/generate',
    ]) {
      expect(
        () => ClienteIa.resolverEndpoint(urlProxy: valor),
        throwsA(
          isA<IaProxyException>().having(
              (error) => error.codigo, 'codigo', 'PROXY_NO_CONFIGURADO'),
        ),
        reason: valor,
      );
    }
  });

  test('cliente proxy envia token y devuelve texto', () async {
    late RequestOptions solicitud;
    final dio = _dioCon((options) async {
      solicitud = options;
      return ResponseBody.fromString(
        jsonEncode({'text': 'Respuesta segura'}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    });

    final respuesta = await ClienteIa.generarTexto(
      'Prompt sin cambios',
      urlProxy: _proxyPrueba,
      obtenerToken: () async => 'firebase-id-token',
      clienteHttp: dio,
    );

    expect(respuesta, 'Respuesta segura');
    expect(solicitud.headers['Authorization'], 'Bearer firebase-id-token');
    expect(solicitud.data, {'prompt': 'Prompt sin cambios'});
  });

  test('cliente rechaza sesion ausente antes de llamar al proxy', () async {
    var llamado = false;
    final dio = _dioCon((_) async {
      llamado = true;
      return ResponseBody.fromString('{}', 500);
    });

    await expectLater(
      ClienteIa.generarTexto(
        'Prompt',
        urlProxy: _proxyPrueba,
        obtenerToken: () async => null,
        clienteHttp: dio,
      ),
      throwsA(
        isA<IaProxyException>().having(
            (error) => error.codigo, 'codigo', 'AUTENTICACION_REQUERIDA'),
      ),
    );
    expect(llamado, isFalse);
  });

  test('cliente conserva codigo HTTP sanitizado del Worker', () async {
    final dio = _dioCon((_) async => ResponseBody.fromString(
          jsonEncode({
            'error': {'code': 'TOKEN_INVALIDO', 'message': 'sanitizado'}
          }),
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ));

    await expectLater(
      ClienteIa.generarTexto(
        'Prompt',
        urlProxy: _proxyPrueba,
        obtenerToken: () async => 'token',
        clienteHttp: dio,
      ),
      throwsA(
        isA<IaProxyException>()
            .having((error) => error.codigo, 'codigo', 'TOKEN_INVALIDO')
            .having((error) => error.estadoHttp, 'estadoHttp', 401),
      ),
    );
  });

  test('cliente envia adjunto como Base64 solo al proxy', () async {
    late RequestOptions solicitud;
    final dio = _dioCon((options) async {
      solicitud = options;
      return ResponseBody.fromString(
        jsonEncode({'text': 'Adjunto procesado'}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType]
        },
      );
    });

    await ClienteIa.generarTexto(
      'Analiza',
      adjuntos: [
        ArchivoAdjuntoIA(
          nombre: 'informe.pdf',
          mimeType: 'application/pdf',
          bytes: Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]),
        ),
      ],
      urlProxy: _proxyPrueba,
      obtenerToken: () async => 'firebase-id-token',
      clienteHttp: dio,
    );

    expect(solicitud.data, {
      'prompt': 'Analiza',
      'attachments': [
        {'mimeType': 'application/pdf', 'data': 'JVBERi0='}
      ],
    });
  });

  test('cliente rechaza MIME y adjunto grande antes de llamar al proxy',
      () async {
    var llamadas = 0;
    final dio = _dioCon((_) async {
      llamadas++;
      return ResponseBody.fromString('{}', 500);
    });

    Future<void> ejecutar(String mime, Uint8List bytes) async {
      await ClienteIa.generarTexto(
        'Prompt',
        adjuntos: [
          ArchivoAdjuntoIA(nombre: 'archivo', mimeType: mime, bytes: bytes),
        ],
        urlProxy: _proxyPrueba,
        obtenerToken: () async => 'token',
        clienteHttp: dio,
      );
    }

    await expectLater(
      ejecutar('text/plain', Uint8List.fromList([1])),
      throwsA(isA<IaProxyException>().having(
        (error) => error.codigo,
        'codigo',
        'MIME_NO_ADMITIDO',
      )),
    );
    final pdfGrande = Uint8List(ClienteIa.maximoBytesPorAdjunto + 1)
      ..setAll(0, const [0x25, 0x50, 0x44, 0x46, 0x2D]);
    await expectLater(
      ejecutar(
        'application/pdf',
        pdfGrande,
      ),
      throwsA(isA<IaProxyException>().having(
        (error) => error.codigo,
        'codigo',
        'ADJUNTO_DEMASIADO_GRANDE',
      )),
    );
    expect(llamadas, 0);
  });

  test('selección por bytes acepta JPEG, PNG, WebP, PDF y WebM', () {
    final muestras = <String, Uint8List>{
      'foto.jpg': Uint8List.fromList([0xFF, 0xD8, 0xFF]),
      'foto.png': Uint8List.fromList(
        [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A],
      ),
      'foto.webp': Uint8List.fromList(
        [0x52, 0x49, 0x46, 0x46, 0, 0, 0, 0, 0x57, 0x45, 0x42, 0x50],
      ),
      'documento.pdf': Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]),
      'nota.webm': Uint8List.fromList([0x1A, 0x45, 0xDF, 0xA3]),
    };

    final adjuntos = muestras.entries
        .map((muestra) => crearAdjuntoIaValidado(
              nombre: muestra.key,
              bytes: muestra.value,
            ))
        .toList();

    expect(adjuntos.map((item) => item.mimeType), [
      'image/jpeg',
      'image/png',
      'image/webp',
      'application/pdf',
      'audio/webm',
    ]);
    expect(() => ClienteIa.validarAdjuntos(adjuntos), returnsNormally);
  });

  test('validación conserva límites de cantidad y total', () {
    final seisPdfs = List.generate(
      6,
      (indice) => ArchivoAdjuntoIA(
        nombre: '$indice.pdf',
        mimeType: 'application/pdf',
        bytes: Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]),
      ),
    );
    expect(
      () => ClienteIa.validarAdjuntos(seisPdfs),
      throwsA(isA<IaProxyException>().having(
        (error) => error.codigo,
        'codigo',
        'DEMASIADOS_ADJUNTOS',
      )),
    );

    final adjuntosGrandes = List.generate(
      2,
      (indice) => ArchivoAdjuntoIA(
        nombre: '$indice.pdf',
        mimeType: 'application/pdf',
        bytes: Uint8List(7 * 1024 * 1024)
          ..setAll(0, const [0x25, 0x50, 0x44, 0x46, 0x2D]),
      ),
    );
    expect(
      () => ClienteIa.validarAdjuntos(adjuntosGrandes),
      throwsA(isA<IaProxyException>().having(
        (error) => error.codigo,
        'codigo',
        'ADJUNTOS_DEMASIADO_GRANDES',
      )),
    );
  });

  test('timeout se propaga y produce mensaje util', () async {
    final dio = _dioCon((options) async {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.receiveTimeout,
      );
    });

    Object? error;
    try {
      await ClienteIa.generarTexto(
        'Prompt',
        urlProxy: _proxyPrueba,
        obtenerToken: () async => 'token',
        clienteHttp: dio,
      );
    } catch (caught) {
      error = caught;
    }

    expect(error, isA<DioException>());
    expect(mensajeErrorIa(error!), contains('conectar'));
  });

  test('respuesta 504 se considera transitoria y muestra mensaje util', () {
    const error = IaProxyException('GEMINI_TIMEOUT', estadoHttp: 504);
    expect(error.esTransitorio, isTrue);
    expect(mensajeErrorIa(error), contains('temporalmente ocupado'));
  });

  test('401, 403, 429 y 5xx producen mensajes utiles', () {
    expect(
      mensajeErrorIa(const IaProxyException('ERROR_PROXY', estadoHttp: 401)),
      contains('sesi'),
    );
    expect(
      mensajeErrorIa(const IaProxyException('ERROR_PROXY', estadoHttp: 403)),
      contains('autorizaci'),
    );
    expect(
      mensajeErrorIa(const IaProxyException('ERROR_PROXY', estadoHttp: 429)),
      contains('demasiadas solicitudes'),
    );
    for (final estado in [500, 501, 502, 503, 504, 599]) {
      final error = IaProxyException('ERROR_PROXY', estadoHttp: estado);
      expect(error.esTransitorio, isTrue, reason: 'HTTP $estado');
      expect(mensajeErrorIa(error), contains('temporalmente ocupado'));
    }
  });

  test('presupuesto total evita esperas acumuladas y cargas infinitas',
      () async {
    final pendiente = Completer<String>();
    final reloj = Stopwatch()..start();

    await expectLater(
      generarRespuestaIaConReintento(
        generar: (_) => pendiente.future,
        prompt: 'Prompt',
        tiempoMaximo: const Duration(milliseconds: 80),
      ),
      throwsA(isA<TimeoutException>()),
    );

    expect(reloj.elapsed, lessThan(const Duration(seconds: 1)));
  });

  test('cancelar corta la espera y no inicia un reintento', () async {
    final pendiente = Completer<String>();
    final control = ControlSolicitudIa();
    var intentos = 0;
    final solicitud = generarRespuestaIaConReintento(
      generar: (_) {
        intentos++;
        return pendiente.future;
      },
      prompt: 'Prompt',
      control: control,
    );

    control.cancelar();

    await expectLater(solicitud, throwsA(isA<SolicitudIaCanceladaException>()));
    expect(intentos, 1);
    expect(mensajeErrorIa(const SolicitudIaCanceladaException()),
        'Solicitud cancelada.');
  });
}
