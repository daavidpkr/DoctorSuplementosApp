import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicioTextoVoz {
  ServicioTextoVoz._();

  static final FlutterTts _tts = FlutterTts();
  static String? _idiomaConfigurado;
  static const double _palabrasPorSegundoEs = 2.25;
  static const double _palabrasPorSegundoEn = 2.45;

  static Future<String> _idiomaActual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('idioma_app_4life') ?? 'es';
  }

  static Future<void> _configurar(String idioma) async {
    if (_idiomaConfigurado == idioma) return;

    await _tts.setLanguage(idioma == 'en' ? 'en-US' : 'es-US');
    await _seleccionarMejorVoz(idioma);
    await _tts.setSpeechRate(idioma == 'en' ? 0.42 : 0.40);
    await _tts.setVolume(1.0);
    await _tts.setPitch(idioma == 'en' ? 1.02 : 1.0);
    await _tts.awaitSpeakCompletion(true);
    _idiomaConfigurado = idioma;
  }

  static Future<void> _seleccionarMejorVoz(String idioma) async {
    try {
      final voces = await _tts.getVoices;
      if (voces is! List) return;

      final prefijo = idioma == 'en' ? 'en' : 'es';
      final regiones =
          idioma == 'en' ? ['us', 'gb', 'au'] : ['us', 'mx', '419', 'es'];
      Map<dynamic, dynamic>? mejor;
      var mejorPuntaje = -1;

      for (final voz in voces.whereType<Map>()) {
        final locale = (voz['locale'] ?? '').toString().toLowerCase();
        final nombre = (voz['name'] ?? '').toString().toLowerCase();
        if (!locale.startsWith(prefijo)) continue;

        var puntaje = 10;
        for (var i = 0; i < regiones.length; i++) {
          if (locale.contains(regiones[i])) {
            puntaje += 10 - i;
            break;
          }
        }
        if (nombre.contains('neural')) {
          puntaje += 18;
        }
        if (nombre.contains('premium') ||
            nombre.contains('enhanced') ||
            nombre.contains('network') ||
            nombre.contains('natural')) {
          puntaje += 14;
        }
        if (nombre.contains('google') ||
            nombre.contains('microsoft') ||
            nombre.contains('samsung')) {
          puntaje += 4;
        }
        if (nombre.contains('female') || nombre.contains('woman')) {
          puntaje += 2;
        }

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
      await _tts.setLanguage(idioma == 'en' ? 'en-US' : 'es-ES');
    }
  }

  static Future<void> reproducir(
    String texto, {
    void Function(String text, int startOffset, int endOffset, String word)?
        onProgreso,
  }) async {
    final idioma = await _idiomaActual();
    final contenido = prepararTexto(texto, idioma: idioma);
    if (contenido.isEmpty) return;

    await _configurar(idioma);
    _tts.setProgressHandler(
      (text, startOffset, endOffset, word) {
        onProgreso?.call(text, startOffset, endOffset, word);
      },
    );
    await _tts.stop();
    await _tts.speak(contenido);
  }

  static Future<void> detener() => _tts.stop();

  static Duration estimarDuracion(String texto, {String idioma = 'es'}) {
    final contenido = prepararTexto(texto, idioma: idioma);
    if (contenido.isEmpty) return Duration.zero;
    final palabras = contenido.split(RegExp(r'\s+')).length;
    final palabrasPorSegundo =
        idioma == 'en' ? _palabrasPorSegundoEn : _palabrasPorSegundoEs;
    final segundos = (palabras / palabrasPorSegundo).clamp(3.5, 120.0);
    return Duration(milliseconds: (segundos * 1000).round());
  }

  static String prepararTexto(String texto, {String idioma = 'es'}) {
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

    return _mejorarPronunciacion(contenido, idioma)
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

  static String _mejorarPronunciacion(String texto, String idioma) {
    var contenido = texto;
    final reemplazos = idioma == 'en'
        ? <Pattern, String>{
            RegExp(r'\b4Life\b', caseSensitive: false): 'four life',
            RegExp(r'\bRioVida\b', caseSensitive: false): 'Rio Vida',
            RegExp(r'\bStix\b', caseSensitive: false): 'sticks',
            RegExp(r'\bTri[- ]?Factor\b', caseSensitive: false): 'try factor',
            RegExp(r'\bNK\b'): 'N K',
            RegExp(r'\bAçaí\b', caseSensitive: false): 'ah-sah-ee',
            RegExp(r'\bLP\b'): 'L P',
          }
        : <Pattern, String>{
            RegExp(r'\b4Life\b', caseSensitive: false): 'for life',
            RegExp(r'\bRioVida\b', caseSensitive: false): 'Rio Vida',
            RegExp(r'\bStix\b', caseSensitive: false): 'sticks',
            RegExp(r'\bTri[- ]?Factor\b', caseSensitive: false): 'trai factor',
            RegExp(r'\bNK\b'): 'ene ka',
            RegExp(r'\bAçaí\b', caseSensitive: false): 'asai',
            RegExp(r'\bLP\b'): 'ele pe',
          };

    for (final entry in reemplazos.entries) {
      contenido = contenido.replaceAll(entry.key, entry.value);
    }
    return contenido;
  }
}
