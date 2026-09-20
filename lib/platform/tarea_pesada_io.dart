import 'dart:async';
import 'dart:isolate';

Future<T> ejecutarTareaPesada<T>(FutureOr<T> Function() tarea) =>
    Isolate.run(tarea);
