part of '../main.dart';

class HistorialService {
  static const String prefsKey = 'historial_pacientes';
  static final List<Map<String, dynamic>> registros = [];

  static Future<void> guardar(
    String titulo,
    String resultado,
    Map<String, String> datos, {
    String tipo = 'diagnostico',
  }) async {
    final registro = {
      'fecha': DateTime.now().toString().substring(0, 16),
      'titulo': titulo,
      'nombre': datos['nombre'] ?? '',
      'resultado': resultado,
      'datos': datos,
      'tipo': tipo,
    };

    registros.insert(0, registro);

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(prefsKey) ?? [];
    raw.insert(0, jsonEncode(registro));
    await prefs.setStringList(prefsKey, raw);

    final usuario =
        await AutenticacionFirebaseService.autenticarSilenciosamente();
    if (usuario == null) {
      debugPrint(
        'Diagnostico guardado localmente; no se sincronizo porque no hay un usuario autenticado.',
      );
    } else {
      try {
        await FirebaseFirestore.instance.collection('diagnosticos').add({
          ...registro,
          'propietarioUid': usuario.uid,
          'pais': datos['pais'] ?? PaisService.actual.value.codigo,
          'creadoEn': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        debugPrint('No se pudo guardar el diagnostico en Firebase: $e');
      }
    }

    await ImpactoService.registrar(
      tipo: tipo,
      titulo: titulo,
      datos: {
        'nombre': datos['nombre'] ?? '',
        'sintomas': datos['sintomas'] ?? '',
        'objetivoFisico': datos['objetivoFisico'] ?? '',
      },
    );
  }

  static Future<int> eliminarRegistro(Map<String, dynamic> registro) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(prefsKey) ?? <String>[];
    final codificado = jsonEncode(registro);
    var indice = raw.indexOf(codificado);
    if (indice < 0) {
      indice = raw.indexWhere((item) {
        try {
          return jsonEncode(jsonDecode(item)) == codificado;
        } catch (_) {
          return false;
        }
      });
    }
    if (indice < 0) {
      throw StateError('El registro seleccionado ya no existe.');
    }
    raw.removeAt(indice);
    final guardado = await prefs.setStringList(prefsKey, raw);
    if (!guardado) throw StateError('No se pudo actualizar el historial.');
    registros.removeWhere((item) => jsonEncode(item) == codificado);
    return indice;
  }

  static Future<void> restaurarRegistro(
    Map<String, dynamic> registro,
    int indice,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(prefsKey) ?? <String>[];
    final posicion = indice.clamp(0, raw.length);
    raw.insert(posicion, jsonEncode(registro));
    final guardado = await prefs.setStringList(prefsKey, raw);
    if (!guardado) throw StateError('No se pudo restaurar el historial.');
  }
}

class ChatHistoryService {
  static const String prefsKey = 'historial_chat_4life';

  static Future<List<Map<String, dynamic>>> cargarConversaciones() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(prefsKey) ?? [];
    return raw
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .where((e) => e['mensajes'] is List)
        .toList();
  }

  static Future<void> guardarConversacion(
    String id,
    List<Map<String, String>> mensajes, {
    String tipo = 'asesor_4life',
    String modoAsesor = 'asesor_ia',
  }) async {
    if (mensajes.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final conversaciones = await cargarConversaciones();
    final primeraPregunta = mensajes.firstWhere(
      (m) => m['rol'] == 'usuario',
      orElse: () => mensajes.first,
    )['texto'];

    final titulo = primeraPregunta ?? 'Chat 4Life';
    final tituloNormalizado = tipo == 'chat_live_voz' &&
            normalizarTexto(titulo).contains('analiza esta nota de voz')
        ? 'Nota de voz Chat Live'
        : titulo;
    final registro = {
      'id': id,
      'fecha': DateTime.now().toString().substring(0, 16),
      'titulo': tituloNormalizado.length > 45
          ? '${tituloNormalizado.substring(0, 45)}...'
          : tituloNormalizado,
      'tipo': tipo,
      'modoAsesor': modoAsesor,
      'mensajes': mensajes,
    };

    conversaciones.removeWhere((chat) => chat['id'] == id);
    conversaciones.insert(0, registro);
    await prefs.setStringList(
      prefsKey,
      conversaciones.map((chat) => jsonEncode(chat)).toList(),
    );
  }

  static Future<void> eliminarConversacion(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final conversaciones = await cargarConversaciones();
    conversaciones.removeWhere((chat) => chat['id'] == id);
    await prefs.setStringList(
      prefsKey,
      conversaciones.map((chat) => jsonEncode(chat)).toList(),
    );
  }
}

// --- PANTALLA DE DIAGNÓSTICO (FORMULARIO) ---
