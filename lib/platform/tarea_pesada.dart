import 'dart:async';

import 'tarea_pesada_web.dart' if (dart.library.io) 'tarea_pesada_io.dart'
    as plataforma;

Future<T> ejecutarTareaPesada<T>(FutureOr<T> Function() tarea) =>
    plataforma.ejecutarTareaPesada(tarea);
