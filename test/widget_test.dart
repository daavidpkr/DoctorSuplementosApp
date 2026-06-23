import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doctor_suplementos/main.dart';

void main() {
  testWidgets('shows main menu', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'instalacion_inicial_configurada_v1': true,
      PerfilService.prefsKey: '{"nombre":"Socio","fotoBase64":""}',
    });

    await tester.pumpWidget(const DoctorSuplementos());
    await tester.pumpAndSettle();

    expect(find.textContaining('Hola, Socio'), findsOneWidget);
    expect(find.text(IdiomaService.texto('consult_products')), findsWidgets);
    expect(find.text(IdiomaService.texto('diagnosis')), findsOneWidget);
    expect(find.text(IdiomaService.texto('history')), findsOneWidget);
    expect(find.text(IdiomaService.texto('ai_adviser')), findsOneWidget);
    expect(find.text(IdiomaService.texto('quick_access')), findsOneWidget);
  });

  testWidgets('fresh install starts on adviser profile', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const DoctorSuplementos());
    await tester.pumpAndSettle();

    expect(find.text('Perfil del asesor'), findsOneWidget);
    expect(find.text('Socio'), findsOneWidget);
  });
}
