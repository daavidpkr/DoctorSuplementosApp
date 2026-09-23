import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doctor_suplementos/main.dart';

void main() {
  testWidgets('shows quick home and opens categories with visible controls',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'instalacion_inicial_configurada_v1': true,
      PerfilService.prefsKey: '{"nombre":"Socio","fotoBase64":""}',
    });

    await tester.pumpWidget(const DoctorSuplementos());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('pais-ec')));
    await tester.pumpAndSettle();
    await tester
        .ensureVisible(find.byKey(const ValueKey('continuar-seleccion')));
    await tester.tap(find.byKey(const ValueKey('continuar-seleccion')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Hola, Socio'), findsOneWidget);
    expect(find.text(IdiomaService.texto('consult_products')), findsWidgets);
    expect(find.text(IdiomaService.texto('mitienda_catalog')), findsWidgets);
    expect(find.text('Catálogos PDF'), findsWidgets);
    expect(find.text(IdiomaService.texto('price_calculator')), findsWidgets);
    expect(find.text(IdiomaService.texto('diagnosis')), findsWidgets);
    expect(find.text('Chat Live 4Life'), findsWidgets);
    expect(find.text(IdiomaService.texto('ai_adviser')), findsWidgets);
    expect(find.byType(PageView), findsNothing);
    expect(find.byKey(const ValueKey('pagina-siguiente')), findsNothing);

    await tester.ensureVisible(find.text('Panel de Rendimiento'));
    await tester.pumpAndSettle();
    expect(find.text('Panel de Rendimiento'), findsOneWidget);
    expect(find.textContaining('Hola, Socio'), findsOneWidget);
  });

  testWidgets('home controls expose button semantics and named routes',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      PerfilService.prefsKey: '{"nombre":"Socio","fotoBase64":""}',
    });
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(MaterialApp(
      onGenerateRoute: generarRutaApp,
      home: const PantallaPrincipal(),
    ));
    await tester.pump();

    final card = tester.getSemantics(
      find.byKey(const ValueKey('acceso-/catalogo-afiliado')),
    );
    expect(card.flagsCollection.isButton, isTrue);
    expect(card.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    bool banderaTieneFoco() {
      final context = FocusManager.instance.primaryFocus?.context;
      if (context == null) return false;
      var encontrado =
          context.widget.key == const ValueKey<String>('bandera-pais-ec');
      context.visitAncestorElements((element) {
        encontrado = encontrado ||
            element.widget.key == const ValueKey<String>('bandera-pais-ec');
        return !encontrado;
      });
      return encontrado;
    }

    for (var i = 0; i < 40 && !banderaTieneFoco(); i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
    }
    expect(banderaTieneFoco(), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('selector-pais-idioma-inicio')),
        findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    semantics.dispose();

    await tester.pumpWidget(MaterialApp(
      onGenerateRoute: generarRutaApp,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.pushNamed(
            context,
            RutasApp.catalogoAfiliado,
          ),
          child: const Text('Abrir catalogo'),
        ),
      ),
    ));
    await tester.ensureVisible(find.text('Abrir catalogo'));
    await tester.tap(find.text('Abrir catalogo'));
    await tester.pumpAndSettle();

    expect(find.byType(ConsultaProductoPagina), findsOneWidget);
    final route = ModalRoute.of(
      tester.element(find.byType(ConsultaProductoPagina)),
    );
    expect(route?.settings.name, RutasApp.catalogoAfiliado);

    Navigator.of(tester.element(find.byType(ConsultaProductoPagina))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Abrir catalogo'), findsOneWidget);
  });

  test('all web routes have a named material route', () {
    const routes = <String>[
      RutasApp.catalogoAfiliado,
      RutasApp.catalogoMiTienda,
      RutasApp.catalogosPdf,
      RutasApp.calculadoraPrecios,
      RutasApp.optimizadorConsumo,
      RutasApp.optimizadorAcelerado,
      RutasApp.inventarioLocal,
      RutasApp.comparadorAB,
      RutasApp.diagnostico,
      RutasApp.cambioFisico,
      RutasApp.historial,
      RutasApp.chatLive,
      RutasApp.asesorIa,
      RutasApp.historialChatsIa,
      RutasApp.testimonios,
      RutasApp.diccionario,
      RutasApp.mapaAnatomico,
      RutasApp.impacto,
      RutasApp.perfil,
    ];

    for (final name in routes) {
      final route = generarRutaApp(RouteSettings(name: name));
      expect(route, isA<MaterialPageRoute<void>>(), reason: name);
      expect(route?.settings.name, name);
    }
  });

  testWidgets('fresh install starts on adviser profile', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const DoctorSuplementos());
    await tester.pumpAndSettle();

    expect(find.text('Perfil del asesor'), findsOneWidget);
    expect(find.text('Socio'), findsOneWidget);
  });
}
