import 'package:flutter_tts/flutter_tts.dart';

class ServicioTextoVoz {
  ServicioTextoVoz._();

  static final FlutterTts _tts = FlutterTts();
  static bool _configurado = false;

  static Future<void> _configurar() async {
    if (_configurado) return;
    await _tts.setLanguage('es-ES');
    await _tts.setSpeechRate(0.48);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
    _configurado = true;
  }

  static Future<void> reproducir(String texto) async {
    final contenido = texto.trim();
    if (contenido.isEmpty) return;

    await _configurar();
    await _tts.stop();
    await _tts.speak(_limpiarFormato(contenido));
  }

  static Future<void> detener() => _tts.stop();

  static String _limpiarFormato(String texto) {
    return texto
        .replaceAll(RegExp(r'[*#_`]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
