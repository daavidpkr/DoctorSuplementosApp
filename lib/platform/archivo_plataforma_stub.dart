import 'dart:typed_data';

import 'archivo_plataforma_tipos.dart';

Future<String> crearRutaTemporal(String nombre) async =>
    throw UnsupportedError('Plataforma no compatible.');

Future<Uint8List> leerYEliminarArchivoTemporal(String ruta) async =>
    throw UnsupportedError('Plataforma no compatible.');

Future<ResultadoCompartirArchivo> compartirArchivoBytes({
  required Uint8List bytes,
  required String nombre,
  required String mimeType,
  String? asunto,
  String? texto,
}) async =>
    throw UnsupportedError('Plataforma no compatible.');

Future<void> reproducirAudioBytes(Uint8List bytes, String mimeType) async =>
    throw UnsupportedError('Plataforma no compatible.');
