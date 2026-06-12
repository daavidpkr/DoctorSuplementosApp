part of '../main.dart';

class ArchivoAdjuntoIA {
  final String nombre;
  final String mimeType;
  final Uint8List bytes;

  const ArchivoAdjuntoIA({
    required this.nombre,
    required this.mimeType,
    required this.bytes,
  });

  bool get esImagen => mimeType.startsWith('image/');
  bool get esPdf => mimeType == 'application/pdf';
  bool get esAudio => mimeType.startsWith('audio/');
}

class PerfilAsesor {
  final String nombre;
  final String fotoBase64;

  const PerfilAsesor({
    required this.nombre,
    required this.fotoBase64,
  });

  bool get tieneNombre => nombre.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'nombre': nombre.trim(),
        'fotoBase64': fotoBase64,
      };

  factory PerfilAsesor.fromJson(Map<String, dynamic> json) {
    return PerfilAsesor(
      nombre: json['nombre']?.toString() ?? '',
      fotoBase64: json['fotoBase64']?.toString() ?? '',
    );
  }
}

class PerfilService {
  static const String _prefsKey = 'perfil_asesor_4life';
  static const String _documentId = 'perfil_principal';

  static Future<PerfilAsesor> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null && raw.isNotEmpty) {
      return PerfilAsesor.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('perfiles_asesores')
          .doc(_documentId)
          .get();
      final data = doc.data();
      if (data != null) {
        final perfil = PerfilAsesor.fromJson(data);
        await prefs.setString(_prefsKey, jsonEncode(perfil.toJson()));
        return perfil;
      }
    } catch (e) {
      debugPrint('No se pudo cargar el perfil desde Firebase: $e');
    }

    return const PerfilAsesor(nombre: '', fotoBase64: '');
  }

  static Future<void> guardar(PerfilAsesor perfil) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(perfil.toJson()));

    try {
      await FirebaseFirestore.instance
          .collection('perfiles_asesores')
          .doc(_documentId)
          .set({
        ...perfil.toJson(),
        'actualizadoEn': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('No se pudo guardar el perfil en Firebase: $e');
    }
  }
}

class ImpactoService {
  static const String _prefsKey = 'impacto_4life';

  static Future<void> registrar({
    required String tipo,
    required String titulo,
    Map<String, dynamic> datos = const {},
    bool guardarEnFirebase = true,
  }) async {
    final registro = {
      'tipo': tipo,
      'titulo': titulo,
      'fecha': DateTime.now().toIso8601String(),
      'datos': datos,
    };

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey) ?? [];
    raw.insert(0, jsonEncode(registro));
    await prefs.setStringList(_prefsKey, raw);

    if (!guardarEnFirebase) return;

    try {
      await FirebaseFirestore.instance.collection('impacto_4life').add({
        ...registro,
        'creadoEn': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('No se pudo guardar el impacto en Firebase: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> cargarEventos() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey) ?? [];
    return raw.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }
}
