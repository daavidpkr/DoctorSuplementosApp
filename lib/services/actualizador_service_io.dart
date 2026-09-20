import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'actualizador_service.dart';

class ActualizadorServicePlataforma {
  final Dio _dio = Dio();

  Future<void> descargarEInstalar(
    String url,
    ProgresoDescarga onProgress,
  ) async {
    if (!Platform.isAndroid) {
      throw const ActualizacionException(
        'La instalación directa solo está disponible en Android.',
      );
    }
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      throw const ActualizacionException(
        'El enlace de descarga configurado no es válido.',
      );
    }
    final permiso = await Permission.requestInstallPackages.request();
    if (!permiso.isGranted) {
      throw const ActualizacionException(
        'Autoriza a DoctorSuplementos para instalar aplicaciones y vuelve a intentarlo.',
      );
    }
    final directorio =
        await getExternalStorageDirectory() ?? await getTemporaryDirectory();
    final archivo = File('${directorio.path}/actualizacion.apk');
    if (await archivo.exists()) await archivo.delete();
    try {
      await _dio.download(
        uri.toString(),
        archivo.path,
        options: Options(
          followRedirects: true,
          receiveTimeout: const Duration(minutes: 5),
        ),
        onReceiveProgress: (recibidos, total) {
          if (total > 0) onProgress((recibidos / total).clamp(0.0, 1.0));
        },
      );
    } on DioException catch (error) {
      final codigo = error.response?.statusCode;
      throw ActualizacionException(codigo == null
          ? 'No se pudo descargar la actualización. Revisa tu conexión.'
          : 'No se pudo descargar la actualización (HTTP $codigo).');
    }
    if (!await archivo.exists() || await archivo.length() == 0) {
      throw const ActualizacionException(
        'La descarga no generó un archivo APK válido.',
      );
    }
    onProgress(1);
    final resultado = await OpenFile.open(
      archivo.path,
      type: 'application/vnd.android.package-archive',
    );
    if (resultado.type != ResultType.done) {
      throw ActualizacionException(resultado.message.isEmpty
          ? 'No se pudo abrir el instalador de Android.'
          : resultado.message);
    }
  }
}
