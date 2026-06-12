part of '../main.dart';

class HistorialService {
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
    final raw = prefs.getStringList('historial_pacientes') ?? [];
    raw.insert(0, jsonEncode(registro));
    await prefs.setStringList('historial_pacientes', raw);

    try {
      await FirebaseFirestore.instance.collection('diagnosticos').add({
        ...registro,
        'creadoEn': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('No se pudo guardar el diagnostico en Firebase: $e');
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
}

class ChatHistoryService {
  static const String _key = 'historial_chat_4life';

  static Future<List<Map<String, dynamic>>> cargarConversaciones() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .where((e) => e['mensajes'] is List)
        .toList();
  }

  static Future<void> guardarConversacion(
    String id,
    List<Map<String, String>> mensajes,
  ) async {
    if (mensajes.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final conversaciones = await cargarConversaciones();
    final primeraPregunta = mensajes.firstWhere(
      (m) => m['rol'] == 'usuario',
      orElse: () => mensajes.first,
    )['texto'];

    final titulo = primeraPregunta ?? 'Chat 4Life';
    final registro = {
      'id': id,
      'fecha': DateTime.now().toString().substring(0, 16),
      'titulo': titulo.length > 45 ? '${titulo.substring(0, 45)}...' : titulo,
      'mensajes': mensajes,
    };

    conversaciones.removeWhere((chat) => chat['id'] == id);
    conversaciones.insert(0, registro);
    await prefs.setStringList(
      _key,
      conversaciones.map((chat) => jsonEncode(chat)).toList(),
    );
  }

  static Future<void> eliminarConversacion(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final conversaciones = await cargarConversaciones();
    conversaciones.removeWhere((chat) => chat['id'] == id);
    await prefs.setStringList(
      _key,
      conversaciones.map((chat) => jsonEncode(chat)).toList(),
    );
  }
}

// --- PANTALLA DE DIAGNÓSTICO (FORMULARIO) ---
