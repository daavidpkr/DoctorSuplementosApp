import 'dart:convert';
import 'package:doctor_suplementos/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'instalacion_inicial_configurada_v1': true,
      'inventario_local_4life': '{"Agpro":3,"Producto antiguo":7}',
      HistorialService.prefsKey: ['{"resultado":"Agpro","datos":{}}'],
    });
    PaisService.actual.value = PaisApp.ecuador;
    IdiomaService.actual.value = IdiomaApp.espanol;
  });

  test('Ecuador conserves its 32 names, prices and active resolvers', () {
    expect(
        () => procesarRespuestaProductosPais('Recomiendo Super Greens',
            'bienestar', PaisApp.ecuador, IdiomaApp.espanol),
        throwsStateError);
    expect(productosPermitidosEcuador.length, 32);
    expect(productosPermitidosPaisActual, same(productosPermitidosEcuador));
    expect(productosConPrecioPaisActual, same(productosConPrecioEcuador));
    expect(imagenesProductoPaisActual, same(imagenesProductoEcuador));
    expect(catalogoPermitidoPaisActual, productosPermitidosEcuador.join(', '));
    expect(buscarProductoConPrecio('tf max')?.afiliado, 109.25);
    expect(precioPromocionalMiTienda('Transfer factor MAX'), 116.24);
  });

  test('USA has exactly 80 unique commercial IDs and verified source pages',
      () {
    PaisService.actual.value = PaisApp.estadosUnidos;
    expect(productosPermitidosPaisActual.length, 80);
    expect(productosPermitidosPaisActual.toSet().length, 80);
    expect(catalogoProductosEstadosUnidos.length, 80);
    expect(productosPermitidosPaisActual, isNot(contains('4LifeTransform')));
    for (final p in catalogoProductosEstadosUnidos) {
      expect(p.nombreEspanol, isNotEmpty);
      expect(p.nombreIngles, isNotEmpty);
      expect(p.paginaFuente, inInclusiveRange(16, 84));
      expect(p.presentaciones, isNotEmpty);
      expect(p.campo('description', IdiomaApp.ingles), isNotEmpty,
          reason: p.id);
      expect(p.campo('description', IdiomaApp.espanol), isNotEmpty,
          reason: p.id);
      expect(buscarProductoPermitido(p.id), p.id);
      expect(buscarProductoPermitido(p.nombreEspanol), p.id,
          reason: p.nombreEspanol);
      expect(buscarProductoPermitido(p.nombreIngles), p.id,
          reason: p.nombreIngles);
    }
  });

  test('five energy flavors and three transform packs remain independent', () {
    final energy = catalogoProductosEstadosUnidos
        .where((p) => p.categoria == 'Energy')
        .toList();
    expect(energy.length, 5);
    expect(energy.map((p) => p.presentaciones.first['item']).toSet().length, 5);
    final packs = catalogoProductosEstadosUnidos
        .where((p) => p.esPaquete && p.categoria == '4LifeTransform');
    expect(packs.length, 3);
    expect(packs.map((p) => p.id).toSet().length, 3);
  });

  test('search never adapts market-exclusive names to another market', () {
    for (final name in [
      'Super Greens',
      '4Life Transfer Factor Classic',
      'Energy Go Stix Orange Citrus',
      '4LifeTransform Shred Pack for Men'
    ]) {
      expect(buscarProductoPermitido(name), isNull, reason: name);
      expect(buscarProductoConPrecio(name), isNull, reason: name);
    }
    PaisService.actual.value = PaisApp.estadosUnidos;
    for (final name in [
      'Agpro',
      'Bioefa',
      'Vistari',
      'Riovida Jugo',
      'Aloe Vera Stix Tropical'
    ]) {
      expect(buscarProductoPermitido(name), isNull, reason: name);
      expect(buscarProductoConPrecio(name), isNull, reason: name);
    }
    expect(buscarProductoPermitido('Clasisc'), '4Life Transfer Factor Classic');
    expect(buscarProductoPermitido('Energy Go Stix Moras'),
        'Energy Go Stix Berry');
    expect(productoDesdeTexto('Consulta sobre Energy Go Stix Moras.'),
        'Energy Go Stix Berry');
  });

  test('USA prices never inherit Ecuador prices and flavors retain sizes', () {
    PaisService.actual.value = PaisApp.estadosUnidos;
    final max = buscarProductoConPrecio('4Life Transfer Factor Max')!;
    expect((max.publico, max.afiliado, max.lp), (111, 89, 75));
    expect(precioPromocionalMiTienda(max.nombre), 94);
    expect(precioPromocionalMiTienda('Transfer factor MAX'), isNull);
    expect(
        fichaProductoUsa('Energy Go Stix Berry')!
            .campo('size', IdiomaApp.ingles),
        '30 powder packets');
    expect(
        fichaProductoUsa('Energy Go Stix Tropical')!
            .campo('size', IdiomaApp.ingles),
        '15 powder packets');
    expect(imagenesProductoPaisActual, isEmpty);
    expect(seleccionProductoVigente(productosConPrecioEcuador.first), isFalse);
  });

  test(
      'AI context contains only USA pertinent sheets and localized official content',
      () {
    PaisService.actual.value = PaisApp.estadosUnidos;
    const query = 'Super Greens';
    final sheets = productosUsaRelevantes(query);
    expect(sheets.length, lessThanOrEqualTo(6));
    expect(sheets.map((p) => p.id), contains(query));
    final es =
        construirPromptProductosPais(query, 'CATALOGO ECUADOR: Agpro Bioefa');
    expect(es, isNot(contains('Agpro')));
    expect(es, isNot(contains('Bioefa')));
    expect(es, contains('Nutrición básica'));
    final en =
        construirPromptProductosPais(query, '', idioma: IdiomaApp.ingles);
    expect(en, contains('Core Nutrition'));
    expect(en, isNot(contains('Nutrición básica')));
    expect(
        construirPromptProductosPais('query', 'original',
            pais: PaisApp.ecuador),
        'original');
  });

  test(
      'response validation rejects other market recommendations and country changes',
      () {
    PaisService.actual.value = PaisApp.estadosUnidos;
    const query = 'Super Greens';
    expect(
        () => procesarRespuestaProductosPais(
            jsonEncode({
              'texto': 'Agpro',
              'productos': ['Agpro']
            }),
            query,
            PaisApp.estadosUnidos,
            IdiomaApp.espanol),
        throwsStateError);
    expect(
        () => procesarRespuestaProductosPais(
            jsonEncode({'texto': 'Agpro', 'productos': []}),
            query,
            PaisApp.estadosUnidos,
            IdiomaApp.espanol),
        throwsStateError);
    final text = procesarRespuestaProductosPais(
        jsonEncode({
          'texto': 'Super Greens',
          'productos': ['Super Greens']
        }),
        query,
        PaisApp.estadosUnidos,
        IdiomaApp.espanol);
    expect(text, contains('no medicamentos'));
    PaisService.actual.value = PaisApp.ecuador;
    expect(
        () => procesarRespuestaProductosPais(
            '{}', query, PaisApp.estadosUnidos, IdiomaApp.espanol),
        throwsStateError);
  });

  test('inventory namespaces and country updates preserve old preferences',
      () async {
    expect(claveInventarioPais(PaisApp.ecuador), 'inventario_local_4life');
    expect(claveInventarioPais(PaisApp.estadosUnidos),
        'inventario_local_4life_usa');
    final prefs = await SharedPreferences.getInstance();
    final previous = prefs.getString('inventario_local_4life');
    final history = prefs.getStringList(HistorialService.prefsKey);
    await PaisService.guardar(PaisApp.estadosUnidos);
    expect(prefs.getString('inventario_local_4life'), previous);
    expect(prefs.getStringList(HistorialService.prefsKey), history);
  });

  testWidgets('gallery switches immediately and searches localized USA names',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ConsultaProductoPagina()));
    await tester.pumpAndSettle();
    final state = tester.state(find.byType(ConsultaProductoPagina));
    await PaisService.guardar(PaisApp.estadosUnidos);
    await tester.pumpAndSettle();
    expect(tester.state(find.byType(ConsultaProductoPagina)), same(state));
    await tester.enterText(find.byType(TextField).first, 'Super Greens');
    await tester.pumpAndSettle();
    expect(find.byWidgetPredicate((w) => w is Text && w.data == 'Super Greens'),
        findsOneWidget);
    await PaisService.guardar(PaisApp.ecuador);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Super Greens');
    await tester.pumpAndSettle();
    expect(find.byWidgetPredicate((w) => w is Text && w.data == 'Super Greens'),
        findsNothing);
  });

  testWidgets('profile country selection updates the gallery beneath its route',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ConsultaProductoPagina()));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(ConsultaProductoPagina));
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const PaginaPerfil()));
    await tester.pumpAndSettle();
    tester
        .widget<SelectorEstilizado<PaisApp>>(
            find.byType(SelectorEstilizado<PaisApp>))
        .onChanged(PaisApp.estadosUnidos);
    await tester.pumpAndSettle();
    expect(await PaisService.cargar(), PaisApp.estadosUnidos);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Super Greens');
    await tester.pumpAndSettle();
    expect(find.byWidgetPredicate((w) => w is Text && w.data == 'Super Greens'),
        findsOneWidget);
  });

  testWidgets('inventory changes market without deleting old or unknown stock',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PaginaInventarioLocal()));
    await tester.pumpAndSettle();
    await PaisService.guardar(PaisApp.estadosUnidos);
    await tester.pumpAndSettle();
    final prefs = await SharedPreferences.getInstance();
    expect(jsonDecode(prefs.getString('inventario_local_4life')!),
        {'Agpro': 3, 'Producto antiguo': 7});
    expect(prefs.getString('inventario_local_4life_usa'), isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('calculator clears Ecuador selections after market switch',
      (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: PaginaCalculadoraPrecios()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Afiliado').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Agpro');
    await tester.pumpAndSettle();
    final name = find.byWidgetPredicate((w) => w is Text && w.data == 'Agpro');
    await tester.ensureVisible(name.first);
    await tester.tap(name.first);
    await tester.pumpAndSettle();
    expect(find.byWidgetPredicate((w) => w is Text && w.data == 'Agpro'),
        findsWidgets);
    await PaisService.guardar(PaisApp.estadosUnidos);
    await tester.pumpAndSettle();
    expect(find.byWidgetPredicate((w) => w is Text && w.data == 'Agpro'),
        findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('comparator discards previous market products', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PaginaComparadorAB()));
    await tester.pumpAndSettle();
    expect(find.text('Transfer factor plus'), findsWidgets);
    await PaisService.guardar(PaisApp.estadosUnidos);
    await tester.pumpAndSettle();
    expect(find.text('Transfer factor plus'), findsNothing);
    expect(find.text('4Life Transfer Factor Max'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
