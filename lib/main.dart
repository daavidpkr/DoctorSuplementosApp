import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // <--- PARA COPIAR (Clipboard)
import 'package:share_plus/share_plus.dart'; // <--- PARA COMPARTIR
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

const List<String> productosPermitidos4Life = [
  'Transfer factor plus',
  'Riovida stix',
  'Energy go stix',
  'Renuvo',
  'Glucoach',
  'Bcv',
  'Malepro',
  'Colageno tipo i',
  'Transfer factor tri factor',
  'Nutrastart',
  'Riovida burst',
  'Protf',
  'Bioefa',
  'Belle vie',
  'Glutamine prime',
  'Kbu',
  'Vistari',
  'Preo biotics',
  'Fibre',
  'Agpro',
  'Suero',
  'Crema para los ojos',
  'Tonico',
  'Crema humectante',
  'Pasta de dientes',
  'Crema cuerpo',
  'Limpiador',
  'Recall',
  'TF Boost',
];

final String catalogoPermitido4Life = productosPermitidos4Life.join(', ');

const Map<String, String> imagenesProducto4Life = {
  'Transfer factor plus': 'assets/productos/trasnfer_factor_plus.png',
  'Riovida stix': 'assets/productos/riovida_stix.png',
  'Energy go stix': 'assets/productos/energy_go_stix.png',
  'Renuvo': 'assets/productos/renuvo.png',
  'Glucoach': 'assets/productos/glucoach.png',
  'Bcv': 'assets/productos/bcv.png',
  'Malepro': 'assets/productos/malepro.png',
  'Colageno tipo i': 'assets/productos/colageno_tipo_i.png',
  'Transfer factor tri factor':
      'assets/productos/transfer_factor_tri_factor.png',
  'Nutrastart': 'assets/productos/nutrastart.png',
  'Riovida burst': 'assets/productos/riovida_burst.png',
  'Protf': 'assets/productos/protf.png',
  'Bioefa': 'assets/productos/bioefa.png',
  'Belle vie': 'assets/productos/belle_vie.png',
  'Glutamine prime': 'assets/productos/glutamine_prime.png',
  'Kbu': 'assets/productos/kbu.png',
  'Vistari': 'assets/productos/vistari.png',
  'Preo biotics': 'assets/productos/preo_biotics.png',
  'Fibre': 'assets/productos/fibre.png',
  'Agpro': 'assets/productos/agpro.png',
  'Suero': 'assets/productos/suero.png',
  'Crema para los ojos': 'assets/productos/crema_para_los_ojos.png',
  'Tonico': 'assets/productos/tonico.png',
  'Crema humectante': 'assets/productos/crema_humectante.png',
  'Pasta de dientes': 'assets/productos/pasta_de_dientes.png',
  'Crema cuerpo': 'assets/productos/crema_de_cuerpo.png',
  'Limpiador': 'assets/productos/limpiador.png',
  'Recall': 'assets/productos/recall.png',
  'TF Boost': 'assets/productos/tf_boost.png',
};

class ProductoPrecio {
  final String nombre;
  final double afiliado;
  final double publico;
  final int? lp;

  const ProductoPrecio({
    required this.nombre,
    required this.afiliado,
    required this.publico,
    required this.lp,
  });
}

const List<ProductoPrecio> productosConPrecio4Life = [
  ProductoPrecio(
      nombre: 'Transfer factor plus', afiliado: 83.17, publico: 110.98, lp: 55),
  ProductoPrecio(
      nombre: 'Riovida stix', afiliado: 43.36, publico: 57.67, lp: 20),
  ProductoPrecio(
      nombre: 'Energy go stix', afiliado: 69.82, publico: 92.41, lp: 36),
  ProductoPrecio(nombre: 'Renuvo', afiliado: 69.82, publico: 92.41, lp: 42),
  ProductoPrecio(nombre: 'Glucoach', afiliado: 79.06, publico: 104.73, lp: 53),
  ProductoPrecio(nombre: 'Bcv', afiliado: 79.06, publico: 104.73, lp: 52),
  ProductoPrecio(nombre: 'Malepro', afiliado: 77.01, publico: 102.68, lp: 44),
  ProductoPrecio(
      nombre: 'Colageno tipo i', afiliado: 43.12, publico: 57.35, lp: 23),
  ProductoPrecio(
      nombre: 'Transfer factor tri factor',
      afiliado: 66.74,
      publico: 88.30,
      lp: 40),
  ProductoPrecio(nombre: 'Nutrastart', afiliado: 73.93, publico: 98.57, lp: 30),
  ProductoPrecio(
      nombre: 'Riovida burst', afiliado: 53.39, publico: 70.85, lp: 27),
  ProductoPrecio(nombre: 'Protf', afiliado: 90.36, publico: 120.13, lp: 26),
  ProductoPrecio(nombre: 'Bioefa', afiliado: 33.11, publico: 44.04, lp: 18),
  ProductoPrecio(nombre: 'Belle vie', afiliado: 67.77, publico: 90.36, lp: 43),
  ProductoPrecio(
      nombre: 'Glutamine prime', afiliado: 46.21, publico: 61.61, lp: 27),
  ProductoPrecio(nombre: 'Kbu', afiliado: 67.77, publico: 90.36, lp: 42),
  ProductoPrecio(nombre: 'Vistari', afiliado: 68.79, publico: 91.38, lp: 40),
  ProductoPrecio(
      nombre: 'Preo biotics', afiliado: 60.95, publico: 81.06, lp: 35),
  ProductoPrecio(nombre: 'Fibre', afiliado: 54.47, publico: 72.45, lp: 24),
  ProductoPrecio(nombre: 'Agpro', afiliado: 73.00, publico: 97.00, lp: 45),
  ProductoPrecio(nombre: 'Suero', afiliado: 50.31, publico: 66.74, lp: 29),
  ProductoPrecio(
      nombre: 'Crema para los ojos', afiliado: 45.00, publico: 60.00, lp: 27),
  ProductoPrecio(nombre: 'Tonico', afiliado: 36.00, publico: 48.00, lp: 19),
  ProductoPrecio(
      nombre: 'Crema humectante', afiliado: 36.96, publico: 49.29, lp: 19),
  ProductoPrecio(
      nombre: 'Pasta de dientes', afiliado: 16.43, publico: 21.56, lp: 5),
  ProductoPrecio(
      nombre: 'Crema cuerpo', afiliado: 25.67, publico: 33.88, lp: 8),
  ProductoPrecio(nombre: 'Recall', afiliado: 72.90, publico: 96.52, lp: 42),
  ProductoPrecio(nombre: 'TF Boost', afiliado: 27.72, publico: 36.96, lp: 15),
];

String normalizarTexto(String texto) {
  return texto
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

String normalizarClaveProducto(String texto) {
  return normalizarTexto(texto).replaceAll(RegExp(r'\s+'), '');
}

int puntajeCoincidencia(String consulta, String producto) {
  final q = normalizarTexto(consulta);
  final p = normalizarTexto(producto);
  final qClave = normalizarClaveProducto(consulta);
  final pClave = normalizarClaveProducto(producto);
  if (q.isEmpty) return 0;
  if (q == p || qClave == pClave) return 100;
  if (p.contains(q) ||
      q.contains(p) ||
      pClave.contains(qClave) ||
      qClave.contains(pClave)) {
    return 85;
  }

  final palabras = q.split(' ').where((e) => e.isNotEmpty).toSet();
  final palabrasProducto = p.split(' ').where((e) => e.isNotEmpty).toSet();
  if (palabras.isEmpty) return 0;
  final coincidencias = palabras.intersection(palabrasProducto).length;
  return ((coincidencias / palabras.length) * 70).round();
}

ProductoPrecio? buscarProductoConPrecio(String consulta) {
  ProductoPrecio? mejor;
  var mejorPuntaje = 0;
  for (final producto in productosConPrecio4Life) {
    final puntaje = puntajeCoincidencia(consulta, producto.nombre);
    if (puntaje > mejorPuntaje) {
      mejorPuntaje = puntaje;
      mejor = producto;
    }
  }
  return mejorPuntaje >= 45 ? mejor : null;
}

String? buscarProductoPermitido(String consulta) {
  String? mejor;
  var mejorPuntaje = 0;
  for (final producto in productosPermitidos4Life) {
    final puntaje = puntajeCoincidencia(consulta, producto);
    if (puntaje > mejorPuntaje) {
      mejorPuntaje = puntaje;
      mejor = producto;
    }
  }
  return mejorPuntaje >= 45 ? mejor : null;
}

String? productoDesdeTexto(String texto) {
  final normalizado = normalizarTexto(texto);
  final normalizadoClave = normalizarClaveProducto(texto);
  for (final producto in productosPermitidos4Life) {
    if (normalizado.contains(normalizarTexto(producto)) ||
        normalizadoClave.contains(normalizarClaveProducto(producto))) {
      return producto;
    }
  }
  return null;
}

List<String> dividirConsultaProductos(String texto) {
  return texto
      .split(RegExp(r'[,;\n]+'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

Future<XFile> imagenProductoComoPng(String assetPath, String nombre) async {
  final data = await rootBundle.load(assetPath);
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  final archivo = normalizarTexto(nombre).replaceAll(' ', '_');
  return XFile.fromData(
    bytes,
    name: '$archivo.png',
    mimeType: 'image/png',
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inicializarFirebaseSeguro();
  runApp(const DoctorSuplementos());
}

Future<void> inicializarFirebaseSeguro() async {
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 5));
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  } catch (e) {
    debugPrint('Firebase no se pudo inicializar en este dispositivo: $e');
  }
}

class DoctorSuplementos extends StatelessWidget {
  const DoctorSuplementos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor de Suplementos',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5EE),
        primaryColor: const Color(0xFF1A237E),
      ),
      home: const PantallaPrincipal(),
    );
  }
}

// --- PANTALLA PRINCIPAL ---
class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heroAsesor(),
                    const SizedBox(height: 18),
                    _tarjetaMenu(
                      context,
                      titulo: "Consultar producto(s)",
                      descripcion:
                          "Explora el catalogo y descubre todos nuestros productos.",
                      icono: Icons.search_rounded,
                      colores: const [Color(0xFF2E3192), Color(0xFF151B7C)],
                      destino: const ConsultaProductoPagina(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: "Diagnostico",
                      descripcion:
                          "Evalua y conoce las necesidades de tus clientes.",
                      icono: Icons.medical_services_rounded,
                      colores: const [Color(0xFF1457E8), Color(0xFF1531A6)],
                      destino: const FormularioPaciente(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: "Historial",
                      descripcion:
                          "Revisa tus consultas, diagnosticos y recomendaciones previas.",
                      icono: Icons.history_rounded,
                      colores: const [Color(0xFF8051D4), Color(0xFF6047B7)],
                      destino: const PaginaHistorial(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: "Asesor IA 4Life",
                      descripcion:
                          "Obten recomendaciones personalizadas con inteligencia artificial.",
                      icono: Icons.chat_rounded,
                      colores: const [Color(0xFF1487A8), Color(0xFF087394)],
                      destino: const PaginaChatbot(),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 10),
                      child: Text(
                        "Accesos rapidos",
                        style: TextStyle(
                          color: Color(0xFF0A1552),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _accesosRapidos(context),
                  ],
                ),
              ),
            ),
            _barraInferior(context),
          ],
        ),
      ),
    );
  }

  Widget _heroAsesor() {
    return Container(
      height: 158,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF071451).withValues(alpha: 0.13),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -42,
            child: Container(
              width: 156,
              height: 156,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFBFCBFF).withValues(alpha: 0.28),
              ),
            ),
          ),
          Positioned(
            right: 36,
            top: 22,
            child: Icon(
              Icons.science_rounded,
              size: 92,
              color: const Color(0xFF1B2A99).withValues(alpha: 0.88),
            ),
          ),
          Positioned(
            right: 18,
            top: 22,
            child: CustomPaint(
              size: const Size(116, 88),
              painter: _MoleculaPainter(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 120, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "¡Hola, Asesor!",
                  style: TextStyle(
                    color: Color(0xFF101A5B),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Gestiona, asesora y mejora la vida de mas personas.",
                  style: TextStyle(
                    color: Color(0xFF25315F),
                    fontSize: 12,
                    height: 1.25,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101A70),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.track_changes_rounded,
                          color: Colors.white, size: 15),
                      SizedBox(width: 7),
                      Text(
                        "Tu impacto 4Life",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded,
                          color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaMenu(
    BuildContext context, {
    required String titulo,
    required String descripcion,
    required IconData icono,
    required List<Color> colores,
    required Widget destino,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1A5F).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destino),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colores,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icono, color: Colors.white, size: 34),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          color: Color(0xFF111B59),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        descripcion,
                        style: const TextStyle(
                          color: Color(0xFF465074),
                          fontSize: 12,
                          height: 1.22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF071451),
                  size: 31,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _accesosRapidos(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1A5F).withValues(alpha: 0.06),
            blurRadius: 13,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _accesoRapido(
            context,
            "Catalogo",
            Icons.article_outlined,
            const ConsultaProductoPagina(),
          ),
          _accesoRapido(
            context,
            "Precios",
            Icons.calculate_outlined,
            const PaginaCalculadoraPrecios(),
          ),
          _accesoRapido(
            context,
            "Clientes",
            Icons.groups_2_outlined,
            const PaginaHistorial(),
          ),
          _accesoRapido(
            context,
            "Chats",
            Icons.school_outlined,
            const PaginaHistorialChatbot(),
          ),
        ],
      ),
    );
  }

  Widget _accesoRapido(
      BuildContext context, String texto, IconData icono, Widget destino) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destino),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: const Color(0xFF1B2A99), size: 20),
            const SizedBox(height: 4),
            Text(
              texto,
              style: const TextStyle(
                color: Color(0xFF18215E),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barraInferior(BuildContext context) {
    return Container(
      height: 58,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
      decoration: BoxDecoration(
        color: const Color(0xFF071363),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _itemBarra(
            context,
            "Inicio",
            Icons.home_outlined,
            null,
            seleccionado: true,
          ),
          _itemBarra(
            context,
            "Consultas",
            Icons.search_rounded,
            const ConsultaProductoPagina(),
          ),
          _itemBarra(
            context,
            "Clientes",
            Icons.groups_2_outlined,
            const PaginaHistorial(),
          ),
          _itemBarra(
            context,
            "Perfil",
            Icons.person_outline_rounded,
            const PaginaCalculadoraPrecios(),
          ),
        ],
      ),
    );
  }

  Widget _itemBarra(
    BuildContext context,
    String texto,
    IconData icono,
    Widget? destino, {
    bool seleccionado = false,
  }) {
    final contenido = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icono, color: Colors.white, size: 20),
        const SizedBox(height: 3),
        Text(
          texto,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
        child: seleccionado
            ? Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF273BB1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: contenido,
              )
            : InkWell(
                borderRadius: BorderRadius.circular(9),
                onTap: destino == null
                    ? null
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => destino),
                        ),
                child: contenido,
              ),
      ),
    );
  }
}

class _MoleculaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF9FAEE8).withValues(alpha: 0.62)
      ..strokeWidth = 1.3;
    final nodePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final nodeBorder = Paint()
      ..color = const Color(0xFF93A4E2).withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final points = [
      Offset(size.width * .10, size.height * .76),
      Offset(size.width * .28, size.height * .52),
      Offset(size.width * .25, size.height * .22),
      Offset(size.width * .48, size.height * .35),
      Offset(size.width * .68, size.height * .16),
      Offset(size.width * .82, size.height * .42),
      Offset(size.width * .94, size.height * .70),
      Offset(size.width * .64, size.height * .66),
    ];

    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }
    canvas.drawLine(points[1], points[7], linePaint);
    canvas.drawLine(points[3], points[6], linePaint);

    for (final point in points) {
      canvas.drawCircle(point, 3.2, nodePaint);
      canvas.drawCircle(point, 3.2, nodeBorder);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- PANTALLA PRINCIPAL ANTERIOR ---
class PantallaPrincipalVieja extends StatelessWidget {
  const PantallaPrincipalVieja({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DoctorSuplementos"),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.biotech, size: 80, color: Color(0xFF1A237E)),
                const SizedBox(height: 40),
                _botonMenu(context, "Consultar producto(s)", Icons.search,
                    const ConsultaProductoPagina()),
                _botonMenu(context, "Consultora y calculadora", Icons.calculate,
                    const PaginaCalculadoraPrecios()),
                _botonMenu(context, "Diagnóstico", Icons.medication,
                    const FormularioPaciente()),
                _botonMenu(context, "Historial", Icons.history,
                    const PaginaHistorial()),
                _botonMenu(context, "Asesor IA 4Life", Icons.chat,
                    const PaginaChatbot()),
                _botonMenu(context, "Historial de chats", Icons.forum,
                    const PaginaHistorialChatbot()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonMenu(
      BuildContext context, String titulo, IconData icono, Widget destino) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => destino)),
        icon: Icon(icono, color: Colors.white),
        label: Text(titulo,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          minimumSize: const Size(double.infinity, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}

// --- GESTIÓN DE HISTORIAL LOCAL ---
class HistorialService {
  static final List<Map<String, dynamic>> registros = [];

  static Future<void> guardar(
      String titulo, String resultado, Map<String, String> datos) async {
    final registro = {
      'fecha': DateTime.now().toString().substring(0, 16),
      'titulo': titulo,
      'nombre': datos['nombre'] ?? '',
      'resultado': resultado,
      'datos': datos,
    };

    registros.insert(0, registro);

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('historial_pacientes') ?? [];
    raw.insert(0, jsonEncode(registro));
    await prefs.setStringList('historial_pacientes', raw);
  }
}

class ChatHistoryService {
  static const String _key = 'historial_chat_4life';

  static Future<List<Map<String, dynamic>>> cargarConversaciones() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .where((e) => e['mensajes'] is List)
        .toList();
  }

  static Future<void> guardarConversacion(
    String id,
    List<Map<String, String>> mensajes,
  ) async {
    if (mensajes.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final conversaciones = await cargarConversaciones();
    final primeraPregunta = mensajes.firstWhere(
      (m) => m['rol'] == 'usuario',
      orElse: () => mensajes.first,
    )['texto'];

    final titulo = primeraPregunta ?? 'Chat 4Life';
    final registro = {
      'id': id,
      'fecha': DateTime.now().toString().substring(0, 16),
      'titulo': titulo.length > 45 ? '${titulo.substring(0, 45)}...' : titulo,
      'mensajes': mensajes,
    };

    conversaciones.removeWhere((chat) => chat['id'] == id);
    conversaciones.insert(0, registro);
    await prefs.setStringList(
      _key,
      conversaciones.map((chat) => jsonEncode(chat)).toList(),
    );
  }

  static Future<void> eliminarConversacion(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final conversaciones = await cargarConversaciones();
    conversaciones.removeWhere((chat) => chat['id'] == id);
    await prefs.setStringList(
      _key,
      conversaciones.map((chat) => jsonEncode(chat)).toList(),
    );
  }
}

// --- PANTALLA DE DIAGNÓSTICO (FORMULARIO) ---
class FormularioPaciente extends StatefulWidget {
  final Map<String, dynamic>? infoPrevia;
  const FormularioPaciente({super.key, this.infoPrevia});

  @override
  State<FormularioPaciente> createState() => _FormularioPacienteState();
}

class _FormularioPacienteState extends State<FormularioPaciente> {
  late TextEditingController nombreController;
  late TextEditingController edadController;
  late TextEditingController historialController;
  String? _generoSeleccionado;
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(
        text: widget.infoPrevia?['datos']?['nombre'] ?? "");
    edadController =
        TextEditingController(text: widget.infoPrevia?['datos']?['edad'] ?? "");
    _generoSeleccionado = widget.infoPrevia?['datos']?['genero'];
    historialController = TextEditingController();
  }

  Future<void> generarDiagnostico() async {
    if (historialController.text.isEmpty) return;
    if (_generoSeleccionado == null || _generoSeleccionado!.isEmpty) {
      _mostrarDialogoSimple("Falta género", "Por favor, selecciona el género.");
      return;
    }
    setState(() => cargando = true);

    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: 'AIzaSyB3ea3TYD72dtfGyP9kSrjyot7RzMk0ZXk',
    );

    String contextoAnterior = widget.infoPrevia != null
        ? "HISTORIAL PREVIO: El paciente anteriormente reportó: ${widget.infoPrevia!['datos']['sintomas']}. El resultado anterior fue: ${widget.infoPrevia!['resultado']}. "
        : "";

    final prompt = """
    $contextoAnterior
    SÍNTOMAS ACTUALES: ${historialController.text}
    DATOS: Nombre: ${nombreController.text}, Edad: ${edadController.text}, Género: $_generoSeleccionado.
    
    Actúa como un experto en inmunología, bioenergética y asesor profesional de la línea de suplementos de bienestar de 4Life. Tu objetivo es generar un reporte de recomendación altamente profesional, ético y optimizado exclusivamente para ser compartido por WhatsApp.

    REGLA CRÍTICA DE NEGOCIO: 
    - Debes recomendar ÚNICAMENTE estos productos: $catalogoPermitido4Life.
    - Queda estrictamente prohibido inventar nombres de productos, sugerir medicamentos fármacos o marcas externas a 4Life.

    Instrucciones estrictas de formato y contenido:
    1. Usa el formato de WhatsApp: coloca asteriscos (*) al principio y al final de los títulos o frases clave para generar textos en **negrita**. Usa listas con viñetas limpias (-) o números.
    2. El mensaje debe ser directo, empático y estructurado en bloques separados por espacios para que sea scannable en el celular.
    3. RECOMENDACIÓN DE PRODUCTOS: Recomienda un máximo de 3 o 4 productos de 4Life específicos para el caso. No satures al cliente.
    4. DOSIFICACIÓN EXACTA Y DETALLADA: Para cada producto recomendado, debes dar la dosis exacta en una lista independiente, clara y legible. Queda estrictamente prohibido agrupar o mezclar las dosis en un solo párrafo de texto corrido.
    5. TONO Y SEGURIDAD: Mantén un tono científico pero accesible. No uses lenguaje de ventas exagerado ni prometas "curas milagrosas". Incluye siempre de forma sutil que los suplementos respaldan las funciones fisiológicas y el sistema inmunitario, y que no sustituyen ningún tratamiento médico.

    Estructura requerida para la respuesta:

    *SALUDO Y ANÁLISIS DEL CASO*
    [Breve introducción empática analizando los datos del paciente]

    *SUSTRATO Y RESPALDO RECOMENDADO (Máx. 3-4 productos)*

    *1. [Nombre del Producto 4Life]*
    - *Dosis mañana:* [Cantidad exacta]
    - *Dosis tarde:* [Cantidad exacta]
    - *Dosis noche:* [Cantidad exacta]
    - *Beneficio clave:* [Breve explicación técnica de cómo actúa en el organismo]

    *2. [Nombre del Producto 4Life]*
    - *Dosis mañana:* [Cantidad exacta]
    - *Dosis tarde:* [Cantidad exacta]
    - *Dosis noche:* [Cantidad exacta]
    - *Beneficio clave:* [Breve explicación técnica]

    [Repetir estructura si se requiere un 3er o 4to producto, máximo y si no requiere no incluir el texto "No se requiere" o "No aplica"] 
    [Si por ejemplo no se tiene que tomar en la tarde o noche no pongas esa sección y solo pon las secciones que sean]
      
    *RECOMENDACIONES DE BIENESTAR GENERAL*
    - [Dar 2 o 3 hábitos diarios o consejos funcionales de apoyo]

    *Nota de seguridad:* Los productos de 4Life están diseñados para respaldar y potenciar la inteligencia de tu sistema inmunitario y funciones metabólicas generales; no reemplazan las indicaciones de su médico de cabecera.""";

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      String textoFinal = response.text ?? "Sin respuesta";

      await HistorialService.guardar(
          "Diagnóstico: ${nombreController.text}", textoFinal, {
        'nombre': nombreController.text,
        'edad': edadController.text,
        'genero': _generoSeleccionado!,
        'sintomas': historialController.text,
      });

      _mostrarResultado(textoFinal);
    } catch (e) {
      _mostrarDialogoSimple("Error", "No se pudo conectar con la IA.");
    } finally {
      setState(() => cargando = false);
    }
  }

  void _mostrarResultado(String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Resultado del Diagnóstico"),
        content: SingleChildScrollView(child: Text(mensaje)),
        actions: [
          IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: mensaje));
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Copiado al portapapeles")));
              }),
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => Share.share(mensaje)),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar")),
        ],
      ),
    );
  }

  void _mostrarDialogoSimple(String t, String m) {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(title: Text(t), content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Formulario de Diagnóstico")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildCampo("Nombre", nombreController, "Nombre..."),
            _buildCampo("Edad", edadController, "Edad..."),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
                    initialValue: _generoSeleccionado,
                    isDense: true,
                    decoration: const InputDecoration(
                      labelText: 'Género',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.wc),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Hombre', child: Text('Hombre')),
                      DropdownMenuItem(value: 'Mujer', child: Text('Mujer')),
                    ],
                    onChanged: (String? nuevoValor) {
                      setState(() {
                        _generoSeleccionado = nuevoValor;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecciona el género';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            _buildCampo("Síntomas actuales", historialController,
                "Describa qué siente...",
                lineas: 4),
            const SizedBox(height: 20),
            cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: generarDiagnostico,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        minimumSize: const Size(double.infinity, 55)),
                    child: const Text("GENERAR DIAGNÓSTICO",
                        style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampo(
      String label, TextEditingController controller, String hint,
      {int lineas = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: lineas,
        decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: const OutlineInputBorder()),
      ),
    );
  }
}

// --- PANTALLA: CONSULTA DE PRODUCTO ---
class ConsultaProductoPagina extends StatefulWidget {
  const ConsultaProductoPagina({super.key});

  @override
  State<ConsultaProductoPagina> createState() => _ConsultaProductoPaginaState();
}

class _ConsultaProductoPaginaState extends State<ConsultaProductoPagina> {
  final controller = TextEditingController();
  bool consultando = false;

  Future<void> consultar() async {
    final productoBuscado = controller.text.trim();
    if (productoBuscado.isEmpty || consultando) return;

    setState(() => consultando = true);
    final productoCoincidenteLocal = buscarProductoPermitido(productoBuscado);
    final productoParaIa = productoCoincidenteLocal ?? productoBuscado;

    final model = GenerativeModel(
        model: 'gemini-3-flash-preview',
        apiKey: 'AIzaSyB3ea3TYD72dtfGyP9kSrjyot7RzMk0ZXk');
    final prompt = """
    Actua como un asesor experto de productos 4Life.

    El usuario escribio este producto, posiblemente con errores de escritura:
    "$productoBuscado"

    Coincidencia local del catalogo:
    "$productoParaIa"

    Primero identifica el producto 4Life mas probable aunque el nombre este incompleto,
    mal escrito o con abreviaturas. Usa tu conocimiento de productos 4Life y el contexto
    de la marca. Si hay varias opciones parecidas, elige la mas probable y menciona
    brevemente que fue una coincidencia aproximada.
    Si la coincidencia local del catalogo coincide con un producto de la lista autorizada,
    usala como el producto identificado.

    REGLA OBLIGATORIA: Solo puedes identificar, describir o recomendar productos de esta lista:
    $catalogoPermitido4Life.
    Si el usuario pregunta por un producto fuera de la lista, indica que no esta en el catalogo permitido
    y sugiere que escriba uno de los productos autorizados.

    Responde en espanol, claro y ordenado, con esta estructura:

    Producto identificado:
    [Nombre correcto del producto]

    Descripcion:
    [Para que se usa o que respalda]

    Ingredientes o componentes principales:
    [Lista breve]

    Indicaciones de uso:
    [Uso sugerido de bienestar, sin prometer curas]

    Contraindicaciones o precauciones:
    [Advertencias responsables]

    Dosis sugerida:
    [Dosis general si la conoces. Si no estas seguro, indicalo y recomienda revisar la etiqueta oficial]

    Nota:
    No inventes informacion si no estas seguro. No recomiendes medicamentos, marcas externas ni productos fuera del catalogo permitido.
    """;
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final resultado = response.text ?? "No pude generar una respuesta.";
      final productoIdentificado = productoDesdeTexto(resultado) ??
          productoCoincidenteLocal ??
          buscarProductoPermitido(productoBuscado);
      final imagenProducto = productoIdentificado == null
          ? null
          : imagenesProducto4Life[productoIdentificado];

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(productoIdentificado ?? "Info: $productoBuscado"),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imagenProducto != null) ...[
                    Container(
                      height: 230,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE1E1D7)),
                      ),
                      child: Image.asset(
                        imagenProducto,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(resultado),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: resultado));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Copiado al portapapeles")),
                  );
                }),
            IconButton(
                icon: const Icon(Icons.share),
                onPressed: () async {
                  if (imagenProducto == null || productoIdentificado == null) {
                    await Share.share(resultado);
                    return;
                  }

                  final imagen = await imagenProductoComoPng(
                      imagenProducto, productoIdentificado);
                  await Share.shareXFiles([imagen], text: resultado);
                }),
            TextButton(
                onPressed: () => Navigator.pop(c), child: const Text("Cerrar")),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text("Error"),
          content: const Text("No se pudo consultar el producto con la IA."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c), child: const Text("Cerrar")),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => consultando = false);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consultar Productos")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: controller,
                decoration:
                    const InputDecoration(labelText: "Nombre del producto")),
            const SizedBox(height: 20),
            consultando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: consultar, child: const Text("Consultar")),
          ],
        ),
      ),
    );
  }
}

class PaginaCalculadoraPrecios extends StatefulWidget {
  const PaginaCalculadoraPrecios({super.key});

  @override
  State<PaginaCalculadoraPrecios> createState() =>
      _PaginaCalculadoraPreciosState();
}

class _PaginaCalculadoraPreciosState extends State<PaginaCalculadoraPrecios> {
  final TextEditingController _controller = TextEditingController();
  List<ProductoPrecio> _productos = [];
  List<String> _noEncontrados = [];

  void _calcular() {
    final consultas = dividirConsultaProductos(_controller.text);
    final encontrados = <ProductoPrecio>[];
    final noEncontrados = <String>[];

    for (final consulta in consultas) {
      final producto = buscarProductoConPrecio(consulta);
      if (producto == null) {
        noEncontrados.add(consulta);
      } else {
        encontrados.add(producto);
      }
    }

    setState(() {
      _productos = encontrados;
      _noEncontrados = noEncontrados;
    });
  }

  double get _totalAfiliado =>
      _productos.fold(0, (total, p) => total + p.afiliado);

  double get _totalPublico =>
      _productos.fold(0, (total, p) => total + p.publico);

  int get _totalLp => _productos.fold(0, (total, p) => total + (p.lp ?? 0));

  String _precio(double valor) => '\$${valor.toStringAsFixed(2)}';

  String _resumenCompartir() {
    final buffer = StringBuffer('Consulta de precios 4Life\n\n');
    for (final producto in _productos) {
      buffer.writeln(producto.nombre);
      buffer.writeln('Afiliado: ${_precio(producto.afiliado)}');
      buffer.writeln('Publico: ${_precio(producto.publico)}');
      buffer.writeln('LP: ${producto.lp?.toString() ?? 'Sin dato'}\n');
    }
    buffer.writeln('Total afiliado: ${_precio(_totalAfiliado)}');
    buffer.writeln('Total publico: ${_precio(_totalPublico)}');
    buffer.writeln('Total LP: $_totalLp');
    return buffer.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consultora y calculadora"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Producto(s)",
                    hintText: "Ej: Bioefa, Transfer factor plus",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                  onSubmitted: (_) => _calcular(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _calcular,
                        icon: const Icon(Icons.calculate),
                        label: const Text("Calcular"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A237E),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: "Copiar resumen",
                      onPressed: _productos.isEmpty
                          ? null
                          : () {
                              Clipboard.setData(
                                  ClipboardData(text: _resumenCompartir()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Resumen copiado")),
                              );
                            },
                      icon: const Icon(Icons.copy),
                    ),
                    IconButton(
                      tooltip: "Compartir resumen",
                      onPressed: _productos.isEmpty
                          ? null
                          : () => Share.share(_resumenCompartir()),
                      icon: const Icon(Icons.share),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _productos.isEmpty && _noEncontrados.isEmpty
                ? const Center(
                    child: Text(
                      "Escribe uno o varios productos para consultar precios y LP.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      for (final producto in _productos)
                        Card(
                          child: ListTile(
                            leading: imagenesProducto4Life[producto.nombre] ==
                                    null
                                ? null
                                : SizedBox(
                                    width: 58,
                                    height: 58,
                                    child: Image.asset(
                                      imagenesProducto4Life[producto.nombre]!,
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                            title: Text(producto.nombre),
                            subtitle: Text(
                              "Afiliado: ${_precio(producto.afiliado)}\n"
                              "Publico: ${_precio(producto.publico)}\n"
                              "LP: ${producto.lp?.toString() ?? 'Sin dato'}",
                            ),
                          ),
                        ),
                      if (_productos.isNotEmpty)
                        Card(
                          color: const Color(0xFFE8EAF6),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Totales",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text("Afiliado: ${_precio(_totalAfiliado)}"),
                                Text("Publico: ${_precio(_totalPublico)}"),
                                Text("LP: $_totalLp"),
                              ],
                            ),
                          ),
                        ),
                      for (final item in _noEncontrados)
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: Text(item),
                            subtitle: const Text(
                              "No se encontro precio para este producto en la lista cargada.",
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// --- PANTALLA: HISTORIAL ---
class HistorialPagina extends StatelessWidget {
  const HistorialPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historial (Local)")),
      body: HistorialService.registros.isEmpty
          ? const Center(child: Text("No hay consultas previas"))
          : ListView.builder(
              itemCount: HistorialService.registros.length,
              itemBuilder: (context, index) {
                final item = HistorialService.registros[index];
                return ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(item['titulo']),
                  subtitle: Text("Fecha: ${item['fecha']}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) =>
                                FormularioPaciente(infoPrevia: item)));
                  },
                );
              },
            ),
    );
  }
}
// --- PANTALLAS DE NAVEGACIÓN ---

class PaginaConsulta extends StatelessWidget {
  const PaginaConsulta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consultar Producto"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Aquí podrás consultar información detallada de los productos 4Life.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class PaginaHistorial extends StatefulWidget {
  const PaginaHistorial({super.key});

  @override
  State<PaginaHistorial> createState() => _PaginaHistorialState();
}

class _PaginaHistorialState extends State<PaginaHistorial> {
  List<Map<String, dynamic>> _todoElHistorial = [];
  List<Map<String, dynamic>> _historialFiltrado = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('historial_pacientes') ?? [];
    final datos =
        raw.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    if (!mounted) return;
    setState(() {
      _todoElHistorial = datos;
      _historialFiltrado = datos;
    });
  }

  String _nombrePaciente(Map<String, dynamic> registro) {
    final datos = registro['datos'];
    if (registro['nombre'] != null &&
        registro['nombre'].toString().trim().isNotEmpty) {
      return registro['nombre'].toString();
    }
    if (datos is Map &&
        datos['nombre'] != null &&
        datos['nombre'].toString().trim().isNotEmpty) {
      return datos['nombre'].toString();
    }
    return registro['titulo']?.toString() ?? "Sin nombre";
  }

  void _filtrarHistorial(String query) {
    final busqueda = query.toLowerCase().trim();
    setState(() {
      _historialFiltrado = _todoElHistorial
          .where((paciente) =>
              _nombrePaciente(paciente).toLowerCase().contains(busqueda))
          .toList();
    });
  }

  void _reDiagnosticar(Map<String, dynamic> pacienteViejo) {
    final nombre = _nombrePaciente(pacienteViejo);
    final resultado =
        pacienteViejo['resultado']?.toString() ?? "Sin resultado guardado";
    final nuevaPreguntaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Re-evaluar a $nombre"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Diagnóstico anterior:\n$resultado",
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nuevaPreguntaController,
              decoration: const InputDecoration(
                labelText: "¿Qué cambió o qué nueva duda tienes?",
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              final nuevaConsultaIA =
                  "Tomando como base el diagnóstico anterior de este paciente: $resultado. "
                  "El paciente ahora presenta lo siguiente o se requiere ajustar esto: ${nuevaPreguntaController.text}";

              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PaginaChatbot(consultaInicial: nuevaConsultaIA),
                ),
              );
            },
            child: const Text("Consultar Ajuste"),
          ),
        ],
      ),
    ).then((_) => nuevaPreguntaController.dispose());
  }

  void _verReporteAnterior(Map<String, dynamic> pacienteViejo) {
    final nombre = _nombrePaciente(pacienteViejo);
    final fecha = pacienteViejo['fecha']?.toString() ?? "Sin fecha";
    final resultado =
        pacienteViejo['resultado']?.toString() ?? "Sin resultado guardado";
    final datos = pacienteViejo['datos'];
    final sintomas = datos is Map ? datos['sintomas']?.toString() ?? "" : "";

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Reporte anterior de $nombre"),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Fecha: $fecha"),
                if (sintomas.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    "Sintomas registrados:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(sintomas),
                ],
                const SizedBox(height: 12),
                const Text(
                  "Reporte o diagnostico:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(resultado),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: resultado))),
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => Share.share(resultado)),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _reDiagnosticar(pacienteViejo);
            },
            child: const Text("Consultar ajuste"),
          ),
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cerrar")),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial 4Life"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: _filtrarHistorial,
              decoration: const InputDecoration(
                labelText: 'Buscar paciente por nombre...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _historialFiltrado.isEmpty
                ? const Center(child: Text("No se encontraron registros"))
                : ListView.builder(
                    itemCount: _historialFiltrado.length,
                    itemBuilder: (context, i) {
                      final item = _historialFiltrado[i];
                      return ListTile(
                        leading: const Icon(Icons.assignment_ind),
                        title: Text(_nombrePaciente(item)),
                        subtitle:
                            Text("Fecha: ${item['fecha'] ?? 'Sin fecha'}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.blue),
                          onPressed: () => _reDiagnosticar(item),
                        ),
                        onTap: () => _verReporteAnterior(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PaginaDatosPaciente extends StatelessWidget {
  const PaginaDatosPaciente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datos del Paciente"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "No tienes datos guardados localmente.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para agregar nuevo paciente (no implementada)
        },
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PaginaHistorialChatbot extends StatefulWidget {
  const PaginaHistorialChatbot({super.key});

  @override
  State<PaginaHistorialChatbot> createState() => _PaginaHistorialChatbotState();
}

class _PaginaHistorialChatbotState extends State<PaginaHistorialChatbot> {
  List<Map<String, dynamic>> _conversaciones = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final datos = await ChatHistoryService.cargarConversaciones();
    if (!mounted) return;
    setState(() {
      _conversaciones = datos;
      _cargando = false;
    });
  }

  List<Map<String, String>> _mensajes(Map<String, dynamic> chat) {
    final raw = chat['mensajes'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((m) => {
              'rol': m['rol']?.toString() ?? 'usuario',
              'texto': m['texto']?.toString() ?? '',
            })
        .toList();
  }

  Future<void> _eliminar(String id) async {
    await ChatHistoryService.eliminarConversacion(id);
    await _cargar();
  }

  void _abrirChat(Map<String, dynamic> chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaChatbot(
          conversacionId: chat['id']?.toString(),
          mensajesIniciales: _mensajes(chat),
        ),
      ),
    ).then((_) => _cargar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de chats"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _conversaciones.isEmpty
              ? const Center(child: Text("No hay conversaciones guardadas"))
              : ListView.builder(
                  itemCount: _conversaciones.length,
                  itemBuilder: (context, index) {
                    final chat = _conversaciones[index];
                    final id = chat['id']?.toString() ?? '';
                    return ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: Text(chat['titulo']?.toString() ?? 'Chat 4Life'),
                      subtitle: Text("Fecha: ${chat['fecha'] ?? 'Sin fecha'}"),
                      onTap: () => _abrirChat(chat),
                      trailing: IconButton(
                        tooltip: "Eliminar",
                        icon: const Icon(Icons.delete_outline),
                        onPressed: id.isEmpty ? null : () => _eliminar(id),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaginaChatbot()),
        ).then((_) => _cargar()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PaginaChatbot extends StatefulWidget {
  final String? consultaInicial;
  final String? conversacionId;
  final List<Map<String, String>>? mensajesIniciales;

  const PaginaChatbot({
    super.key,
    this.consultaInicial,
    this.conversacionId,
    this.mensajesIniciales,
  });

  @override
  State<PaginaChatbot> createState() => _PaginaChatbotState();
}

class _PaginaChatbotState extends State<PaginaChatbot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> mensajes = [];
  bool enviando = false;
  late String _conversacionId;

  @override
  void initState() {
    super.initState();
    _conversacionId = widget.conversacionId ??
        DateTime.now().microsecondsSinceEpoch.toString();
    if (widget.mensajesIniciales != null) {
      mensajes.addAll(widget.mensajesIniciales!);
    }
    _controller.text = widget.consultaInicial ?? "";
  }

  Future<void> enviarMensaje() async {
    final textoUsuario = _controller.text.trim();
    if (textoUsuario.isEmpty || enviando) return;

    setState(() {
      mensajes.add({"rol": "usuario", "texto": textoUsuario});
      enviando = true;
    });
    _controller.clear();

    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: 'AIzaSyB3ea3TYD72dtfGyP9kSrjyot7RzMk0ZXk',
    );

    final historialPrevio = mensajes
        .take(mensajes.length - 1)
        .map((mensaje) =>
            "${mensaje['rol'] == 'ia' ? 'Asesor IA' : 'Socio'}: ${mensaje['texto']}")
        .join("\n");

    final promptLimpioParaChatbot = """
    Eres un asesor IA para socios de 4Life.
    Responde de manera clara, conversacional, sumamente ordenada y amigable.
    IMPORTANTE: No uses asteriscos (*), no uses almohadillas (#), ni guiones extraños para dar formato.
    Usa saltos de línea normales y texto limpio.
    Responde preguntas libres sobre suplementos, productos 4Life, hábitos saludables, ventas y seguimiento de clientes.
    REGLA OBLIGATORIA DE PRODUCTOS: Cuando recomiendes, compares, armes rutinas o sugieras productos,
    usa UNICAMENTE estos nombres del catalogo autorizado: $catalogoPermitido4Life.
    Si el socio pide algo que requiera un producto fuera de esa lista, explica que solo puedes recomendar
    productos del catalogo autorizado y ofrece alternativas dentro de esa lista.
    No inventes nombres, presentaciones ni productos adicionales.
    Mantén un tono claro, práctico y responsable. Si la pregunta parece médica, recomienda consultar a un profesional de salud.

    Conversación actual:
    $historialPrevio

    Consulta actual:
    $textoUsuario
    """;

    try {
      final response =
          await model.generateContent([Content.text(promptLimpioParaChatbot)]);
      final respuestaIA = response.text ?? "No pude generar una respuesta.";

      if (!mounted) return;
      setState(() {
        mensajes.add({"rol": "ia", "texto": respuestaIA});
      });
      await ChatHistoryService.guardarConversacion(_conversacionId, mensajes);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        mensajes.add({
          "rol": "ia",
          "texto": "No se pudo conectar con la IA. Intenta nuevamente."
        });
      });
      await ChatHistoryService.guardarConversacion(_conversacionId, mensajes);
    } finally {
      if (mounted) {
        setState(() => enviando = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asesor IA 4Life"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: "Historial de chats",
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaginaHistorialChatbot(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: mensajes.isEmpty
                ? const Center(
                    child: Text(
                      "Haz una pregunta para iniciar la conversación.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: mensajes.length,
                    itemBuilder: (context, i) {
                      final esIA = mensajes[i]["rol"] == "ia";
                      final texto = mensajes[i]["texto"] ?? "";
                      return ListTile(
                        leading: Icon(esIA ? Icons.smart_toy : Icons.person),
                        title: Text(esIA ? "Gemini 4Life" : "Tú"),
                        subtitle: Text(texto),
                        trailing: esIA
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: texto));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Copiado al portapapeles")),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () => Share.share(texto),
                                  ),
                                ],
                              )
                            : null,
                      );
                    },
                  ),
          ),
          if (enviando)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Pregunta lo que sea...",
                      border: OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 4,
                    onSubmitted: (_) => enviarMensaje(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: enviando ? null : enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
