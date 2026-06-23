import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_suplementos/services/servicio_compartir.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('genera link de WhatsApp para orden de compra con totales', () {
    final link = generarLinkWhatsApp(
      const [
        ProductoOrdenCompra(
          nombre: 'Transfer factor plus',
          precioAfiliado: 42.5,
          cantidad: 2,
          puntosLP: 30,
        ),
        ProductoOrdenCompra(
          nombre: 'RioVida Stix',
          precioAfiliado: 25,
          cantidad: 1,
          puntosLP: 18,
        ),
      ],
      numeroWhatsApp: '0959848545',
    );

    final uri = Uri.parse(link);
    final mensaje = Uri.decodeComponent(uri.queryParameters['text'] ?? '');

    expect(uri.toString(), startsWith('https://wa.me/593959848545?text='));
    expect(mensaje, contains('*2x Transfer factor plus*'));
    expect(mensaje, contains('- Precio Afiliado: \$85.00'));
    expect(mensaje, contains('- Puntos LP: 60'));
    expect(mensaje, contains('*TOTAL A PAGAR:* \$110.00'));
    expect(mensaje, contains('*TOTAL LP:* 78'));
  });

  test('genera un PDF legible con secciones, productos y orden de compra',
      () async {
    final bytes = await ServicioCompartir.generarPdf(
      DocumentoCompartible(
        titulo: 'DIAGNOSTICO DE PACIENTE',
        nombreArchivo: 'diagnostico_paciente',
        texto: 'Diagnostico de prueba',
        paciente: 'Paciente',
        fecha: DateTime(2026, 6, 12),
        secciones: const [
          SeccionDocumento(
            titulo: 'Diagnostico',
            contenido: 'Contenido clinico informativo de prueba.',
          ),
          SeccionDocumento(
            titulo: 'Recomendaciones',
            contenido: 'Mantener hidratacion y descanso.',
          ),
        ],
        productos: const [
          ProductoDocumento(
            nombre: 'Transfer factor plus',
            imagenAsset:
                'assets/productos/productos-ec/trasnfer_factor_plus.png',
            indicaciones: [
              'Dosis manana: 1 capsula',
              'Precio afiliado: \$42.50',
              'LP: 30',
            ],
            precioAfiliado: 42.5,
            puntosLP: 30,
            detalle: 'Apoyo general para el sistema inmunitario.',
          ),
        ],
        numeroWhatsAppCompra: '0959848545',
      ),
    );

    expect(bytes.length, greaterThan(1000));
    expect(ascii.decode(bytes.take(4).toList()), '%PDF');
  });
}
