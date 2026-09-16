import 'dart:convert';
import 'package:doctor_suplementos/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    PaisService.actual.value = PaisApp.estadosUnidos;
    IdiomaService.actual.value = IdiomaApp.espanol;
  });

  String diagnostico(PaisApp pais) => construirPromptDiagnosticoBase(
      pais: pais,
      instruccionIdioma: 'Español',
      contextoAnterior: 'HISTORIAL PREVIO: seguimiento de Ana',
      saludoAsesor: 'Hola, soy David',
      nombre: 'Ana',
      edad: '42',
      genero: 'Femenino',
      sintomas: 'Tengo cansancio frecuente y dificultad para dormir.');
  String procesar(String raw, [String query = 'Super Greens']) =>
      procesarRespuestaProductosPais(
          raw, query, PaisApp.estadosUnidos, IdiomaApp.espanol);

  test(
      'All 80 bilingual names can be validated without shorter-name collisions',
      () {
    for (final p in catalogoProductosEstadosUnidos) {
      for (final idioma in IdiomaApp.values) {
        final text = procesarRespuestaProductosPais(
            jsonEncode({
              'texto': p.nombre(idioma),
              'productos': [p.id]
            }),
            p.id,
            PaisApp.estadosUnidos,
            idioma);
        expect(text, startsWith(p.nombre(idioma)), reason: p.id);
      }
    }
  });

  test(
      'Requested five offline scenarios preserve format, sources, sizes and market rejection',
      () {
    for (final pais in PaisApp.values) {
      final base = diagnostico(pais);
      final prompt = construirPromptProductosPais(
          'Tengo cansancio frecuente y dificultad para dormir.', base,
          pais: pais);
      expect(prompt, contains(base));
      expect(prompt, contains('NUESTRO OBJETIVO'));
      if (pais == PaisApp.ecuador) expect(prompt, base);
    }
    const greens = '¿Qué es Super Greens y cómo se usa?';
    expect(productosUsaRelevantes(greens).map((p) => p.id), ['Super Greens']);
    expect(construirPromptProductosPais(greens, 'Consulta: $greens'),
        contains('omite dosis, frecuencia, horario y cantidad'));
    final comparacion = productosUsaRelevantes(
        'Compara Energy Go Stix Berry con Energy Go Stix Tropical.');
    expect(comparacion.length, 2);
    expect(comparacion.map((p) => p.campo('size', IdiomaApp.espanol)).toSet(),
        {'30 sobres', '15 sobres'});
    expect(productosUsaRelevantes('Quiero Agpro.'), isEmpty);
    expect(
        () => procesar(
            jsonEncode({'texto': 'Agpro', 'productos': []}), 'Quiero Agpro.'),
        throwsStateError);
    PaisService.actual.value = PaisApp.ecuador;
    expect(productoDesdeTexto('Quiero Super Greens.'), isNull);
    expect(
        () => procesarRespuestaProductosPais('Super Greens',
            'Quiero Super Greens.', PaisApp.ecuador, IdiomaApp.espanol),
        throwsStateError);
  });

  test(
      'Base is preserved verbatim, Ecuador unchanged, USA appends only USA sheets',
      () {
    const base =
        'ROL DEL MODULO\nHistorial: seguimiento\nAdjuntos: nota de voz\nFORMATO: comparación';
    expect(
        construirPromptProductosPais('Super Greens', base,
            pais: PaisApp.ecuador),
        base);
    final usa = construirPromptProductosPais('Super Greens', base);
    expect(usa, startsWith('$base\n\n'));
    expect(usa, contains('CONTEXTO ADICIONAL OBLIGATORIO DEL MERCADO USA'));
    expect(usa, contains('"pagina_fuente"'));
    expect(usa, contains('"ingredientes"'));
    expect(usa, isNot(contains('Agpro')));
    expect(usa, isNot(contains('Bioefa')));
    // Market rules have priority without deleting functional instructions.
    expect(construirPromptProductosPais('Super Greens', 'BASE: Agpro'),
        startsWith('BASE: Agpro'));
  });

  test(
      'Actual diagnosis builder retains sections, patient, history and greeting without undocumented doses',
      () {
    final base = diagnostico(PaisApp.estadosUnidos);
    final prompt = construirPromptProductosPais(
        'Tengo cansancio frecuente y dificultad para dormir.', base);
    for (final value in [
      'ANÁLISIS DEL CASO',
      'NUESTRO OBJETIVO',
      'SUSTRATO Y RESPALDO RECOMENDADO',
      'RECOMENDACIONES DE BIENESTAR GENERAL',
      'Nota de seguridad',
      'Ana',
      '42',
      'Femenino',
      'cansancio frecuente',
      'HISTORIAL PREVIO: seguimiento de Ana',
      'Hola, soy David',
      '3 o 4'
    ]) {
      expect(prompt, contains(value));
    }
    expect(prompt, contains(base));
    expect(base, isNot(contains('DOSIFICACIÓN EXACTA')));
    expect(base, isNot(contains('[Cantidad exacta]')));
    expect(base, isNot(contains('*Dosis manana:*')));
    expect(prompt, contains('revisa la etiqueta vigente'));
    expect(prompt, contains('deben estar dentro de texto'));
    final response = procesar(jsonEncode({
      'texto':
          '*ANÁLISIS DEL CASO*\nAna\n*NUESTRO OBJETIVO*\nSeguimiento\n*SUSTRATO Y RESPALDO RECOMENDADO*\nNo hay opción documentada\n*RECOMENDACIONES DE BIENESTAR GENERAL*\nDescanso\n*Nota de seguridad*\nEvaluación profesional',
      'productos': []
    }));
    expect(response, contains('*NUESTRO OBJETIVO*\nSeguimiento'));
    expect(diagnostico(PaisApp.ecuador),
        contains('DOSIFICACIÓN EXACTA Y DETALLADA'));
    expect(diagnostico(PaisApp.ecuador), contains('*ANALISIS DEL CASO*'));
  });

  String chat(bool cientifico) => construirPromptChatbotBase(
      pais: PaisApp.estadosUnidos,
      modoCientifico: cientifico,
      instruccionIdioma: 'Español',
      instruccionVozHumana: 'VOZ HUMANA: cálida',
      instruccionModoCientifico:
          cientifico ? 'No recomiendes productos 4Life.' : '',
      reglaProductos: cientifico
          ? 'No hables de productos.'
          : 'REGLA NORMAL: solo catálogo USA',
      instruccionProducto: 'Producto identificado: Super Greens',
      instruccionComponente: 'No conviertas ingredientes en recomendación',
      instruccionVoz: 'LLAMADA: frases respirables',
      historialPrevio: 'Socio: seguimiento de mi consulta actual',
      textoVisible: '¿Qué es Super Greens y cómo se usa?',
      terminosComponentes: 'vitaminas');

  test(
      'Actual chat preserves conversation, current query, voice, mode and product rules',
      () {
    final base = chat(false);
    final prompt = componerPromptChatbotPais('Super Greens', base,
        modoCientifico: false,
        pais: PaisApp.estadosUnidos,
        idioma: IdiomaApp.espanol);
    for (final value in [
      'Socio: seguimiento',
      '¿Qué es Super Greens y cómo se usa?',
      'VOZ HUMANA: cálida',
      'LLAMADA: frases respirables',
      'REGLA NORMAL',
      'Producto identificado: Super Greens',
      'No conviertas ingredientes',
      'Ficha Tecnica Ejecutiva',
      'comparación'
    ]) {
      expect(prompt, contains(value));
    }
    expect(prompt, startsWith(base));
    expect(prompt, isNot(contains('Transfer factor tri factor')));
  });

  test('Scientific chat bypasses commercial JSON and keeps prohibition', () {
    final base = chat(true);
    final prompt = componerPromptChatbotPais('Super Greens', base,
        modoCientifico: true,
        pais: PaisApp.estadosUnidos,
        idioma: IdiomaApp.espanol);
    expect(prompt, base);
    expect(prompt, contains('No recomiendes productos 4Life.'));
    expect(prompt, isNot(contains('SALIDA OBLIGATORIA: JSON')));
  });

  test(
      'Actual body-change builder preserves physical data and format with USA-only sheets',
      () {
    final base = construirPromptCambioFisicoBase(
        pais: PaisApp.estadosUnidos,
        instruccionIdioma: 'Español',
        saludoAsesor: 'Hola, soy David',
        nombre: 'Ana',
        edad: '42',
        genero: 'Femenino',
        peso: '70',
        altura: '1.65',
        objetivo: 'Mejorar hábitos con Super Greens',
        contextura: 'Media',
        descripcionContextura: 'Perfil previo');
    final prompt = construirPromptProductosPais('Super Greens', base);
    for (final value in [
      'SALUDO Y ANÁLISIS FÍSICO',
      'PLANIFICACIÓN DEL CASO',
      'PLAN DE APOYO 4LIFE',
      'HABITOS PARA EL OBJETIVO',
      '70 kg',
      '1.65 m',
      'Mejorar hábitos',
      'Media',
      'Perfil previo',
      'Hola, soy David'
    ]) {
      expect(prompt, contains(value));
    }
    expect(prompt, startsWith(base));
    expect(prompt, isNot(contains('BioEFA con CLA')));
    expect(base, isNot(contains('*Dosis manana:*')));
  });

  test('Technical sheet and comparison formats stay inside JSON text', () {
    const query = 'Compara Energy Go Stix Berry con Energy Go Stix Tropical.';
    const base =
        'Consulta original: $query\nFICHA TECNICA EJECUTIVA\nCOMPONENTES PRINCIPALES Y ORIGEN\nPROTOCOLO DE USO\nCOMPARACIÓN A/B\nAdjunto: documento del usuario';
    final prompt = construirPromptProductosPais(query, base);
    expect(prompt, startsWith(base));
    final relevantes = productosUsaRelevantes(query);
    expect(relevantes.take(2).map((p) => p.id).toSet(),
        {'Energy Go Stix Berry', 'Energy Go Stix Tropical'});
    expect(prompt, contains('30 sobres'));
    expect(prompt, contains('15 sobres'));
    final text = procesar(
        jsonEncode({
          'texto':
              'COMPARACIÓN A/B\nEnergy Go Stix Berry frente a Energy Go Stix Tropical',
          'productos': ['Energy Go Stix Berry', 'Energy Go Stix Tropical']
        }),
        query);
    expect(text, startsWith('COMPARACIÓN A/B\n'));
    expect(textoFichaProductoUsa('Super Greens', IdiomaApp.espanol),
        contains('No documentado en el catálogo'));
  });

  test(
      'Relevance prioritizes bilingual exact names and typos, ignores generic and foreign terms',
      () {
    for (final query in [
      'Quiero Super Greens.',
      '¿Qué es Super Greens y cómo se usa?',
      'Quiero Super Grens.',
      'Super Greens'
    ]) {
      expect(productosUsaRelevantes(query).first.id, 'Super Greens');
    }
    expect(productosUsaRelevantes('Energy Go Stix Moras').first.id,
        'Energy Go Stix Berry');
    expect(
        productosUsaRelevantes(
            'informacion general sobre productos de bienestar y salud'),
        isEmpty);
    expect(productosUsaRelevantes('Quiero Agpro.'), isEmpty);
    expect(productosUsaRelevantes('zxqv inexplicable'), isEmpty);
    final sintomas = productosUsaRelevantes(
        'Tengo cansancio frecuente y dificultad para dormir.');
    expect(sintomas.length, lessThanOrEqualTo(6));
    for (final p in sintomas) {
      final fuente = normalizarTexto(
          '${p.campo('description', IdiomaApp.espanol)} ${p.campo('description', IdiomaApp.ingles)} ${p.campo('ingredients', IdiomaApp.espanol)} ${p.campo('ingredients', IdiomaApp.ingles)}');
      expect(
          fuente
              .split(' ')
              .any({'cansancio', 'dormir', 'fatigue', 'sleep'}.contains),
          isTrue,
          reason: p.id);
    }
  });

  for (final malformed in [
    'no es JSON',
    '[]',
    'null',
    '{}',
    '{"texto":3,"productos":[]}',
    '{"texto":"ok","productos":"Super Greens"}',
    '{"texto":"ok","productos":[3]}',
    '{"texto":"","productos":[]}'
  ]) {
    test('Controlled failure for malformed response: $malformed', () {
      expect(() => procesar(malformed), throwsStateError);
    });
  }
  test(
      'Validation accepts fenced JSON, rejects unauthorized IDs, foreign names and missing declared IDs',
      () {
    final valid = jsonEncode({
      'texto': 'Super Greens: revisa la etiqueta vigente.',
      'productos': ['Super Greens']
    });
    expect(procesar('```json\n$valid\n```'), contains('Super Greens'));
    for (final salida in [
      {
        'texto': 'ok',
        'productos': ['Agpro']
      },
      {
        'texto': 'ok',
        'productos': ['Renuvo']
      },
      {'texto': 'Agpro', 'productos': []},
      {'texto': '4Life Transfer Factor BCV', 'productos': []},
      {'texto': 'Energy Go Stix Moras', 'productos': []},
      {'texto': 'Super Greens', 'productos': []},
    ]) {
      expect(() => procesar(jsonEncode(salida)), throwsStateError);
    }
    expect(procesar(valid), contains('no medicamentos'));
    PaisService.actual.value = PaisApp.ecuador;
    expect(() => procesar(valid), throwsStateError);
  });
}
