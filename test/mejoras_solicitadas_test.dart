import 'dart:convert';

import 'package:doctor_suplementos/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'instalacion_inicial_configurada_v1': true,
      PerfilService.prefsKey:
          '{"nombre":"Socio","fotoBase64":"dato-historico","codigoSocio":"1"}',
    });
    PaisService.actual.value = PaisApp.ecuador;
    IdiomaService.actual.value = IdiomaApp.espanol;
  });

  testWidgets('Inicio cambia país e idioma solo después de confirmar',
      (tester) async {
    await tester.binding.setSurfaceSize(null);
    await tester.pumpWidget(const MaterialApp(home: PantallaPrincipal()));
    await tester.pump();

    expect(find.byKey(const ValueKey('bandera-pais-ec')), findsOneWidget);
    expect(find.text('EC'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('bandera-pais-ec')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('opcion-pais-us')));
    await tester.tap(find.byKey(const ValueKey('opcion-idioma-en')));
    expect(PaisService.actual.value, PaisApp.ecuador);
    expect(IdiomaService.actual.value, IdiomaApp.espanol);

    await tester
        .tap(find.byKey(const ValueKey('solicitar-confirmacion-mercado')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirmar-cambio-mercado')));
    await tester.pumpAndSettle();

    expect(PaisService.actual.value, PaisApp.estadosUnidos);
    expect(IdiomaService.actual.value, IdiomaApp.ingles);
    expect(find.byKey(const ValueKey('bandera-pais-us')), findsOneWidget);
    expect(productosConPrecioPaisActual.length, 76);
    expect(buscarProductoConPrecio('Super Greens')?.nombre, 'Super Greens');
    expect(buscarProductoConPrecio('Agpro'), isNull);
  });

  testWidgets('Inicio pagina dos grupos exactos sin scroll interno ni overflow',
      (tester) async {
    const principales = [
      '/catalogo-afiliado',
      '/catalogo-mitienda',
      '/catalogos-pdf',
      '/calculadora-precios',
      '/diagnostico',
      '/chat-live',
      '/asesor-ia',
    ];
    const categorias = [
      'catalogos',
      'panel_rendimiento',
      'diagnosticos',
      'analisis_control',
      'asistentes_ia',
      'recursos_aprendizaje',
    ];
    for (final size in const [
      Size(280, 700),
      Size(390, 844),
      Size(390, 600),
      Size(800, 1024),
      Size(1440, 900),
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(MaterialApp(
        key: ValueKey(size),
        home: const PantallaPrincipal(),
      ));
      await tester.pump();
      expect(find.byType(PageView), findsOneWidget);
      expect(find.text('Accesos rápidos 1/2'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('pagina-accesos-rapidos')),
          matching: find.byType(Scrollable),
        ),
        findsNothing,
      );
      for (final ruta in principales) {
        expect(find.byKey(ValueKey('principal-$ruta')), findsOneWidget);
      }
      final ordenPrincipales = tester
          .widgetList<Semantics>(find.descendant(
            of: find.byKey(const ValueKey('pagina-accesos-rapidos')),
            matching: find.byType(Semantics),
          ))
          .map((widget) => widget.key)
          .whereType<ValueKey<String>>()
          .map((key) => key.value)
          .where((key) => key.startsWith('principal-'))
          .toList();
      expect(
        ordenPrincipales,
        principales.map((ruta) => 'principal-$ruta').toList(),
      );
      expect(
        tester
            .widget<IconButton>(
              find.byKey(const ValueKey('pagina-anterior')),
            )
            .onPressed,
        isNull,
      );
      expect(tester.takeException(), isNull, reason: '$size página 1');

      final pais = PaisService.actual.value;
      final idioma = IdiomaService.actual.value;
      await tester.fling(
        find.byKey(const ValueKey('paginas-inicio')),
        const Offset(-1200, 0),
        1600,
      );
      await tester.pumpAndSettle();
      expect(find.text('Todas las funciones 2/2'), findsOneWidget);
      for (final id in categorias) {
        expect(find.byKey(ValueKey('categoria-$id')), findsOneWidget);
      }
      expect(find.byKey(const ValueKey('general-/perfil')), findsOneWidget);
      final ordenGeneral = tester
          .widgetList<Semantics>(find.descendant(
            of: find.byKey(const ValueKey('pagina-todas-funciones')),
            matching: find.byType(Semantics),
          ))
          .map((widget) => widget.key)
          .whereType<ValueKey<String>>()
          .map((key) => key.value)
          .where(
            (key) => key.startsWith('categoria-') || key == 'general-/perfil',
          )
          .toList();
      expect(
        ordenGeneral,
        [...categorias.map((id) => 'categoria-$id'), 'general-/perfil'],
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('pagina-todas-funciones')),
          matching: find.byType(Scrollable),
        ),
        findsNothing,
      );
      expect(
        tester
            .widget<IconButton>(
              find.byKey(const ValueKey('pagina-siguiente')),
            )
            .onPressed,
        isNull,
      );
      expect(PaisService.actual.value, pais);
      expect(IdiomaService.actual.value, idioma);
      expect(tester.takeException(), isNull, reason: '$size página 2');
    }
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('flechas sincronizan páginas e ignoran pulsaciones rápidas',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const MaterialApp(home: PantallaPrincipal()));
    await tester.pump();

    final siguiente = find.byKey(const ValueKey('pagina-siguiente'));
    await tester.tap(siguiente);
    await tester.tap(siguiente);
    await tester.pumpAndSettle();
    expect(find.text('Todas las funciones 2/2'), findsOneWidget);
    expect(
      tester.widget<IconButton>(siguiente).onPressed,
      isNull,
    );
    expect(
      tester
          .widget<IconButton>(
            find.byKey(const ValueKey('pagina-anterior')),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.byKey(const ValueKey('pagina-anterior')));
    await tester.pumpAndSettle();
    expect(find.text('Accesos rápidos 1/2'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Perfil ignora la foto histórica y no ofrece controles de foto',
      (tester) async {
    await tester.binding.setSurfaceSize(null);
    await tester.pumpWidget(const MaterialApp(home: PaginaPerfil()));
    await tester.pumpAndSettle();
    expect(find.text('Foto de perfil'), findsNothing);
    expect(find.text('Cambiar foto'), findsNothing);
    expect(find.byIcon(Icons.photo_camera_rounded), findsNothing);
    expect(find.text('Nombre del asesor'), findsOneWidget);
  });

  test('nombres oficiales conservan IDs, alias y unicidad', () {
    expect(nombreProductoVisible('Transfer factor MAX'),
        '4Life Transfer Factor Max');
    expect(nombreProductoVisible('Transfer factor plus'),
        '4Life Transfer Factor Plus Tri-Factor Formula');
    expect(nombreProductoVisible('Colageno tipo i'),
        '4Life Transfer Factor Collagen');
    expect(
        buscarProductoPermitido('Transfer factor MAX'), 'Transfer factor MAX');
    expect(buscarProductoPermitido('4Life Transfer Factor Max'),
        'Transfer factor MAX');
    expect(buscarProductoPermitido('Transfer factor plus'),
        'Transfer factor plus');
    expect(
        buscarProductoPermitido(
            '4Life Transfer Factor Plus Tri-Factor Formula'),
        'Transfer factor plus');
    expect(
      productosConPrecioEcuador.map((p) => p.nombreVisible).toSet().length,
      productosConPrecioEcuador.length,
    );
  });

  testWidgets('Presentación larga se adapta en Ecuador y USA', (tester) async {
    await tester.binding.setSurfaceSize(null);
    await tester.pumpWidget(const MaterialApp(home: ConsultaProductoPagina()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Belle vie');
    await tester.pump();
    await tester.tap(find.text('4Life Transfer Factor Belle Vie'));
    await tester.pumpAndSettle();
    expect(find.text('Presentación'), findsOneWidget);
    expect(find.text('60 cápsulas vegetales'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cancelar y eliminar afectan solo el historial elegido',
      (tester) async {
    await tester.binding.setSurfaceSize(null);
    final registros = [
      {
        'fecha': '2026-09-22 10:00',
        'titulo': 'Diagnóstico Ana',
        'nombre': 'Ana',
        'resultado': 'Resultado A',
        'datos': {'nombre': 'Ana', 'pais': 'ec'},
        'tipo': 'diagnostico',
      },
      {
        'fecha': '2026-09-21 09:00',
        'titulo': 'Diagnóstico Luis',
        'nombre': 'Luis',
        'resultado': 'Resultado B',
        'datos': {'nombre': 'Luis', 'pais': 'ec'},
        'tipo': 'diagnostico',
      },
    ];
    SharedPreferences.setMockInitialValues({
      HistorialService.prefsKey: registros.map(jsonEncode).toList(),
    });
    await tester.pumpWidget(const MaterialApp(home: PaginaHistorial()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Paciente: Ana'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Ana'), findsOneWidget);
    var prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList(HistorialService.prefsKey), hasLength(2));

    await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    await tester.pumpAndSettle();
    await tester
        .tap(find.byKey(const ValueKey('eliminar-historial-confirmado')));
    await tester.pumpAndSettle();
    expect(find.text('Ana'), findsNothing);
    prefs = await SharedPreferences.getInstance();
    final guardados = prefs.getStringList(HistorialService.prefsKey)!;
    expect(guardados, hasLength(1));
    expect(guardados.single, contains('Luis'));
  });
}
