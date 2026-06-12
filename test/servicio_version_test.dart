import 'package:doctor_suplementos/services/servicio_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServicioVersion.esVersionInferior', () {
    test('compara mayor, menor y parche matematicamente', () {
      expect(ServicioVersion.esVersionInferior('1.9.9', '1.10.0'), isTrue);
      expect(ServicioVersion.esVersionInferior('2.0.0', '1.10.0'), isFalse);
      expect(ServicioVersion.esVersionInferior('1.10.0', '1.10.0'), isFalse);
    });

    test('tolera partes faltantes rellenando matematicamente con cero', () {
      expect(ServicioVersion.esVersionInferior('1.2', '1.2.1'), isTrue);
      expect(ServicioVersion.esVersionInferior('1.2.0', '1.2'), isFalse);
    });

    test('compara cada bloque como entero y no como texto', () {
      expect(ServicioVersion.esVersionInferior('1.2.10', '1.2.9'), isFalse);
      expect(ServicioVersion.esVersionInferior('10.0.0', '9.99.99'), isFalse);
    });
  });
}
