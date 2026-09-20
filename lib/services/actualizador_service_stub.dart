import 'actualizador_service.dart';

class ActualizadorServicePlataforma {
  Future<void> descargarEInstalar(
    String url,
    ProgresoDescarga onProgress,
  ) async {
    throw const ActualizacionException(
      'La instalación directa solo está disponible en Android.',
    );
  }
}
