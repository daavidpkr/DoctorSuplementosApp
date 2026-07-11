import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doctor_suplementos/main.dart';

void main() {
  testWidgets('shows quick home and opens categories with a left swipe',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'instalacion_inicial_configurada_v1': true,
      PerfilService.prefsKey: '{"nombre":"Socio","fotoBase64":""}',
    });

    await tester.pumpWidget(const DoctorSuplementos());
    await tester.pumpAndSettle();

    expect(find.textContaining('Hola, Socio'), findsOneWidget);
    expect(find.text(IdiomaService.texto('consult_products')), findsWidgets);
    expect(find.text(IdiomaService.texto('mitienda_catalog')), findsOneWidget);
    expect(find.text('Catálogos PDF'), findsOneWidget);
    expect(find.text(IdiomaService.texto('price_calculator')), findsOneWidget);
    expect(find.text(IdiomaService.texto('diagnosis')), findsOneWidget);
    expect(find.text('Chat Live 4Life'), findsOneWidget);
    expect(find.text(IdiomaService.texto('ai_adviser')), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text(IdiomaService.texto('history')), findsOneWidget);
    expect(find.text('Panel de Rendimiento'), findsOneWidget);
    expect(find.textContaining('Hola, Socio'), findsOneWidget);
  });

  testWidgets('fresh install starts on adviser profile', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const DoctorSuplementos());
    await tester.pumpAndSettle();

    expect(find.text('Perfil del asesor'), findsOneWidget);
    expect(find.text('Socio'), findsOneWidget);
  });
}
