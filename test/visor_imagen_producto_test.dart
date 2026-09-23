import 'package:doctor_suplementos/main.dart';
import 'package:doctor_suplementos/ui/visor_imagen_producto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const imagenEcuador = 'assets/productos/productos-ec/agpro.webp';

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'instalacion_inicial_configurada_v1': true,
    });
    PaisService.actual.value = PaisApp.ecuador;
    IdiomaService.actual.value = IdiomaApp.espanol;
  });

  Future<void> montarImagen(
    WidgetTester tester, {
    String? asset = imagenEcuador,
    Size size = const Size(390, 844),
  }) async {
    await tester.binding.setSurfaceSize(size);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 260,
              height: 220,
              child: ImagenProductoAmpliable(
                imagenAsset: asset,
                nombreProducto: 'Producto de prueba',
                ingles: false,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('abre asset local, limita zoom y permite desplazamiento',
      (tester) async {
    await montarImagen(tester);
    expect(find.byIcon(Icons.zoom_in_rounded), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('imagen-producto-ampliable')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('visor-imagen-producto')), findsOneWidget);
    var visor =
        tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
    expect(visor.minScale, 1);
    expect(visor.maxScale, 5);
    expect(visor.panEnabled, isFalse);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Image && widget.image is NetworkImage,
      ),
      findsNothing,
    );

    final centro = tester.getCenter(find.byType(InteractiveViewer));
    await tester.tapAt(centro);
    await tester.pump(const Duration(milliseconds: 40));
    await tester.tapAt(centro);
    await tester.pumpAndSettle();
    visor = tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
    expect(visor.transformationController!.value.getMaxScaleOnAxis(), 2.5);
    expect(visor.panEnabled, isTrue);

    for (var i = 0; i < 20; i++) {
      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: centro,
          scrollDelta: const Offset(0, -100),
        ),
      );
    }
    await tester.pump();
    visor = tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
    expect(
      visor.transformationController!.value.getMaxScaleOnAxis(),
      lessThanOrEqualTo(5.0001),
    );

    final antes = Matrix4.copy(visor.transformationController!.value);
    await tester.drag(find.byType(InteractiveViewer), const Offset(30, 20));
    await tester.pump(const Duration(milliseconds: 400));
    visor = tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
    expect(visor.transformationController!.value, isNot(equals(antes)));

    for (var i = 0; i < 40; i++) {
      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: centro,
          scrollDelta: const Offset(0, 100),
        ),
      );
    }
    await tester.pump();
    visor = tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
    expect(
      visor.transformationController!.value.getMaxScaleOnAxis(),
      greaterThanOrEqualTo(0.9999),
    );
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('cerrar conserva la ficha abierta y Escape cierra el visor',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ConsultaProductoPagina()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Agpro');
    await tester.pumpAndSettle();
    await tester.tap(find.text('4Life Transfer Factor AG-Pro').first);
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('imagen-producto-ampliable')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('visor-imagen-producto')), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('visor-imagen-producto')), findsNothing);
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('4Life Transfer Factor AG-Pro'), findsWidgets);
  });

  testWidgets('funciona con una ficha USA y vuelve a la misma ficha',
      (tester) async {
    await PaisService.guardar(PaisApp.estadosUnidos);
    await tester.pumpWidget(const MaterialApp(home: ConsultaProductoPagina()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Super Greens');
    await tester.pumpAndSettle();
    final producto = find.byWidgetPredicate(
      (widget) => widget is Text && widget.data == 'Super Greens',
    );
    expect(producto, findsOneWidget);
    await tester.ensureVisible(producto);
    await tester.tap(producto);
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('imagen-producto-ampliable')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('visor-imagen-producto')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('cerrar-visor-imagen')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('visor-imagen-producto')), findsNothing);
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Super Greens'), findsWidgets);
  });

  testWidgets('placeholder no abre el visor', (tester) async {
    await montarImagen(tester, asset: null);
    expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
    expect(find.byIcon(Icons.zoom_in_rounded), findsNothing);
    await tester.tap(find.byKey(const ValueKey('imagen-producto-ampliable')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('visor-imagen-producto')), findsNothing);
  });

  testWidgets('no presenta overflow en anchos objetivo', (tester) async {
    for (final size in const [
      Size(280, 700),
      Size(390, 844),
      Size(1440, 900),
    ]) {
      await montarImagen(tester, size: size);
      await tester.tap(find.byKey(const ValueKey('imagen-producto-ampliable')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$size');
      await tester.tap(find.byKey(const ValueKey('cerrar-visor-imagen')));
      await tester.pumpAndSettle();
    }
    await tester.binding.setSurfaceSize(null);
  });
}
