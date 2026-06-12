import 'package:flutter_tts/flutter_tts.dart';

class ServicioTextoVoz {
  ServicioTextoVoz._();

  static final FlutterTts _tts = FlutterTts();
  static bool _configurado = false;

  static Future<void> _configurar() async {
    if (_configurado) return;
    await _tts.setLanguage('es-US');
    await _seleccionarMejorVoz();
    await _tts.setSpeechRate(0.43);
    await _tts.setVolume(1.0);
    await _tts.setPitch(0.96);
    await _tts.awaitSpeakCompletion(true);
    _configurado = true;
  }

  static Future<void> _seleccionarMejorVoz() async {
    try {
      final voces = await _tts.getVoices;
      if (voces is! List) return;

      Map<dynamic, dynamic>? mejor;
      var mejorPuntaje = -1;
      for (final voz in voces.whereType<Map>()) {
        final locale = (voz['locale'] ?? '').toString().toLowerCase();
        final nombre = (voz['name'] ?? '').toString().toLowerCase();
        if (!locale.startsWith('es')) continue;

        var puntaje = 10;
        if (locale.contains('us') ||
            locale.contains('mx') ||
            locale.contains('419')) {
          puntaje += 8;
        } else if (locale.contains('es')) {
          puntaje += 5;
        }
        if (nombre.contains('neural') ||
            nombre.contains('premium') ||
            nombre.contains('enhanced') ||
            nombre.contains('network')) {
          puntaje += 12;
        }
        if (nombre.contains('female')) puntaje += 2;

        if (puntaje > mejorPuntaje) {
          mejor = voz;
          mejorPuntaje = puntaje;
        }
      }

      if (mejor != null) {
        await _tts.setVoice({
          'name': mejor['name'].toString(),
          'locale': mejor['locale'].toString(),
        });
      }
    } catch (_) {
      await _tts.setLanguage('es-ES');
    }
  }

  static Future<void> reproducir(String texto) async {
    final contenido = prepararTexto(texto);
    if (contenido.isEmpty) return;

    await _configurar();
    await _tts.stop();
    await _tts.speak(contenido);
  }

  static Future<void> detener() => _tts.stop();

  static String prepararTexto(String texto) {
    var contenido = texto.trim();
    if (contenido.isEmpty) return '';

    final inicioAnalisis = RegExp(
      r'(?:^|\n)\s*[*#_`]*\s*(?:saludo\s+y\s+)?an[aá]lisis\s+(?:del|de)\s+caso\s*[*#_`]*\s*:?\s*',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(contenido);
    if (inicioAnalisis != null) {
      contenido =
          'Análisis del caso. ${contenido.substring(inicioAnalisis.end)}';
    }

    return contenido
        .replaceAllMapped(
          RegExp(r'\[([^\]]+)\]\([^)]+\)'),
          (coincidencia) => coincidencia.group(1) ?? '',
        )
        .replaceAll(RegExp(r'[*#_`]'), '')
        .replaceAll(RegExp(r'^\s*[•●▪◦]+\s*', multiLine: true), '')
        .replaceAll(RegExp(r'[-‐‑‒–—―]+'), ' ')
        .replaceAll(
          RegExp(r"[^A-Za-zÁÉÍÓÚÜÑáéíóúüñ0-9\s.,;:¿?¡!()%'\/]"),
          '',
        )
        .replaceAll(RegExp(r'\n+'), '. ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAllMapped(
          RegExp(r'\s+([.,;:?!])'),
          (coincidencia) => coincidencia.group(1) ?? '',
        )
        .replaceAllMapped(
          RegExp(r'([.!?])\s*\.'),
          (coincidencia) => coincidencia.group(1) ?? '',
        )
        .trim();
  }
}
