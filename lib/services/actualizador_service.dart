import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

typedef ProgresoDescarga = void Function(double progreso);

class ActualizadorService {
  ActualizadorService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<void> descargarEInstalar(
    String url,
    ProgresoDescarga onProgress,
  ) async {
    if (!Platform.isAndroid) {
      throw const ActualizacionException(
        'La instalacion directa solo esta disponible en Android.',
      );
    }

    final uri = Uri.tryParse(url);
    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      throw const ActualizacionException(
        'El enlace de descarga configurado no es valido.',
      );
    }

    final permisoInstalacion =
        await Permission.requestInstallPackages.request();
    if (!permisoInstalacion.isGranted) {
      throw const ActualizacionException(
        'Autoriza a DoctorSuplementos para instalar aplicaciones y vuelve a intentarlo.',
      );
    }

    final directorio =
        await getExternalStorageDirectory() ?? await getTemporaryDirectory();
    final archivo = File('${directorio.path}/actualizacion.apk');

    if (await archivo.exists()) {
      await archivo.delete();
    }

    try {
      await _dio.download(
        uri.toString(),
        archivo.path,
        options: Options(
          followRedirects: true,
          receiveTimeout: const Duration(minutes: 5),
        ),
        onReceiveProgress: (recibidos, total) {
          if (total <= 0) return;
          onProgress((recibidos / total).clamp(0.0, 1.0));
        },
      );
    } on DioException catch (error) {
      throw ActualizacionException(
        _mensajeDescarga(error),
      );
    }

    if (!await archivo.exists() || await archivo.length() == 0) {
      throw const ActualizacionException(
        'La descarga no genero un archivo APK valido.',
      );
    }

    onProgress(1);
    final resultado = await OpenFile.open(
      archivo.path,
      type: 'application/vnd.android.package-archive',
    );

    if (resultado.type != ResultType.done) {
      throw ActualizacionException(
        resultado.message.isEmpty
            ? 'No se pudo abrir el instalador de Android.'
            : resultado.message,
      );
    }
  }

  String _mensajeDescarga(DioException error) {
    final codigo = error.response?.statusCode;
    if (codigo != null) {
      return 'No se pudo descargar la actualizacion (HTTP $codigo).';
    }
    return 'No se pudo descargar la actualizacion. Revisa tu conexion.';
  }
}

class ActualizacionException implements Exception {
  const ActualizacionException(this.message);

  final String message;

  @override
  String toString() => message;
}
