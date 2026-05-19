import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_suplementos/main.dart';

void main() {
  testWidgets('shows main menu', (WidgetTester tester) async {
    await tester.pumpWidget(const DoctorSuplementos());

    expect(find.textContaining('Hola, Asesor'), findsOneWidget);
    expect(find.text('Consultar producto(s)'), findsOneWidget);
    expect(find.text('Diagnostico'), findsOneWidget);
    expect(find.text('Historial'), findsOneWidget);
    expect(find.text('Asesor IA 4Life'), findsOneWidget);
    expect(find.text('Accesos rapidos'), findsOneWidget);
  });
}
