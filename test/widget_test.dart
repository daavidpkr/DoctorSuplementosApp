// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_suplementos/main.dart';

void main() {
  testWidgets('shows main menu', (WidgetTester tester) async {
    await tester.pumpWidget(const DoctorSuplementos());

    expect(find.text('4Life Asesor Integral'), findsOneWidget);
    expect(find.text('Consultar producto(s)'), findsOneWidget);
    expect(find.text('Diagnóstico'), findsOneWidget);
    expect(find.text('Historial'), findsOneWidget);
    expect(find.text('Asesor IA 4Life'), findsOneWidget);
  });
}
