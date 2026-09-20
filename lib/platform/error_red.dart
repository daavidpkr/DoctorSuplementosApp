import 'error_red_stub.dart' if (dart.library.io) 'error_red_io.dart'
    as plataforma;

bool esSocketException(Object error) => plataforma.esSocketException(error);
