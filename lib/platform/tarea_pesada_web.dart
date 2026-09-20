import 'dart:async';

Future<T> ejecutarTareaPesada<T>(FutureOr<T> Function() tarea) async => tarea();
