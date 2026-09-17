import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:doctor_suplementos/main.dart';
import 'package:doctor_suplementos/ui/pantalla_resultado_ficha.dart';

void main() {
  test('separa siempre las secciones principales del diagnostico', () {
    const texto = '''
*ANALISIS DEL CASO*
Nuestro objetivo es comprender el caso sin confundir esta frase con un titulo.
*NUESTRO OBJETIVO*
Vigilar los datos clinicos.
*SUSTRATO Y RESPALDO RECOMENDADO*
*1. Riovida Jugo*
- *Dosis mañana:* 30 ml
-
- *Dosis tarde:* 30 ml
- *Por que se elige:* Apoyo antioxidante.
- *Beneficio clave:* Proteccion celular.
*RECOMENDACIONES DE BIENESTAR GENERAL*
- Mantener seguimiento medico.
*Nota de seguridad:* No sustituye el tratamiento medico.
''';

    final contenido = ContenidoResultadoFicha.desdeTexto(
      texto,
      const {'Riovida Jugo': 'assets/images/riovida.png'},
    );

    expect(contenido.analisis, contains('Nuestro objetivo es comprender'));
    expect(contenido.objetivo, 'Vigilar los datos clinicos.');
    expect(contenido.productos, hasLength(1));
    expect(contenido.productos.single.dosis, hasLength(2));
    expect(contenido.recomendaciones, 'Mantener seguimiento medico.');
    expect(contenido.nota, 'No sustituye el tratamiento medico.');
  });

  testWidgets('USA detecta Super Greens, muestra precios y placeholder',
      (tester) async {
    const texto = '''
*ANALISIS DEL CASO*
Consulta informativa sin contenido JSON.
*NUESTRO OBJETIVO*
Conocer el producto.
*SUSTRATO Y RESPALDO RECOMENDADO*
*1. Super Greens*
- *Forma de uso:* No documentado en el catálogo; revisa la etiqueta vigente.
- *Por qué se elige:* Es el producto consultado.
- *Beneficio clave:* Apoyo nutricional documentado.
*RECOMENDACIONES DE BIENESTAR GENERAL*
- Revisar la etiqueta.
*Nota de seguridad:* No sustituye atención médica.
''';

    await tester.pumpWidget(
      MaterialApp(
        home: PantallaResultadoFicha(
          titulo: 'Resultado',
          tipoFicha: 'Diagnóstico',
          paciente: 'Ana',
          nombreAsesor: 'David',
          especialidad: 'Bienestar',
          resultado: texto,
          fecha: DateTime(2026, 9, 16),
          imagenesProducto: {},
          preciosProducto: {
            'Super Greens': PrecioProductoResultadoFicha(
              afiliado: 25,
              publico: 32,
              promocional: 28,
              lp: 20,
              presentacion: '30 porciones',
            ),
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Super Greens'), findsOneWidget);
    expect(find.text('Precio público'), findsOneWidget);
    expect(find.text('Precio MiTienda'), findsOneWidget);
    expect(find.text('Precio mayorista'), findsOneWidget);
    expect(find.text('LP'), findsOneWidget);
    expect(find.text('Presentación'), findsOneWidget);
    expect(find.byIcon(Icons.medication_liquid_outlined), findsWidgets);
    expect(find.textContaining('{'), findsNothing);
  });

  test('reconoce todos los nombres oficiales localizados de USA', () {
    PaisService.actual.value = PaisApp.estadosUnidos;
    IdiomaService.actual.value = IdiomaApp.espanol;
    final precios = preciosResultadoPaisActual;
    for (final producto in catalogoProductosEstadosUnidos) {
      for (final nombre in {
        producto.id,
        producto.nombreEspanol,
        producto.nombreIngles,
      }) {
        final contenido = ContenidoResultadoFicha.desdeTexto(
          '''
*ANALISIS DEL CASO*
Caso informativo.
*NUESTRO OBJETIVO*
Orientar.
*SUSTRATO Y RESPALDO RECOMENDADO*
*1. $nombre*
- *Forma de uso:* No documentado en el catálogo; revisa la etiqueta vigente.
- *Por qué se elige:* Producto consultado.
- *Beneficio clave:* Apoyo documentado.
*RECOMENDACIONES DE BIENESTAR GENERAL*
- Revisar la etiqueta.
*Nota de seguridad:*
No sustituye atención médica.
''',
          const {},
          productosDisponibles: precios.keys,
        );
        expect(contenido.productos, hasLength(1), reason: nombre);
        expect(precios[contenido.productos.single.nombre], isNotNull,
            reason: nombre);
      }
    }
  });
}
