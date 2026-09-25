import 'dart:io';

import 'package:doctor_suplementos/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    PaisService.actual.value = PaisApp.estadosUnidos;
    IdiomaService.actual.value = IdiomaApp.espanol;
  });

  String diagnostico(PaisApp pais, {String sintomas = 'cansancio frecuente'}) =>
      construirPromptDiagnosticoBase(
        pais: pais,
        instruccionIdioma: 'Español',
        contextoAnterior: 'HISTORIAL PREVIO: seguimiento de Ana',
        saludoAsesor: 'Hola, soy David',
        nombre: 'Ana',
        edad: '42',
        genero: 'Femenino',
        sintomas: sintomas,
      );

  String procesar(String texto, [String consulta = 'Super Greens']) =>
      procesarRespuestaProductosPais(
        texto,
        consulta,
        PaisApp.estadosUnidos,
        IdiomaApp.espanol,
      );

  test('Ecuador conserva exactamente su respuesta normal', () {
    PaisService.actual.value = PaisApp.ecuador;
    const respuesta = 'Respuesta normal de Ecuador\ncon sus secciones.';
    expect(
      procesarRespuestaProductosPais(
        respuesta,
        'consulta',
        PaisApp.ecuador,
        IdiomaApp.espanol,
      ),
      respuesta,
    );
  });

  test('USA acepta texto normal sin campos texto ni productos', () {
    final resultado = procesar('Orientación general sin productos.');
    expect(resultado, startsWith('Orientación general sin productos.'));
    expect(resultado, contains('no medicamentos'));
  });

  test('El procesador USA no decodifica JSON', () {
    final source =
        File('lib/core/catalogo_productos_usa.dart').readAsStringSync();
    final inicio = source.indexOf('String procesarRespuestaProductosPais(');
    final fin = source.indexOf('void validarMercadoEstadosUnidos', inicio);
    expect(source.substring(inicio, fin), isNot(contains('jsonDecode')));
    expect(procesar('Texto libre: {sin contenedor válido'),
        startsWith('Texto libre: {sin contenedor válido'));
  });

  test('USA añade contexto sin sustituir el prompt de diagnóstico', () {
    final base = diagnostico(PaisApp.estadosUnidos);
    final prompt = construirPromptProductosPais('cansancio frecuente', base);
    expect(prompt, startsWith(base));
    for (final seccion in [
      'ANALISIS DEL CASO',
      'NUESTRO OBJETIVO',
      'SUSTRATO Y RESPALDO RECOMENDADO',
      'RECOMENDACIONES DE BIENESTAR GENERAL',
      'Nota de seguridad',
      'HISTORIAL PREVIO: seguimiento de Ana',
      'Hola, soy David',
    ]) {
      expect(prompt, contains(seccion));
    }
    expect(prompt, contains('Responde directamente en texto normal'));
    expect(prompt, isNot(contains('SALIDA OBLIGATORIA: JSON')));
  });

  test('Cambio físico USA conserva datos y todas sus secciones', () {
    final base = construirPromptCambioFisicoBase(
      pais: PaisApp.estadosUnidos,
      instruccionIdioma: 'Español',
      saludoAsesor: 'Hola, soy David',
      nombre: 'Ana',
      edad: '42',
      genero: 'Femenino',
      peso: '70',
      altura: '1.65',
      objetivo: 'Mejorar hábitos',
      contextura: 'Media',
      descripcionContextura: 'Perfil previo',
    );
    final prompt = construirPromptProductosPais('Mejorar hábitos', base);
    expect(prompt, startsWith(base));
    for (final valor in [
      'SALUDO Y ANÁLISIS FÍSICO',
      'PLANIFICACIÓN DEL CASO',
      'PLAN DE APOYO 4LIFE',
      'HABITOS PARA EL OBJETIVO',
      '70 kg',
      '1.65 m',
      'Perfil previo',
    ]) {
      expect(prompt, contains(valor));
    }
  });

  test('Diagnóstico usa la misma estructura para Ecuador y USA', () {
    const caso = 'Tengo cansancio frecuente y dificultad para dormir.';
    final ecuador = diagnostico(PaisApp.ecuador, sintomas: caso);
    final usa = diagnostico(PaisApp.estadosUnidos, sintomas: caso);
    const estructura = [
      '*ANALISIS DEL CASO*',
      '*NUESTRO OBJETIVO*',
      '*SUSTRATO Y RESPALDO RECOMENDADO*',
      '*RECOMENDACIONES DE BIENESTAR GENERAL*',
      '*Nota de seguridad:*',
    ];

    List<String> titulos(String prompt) => estructura
        .where((titulo) => prompt.contains(titulo))
        .toList(growable: false);

    expect(titulos(ecuador), estructura);
    expect(titulos(usa), estructura);
    for (final titulo in estructura) {
      expect(titulo.allMatches(ecuador), hasLength(1));
      expect(titulo.allMatches(usa), hasLength(1));
    }
    const bloqueProducto = [
      '*1. [Nombre exacto del producto]*',
      '- *Forma de uso:*',
      '- *Por qué se elige:*',
      '- *Beneficio clave:*',
    ];
    for (final campo in bloqueProducto) {
      expect(ecuador, contains(campo));
      expect(usa, contains(campo));
    }
    expect(ecuador, isNot(contains('LECTURA CLÍNICA ORIENTATIVA')));
    expect(ecuador, isNot(contains('SALUDO Y ANÁLISIS DEL CASO')));
    expect(usa, isNot(contains('INSTRUCCION MAESTRA NUEVA')));
  });

  test('Cambio físico y Chat conservan estructura entre mercados', () {
    String cambio(PaisApp pais) => construirPromptCambioFisicoBase(
          pais: pais,
          instruccionIdioma: 'Español',
          saludoAsesor: 'Hola, soy David',
          nombre: 'Ana',
          edad: '42',
          genero: 'Femenino',
          peso: '70',
          altura: '1.65',
          objetivo: 'Dormir mejor',
          contextura: 'Media',
          descripcionContextura: 'Perfil previo',
        );
    const titulosCambio = [
      '*SALUDO Y ANÁLISIS FÍSICO*',
      '*PLANIFICACIÓN DEL CASO*',
      '*PLAN DE APOYO 4LIFE (Máx. 3-4 productos; más solo si el caso es extremo/especial)*',
      '*HABITOS PARA EL OBJETIVO*',
      '*Nota responsable:*',
    ];
    for (final titulo in titulosCambio) {
      expect(cambio(PaisApp.ecuador), contains(titulo));
      expect(cambio(PaisApp.estadosUnidos), contains(titulo));
    }

    String chatPais(PaisApp pais) => construirPromptChatbotBase(
          pais: pais,
          modoCientifico: false,
          instruccionIdioma: 'Español',
          instruccionVozHumana: 'VOZ HUMANA',
          instruccionModoCientifico: '',
          reglaProductos: 'Solo productos autorizados',
          instruccionProducto: '',
          instruccionComponente: '',
          instruccionVoz: 'VOZ',
          historialPrevio: 'Historial',
          textoVisible: '¿Qué es Super Greens?',
          terminosComponentes: 'vitaminas',
        );
    expect(chatPais(PaisApp.ecuador), chatPais(PaisApp.estadosUnidos));
  });

  String chat(bool cientifico) => construirPromptChatbotBase(
        pais: PaisApp.estadosUnidos,
        modoCientifico: cientifico,
        instruccionIdioma: 'Español',
        instruccionVozHumana: 'VOZ HUMANA: cálida',
        instruccionModoCientifico:
            cientifico ? 'No recomiendes productos 4Life.' : '',
        reglaProductos:
            cientifico ? 'No hables de productos.' : 'Solo catálogo USA',
        instruccionProducto: 'Producto identificado: Super Greens',
        instruccionComponente: 'No conviertas ingredientes en recomendación',
        instruccionVoz: 'LLAMADA: frases respirables',
        historialPrevio: 'Socio: seguimiento de mi consulta actual',
        textoVisible: '¿Qué es Super Greens?',
        terminosComponentes: 'vitaminas',
      );

  test('Chat y Chat Live conservan historial, tono y voz', () {
    final base = chat(false);
    final prompt = componerPromptChatbotPais(
      'Super Greens',
      base,
      modoCientifico: false,
      pais: PaisApp.estadosUnidos,
      idioma: IdiomaApp.espanol,
    );
    expect(prompt, startsWith(base));
    for (final valor in [
      'Socio: seguimiento',
      'VOZ HUMANA: cálida',
      'LLAMADA: frases respirables',
      'Producto identificado: Super Greens',
      'No conviertas ingredientes',
    ]) {
      expect(prompt, contains(valor));
    }
  });

  test('Modo científico evita contexto y validación comercial', () {
    final base = chat(true);
    final prompt = componerPromptChatbotPais(
      'Agpro',
      base,
      modoCientifico: true,
      pais: PaisApp.estadosUnidos,
      idioma: IdiomaApp.espanol,
    );
    expect(prompt, base);
    expect(prompt, isNot(contains('CONTEXTO ADICIONAL')));
    expect(prompt, contains('No recomiendes productos 4Life.'));
  });

  test('Ficha técnica y comparación conservan formato y ambas fichas', () {
    const consulta =
        'Compara Energy Go Stix Berry con Energy Go Stix Tropical.';
    const base = 'FICHA TECNICA EJECUTIVA\nPROTOCOLO DE USO\nCOMPARACIÓN A/B';
    final prompt = construirPromptProductosPais(consulta, base);
    expect(prompt, startsWith(base));
    expect(prompt, contains('30 sobres'));
    expect(prompt, contains('15 sobres'));
    final ids = productosUsaRelevantes(consulta).map((p) => p.id).toSet();
    expect(
        ids,
        containsAll(<String>{
          'Energy Go Stix Berry',
          'Energy Go Stix Tropical',
        }));
    expect(
      procesar('COMPARACIÓN A/B\nEnergy Go Stix Berry frente a '
          'Energy Go Stix Tropical'),
      startsWith('COMPARACIÓN A/B'),
    );
  });

  test('Consulta sin fichas, incluida anemia menstrual, no es un error', () {
    const consulta =
        'Me puedes dar algo para la anemia causada por la menstruación.';
    expect(productosUsaRelevantes(consulta), isEmpty);
    final prompt = construirPromptProductosPais(
      consulta,
      diagnostico(PaisApp.estadosUnidos, sintomas: consulta),
    );
    expect(prompt, contains('La ausencia de productos no es un error'));
    expect(prompt, contains('sin recomendar productos'));
    expect(
      diagnostico(PaisApp.estadosUnidos, sintomas: consulta),
      isNot(contains('4Life Transfer Factor Max')),
    );
    expect(
      procesar(
        'No puedo confirmar un diagnóstico. Conviene valoración profesional y '
        'exámenes apropiados; no recomendaré productos sin una ficha pertinente.',
        consulta,
      ),
      contains('valoración profesional'),
    );
  });

  test(
      'consulta general USA entrega varias fichas pertinentes sin todo el catálogo',
      () {
    final productos = productosUsaRelevantes(
      'Busco apoyo para energía, cansancio y bienestar inmunológico.',
    );
    expect(productos.length, inInclusiveRange(3, 4));
    expect(productos.length, lessThan(productosPermitidosEstadosUnidos.length));
  });

  test('consulta directa USA se mantiene enfocada en el producto', () {
    final productos = productosUsaRelevantes('Información de Super Greens');
    expect(productos.map((producto) => producto.id), ['Super Greens']);
  });

  test('USA acepta respuesta sin productos y evita duplicar el descargo', () {
    const texto =
        'Orientación general. Los suplementos no son medicamentos y no están '
        'destinados a diagnosticar, tratar, curar ni prevenir enfermedades.';
    final resultado = procesar(texto, 'consulta general');
    expect(resultado, texto);
  });

  test('Respuesta vacía produce una excepción y mensaje específicos', () {
    expect(() => procesar('  '), throwsA(isA<RespuestaIaVaciaException>()));
    expect(
      mensajeErrorIa(const RespuestaIaVaciaException()),
      'La IA no generó una respuesta. Inténtalo nuevamente.',
    );
  });

  test('Solo nombres completos inequívocos de Ecuador se rechazan', () {
    for (final nombre in ['Agpro', 'Bioefa', 'Vistari']) {
      expect(() => procesar('Recomiendo $nombre.'),
          throwsA(isA<ProductoNoAutorizadoException>()));
    }
    expect(
      procesar(
          'La vista mejora con energía; el factor puede ser máximo, plus.'),
      startsWith('La vista mejora'),
    );
    expect(procesar('Recall y lung son palabras en inglés.'),
        startsWith('Recall y lung'));
  });

  test('Producto de Ecuador activa un solo reintento y muestra la corrección',
      () async {
    var llamadas = 0;
    final resultado = await generarYProcesarRespuestaProductosPais(
      prompt: 'PROMPT COMPLETO',
      consulta: 'Quiero Agpro',
      pais: PaisApp.estadosUnidos,
      idioma: IdiomaApp.espanol,
      generar: (prompt) async {
        llamadas++;
        if (llamadas == 1) return 'Recomiendo Agpro.';
        expect(prompt, contains('Reescribe la respuesta'));
        expect(prompt, contains('PROMPT COMPLETO'));
        return 'Ese producto no está disponible en el catálogo USA.';
      },
    );
    expect(llamadas, 2);
    expect(resultado, startsWith('Ese producto no está disponible'));
  });

  test('Un segundo resultado inválido falla sin crear ciclos', () async {
    var llamadas = 0;
    await expectLater(
      generarYProcesarRespuestaProductosPais(
        prompt: 'PROMPT',
        consulta: 'Agpro',
        pais: PaisApp.estadosUnidos,
        idioma: IdiomaApp.espanol,
        generar: (_) async {
          llamadas++;
          return llamadas == 1 ? 'Agpro' : 'Bioefa';
        },
      ),
      throwsA(isA<RespuestaIaBloqueadaException>()),
    );
    expect(llamadas, 2);
    expect(
      mensajeErrorIa(const RespuestaIaBloqueadaException()),
      'La respuesta incluyó productos que no corresponden al país seleccionado. Inténtalo nuevamente.',
    );
  });

  test('Cambio de país produce una excepción y mensaje específicos', () {
    PaisService.actual.value = PaisApp.ecuador;
    expect(
      () => procesarRespuestaProductosPais(
        'respuesta',
        'consulta',
        PaisApp.estadosUnidos,
        IdiomaApp.espanol,
      ),
      throwsA(isA<PaisConsultaCambioException>()),
    );
    expect(
      mensajeErrorIa(const PaisConsultaCambioException()),
      'El país cambió mientras se generaba la respuesta. Genera nuevamente la consulta.',
    );
  });

  test('Errores de API e inesperados tienen mensajes distintos', () {
    expect(
      mensajeErrorIa(const SocketException('fallo controlado')),
      'No se pudo conectar con la IA. Verifica tu conexión e inténtalo nuevamente.',
    );
    expect(
      mensajeErrorIa(FormatException('fallo controlado')),
      'No fue posible procesar la respuesta. Inténtalo nuevamente.',
    );
    expect(
      mensajeErrorIa(const IaProxyException('GEMINI_RECHAZO', estadoHttp: 422)),
      contains('no pudo responder a esa redacción'),
    );
    expect(
      mensajeErrorIa(const IaProxyException('GEMINI_TIMEOUT', estadoHttp: 504)),
      contains('temporalmente ocupada'),
    );
  });

  test('una solicitud con archivos no se reintenta automaticamente', () async {
    var intentos = 0;
    await expectLater(
      generarYProcesarRespuestaProductosPais(
        generar: (_) async {
          intentos++;
          throw const IaProxyException('GEMINI_TIMEOUT', estadoHttp: 504);
        },
        prompt: 'prompt',
        consulta: 'consulta',
        pais: PaisApp.estadosUnidos,
        idioma: IdiomaApp.espanol,
        permitirReintento: false,
      ),
      throwsA(isA<IaProxyException>()),
    );
    expect(intentos, 1);
  });

  test('Catálogos y dosis USA permanecen intactos', () {
    expect(catalogoProductosEstadosUnidos.length, 76);
    expect(productosPermitidosEcuador.length, 32);
    expect(
      catalogoProductosEstadosUnidos.every(
        (p) => p.campo('directions', IdiomaApp.espanol).isEmpty,
      ),
      isTrue,
    );
    expect(
      construirPromptProductosPais('Super Greens', 'BASE'),
      contains('No documentado en el catálogo;\nrevisa la etiqueta vigente'),
    );
  });
}
