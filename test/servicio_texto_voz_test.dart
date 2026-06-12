import 'package:doctor_suplementos/services/servicio_texto_voz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServicioTextoVoz.prepararTexto', () {
    test('empieza en analisis del caso y elimina formato', () {
      const texto = '''
*DATOS DEL PACIENTE*
- Edad: 40 años

*SALUDO Y ANÁLISIS DEL CASO*
- **Situación:** Buen estado general.
- Recomendación número 1: beber agua.
''';

      expect(
        ServicioTextoVoz.prepararTexto(texto),
        'Análisis del caso. Situación: Buen estado general. '
        'Recomendación número 1: beber agua.',
      );
    });

    test('conserva letras numeros acentos y puntuacion', () {
      const texto = 'Respuesta #1: ¿Cómo estás? ¡Muy bien! *Listo* ✅';

      expect(
        ServicioTextoVoz.prepararTexto(texto),
        'Respuesta 1: ¿Cómo estás? ¡Muy bien! Listo',
      );
    });

    test('elimina guiones sin unir palabras', () {
      const texto = 'Plan diario - mañana: vitamina C — después, agua.';

      expect(
        ServicioTextoVoz.prepararTexto(texto),
        'Plan diario mañana: vitamina C después, agua.',
      );
    });
  });
}
