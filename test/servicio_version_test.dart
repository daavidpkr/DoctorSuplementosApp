import 'package:doctor_suplementos/services/servicio_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServicioVersion.esVersionInferior', () {
    test('compara mayor, menor y parche matematicamente', () {
      expect(ServicioVersion.esVersionInferior('1.9.9', '1.10.0'), isTrue);
      expect(ServicioVersion.esVersionInferior('2.0.0', '1.10.0'), isFalse);
      expect(ServicioVersion.esVersionInferior('1.10.0', '1.10.0'), isFalse);
    });

    test('tolera partes faltantes y sufijos de compilacion', () {
      expect(ServicioVersion.esVersionInferior('1.2', '1.2.1'), isTrue);
      expect(ServicioVersion.esVersionInferior('1.2.3+8', '1.2.3'), isFalse);
    });
  });
}
