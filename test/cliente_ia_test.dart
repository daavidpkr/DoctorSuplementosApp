import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_suplementos/main.dart';

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
      urlProxy: 'https://proxy.example/v1/generate',
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
        urlProxy: 'https://proxy.example/v1/generate',
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
        urlProxy: 'https://proxy.example/v1/generate',
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
      urlProxy: 'https://proxy.example/v1/generate',
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
        urlProxy: 'https://proxy.example/v1/generate',
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
        urlProxy: 'https://proxy.example/v1/generate',
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
}
