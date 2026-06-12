import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_suplementos/services/servicio_compartir.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('genera un PDF legible con secciones y productos', () async {
    final bytes = await ServicioCompartir.generarPdf(
      DocumentoCompartible(
        titulo: 'DIAGNÓSTICO DE PACIENTE',
        nombreArchivo: 'diagnostico_paciente',
        texto: 'Diagnóstico de prueba',
        paciente: 'Paciente',
        fecha: DateTime(2026, 6, 12),
        secciones: const [
          SeccionDocumento(
            titulo: 'Diagnóstico',
            contenido: 'Contenido clínico informativo de prueba.',
          ),
          SeccionDocumento(
            titulo: 'Recomendaciones',
            contenido: 'Mantener hidratación y descanso.',
          ),
        ],
        productos: const [
          ProductoDocumento(
            nombre: 'Transfer factor plus',
            imagenAsset: 'assets/productos/trasnfer_factor_plus.png',
            indicaciones: ['Dosis mañana: 1 cápsula'],
            detalle: 'Apoyo general para el sistema inmunitario.',
          ),
        ],
      ),
    );

    expect(bytes.length, greaterThan(1000));
    expect(ascii.decode(bytes.take(4).toList()), '%PDF');
  });
}
