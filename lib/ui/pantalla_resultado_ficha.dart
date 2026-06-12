import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../services/servicio_texto_voz.dart';

class ProductoResultadoFicha {
  final String nombre;
  final String? imagen;
  final List<String> dosis;
  final String beneficio;

  const ProductoResultadoFicha({
    required this.nombre,
    required this.imagen,
    required this.dosis,
    required this.beneficio,
  });
}

class ContenidoResultadoFicha {
  final String analisis;
  final String objetivo;
  final List<ProductoResultadoFicha> productos;
  final String recomendaciones;
  final String nota;

  const ContenidoResultadoFicha({
    required this.analisis,
    required this.objetivo,
    required this.productos,
    required this.recomendaciones,
    required this.nota,
  });

  static ContenidoResultadoFicha desdeTexto(
    String texto,
    Map<String, String> imagenesProducto,
  ) {
    final lineas = texto
        .replaceAll('\r', '')
        .split('\n')
        .map(_limpiar)
        .where((linea) => linea.isNotEmpty)
        .toList();
    final productos = <ProductoResultadoFicha>[];
    final analisis = <String>[];
    final recomendaciones = <String>[];
    final nota = <String>[];
    var seccion = 'analisis';
    _ProductoTemporal? actual;

    void guardarProducto() {
      if (actual == null) return;
      productos.add(
        ProductoResultadoFicha(
          nombre: actual!.nombre,
          imagen: actual!.imagen,
          dosis: List.unmodifiable(actual!.dosis),
          beneficio: actual!.beneficio.join(' ').trim(),
        ),
      );
      actual = null;
    }

    for (final linea in lineas) {
      final normalizada = _normalizar(linea);
      if (_contiene(normalizada, const [
        'saludo y analisis',
        'analisis del caso',
        'saludo y analisis fisico',
      ])) {
        guardarProducto();
        seccion = 'analisis';
        continue;
      }
      if (_contiene(normalizada, const [
        'sustrato y respaldo',
        'plan de apoyo 4life',
        'productos recomendados',
      ])) {
        guardarProducto();
        seccion = 'productos';
        continue;
      }
      if (_contiene(normalizada, const [
        'recomendaciones de bienestar',
        'habitos para el objetivo',
        'recomendacion general',
      ])) {
        guardarProducto();
        seccion = 'recomendaciones';
        continue;
      }
      if (normalizada.startsWith('nota de seguridad') ||
          normalizada.startsWith('nota responsable')) {
        guardarProducto();
        seccion = 'nota';
        final contenido = linea.split(':').skip(1).join(':').trim();
        if (contenido.isNotEmpty) nota.add(contenido);
        continue;
      }

      final producto = _detectarProducto(linea, imagenesProducto.keys);
      final numerado = RegExp(r'^\s*\d+\s*[\.\)]\s*').hasMatch(linea);
      if (seccion == 'productos' &&
          producto != null &&
          (numerado || actual == null)) {
        guardarProducto();
        actual = _ProductoTemporal(
          nombre: producto,
          imagen: imagenesProducto[producto],
        );
        continue;
      }

      if (seccion == 'productos' && actual != null) {
        final contenido = linea.replaceFirst(RegExp(r'^[-•]\s*'), '').trim();
        final campo = _normalizar(contenido);
        if (campo.startsWith('dosis ')) {
          actual!.dosis.add(contenido);
        } else if (campo.startsWith('beneficio clave') ||
            campo.startsWith('apoyo principal') ||
            actual!.beneficio.isNotEmpty) {
          actual!.beneficio.add(contenido);
        } else {
          actual!.dosis.add(contenido);
        }
        continue;
      }

      final contenido = linea.replaceFirst(RegExp(r'^[-•]\s*'), '').trim();
      if (seccion == 'recomendaciones') {
        recomendaciones.add(contenido);
      } else if (seccion == 'nota') {
        nota.add(contenido);
      } else {
        analisis.add(contenido);
      }
    }
    guardarProducto();

    final corte = analisis.length > 2 ? 2 : analisis.length;
    return ContenidoResultadoFicha(
      analisis: analisis.take(corte).join('\n\n'),
      objetivo: analisis.skip(corte).join(' '),
      productos: productos,
      recomendaciones: recomendaciones.join('\n'),
      nota: nota.join(' '),
    );
  }

  static bool _contiene(String linea, List<String> opciones) =>
      opciones.any(linea.contains);

  static String? _detectarProducto(
    String linea,
    Iterable<String> productos,
  ) {
    final limpia = _normalizar(
      linea.replaceFirst(RegExp(r'^\s*\d+\s*[\.\)]\s*'), ''),
    );
    final compacta = limpia.replaceAll(' ', '');
    String? mejor;
    var longitud = 0;
    for (final producto in productos) {
      final clave = _normalizar(producto);
      final claveCompacta = clave.replaceAll(' ', '');
      final esColageno = clave == 'colageno tipo i' &&
          limpia.contains('transfer factor colageno');
      if ((limpia.contains(clave) ||
              clave.contains(limpia) ||
              compacta.contains(claveCompacta) ||
              claveCompacta.contains(compacta) ||
              esColageno) &&
          clave.length > longitud) {
        mejor = producto;
        longitud = clave.length;
      }
    }
    return mejor;
  }

  static String _limpiar(String texto) => texto
      .replaceAll(RegExp(r'[*#_`]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static String _normalizar(String texto) => texto
      .toLowerCase()
      .replaceAll(RegExp(r'[áàäâ]'), 'a')
      .replaceAll(RegExp(r'[éèëê]'), 'e')
      .replaceAll(RegExp(r'[íìïî]'), 'i')
      .replaceAll(RegExp(r'[óòöô]'), 'o')
      .replaceAll(RegExp(r'[úùüû]'), 'u')
      .replaceAll('ñ', 'n')
      .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

class _ProductoTemporal {
  final String nombre;
  final String? imagen;
  final List<String> dosis = [];
  final List<String> beneficio = [];

  _ProductoTemporal({required this.nombre, required this.imagen});
}

class PantallaResultadoFicha extends StatefulWidget {
  final String titulo;
  final String tipoFicha;
  final String paciente;
  final String nombreAsesor;
  final String especialidad;
  final String resultado;
  final DateTime fecha;
  final Map<String, String> imagenesProducto;

  const PantallaResultadoFicha({
    super.key,
    required this.titulo,
    required this.tipoFicha,
    required this.paciente,
    required this.nombreAsesor,
    required this.especialidad,
    required this.resultado,
    required this.fecha,
    required this.imagenesProducto,
  });

  @override
  State<PantallaResultadoFicha> createState() => _PantallaResultadoFichaState();
}

class _PantallaResultadoFichaState extends State<PantallaResultadoFicha> {
  static const azul = Color(0xFF111F77);
  static const violeta = Color(0xFF5145D8);
  static const texto = Color(0xFF17204B);
  late final ContenidoResultadoFicha contenido;
  bool reproduciendo = false;

  @override
  void initState() {
    super.initState();
    contenido = ContenidoResultadoFicha.desdeTexto(
      widget.resultado,
      widget.imagenesProducto,
    );
  }

  @override
  void dispose() {
    ServicioTextoVoz.detener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Column(
        children: [
          _encabezado(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    children: [
                      _tarjetaDatos(),
                      const SizedBox(height: 12),
                      _tarjetaContenido(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _barraAcciones(),
        ],
      ),
    );
  }

  Widget _encabezado() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF162A89), Color(0xFF071457)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.white,
                iconSize: 30,
              ),
              Expanded(
                child: Text(
                  widget.titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                color: Colors.white,
                iconColor: Colors.white,
                onSelected: (valor) {
                  if (valor == 'copiar') _copiar();
                  if (valor == 'compartir') Share.share(widget.resultado);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'copiar', child: Text('Copiar')),
                  PopupMenuItem(value: 'compartir', child: Text('Compartir')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tarjetaDatos() {
    final fecha =
        '${widget.fecha.year}-${widget.fecha.month.toString().padLeft(2, '0')}-${widget.fecha.day.toString().padLeft(2, '0')}';
    final hora =
        '${widget.fecha.hour.toString().padLeft(2, '0')}:${widget.fecha.minute.toString().padLeft(2, '0')}';
    final asesor = widget.nombreAsesor.trim().isEmpty
        ? 'Asesor de bienestar 4Life'
        : widget.nombreAsesor.trim();
    return _tarjeta(
      child: Column(
        children: [
          Row(
            children: [
              _circuloIcono(Icons.person_outline_rounded, grande: true),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, soy $asesor',
                      style: const TextStyle(
                        color: azul,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.especialidad,
                      style: const TextStyle(
                        color: Color(0xFF445080),
                        fontSize: 14.5,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final compacta = constraints.maxWidth < 470;
              final widgets = [
                _dato(
                  Icons.calendar_month_outlined,
                  'Fecha de la ${widget.tipoFicha.toLowerCase()}',
                  '$fecha · $hora',
                ),
                _dato(
                  Icons.person_outline_rounded,
                  'Paciente',
                  widget.paciente.trim().isEmpty
                      ? 'Sin nombre'
                      : widget.paciente.trim(),
                ),
              ];
              if (compacta) {
                return Column(
                  children: [
                    widgets.first,
                    const SizedBox(height: 14),
                    widgets.last,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: widgets.first),
                  const SizedBox(width: 18),
                  Expanded(child: widgets.last),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _dato(IconData icono, String etiqueta, String valor) {
    return Row(
      children: [
        _circuloIcono(icono),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: const TextStyle(
                  color: azul,
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                valor,
                style: const TextStyle(
                  color: Color(0xFF3F4873),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circuloIcono(IconData icono, {bool grande = false}) {
    final medida = grande ? 66.0 : 50.0;
    return Container(
      width: medida,
      height: medida,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F0FF),
        shape: BoxShape.circle,
      ),
      child: Icon(icono, color: violeta, size: grande ? 36 : 28),
    );
  }

  Widget _tarjetaContenido() {
    final analisis =
        contenido.analisis.isEmpty ? widget.resultado : contenido.analisis;
    return _tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tituloSeccion(
            Icons.auto_awesome_rounded,
            widget.tipoFicha == 'Cambio físico'
                ? 'Análisis del perfil'
                : 'Análisis del caso',
          ),
          const SizedBox(height: 14),
          Text(
            analisis,
            style: const TextStyle(
              color: texto,
              fontSize: 16,
              height: 1.48,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (contenido.objetivo.isNotEmpty) ...[
            const SizedBox(height: 18),
            _objetivo(),
          ],
          if (contenido.productos.isNotEmpty) ...[
            const SizedBox(height: 22),
            _tituloSeccion(
              Icons.medication_liquid_outlined,
              widget.tipoFicha == 'Cambio físico'
                  ? 'Plan de apoyo recomendado'
                  : 'Sustrato y respaldo recomendado',
              mostrarResumen: false,
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < contenido.productos.length; i++) ...[
              _producto(contenido.productos[i], i + 1),
              if (i < contenido.productos.length - 1)
                const SizedBox(height: 10),
            ],
          ],
          if (contenido.recomendaciones.isNotEmpty) ...[
            const SizedBox(height: 16),
            _recomendacionGeneral(),
          ],
          if (contenido.nota.isNotEmpty) ...[
            const SizedBox(height: 14),
            _notaSeguridad(),
          ],
        ],
      ),
    );
  }

  Widget _objetivo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F2FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.track_changes_rounded, color: violeta, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nuestro objetivo',
                  style: TextStyle(
                    color: violeta,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  contenido.objetivo,
                  style: const TextStyle(
                    color: texto,
                    fontSize: 15,
                    height: 1.42,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tituloSeccion(
    IconData icono,
    String titulo, {
    bool mostrarResumen = true,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: violeta,
            shape: BoxShape.circle,
          ),
          child: Icon(icono, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              color: azul,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (mostrarResumen)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Resumen',
              style: TextStyle(
                color: violeta,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }

  Widget _producto(ProductoResultadoFicha producto, int indice) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3E5F0), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: azul.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compacta = constraints.maxWidth < 500;
          final imagen = SizedBox(
            width: compacta ? double.infinity : 170,
            height: compacta ? 180 : 205,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: violeta,
                    child: Text(
                      '$indice',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 12, 8, 4),
                    child: producto.imagen == null
                        ? const Icon(
                            Icons.medication_liquid_outlined,
                            color: Color(0xFFB6B9D1),
                            size: 90,
                          )
                        : Image.asset(
                            producto.imagen!,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                  ),
                ),
              ],
            ),
          );
          final detalle = Padding(
            padding: EdgeInsets.only(
              left: compacta ? 0 : 14,
              top: compacta ? 8 : 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: const TextStyle(
                    color: azul,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                for (final dosis in producto.dosis)
                  _lineaProducto(
                    dosis,
                    dosis.toLowerCase().contains('noche')
                        ? Icons.dark_mode_outlined
                        : Icons.wb_sunny_outlined,
                    dosis.toLowerCase().contains('noche')
                        ? violeta
                        : const Color(0xFFFFA000),
                  ),
                if (producto.beneficio.isNotEmpty)
                  _lineaProducto(
                    producto.beneficio,
                    Icons.check_circle_outline_rounded,
                    violeta,
                  ),
              ],
            ),
          );
          if (compacta) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [imagen, detalle],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [imagen, Expanded(child: detalle)],
          );
        },
      ),
    );
  }

  Widget _lineaProducto(String contenido, IconData icono, Color color) {
    final partes = contenido.split(':');
    final tieneEtiqueta = partes.length > 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icono, color: color, size: 19),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  color: texto,
                  fontSize: 14.5,
                  height: 1.4,
                ),
                children: [
                  if (tieneEtiqueta)
                    TextSpan(
                      text: '${partes.first.trim()}: ',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  TextSpan(
                    text: tieneEtiqueta
                        ? partes.skip(1).join(':').trim()
                        : contenido,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recomendacionGeneral() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF9F1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.volunteer_activism_outlined,
            color: Color(0xFF079447),
            size: 36,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recomendación general',
                  style: TextStyle(
                    color: Color(0xFF087E3C),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  contenido.recomendaciones,
                  style: const TextStyle(
                    color: texto,
                    fontSize: 14.5,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.verified_user_outlined,
            color: Color(0xFF079447),
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _notaSeguridad() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.health_and_safety_outlined,
          color: Color(0xFF586288),
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            contenido.nota,
            style: const TextStyle(
              color: Color(0xFF586288),
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tarjeta({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: azul.withValues(alpha: 0.07),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _barraAcciones() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: azul.withValues(alpha: 0.09),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            _accion(
              reproduciendo ? Icons.stop_circle_outlined : Icons.volume_up,
              reproduciendo ? 'Detener' : 'Escuchar',
              () async {
                if (reproduciendo) {
                  await ServicioTextoVoz.detener();
                  if (mounted) setState(() => reproduciendo = false);
                  return;
                }
                setState(() => reproduciendo = true);
                await ServicioTextoVoz.reproducir(widget.resultado);
                if (mounted) setState(() => reproduciendo = false);
              },
            ),
            _accion(Icons.copy_rounded, 'Copiar', _copiar),
            _accion(
              Icons.share_rounded,
              'Compartir',
              () => Share.share(widget.resultado),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2825B8),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accion(IconData icono, String etiqueta, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, color: violeta, size: 23),
              const SizedBox(height: 3),
              Text(
                etiqueta,
                maxLines: 1,
                style: const TextStyle(
                  color: violeta,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copiar() {
    Clipboard.setData(ClipboardData(text: widget.resultado));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copiado al portapapeles')),
    );
  }
}
