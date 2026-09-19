part of '../main.dart';

/// Mantiene Firestore cerrado hasta que Firebase Authentication entregue un
/// usuario. El inicio de sesion es anonimo y no muestra interfaz al usuario.
class AutenticacionFirebaseService {
  static bool _firebaseDisponible = false;
  static Future<User?>? _autenticacionEnCurso;

  static void habilitarFirebase() {
    _firebaseDisponible = true;
  }

  static User? get usuarioActual {
    if (!_firebaseDisponible) return null;
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (_) {
      return null;
    }
  }

  static Future<User?> autenticarSilenciosamente() async {
    if (!_firebaseDisponible) return null;

    final existente = usuarioActual;
    if (existente != null) return existente;

    final pendiente = _autenticacionEnCurso;
    if (pendiente != null) return pendiente;

    final nuevaAutenticacion = _iniciarSesionAnonima();
    _autenticacionEnCurso = nuevaAutenticacion;
    try {
      return await nuevaAutenticacion;
    } finally {
      if (identical(_autenticacionEnCurso, nuevaAutenticacion)) {
        _autenticacionEnCurso = null;
      }
    }
  }

  static Future<User?> _iniciarSesionAnonima() async {
    try {
      final credencial = await FirebaseAuth.instance
          .signInAnonymously()
          .timeout(const Duration(seconds: 10));
      return credencial.user;
    } catch (error) {
      debugPrint(
        'Firebase Authentication no pudo iniciar una sesion anonima: $error',
      );
      return null;
    }
  }
}
