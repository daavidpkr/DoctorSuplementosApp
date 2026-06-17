import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_suplementos/main.dart';

void main() {
  group('busqueda diferenciada de productos', () {
    test('distingue Transfer factor tri factor de Transfer factor plus', () {
      expect(
        buscarProductoPermitido('transfer factor tri factor'),
        'Transfer factor tri factor',
      );
      expect(
        buscarProductoConPrecio('tri factor')?.nombre,
        'Transfer factor tri factor',
      );
      expect(
        buscarProductoPermitido('transfer factor plus'),
        'Transfer factor plus',
      );
      expect(
        buscarProductoConPrecio('plus')?.nombre,
        'Transfer factor plus',
      );
    });

    test('distingue Riovida stix, Riovida burst y Energy go stix', () {
      expect(buscarProductoPermitido('riovida stix'), 'Riovida stix');
      expect(buscarProductoConPrecio('riovida')?.nombre, 'Riovida stix');
      expect(buscarProductoPermitido('riovida burst'), 'Riovida burst');
      expect(buscarProductoConPrecio('burst')?.nombre, 'Riovida burst');
      expect(buscarProductoPermitido('energy go stix'), 'Energy go stix');
      expect(buscarProductoConPrecio('energy')?.nombre, 'Energy go stix');
    });
  });
}
