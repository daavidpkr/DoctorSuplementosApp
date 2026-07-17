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

    test('incluye Aloe Vera Stix Tropical con precios completos', () {
      final producto = buscarProductoConPrecio('aloe vera tropical');

      expect(buscarProductoPermitido('aloe stix'), 'Aloe Vera Stix Tropical');
      expect(producto?.nombre, 'Aloe Vera Stix Tropical');
      expect(producto?.afiliado, 40.04);
      expect(producto?.publico, 53.39);
      expect(producto?.lp, 22);
      expect(precioPromocionalMiTienda('Aloe Vera Stix Tropical'), 42.72);
    });

    test('distingue Transfer factor MAX y Riovida Jugo', () {
      final max = buscarProductoConPrecio('1 max');
      final jugo = buscarProductoConPrecio('jugo');

      expect(buscarProductoPermitido('tf max'), 'Transfer factor MAX');
      expect(max?.nombre, 'Transfer factor MAX');
      expect(max?.afiliado, 109.25);
      expect(max?.publico, 145.30);
      expect(max?.lp, 75);
      expect(precioPromocionalMiTienda('Transfer factor MAX'), 116.24);

      expect(buscarProductoPermitido('riovida jugo'), 'Riovida Jugo');
      expect(jugo?.nombre, 'Riovida Jugo');
      expect(jugo?.afiliado, 72.73);
      expect(jugo?.publico, 54.68);
      expect(jugo?.lp, 32);
      expect(jugo?.lpCanje, 57);
      expect(precioPromocionalMiTienda('Riovida Jugo'), 58.18);
    });
  });

  group('LP operativo y LP de canje', () {
    test('mantiene ambos valores independientes', () {
      final casos = <String, (int, int?)>{
        'Nutrastart': (30, 80),
        'Protf': (26, 100),
        'Riovida stix': (20, 44),
        'Crema cuerpo': (8, 18),
        'Suero': (27, null),
        'Transfer factor MAX': (75, null),
      };

      for (final entry in casos.entries) {
        final producto = productosConPrecio4Life.firstWhere(
          (producto) => producto.nombre == entry.key,
        );
        expect(producto.lp, entry.value.$1, reason: entry.key);
        expect(producto.lpCanje, entry.value.$2, reason: entry.key);
      }
    });

    test('excluye cosmeticos de los optimizadores', () {
      const excluidos = {
        'Tonico',
        'Limpiador',
        'Crema cuerpo',
        'Crema humectante',
        'Crema para los ojos',
      };

      expect(productosExcluidosOptimizadores4Life, excluidos);
      expect(
        productosConPrecio4Life
            .where(productoDisponibleEnOptimizadores)
            .map((producto) => producto.nombre),
        everyElement(isNot(isIn(excluidos))),
      );
    });
  });
}
