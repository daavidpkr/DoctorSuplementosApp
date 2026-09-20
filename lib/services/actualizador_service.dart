import 'actualizador_service_stub.dart'
    if (dart.library.io) 'actualizador_service_io.dart' as plataforma;

typedef ProgresoDescarga = void Function(double progreso);

class ActualizadorService {
  final plataforma.ActualizadorServicePlataforma _plataforma =
      plataforma.ActualizadorServicePlataforma();

  Future<void> descargarEInstalar(
    String url,
    ProgresoDescarga onProgress,
  ) =>
      _plataforma.descargarEInstalar(url, onProgress);
}

class ActualizacionException implements Exception {
  const ActualizacionException(this.message);

  final String message;

  @override
  String toString() => message;
}
