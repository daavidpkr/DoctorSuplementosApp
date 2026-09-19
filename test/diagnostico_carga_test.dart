import 'dart:async';

import 'package:doctor_suplementos/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _completarFormulario(WidgetTester tester) async {
  final campos = find.byType(TextField);
  await tester.enterText(campos.at(0), 'Paciente prueba');
  await tester.enterText(campos.at(1), '35');
  await tester.enterText(
    campos.at(2),
    'Cansancio ocasional despues de poco descanso.',
  );
  await tester.ensureVisible(find.text('Selecciona una opcion'));
  await tester.tap(find.text('Selecciona una opcion'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Hombre').last);
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('GENERAR DIAGNÓSTICO'));
  await tester.tap(find.text('GENERAR DIAGNÓSTICO'));
  await tester.pump();
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
}

void _prepararVista(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 1600);
  tester.view.devicePixelRatio = 1;
  final manejadorFlutter = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('RenderFlex overflowed')) return;
    manejadorFlutter?.call(details);
  };
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(() => FlutterError.onError = manejadorFlutter);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      PerfilService.prefsKey: '{"nombre":"Socio","fotoBase64":""}',
    });
    PaisService.actual.value = PaisApp.ecuador;
    IdiomaService.actual.value = IdiomaApp.espanol;
  });

  testWidgets('rechazo de Gemini quita el indicador y muestra error',
      (tester) async {
    _prepararVista(tester);
    final respuesta = Completer<String>();
    await tester.pumpWidget(MaterialApp(
      home: FormularioPaciente(
        generarTexto: (_) => respuesta.future,
      ),
    ));
    await tester.pumpAndSettle();

    await _completarFormulario(tester);
    respuesta.completeError(
      const IaProxyException('GEMINI_RECHAZO', estadoHttp: 422),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.textContaining('no pudo responder'), findsOneWidget);
  });

  testWidgets('timeout quita el indicador despues del reintento',
      (tester) async {
    _prepararVista(tester);
    var intentos = 0;
    final respuestas = <Completer<String>>[];
    await tester.pumpWidget(MaterialApp(
      home: FormularioPaciente(
        generarTexto: (_) {
          intentos++;
          final respuesta = Completer<String>();
          respuestas.add(respuesta);
          return respuesta.future;
        },
      ),
    ));
    await tester.pumpAndSettle();

    await _completarFormulario(tester);
    respuestas[0].completeError(
      const IaProxyException('GEMINI_TIMEOUT', estadoHttp: 504),
    );
    await tester.pump(const Duration(milliseconds: 701));
    expect(intentos, 2);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    respuestas[1].completeError(
      const IaProxyException('GEMINI_TIMEOUT', estadoHttp: 504),
    );
    await tester.pumpAndSettle();

    expect(intentos, 2);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.textContaining('temporalmente ocupado'), findsOneWidget);
  });
}
