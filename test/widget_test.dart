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
    expect(find.text('Consultar producto(s)'), findsOneWidget);
    expect(find.text('Diagnóstico'), findsOneWidget);
    expect(find.text('Historial'), findsOneWidget);
    expect(find.text('Asesor IA 4Life'), findsOneWidget);
    expect(find.text('Accesos rápidos'), findsOneWidget);
  });

  testWidgets('fresh install starts on adviser profile', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const DoctorSuplementos());
    await tester.pumpAndSettle();

    expect(find.text('Perfil del asesor'), findsOneWidget);
    expect(find.text('Socio'), findsOneWidget);
  });
}
