import 'package:doctor_suplementos/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'instalacion_inicial_configurada_v1': true,
      PerfilService.prefsKey: '{"nombre":"Socio","fotoBase64":""}',
      PaisService.prefsKey: 'us',
    });
    IdiomaService.actual.value = IdiomaApp.espanol;
    PaisService.actual.value = PaisApp.estadosUnidos;
  });

  Future<void> continuar(WidgetTester tester) async {
    await tester.pumpAndSettle();
    final boton = find.byKey(const ValueKey('continuar-seleccion'));
    await tester.ensureVisible(boton);
    await tester.tap(boton);
    await tester.pumpAndSettle();
  }

  testWidgets('requires an explicit country even with a saved country',
      (tester) async {
    await tester.pumpWidget(const DoctorSuplementos());
    await tester.pumpAndSettle();
    expect(find.byType(PaginaSeleccionPais), findsOneWidget);
    expect(find.byType(PaginaPerfil), findsNothing);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
    expect(find.text('Elige tu país'), findsOneWidget);
    expect(find.text('Select your country'), findsOneWidget);
  });

  for (final pais in PaisApp.values) {
    testWidgets('saves ${pais.codigo}, opens home and profile reflects it',
        (tester) async {
      await tester.pumpWidget(const DoctorSuplementos());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('pais-${pais.codigo}')));
      await continuar(tester);
      expect(PaisService.actual.value, pais);
      expect(await PaisService.cargar(), pais);
      expect(find.byType(PantallaPrincipal), findsOneWidget);
      expect(find.byType(PaginaSeleccionPais), findsNothing);
      await tester.tap(find.byIcon(Icons.person_outline_rounded));
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<SelectorEstilizado<PaisApp>>(
                  find.byType(SelectorEstilizado<PaisApp>))
              .valor,
          pais);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(PaginaSeleccionPais), findsNothing);
      final context = tester.element(find.byType(PantallaPrincipal));
      expect(Navigator.of(context).canPop(), isFalse);

      // Simula un arranque nuevo, conservando SharedPreferences.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(const DoctorSuplementos());
      await tester.pumpAndSettle();
      expect(find.byType(PaginaSeleccionPais), findsOneWidget);
      expect(find.byType(PaginaPerfil), findsNothing);
      expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
          isNull);
    });
  }

  testWidgets(
      'local language preserves country and saving does not restart navigation',
      (tester) async {
    await tester.pumpWidget(const DoctorSuplementos());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('pais-us')));
    final state = tester.state(find.byType(PaginaSeleccionPais));
    final selector = tester.widget<SelectorEstilizado<IdiomaApp>>(
        find.byType(SelectorEstilizado<IdiomaApp>));
    selector.onChanged(IdiomaApp.ingles);
    await tester.pumpAndSettle();
    expect(tester.state(find.byType(PaginaSeleccionPais)), same(state));
    expect(find.text('United States'), findsOneWidget);
    expect(find.text('Select your language'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(IdiomaService.actual.value, IdiomaApp.espanol);
    await continuar(tester);
    expect(await IdiomaService.cargar(), IdiomaApp.ingles);
    expect(PaisService.actual.value, PaisApp.estadosUnidos);
    expect(find.byType(PantallaPrincipal), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pumpAndSettle();
    final perfilState = tester.state(find.byType(PaginaPerfil));
    tester
        .widget<SelectorEstilizado<IdiomaApp>>(
            find.byType(SelectorEstilizado<IdiomaApp>))
        .onChanged(IdiomaApp.espanol);
    await tester.pumpAndSettle();
    expect(tester.state(find.byType(PaginaPerfil)), same(perfilState));
    expect(find.byType(PaginaSeleccionPais), findsNothing);
    tester
        .widget<SelectorEstilizado<PaisApp>>(
            find.byType(SelectorEstilizado<PaisApp>))
        .onChanged(PaisApp.ecuador);
    await tester.pumpAndSettle();
    expect(await PaisService.cargar(), PaisApp.ecuador);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text(IdiomaService.texto('home')), findsOneWidget);
    expect(find.byType(PaginaSeleccionPais), findsNothing);
  });

  testWidgets('fresh install saves initial profile before showing the selector',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const DoctorSuplementos());
    await tester.pumpAndSettle();
    expect(find.byType(PaginaPerfil), findsOneWidget);
    final guardar = find.text('Guardar perfil');
    await tester.ensureVisible(guardar);
    await tester.tap(guardar);
    await tester.pumpAndSettle();
    expect(find.byType(PaginaSeleccionPais), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('pais-ec')));
    await tester.tap(find.byKey(const ValueKey('pais-ec')));
    await continuar(tester);
    expect(find.byType(PantallaPrincipal), findsOneWidget);
  });

  testWidgets('ignores duplicate confirmation while saving', (tester) async {
    var confirmaciones = 0;
    await tester.pumpWidget(MaterialApp(
        home: PaginaSeleccionPais(
      onContinuar: () => confirmaciones++,
    )));
    await tester.ensureVisible(find.byKey(const ValueKey('pais-ec')));
    await tester.tap(find.byKey(const ValueKey('pais-ec')));
    await tester.pump();
    final accion =
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed!;
    accion();
    accion();
    await tester.pump();
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
    await tester.pump(const Duration(milliseconds: 100));
    expect(confirmaciones, 1);
  });

  for (final size in [
    const Size(280, 480),
    const Size(390, 844),
    const Size(1440, 900)
  ]) {
    testWidgets('scrolls without overflow at $size with large text',
        (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: PaginaSeleccionPais(onContinuar: () {}),
      ));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('pais-us')));
      await tester.tap(find.byKey(const ValueKey('pais-us')));
      await tester.ensureVisible(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
          isNotNull);
    });
  }
}
