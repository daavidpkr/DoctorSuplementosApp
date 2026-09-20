import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'archivo_plataforma_tipos.dart';

Future<String> crearRutaTemporal(String nombre) async => nombre;

Future<Uint8List> leerYEliminarArchivoTemporal(String ruta) async {
  try {
    final respuesta = await web.window
        .fetch(ruta.toJS)
        .toDart
        .timeout(const Duration(seconds: 15));
    if (!respuesta.ok) {
      throw StateError('No se pudo leer la grabación del navegador.');
    }
    final buffer = await respuesta
        .arrayBuffer()
        .toDart
        .timeout(const Duration(seconds: 15));
    return buffer.toDart.asUint8List();
  } finally {
    if (ruta.startsWith('blob:')) web.URL.revokeObjectURL(ruta);
  }
}

Future<ResultadoCompartirArchivo> compartirArchivoBytes({
  required Uint8List bytes,
  required String nombre,
  required String mimeType,
  String? asunto,
  String? texto,
}) async {
  final archivo = web.File(
    [bytes.buffer.toJS].toJS,
    nombre,
    web.FilePropertyBag(type: mimeType),
  );
  final datos = web.ShareData(
    files: [archivo].toJS,
    title: asunto ?? '',
    text: texto ?? '',
  );

  try {
    if (web.window.navigator.canShare(datos)) {
      try {
        await web.window.navigator
            .share(datos)
            .toDart
            .timeout(const Duration(seconds: 30));
        return ResultadoCompartirArchivo.compartido;
      } catch (error) {
        if (error.toString().contains('AbortError')) {
          return ResultadoCompartirArchivo.cancelado;
        }
      }
    }
  } catch (_) {
    // El navegador no implementa Web Share; se descarga abajo.
  }

  final blob = web.Blob(
    [bytes.buffer.toJS].toJS,
    web.BlobPropertyBag(type: mimeType),
  );
  final url = web.URL.createObjectURL(blob);
  try {
    final enlace = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = url
      ..download = nombre
      ..style.display = 'none';
    web.document.body?.append(enlace);
    enlace.click();
    enlace.remove();
    await Future<void>.delayed(Duration.zero);
    return ResultadoCompartirArchivo.descargado;
  } finally {
    web.URL.revokeObjectURL(url);
  }
}

Future<void> reproducirAudioBytes(Uint8List bytes, String mimeType) async {
  final blob = web.Blob(
    [bytes.buffer.toJS].toJS,
    web.BlobPropertyBag(type: mimeType),
  );
  final url = web.URL.createObjectURL(blob);
  final audio = web.document.createElement('audio') as web.HTMLAudioElement
    ..src = url
    ..style.display = 'none';
  web.document.body?.append(audio);

  var liberado = false;
  void limpiar() {
    if (liberado) return;
    liberado = true;
    audio.remove();
    web.URL.revokeObjectURL(url);
  }

  audio.onEnded.listen((_) => limpiar());
  audio.onError.listen((_) => limpiar());
  try {
    await audio.play().toDart.timeout(const Duration(seconds: 10));
  } catch (_) {
    limpiar();
    rethrow;
  }
}
