import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'archivo_plataforma_tipos.dart';

Future<String> crearRutaTemporal(String nombre) async {
  final directorio = await getTemporaryDirectory();
  return '${directorio.path}${Platform.pathSeparator}$nombre';
}

Future<Uint8List> leerYEliminarArchivoTemporal(String ruta) async {
  final archivo = File(ruta);
  try {
    return await archivo.readAsBytes().timeout(const Duration(seconds: 15));
  } finally {
    if (await archivo.exists()) {
      await archivo.delete().catchError((_) => archivo);
    }
  }
}

Future<ResultadoCompartirArchivo> compartirArchivoBytes({
  required Uint8List bytes,
  required String nombre,
  required String mimeType,
  String? asunto,
  String? texto,
}) async {
  final resultado = await Share.shareXFiles(
    [XFile.fromData(bytes, mimeType: mimeType, name: nombre)],
    fileNameOverrides: [nombre],
    subject: asunto,
    text: texto,
  );
  return resultado.status == ShareResultStatus.dismissed
      ? ResultadoCompartirArchivo.cancelado
      : ResultadoCompartirArchivo.compartido;
}

Future<void> reproducirAudioBytes(Uint8List bytes, String mimeType) async {
  final extension = mimeType == 'audio/webm' ? 'webm' : 'm4a';
  final ruta = await crearRutaTemporal(
    'audio_${DateTime.now().microsecondsSinceEpoch}.$extension',
  );
  final archivo = File(ruta);
  await archivo.writeAsBytes(bytes, flush: true);
  final resultado = await OpenFile.open(ruta, type: mimeType);
  if (resultado.type != ResultType.done) {
    await archivo.delete().catchError((_) => archivo);
    throw StateError('No hay una aplicación compatible para reproducir audio.');
  }
  unawaited(Future<void>.delayed(const Duration(minutes: 5), () async {
    if (await archivo.exists()) {
      await archivo.delete().catchError((_) => archivo);
    }
  }));
}
