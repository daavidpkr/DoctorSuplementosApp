import 'package:flutter_test/flutter_test.dart';
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
}
