import 'dart:typed_data';

export 'archivo_plataforma_tipos.dart';

import 'archivo_plataforma_tipos.dart';
import 'archivo_plataforma_stub.dart'
    if (dart.library.io) 'archivo_plataforma_io.dart'
    if (dart.library.js_interop) 'archivo_plataforma_web.dart' as plataforma;

Future<String> crearRutaTemporal(String nombre) =>
    plataforma.crearRutaTemporal(nombre);

Future<Uint8List> leerYEliminarArchivoTemporal(String ruta) =>
    plataforma.leerYEliminarArchivoTemporal(ruta);

Future<ResultadoCompartirArchivo> compartirArchivoBytes({
  required Uint8List bytes,
  required String nombre,
  required String mimeType,
  String? asunto,
  String? texto,
}) =>
    plataforma.compartirArchivoBytes(
      bytes: bytes,
      nombre: nombre,
      mimeType: mimeType,
      asunto: asunto,
      texto: texto,
    );

Future<void> reproducirAudioBytes(Uint8List bytes, String mimeType) =>
    plataforma.reproducirAudioBytes(bytes, mimeType);
