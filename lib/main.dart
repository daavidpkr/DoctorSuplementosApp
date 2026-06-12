import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'services/servicio_texto_voz.dart';
import 'services/servicio_version.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

const List<String> productosPermitidos4Life = [
  'Agpro',
  'Bcv',
  'Belle vie',
  'Bioefa',
  'Colageno tipo i',
  'Crema cuerpo',
  'Crema humectante',
  'Crema para los ojos',
  'Energy go stix',
  'Fibre',
  'Glucoach',
  'Glutamine prime',
  'Kbu',
  'Limpiador',
  'Malepro',
  'Nutrastart',
  'Pasta de dientes',
  'Preo biotics',
  'Protf',
  'Recall',
  'Renuvo',
  'Riovida burst',
  'Riovida stix',
  'Suero',
  'TF Boost',
  'Tonico',
  'Transfer factor plus',
  'Transfer factor tri factor',
  'Vistari',
];

const double escalaTextoInterfaces = 0.90;

final String catalogoPermitido4Life = productosPermitidos4Life.join(', ');

const List<String> productosCambioFisico4Life = [
  '4Life Transfer Factor GluCoach',
  'Energy Go Stix Berry',
  '4Life TF-Boost',
  'RioVida Stix',
  'RioVida Burst',
  '4Life Transfer Factor Colageno',
  'Pro-TF',
  'NutraStart',
  'BioEFA con CLA',
  '4Life Transfer Factor BCV',
  'Glutamine Prime',
  'Renuvo',
];

final String catalogoCambioFisico4Life = productosCambioFisico4Life.join(', ');

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

class LineaProductoPrecio {
  final ProductoPrecio producto;
  final int cantidad;

  const LineaProductoPrecio({
    required this.producto,
    required this.cantidad,
  });

  LineaProductoPrecio copyWith({int? cantidad}) {
    return LineaProductoPrecio(
      producto: producto,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}

class ConsultaProductoCantidad {
  final String texto;
  final int cantidad;

  const ConsultaProductoCantidad({
    required this.texto,
    required this.cantidad,
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

int distanciaLevenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  var anterior = List<int>.generate(b.length + 1, (i) => i);
  for (var i = 0; i < a.length; i++) {
    final actual = List<int>.filled(b.length + 1, 0);
    actual[0] = i + 1;
    for (var j = 0; j < b.length; j++) {
      final costo = a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1;
      actual[j + 1] = [
        actual[j] + 1,
        anterior[j + 1] + 1,
        anterior[j] + costo,
      ].reduce((min, value) => value < min ? value : min);
    }
    anterior = actual;
  }
  return anterior.last;
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
  final puntajePalabras = ((coincidencias / palabras.length) * 70).round();

  final maxLen = qClave.length > pClave.length ? qClave.length : pClave.length;
  if (maxLen == 0) return puntajePalabras;
  final distancia = distanciaLevenshtein(qClave, pClave);
  final similitud = (((maxLen - distancia) / maxLen) * 100).round();

  var mejorToken = 0;
  for (final palabraConsulta in palabras) {
    for (final palabraProducto in palabrasProducto) {
      final largo = palabraConsulta.length > palabraProducto.length
          ? palabraConsulta.length
          : palabraProducto.length;
      if (largo < 3) continue;
      final distanciaToken =
          distanciaLevenshtein(palabraConsulta, palabraProducto);
      final similitudToken = (((largo - distanciaToken) / largo) * 100).round();
      if (similitudToken > mejorToken) mejorToken = similitudToken;
    }
  }

  return [puntajePalabras, similitud, mejorToken].reduce(
    (max, value) => value > max ? value : max,
  );
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

ConsultaProductoCantidad extraerConsultaConCantidad(String texto) {
  final limpio = texto.trim();
  final match = RegExp(r'^(\d+)\s*[xX]?\s+(.+)$').firstMatch(limpio);
  if (match == null) {
    return ConsultaProductoCantidad(texto: limpio, cantidad: 1);
  }

  final cantidad = int.tryParse(match.group(1) ?? '') ?? 1;
  final producto = (match.group(2) ?? limpio).trim();
  return ConsultaProductoCantidad(
    texto: producto,
    cantidad: cantidad.clamp(1, 999).toInt(),
  );
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

class ArchivoAdjuntoIA {
  final String nombre;
  final String mimeType;
  final Uint8List bytes;

  const ArchivoAdjuntoIA({
    required this.nombre,
    required this.mimeType,
    required this.bytes,
  });

  bool get esImagen => mimeType.startsWith('image/');
  bool get esPdf => mimeType == 'application/pdf';
  bool get esAudio => mimeType.startsWith('audio/');
}

class PerfilAsesor {
  final String nombre;
  final String fotoBase64;

  const PerfilAsesor({
    required this.nombre,
    required this.fotoBase64,
  });

  bool get tieneNombre => nombre.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'nombre': nombre.trim(),
        'fotoBase64': fotoBase64,
      };

  factory PerfilAsesor.fromJson(Map<String, dynamic> json) {
    return PerfilAsesor(
      nombre: json['nombre']?.toString() ?? '',
      fotoBase64: json['fotoBase64']?.toString() ?? '',
    );
  }
}

class PerfilService {
  static const String _prefsKey = 'perfil_asesor_4life';
  static const String _documentId = 'perfil_principal';

  static Future<PerfilAsesor> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null && raw.isNotEmpty) {
      return PerfilAsesor.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('perfiles_asesores')
          .doc(_documentId)
          .get();
      final data = doc.data();
      if (data != null) {
        final perfil = PerfilAsesor.fromJson(data);
        await prefs.setString(_prefsKey, jsonEncode(perfil.toJson()));
        return perfil;
      }
    } catch (e) {
      debugPrint('No se pudo cargar el perfil desde Firebase: $e');
    }

    return const PerfilAsesor(nombre: '', fotoBase64: '');
  }

  static Future<void> guardar(PerfilAsesor perfil) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(perfil.toJson()));

    try {
      await FirebaseFirestore.instance
          .collection('perfiles_asesores')
          .doc(_documentId)
          .set({
        ...perfil.toJson(),
        'actualizadoEn': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('No se pudo guardar el perfil en Firebase: $e');
    }
  }
}

class ImpactoService {
  static const String _prefsKey = 'impacto_4life';

  static Future<void> registrar({
    required String tipo,
    required String titulo,
    Map<String, dynamic> datos = const {},
    bool guardarEnFirebase = true,
  }) async {
    final registro = {
      'tipo': tipo,
      'titulo': titulo,
      'fecha': DateTime.now().toIso8601String(),
      'datos': datos,
    };

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey) ?? [];
    raw.insert(0, jsonEncode(registro));
    await prefs.setStringList(_prefsKey, raw);

    if (!guardarEnFirebase) return;

    try {
      await FirebaseFirestore.instance.collection('impacto_4life').add({
        ...registro,
        'creadoEn': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('No se pudo guardar el impacto en Firebase: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> cargarEventos() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey) ?? [];
    return raw.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }
}

const FirebaseOptions _firebaseOptionsEscritorio = FirebaseOptions(
  apiKey: 'AIzaSyDY1ZyaLp8i8KVtcEnyUzgNFz0b0M191kA',
  appId: '1:916760929366:android:13656f89d780918867c7f7',
  messagingSenderId: '916760929366',
  projectId: 'doctorsuplementos-4bbb1',
  storageBucket: 'doctorsuplementos-4bbb1.firebasestorage.app',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inicializarFirebaseSeguro();
  runApp(const DoctorSuplementos());
}

Future<void> inicializarFirebaseSeguro() async {
  try {
    try {
      await Firebase.initializeApp().timeout(const Duration(seconds: 5));
    } catch (_) {
      await Firebase.initializeApp(options: _firebaseOptionsEscritorio)
          .timeout(const Duration(seconds: 5));
    }
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
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: media.textScaler.clamp(
              minScaleFactor: 0.82,
              maxScaleFactor: escalaTextoInterfaces,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5EE),
        primaryColor: const Color(0xFF1A237E),
      ),
      home: const PantallaPrincipal(),
    );
  }
}

// --- PANTALLA PRINCIPAL ---
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  late Future<PerfilAsesor> _perfilFuture;

  @override
  void initState() {
    super.initState();
    _perfilFuture = PerfilService.cargar();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ServicioVersion.validarVersion(context);
    });
  }

  void _recargarPerfil() {
    setState(() {
      _perfilFuture = PerfilService.cargar();
    });
  }

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
                    FutureBuilder<PerfilAsesor>(
                      future: _perfilFuture,
                      builder: (context, snapshot) {
                        return _heroAsesor(context, snapshot.data);
                      },
                    ),
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
                      titulo: "Calculadora de precios",
                      descripcion:
                          "Calcula precios, LP: Life Points (Puntos de Vida) y totales para uno o varios productos.",
                      icono: Icons.calculate_rounded,
                      colores: const [Color(0xFF008C7E), Color(0xFF006B61)],
                      destino: const PaginaCalculadoraPrecios(),
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
                      titulo: "Cambio fisico",
                      descripcion:
                          "Crea una guia personalizada para objetivos corporales.",
                      icono: Icons.fitness_center_rounded,
                      colores: const [Color(0xFF1457E8), Color(0xFF1531A6)],
                      destino: const FormularioCambioFisico(),
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
                      titulo: "Chat Live 4Life",
                      descripcion:
                          "Pregunta en tiempo real y recibe respuestas personalizadas de la IA.",
                      icono: Icons.forum_rounded,
                      colores: const [Color(0xFF6A4DE8), Color(0xFF3C2AAE)],
                      destino: const PaginaChatbot(
                        titulo: "Chat Live 4Life",
                        modoLlamada: true,
                      ),
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
                    _tarjetaMenu(
                      context,
                      titulo: "Perfil",
                      descripcion:
                          "Guarda tu nombre y foto para personalizar la app.",
                      icono: Icons.person_rounded,
                      colores: const [Color(0xFF455A64), Color(0xFF263238)],
                      destino: PaginaPerfil(onPerfilGuardado: _recargarPerfil),
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

  Widget _heroAsesor(BuildContext context, PerfilAsesor? perfil) {
    final nombre = perfil?.nombre.trim() ?? '';
    final saludo = nombre.isEmpty ? "¡Hola, Asesor!" : "¡Hola, $nombre!";
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
                Text(
                  saludo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
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
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaImpacto4LifeNueva(),
                    ),
                  ),
                  child: Container(
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
            "Diagnosticos",
            Icons.assignment_turned_in_outlined,
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
            PaginaPerfil(onPerfilGuardado: _recargarPerfil),
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

class PaginaPerfil extends StatefulWidget {
  final VoidCallback? onPerfilGuardado;

  const PaginaPerfil({super.key, this.onPerfilGuardado});

  @override
  State<PaginaPerfil> createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> {
  final TextEditingController _nombreController = TextEditingController();
  String _fotoBase64 = '';
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    final perfil = await PerfilService.cargar();
    if (!mounted) return;
    setState(() {
      _nombreController.text = perfil.nombre;
      _fotoBase64 = perfil.fotoBase64;
      _cargando = false;
    });
  }

  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    final imagen = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 700,
      imageQuality: 70,
    );
    if (imagen == null) return;

    final bytes = await imagen.readAsBytes();
    setState(() {
      _fotoBase64 = base64Encode(bytes);
    });
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    final perfil = PerfilAsesor(
      nombre: _nombreController.text,
      fotoBase64: _fotoBase64,
    );
    await PerfilService.guardar(perfil);
    widget.onPerfilGuardado?.call();
    if (!mounted) return;
    setState(() => _guardando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil guardado")),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fotoBytes = _fotoBase64.isEmpty ? null : base64Decode(_fotoBase64);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Stack(
        children: [
          Container(
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF172B98), Color(0xFF07125E)],
              ),
            ),
          ),
          SafeArea(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF172394),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                    child: Column(
                      children: [
                        _encabezadoPerfil(),
                        const SizedBox(height: 44),
                        _tarjetaFotoPerfil(fotoBytes),
                        const SizedBox(height: 22),
                        _tarjetaInformacionAsesor(),
                        const SizedBox(height: 28),
                        _botonGuardarPerfil(),
                        const SizedBox(height: 28),
                        _tarjetaSeguridadPerfil(),
                        const SizedBox(height: 18),
                        _copyrightPerfil(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _encabezadoPerfil() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          iconSize: 34,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Perfil del asesor",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Gestiona tu informacion personal",
                style: TextStyle(
                  color: Color(0xFFD9DFFF),
                  fontSize: 18,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tarjetaFotoPerfil(Uint8List? fotoBytes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 30, 28, 30),
      decoration: _decoracionTarjetaPerfil(),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 72,
                backgroundColor: const Color(0xFFE7EAFF),
                backgroundImage:
                    fotoBytes == null ? null : MemoryImage(fotoBytes),
                child: fotoBytes == null
                    ? ClipOval(
                        child: Image.asset(
                          'assets/icon.png',
                          width: 144,
                          height: 144,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person_rounded,
                            color: Color(0xFF172394),
                            size: 86,
                          ),
                        ),
                      )
                    : null,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(36),
                onTap: _seleccionarFoto,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4059EA), Color(0xFF172394)],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Icon(
                    Icons.photo_camera_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 34),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Foto de perfil",
                  style: TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Agrega una foto para personalizar tu perfil y que otros te reconozcan facilmente.",
                  style: TextStyle(
                    color: Color(0xFF3F4A82),
                    fontSize: 18,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 26),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _seleccionarFoto,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF1FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.photo_camera_rounded,
                            color: Color(0xFF4059EA), size: 28),
                        SizedBox(width: 14),
                        Text(
                          "Cambiar foto",
                          style: TextStyle(
                            color: Color(0xFF3150D9),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
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

  Widget _tarjetaInformacionAsesor() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
      decoration: _decoracionTarjetaPerfil(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informacion del asesor",
            style: TextStyle(
              color: Color(0xFF12248B),
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Nombre del asesor",
            style: TextStyle(
              color: Color(0xFF2F3A78),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nombreController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Ingresa tu nombre completo",
              hintStyle: const TextStyle(
                color: Color(0xFF6B7192),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF5B628C),
                size: 30,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFFC8CDE0), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF4059EA), width: 1.8),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Este nombre sera visible para tus clientes y en tus reportes.",
            style: TextStyle(
              color: Color(0xFF2F3A78),
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonGuardarPerfil() {
    return InkWell(
      borderRadius: BorderRadius.circular(36),
      onTap: _guardando ? null : _guardar,
      child: Container(
        height: 76,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF172394), Color(0xFF0B176B)],
          ),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: _guardando
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save_rounded, color: Colors.white, size: 30),
                    SizedBox(width: 18),
                    Text(
                      "Guardar perfil",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _tarjetaSeguridadPerfil() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF0FF), Color(0xFFF5F7FF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFE1E6FF),
            child: Icon(
              Icons.health_and_safety_outlined,
              color: Color(0xFF172394),
              size: 42,
            ),
          ),
          SizedBox(width: 26),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tu informacion esta segura",
                  style: TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  "Tus datos personales estan protegidos y solo se utilizaran dentro de la aplicacion.",
                  style: TextStyle(
                    color: Color(0xFF17246B),
                    fontSize: 18,
                    height: 1.35,
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

  Widget _copyrightPerfil() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E4F0)),
      ),
      child: const Text(
        "Copyright © 2026 Josué David Girón Castro. All Rights Reserved.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF5B628C),
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  BoxDecoration _decoracionTarjetaPerfil() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF0B176B).withValues(alpha: 0.08),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

class PaginaImpacto4LifeNueva extends StatefulWidget {
  const PaginaImpacto4LifeNueva({super.key});

  @override
  State<PaginaImpacto4LifeNueva> createState() =>
      _PaginaImpacto4LifeNuevaState();
}

class _PaginaImpacto4LifeNuevaState extends State<PaginaImpacto4LifeNueva> {
  static const _azulVivo = Color(0xFF173BE5);
  static const _verde = Color(0xFF0FA64A);
  static const _naranja = Color(0xFFFF8500);
  static const _tinta = Color(0xFF07136E);
  static const _textoSuave = Color(0xFF56618F);

  List<Map<String, dynamic>> _eventos = [];
  bool _cargando = true;
  String? _mesSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final eventos = await ImpactoService.cargarEventos();
    final grupos = _agruparPorMes(eventos);
    final claves = grupos.keys.toList()..sort((a, b) => b.compareTo(a));
    if (!mounted) return;
    setState(() {
      _eventos = eventos;
      _mesSeleccionado =
          claves.isNotEmpty ? claves.first : _claveMes(DateTime.now());
      _cargando = false;
    });
  }

  DateTime? _fechaEvento(Map<String, dynamic> evento) {
    final raw = evento['fecha']?.toString();
    return raw == null ? null : DateTime.tryParse(raw);
  }

  String _claveMes(DateTime fecha) {
    return '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}';
  }

  DateTime _fechaDesdeClave(String clave) {
    final partes = clave.split('-');
    return DateTime(
      int.tryParse(partes.first) ?? DateTime.now().year,
      int.tryParse(partes.last) ?? DateTime.now().month,
    );
  }

  String _claveMesAnterior(String clave) {
    final fecha = _fechaDesdeClave(clave);
    return _claveMes(DateTime(fecha.year, fecha.month - 1));
  }

  String _nombreMes(DateTime fecha) {
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${meses[fecha.month - 1]} ${fecha.year}';
  }

  String _mesCorto(DateTime fecha) {
    const meses = [
      'ene.',
      'feb.',
      'mar.',
      'abr.',
      'may.',
      'jun.',
      'jul.',
      'ago.',
      'sep.',
      'oct.',
      'nov.',
      'dic.',
    ];
    return meses[fecha.month - 1];
  }

  String _rangoMes(DateTime fecha) {
    final ultimoDia = DateTime(fecha.year, fecha.month + 1, 0).day;
    return 'del 1 al $ultimoDia';
  }

  Map<String, List<Map<String, dynamic>>> _agruparPorMes(
    List<Map<String, dynamic>> eventos,
  ) {
    final grupos = <String, List<Map<String, dynamic>>>{};
    for (final evento in eventos) {
      final fecha = _fechaEvento(evento);
      if (fecha == null) continue;
      grupos.putIfAbsent(_claveMes(fecha), () => []).add(evento);
    }
    return grupos;
  }

  _ResumenImpactoNuevo _resumen(
    List<Map<String, dynamic>> eventos, {
    required String clave,
    required int totalAnterior,
  }) {
    final fecha = _fechaDesdeClave(clave);
    final totalDias = DateTime(fecha.year, fecha.month + 1, 0).day;
    final dias = List<int>.filled(totalDias, 0);
    final horas = List<int>.filled(24, 0);
    final productos = <String, int>{};
    final pacientes = <String>{};
    var diagnosticos = 0;
    var consultasProducto = 0;
    var calculadoras = 0;

    for (final evento in eventos) {
      switch (evento['tipo']) {
        case 'diagnostico':
          diagnosticos++;
          break;
        case 'consulta_producto':
          consultasProducto++;
          break;
        case 'calculadora_productos':
          calculadoras++;
          break;
      }

      final fechaEvento = _fechaEvento(evento);
      if (fechaEvento != null) {
        dias[(fechaEvento.day - 1).clamp(0, totalDias - 1)]++;
        horas[fechaEvento.hour]++;
      }

      final datos = evento['datos'];
      if (datos is! Map) continue;
      final nombrePaciente = datos['nombre']?.toString().trim();
      if (nombrePaciente != null && nombrePaciente.isNotEmpty) {
        pacientes.add(nombrePaciente.toLowerCase());
      }

      final producto = datos['producto']?.toString().trim();
      if (producto != null && producto.isNotEmpty) {
        productos.update(producto, (valor) => valor + 1, ifAbsent: () => 1);
      }

      final lista = datos['productos'];
      if (lista is List) {
        for (final item in lista) {
          String? nombre;
          var cantidad = 1;
          if (item is Map) {
            nombre = item['nombre']?.toString().trim();
            cantidad = int.tryParse('${item['cantidad'] ?? 1}') ?? 1;
          } else {
            nombre = item.toString().trim();
          }
          if (nombre != null && nombre.isNotEmpty) {
            productos.update(nombre, (valor) => valor + cantidad,
                ifAbsent: () => cantidad);
          }
        }
      }
    }

    final productosOrdenados = productos.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final mayorHora = horas.reduce((a, b) => a > b ? a : b);
    final horaActiva = mayorHora == 0 ? 19 : horas.indexOf(mayorHora);

    return _ResumenImpactoNuevo(
      diagnosticos: diagnosticos,
      consultasProducto: consultasProducto,
      calculadoras: calculadoras,
      productos: productosOrdenados,
      accionesPorDia: dias,
      accionesPorHora: horas,
      pacientes: pacientes.length,
      horaActiva: horaActiva,
      totalAnterior: totalAnterior,
    );
  }

  @override
  Widget build(BuildContext context) {
    final grupos = _agruparPorMes(_eventos);
    final claves = grupos.keys.toList()..sort((a, b) => b.compareTo(a));
    final clave = _mesSeleccionado ??
        (claves.isNotEmpty ? claves.first : _claveMes(DateTime.now()));
    final fecha = _fechaDesdeClave(clave);
    final eventosMes = grupos[clave] ?? const <Map<String, dynamic>>[];
    final resumen = _resumen(
      eventosMes,
      clave: clave,
      totalAnterior: (grupos[_claveMesAnterior(clave)] ?? const []).length,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: _azulVivo))
          : Column(
              children: [
                _HeaderImpactoNuevo(onBack: () => Navigator.pop(context)),
                Expanded(
                  child: RefreshIndicator(
                    color: _azulVivo,
                    onRefresh: _cargar,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
                      children: [
                        _SelectorMesImpactoNuevo(
                          mes: _nombreMes(fecha),
                          rango: _rangoMes(fecha),
                          claves: claves,
                          claveSeleccionada: clave,
                          nombreClave: (item) =>
                              _nombreMes(_fechaDesdeClave(item)),
                          onSeleccionar: (item) =>
                              setState(() => _mesSeleccionado = item),
                        ),
                        const SizedBox(height: 14),
                        _CardResumenImpactoNuevo(resumen: resumen),
                        const SizedBox(height: 14),
                        _CardEvolucionImpactoNuevo(
                          resumen: resumen,
                          mesCorto: _mesCorto(fecha),
                        ),
                        const SizedBox(height: 14),
                        _CardProductosImpactoNuevo(
                            productos: resumen.productos),
                        const SizedBox(height: 14),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 620) {
                              return Column(
                                children: [
                                  _CardPacientesImpactoNuevo(resumen: resumen),
                                  const SizedBox(height: 14),
                                  _CardHorasImpactoNuevo(resumen: resumen),
                                ],
                              );
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: _CardPacientesImpactoNuevo(
                                        resumen: resumen)),
                                const SizedBox(width: 14),
                                Expanded(
                                    child: _CardHorasImpactoNuevo(
                                        resumen: resumen)),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        _CardCompromisoImpactoNuevo(resumen: resumen),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ResumenImpactoNuevo {
  final int diagnosticos;
  final int consultasProducto;
  final int calculadoras;
  final List<MapEntry<String, int>> productos;
  final List<int> accionesPorDia;
  final List<int> accionesPorHora;
  final int pacientes;
  final int horaActiva;
  final int totalAnterior;

  const _ResumenImpactoNuevo({
    required this.diagnosticos,
    required this.consultasProducto,
    required this.calculadoras,
    required this.productos,
    required this.accionesPorDia,
    required this.accionesPorHora,
    required this.pacientes,
    required this.horaActiva,
    required this.totalAnterior,
  });

  int get total => diagnosticos + consultasProducto + calculadoras;
  int get variacion {
    if (totalAnterior == 0) return total == 0 ? 0 : 100;
    return (((total - totalAnterior) / totalAnterior) * 100).round();
  }

  double get compromiso => (total / 95).clamp(0.0, 1.0);
}

class _HeaderImpactoNuevo extends StatelessWidget {
  final VoidCallback onBack;

  const _HeaderImpactoNuevo({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF072393), Color(0xFF07146A)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.white,
                iconSize: 34,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints.tightFor(width: 46, height: 46),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Text(
                  'Tu impacto 4Life',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.calendar_month_outlined),
                color: Colors.white,
                iconSize: 34,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectorMesImpactoNuevo extends StatelessWidget {
  final String mes;
  final String rango;
  final List<String> claves;
  final String claveSeleccionada;
  final String Function(String clave) nombreClave;
  final ValueChanged<String> onSeleccionar;

  const _SelectorMesImpactoNuevo({
    required this.mes,
    required this.rango,
    required this.claves,
    required this.claveSeleccionada,
    required this.nombreClave,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return _CardImpactoNuevo(
      padding: const EdgeInsets.fromLTRB(20, 18, 18, 18),
      child: Row(
        children: [
          _IconoSuaveImpacto(
              icono: Icons.calendar_month_outlined,
              color: _PaginaImpacto4LifeNuevaState._azulVivo),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mes,
                  style: const TextStyle(
                    color: _PaginaImpacto4LifeNuevaState._tinta,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rango,
                  style: const TextStyle(
                    color: _PaginaImpacto4LifeNuevaState._textoSuave,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Cambiar mes',
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: _PaginaImpacto4LifeNuevaState._azulVivo, size: 36),
            onSelected: onSeleccionar,
            itemBuilder: (context) {
              final opciones = claves.isEmpty ? [claveSeleccionada] : claves;
              return [
                for (final clave in opciones)
                  PopupMenuItem(
                    value: clave,
                    child: Text(nombreClave(clave)),
                  ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

class _CardImpactoNuevo extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _CardImpactoNuevo({
    required this.child,
    this.padding = const EdgeInsets.all(22),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardResumenImpactoNuevo extends StatelessWidget {
  final _ResumenImpactoNuevo resumen;

  const _CardResumenImpactoNuevo({required this.resumen});

  @override
  Widget build(BuildContext context) {
    final maximo = [
      resumen.diagnosticos,
      resumen.consultasProducto,
      resumen.calculadoras,
      1
    ].reduce((a, b) => a > b ? a : b);
    return _CardImpactoNuevo(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compacto = constraints.maxWidth < 520;
          final grafico = SizedBox(
            width: compacto ? 190 : 230,
            height: compacto ? 190 : 230,
            child: CustomPaint(
              painter: _AnilloImpactoNuevo(
                diagnosticos: resumen.diagnosticos,
                productos: resumen.consultasProducto,
                calculadora: resumen.calculadoras,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${resumen.total}',
                      style: const TextStyle(
                        color: _PaginaImpacto4LifeNuevaState._azulVivo,
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'acciones\ntotales',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _PaginaImpacto4LifeNuevaState._textoSuave,
                        fontSize: 18,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          final barras = Column(
            children: [
              _FilaMetricaImpacto(
                  icono: Icons.monitor_heart_outlined,
                  etiqueta: 'Diagnosticos',
                  valor: resumen.diagnosticos,
                  maximo: maximo,
                  color: _PaginaImpacto4LifeNuevaState._verde),
              const SizedBox(height: 24),
              _FilaMetricaImpacto(
                  icono: Icons.medication_liquid_outlined,
                  etiqueta: 'Productos',
                  valor: resumen.consultasProducto,
                  maximo: maximo,
                  color: _PaginaImpacto4LifeNuevaState._azulVivo),
              const SizedBox(height: 24),
              _FilaMetricaImpacto(
                  icono: Icons.calculate_outlined,
                  etiqueta: 'Calculadora',
                  valor: resumen.calculadoras,
                  maximo: maximo,
                  color: _PaginaImpacto4LifeNuevaState._naranja),
            ],
          );
          if (compacto) {
            return Column(
                children: [grafico, const SizedBox(height: 26), barras]);
          }
          return Row(
            children: [
              grafico,
              Container(
                  width: 1,
                  height: 250,
                  margin: const EdgeInsets.symmetric(horizontal: 26),
                  color: const Color(0xFFE1E5F2)),
              Expanded(child: barras),
            ],
          );
        },
      ),
    );
  }
}

class _FilaMetricaImpacto extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final int valor;
  final int maximo;
  final Color color;

  const _FilaMetricaImpacto({
    required this.icono,
    required this.etiqueta,
    required this.valor,
    required this.maximo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progreso = maximo == 0 ? 0.0 : (valor / maximo).clamp(0.0, 1.0);
    return Row(
      children: [
        _IconoSuaveImpacto(icono: icono, color: color),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      etiqueta,
                      style: const TextStyle(
                        color: _PaginaImpacto4LifeNuevaState._tinta,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    '$valor',
                    style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progreso,
                  minHeight: 13,
                  color: color,
                  backgroundColor: const Color(0xFFE4E8F5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconoSuaveImpacto extends StatelessWidget {
  final IconData icono;
  final Color color;

  const _IconoSuaveImpacto({required this.icono, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icono, color: color, size: 34),
    );
  }
}

class _CardEvolucionImpactoNuevo extends StatelessWidget {
  final _ResumenImpactoNuevo resumen;
  final String mesCorto;

  const _CardEvolucionImpactoNuevo({
    required this.resumen,
    required this.mesCorto,
  });

  @override
  Widget build(BuildContext context) {
    final variacion = resumen.variacion;
    return _CardImpactoNuevo(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Evolucion de acciones',
                  style: TextStyle(
                    color: _PaginaImpacto4LifeNuevaState._tinta,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${variacion >= 0 ? '+' : ''}$variacion%',
                    style: TextStyle(
                      color: variacion >= 0
                          ? _PaginaImpacto4LifeNuevaState._verde
                          : const Color(0xFFD33B3B),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'vs. mes anterior',
                    style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 165,
            child: CustomPaint(
              painter: _LineaImpactoNuevo(
                resumen.accionesPorDia,
                mesCorto,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardProductosImpactoNuevo extends StatelessWidget {
  final List<MapEntry<String, int>> productos;

  const _CardProductosImpactoNuevo({required this.productos});

  @override
  Widget build(BuildContext context) {
    final visibles = productos.take(5).toList();
    return _CardImpactoNuevo(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Productos mas consultados',
                  style: TextStyle(
                    color: _PaginaImpacto4LifeNuevaState._tinta,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                'Ver todos',
                style: TextStyle(
                  color: _PaginaImpacto4LifeNuevaState._azulVivo,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded,
                  color: _PaginaImpacto4LifeNuevaState._azulVivo, size: 28),
            ],
          ),
          const SizedBox(height: 22),
          if (visibles.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Sin productos registrados este mes',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w700),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth < 520
                    ? 128.0
                    : constraints.maxWidth / 5;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < visibles.length; i++)
                        SizedBox(
                          width: itemWidth,
                          child: _ProductoImpactoNuevo(
                            posicion: i + 1,
                            nombre: visibles[i].key,
                            consultas: visibles[i].value,
                            color: [
                              _PaginaImpacto4LifeNuevaState._azulVivo,
                              const Color(0xFF2AA6B8),
                              const Color(0xFF6832DF),
                              _PaginaImpacto4LifeNuevaState._verde,
                              _PaginaImpacto4LifeNuevaState._naranja,
                            ][i],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ProductoImpactoNuevo extends StatelessWidget {
  final int posicion;
  final String nombre;
  final int consultas;
  final Color color;

  const _ProductoImpactoNuevo({
    required this.posicion,
    required this.nombre,
    required this.consultas,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2FD),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.medication_liquid_outlined,
                      color: color, size: 42),
                ),
              ),
              Positioned(
                left: -2,
                top: -2,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: _PaginaImpacto4LifeNuevaState._azulVivo,
                  child: Text(
                    '$posicion',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          nombre,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _PaginaImpacto4LifeNuevaState._tinta,
            fontSize: 15,
            height: 1.12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$consultas ${consultas == 1 ? 'consulta' : 'consultas'}',
          style: const TextStyle(
            color: _PaginaImpacto4LifeNuevaState._textoSuave,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CardPacientesImpactoNuevo extends StatelessWidget {
  final _ResumenImpactoNuevo resumen;

  const _CardPacientesImpactoNuevo({required this.resumen});

  @override
  Widget build(BuildContext context) {
    return _CardImpactoNuevo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pacientes atendidos',
            style: TextStyle(
                color: _PaginaImpacto4LifeNuevaState._tinta,
                fontSize: 21,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const _IconoSuaveImpacto(
                  icono: Icons.groups_2_outlined,
                  color: _PaginaImpacto4LifeNuevaState._azulVivo),
              const SizedBox(width: 26),
              Text(
                '${resumen.pacientes}',
                style: const TextStyle(
                    color: _PaginaImpacto4LifeNuevaState._tinta,
                    fontSize: 44,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'este mes',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            '${resumen.variacion >= 0 ? '+' : ''}${resumen.variacion}%\nvs. mes anterior',
            style: TextStyle(
              color: resumen.variacion >= 0
                  ? _PaginaImpacto4LifeNuevaState._verde
                  : const Color(0xFFD33B3B),
              fontSize: 19,
              height: 1.35,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardHorasImpactoNuevo extends StatelessWidget {
  final _ResumenImpactoNuevo resumen;

  const _CardHorasImpactoNuevo({required this.resumen});

  String _hora(int hora) {
    final periodo = hora >= 12 ? 'PM' : 'AM';
    final h = hora % 12 == 0 ? 12 : hora % 12;
    return '$h:00 $periodo';
  }

  @override
  Widget build(BuildContext context) {
    return _CardImpactoNuevo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Horas mas activas',
            style: TextStyle(
                color: _PaginaImpacto4LifeNuevaState._tinta,
                fontSize: 21,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _PaginaImpacto4LifeNuevaState._azulVivo
                      .withValues(alpha: 0.11),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.schedule_rounded,
                    color: _PaginaImpacto4LifeNuevaState._azulVivo, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  '${_hora(resumen.horaActiva)} - ${_hora((resumen.horaActiva + 2).clamp(0, 23))}',
                  style: const TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._tinta,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 50, top: 4),
            child: Text(
              'Pico de consultas',
              style: TextStyle(
                  color: _PaginaImpacto4LifeNuevaState._textoSuave,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 94,
            child: CustomPaint(
              painter: _BarrasHorasImpactoNuevo(
                  resumen.accionesPorHora, resumen.horaActiva),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardCompromisoImpactoNuevo extends StatelessWidget {
  final _ResumenImpactoNuevo resumen;

  const _CardCompromisoImpactoNuevo({required this.resumen});

  @override
  Widget build(BuildContext context) {
    final porcentaje = (resumen.compromiso * 100).round();
    return _CardImpactoNuevo(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      child: Column(
        children: [
          Row(
            children: [
              const _IconoSuaveImpacto(
                  icono: Icons.volunteer_activism_outlined,
                  color: _PaginaImpacto4LifeNuevaState._verde),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu compromiso en 4Life',
                      style: TextStyle(
                          color: _PaginaImpacto4LifeNuevaState._tinta,
                          fontSize: 19,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Estas generando habitos mas saludables y ayudando a transformar vidas.',
                      style: TextStyle(
                          color: _PaginaImpacto4LifeNuevaState._textoSuave,
                          fontSize: 15.5,
                          height: 1.35,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _PaginaImpacto4LifeNuevaState._verde,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  '$porcentaje%',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 17,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: Color(0xFFE7EAF4)),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: resumen.compromiso,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xFFFF2E2E),
                          Color(0xFFFFB000),
                          Color(0xFF45B846)
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w800)),
              Text('25%',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w800)),
              Text('50%',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w800)),
              Text('75%',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w800)),
              Text('100%',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnilloImpactoNuevo extends CustomPainter {
  final int diagnosticos;
  final int productos;
  final int calculadora;

  const _AnilloImpactoNuevo({
    required this.diagnosticos,
    required this.productos,
    required this.calculadora,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = diagnosticos + productos + calculadora;
    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2 - 13);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFE6EAF5);
    canvas.drawArc(rect, -1.5708, 6.28318, false, base);
    if (total == 0) return;

    final segmentos = [
      MapEntry(diagnosticos, _PaginaImpacto4LifeNuevaState._verde),
      MapEntry(productos, _PaginaImpacto4LifeNuevaState._azulVivo),
      MapEntry(calculadora, _PaginaImpacto4LifeNuevaState._naranja),
    ];
    var inicio = -1.5708;
    for (final segmento in segmentos) {
      if (segmento.key <= 0) continue;
      final sweep = segmento.key / total * 6.28318;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 25
        ..strokeCap = StrokeCap.round
        ..color = segmento.value;
      canvas.drawArc(rect, inicio, sweep, false, paint);
      inicio += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _AnilloImpactoNuevo oldDelegate) {
    return oldDelegate.diagnosticos != diagnosticos ||
        oldDelegate.productos != productos ||
        oldDelegate.calculadora != calculadora;
  }
}

class _LineaImpactoNuevo extends CustomPainter {
  final List<int> dias;
  final String mesCorto;

  const _LineaImpactoNuevo(this.dias, this.mesCorto);

  @override
  void paint(Canvas canvas, Size size) {
    final grafico = Rect.fromLTWH(46, 6, size.width - 54, size.height - 34);
    final grid = Paint()
      ..color = const Color(0xFFDDE2F0)
      ..strokeWidth = 1;
    final texto = TextPainter(textDirection: TextDirection.ltr);
    const labelsY = [100, 75, 50, 25, 0];
    for (var i = 0; i < labelsY.length; i++) {
      final y = grafico.top + (grafico.height / 4) * i;
      canvas.drawLine(Offset(grafico.left, y), Offset(grafico.right, y), grid);
      texto.text = TextSpan(
        text: '${labelsY[i]}',
        style: const TextStyle(
            color: _PaginaImpacto4LifeNuevaState._textoSuave,
            fontSize: 13,
            fontWeight: FontWeight.w700),
      );
      texto.layout();
      texto.paint(canvas, Offset(4, y - 8));
    }

    final acumulados = <int>[];
    var acumulado = 0;
    for (final valor in dias) {
      acumulado += valor;
      acumulados.add(acumulado);
    }
    final maximo = [100, ...acumulados].reduce((a, b) => a > b ? a : b);
    final puntosDias =
        [1, 8, 15, 22, dias.length].where((d) => d <= dias.length).toList();
    final puntos = <Offset>[];
    for (final dia in puntosDias) {
      final x = grafico.left +
          ((dia - 1) / (dias.length - 1).clamp(1, 99)) * grafico.width;
      final valor = acumulados.isEmpty ? 0 : acumulados[dia - 1];
      final y = grafico.bottom - (valor / maximo) * grafico.height;
      puntos.add(Offset(x, y));
    }

    if (puntos.isNotEmpty) {
      final area = Path()..moveTo(puntos.first.dx, grafico.bottom);
      for (final punto in puntos) {
        area.lineTo(punto.dx, punto.dy);
      }
      area.lineTo(puntos.last.dx, grafico.bottom);
      area.close();
      canvas.drawPath(
        area,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x33213FE7), Color(0x00213FE7)],
          ).createShader(grafico),
      );

      final path = Path()..moveTo(puntos.first.dx, puntos.first.dy);
      for (final punto in puntos.skip(1)) {
        path.lineTo(punto.dx, punto.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = _PaginaImpacto4LifeNuevaState._azulVivo
          ..strokeWidth = 3.2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      for (final punto in puntos) {
        canvas.drawCircle(
            punto, 6, Paint()..color = _PaginaImpacto4LifeNuevaState._azulVivo);
      }
    }

    for (final dia in puntosDias) {
      final x = grafico.left +
          ((dia - 1) / (dias.length - 1).clamp(1, 99)) * grafico.width;
      texto.text = TextSpan(
        text: '$dia $mesCorto',
        style: const TextStyle(
            color: _PaginaImpacto4LifeNuevaState._textoSuave,
            fontSize: 13,
            fontWeight: FontWeight.w700),
      );
      texto.layout();
      texto.paint(canvas, Offset(x - texto.width / 2, grafico.bottom + 12));
    }
  }

  @override
  bool shouldRepaint(covariant _LineaImpactoNuevo oldDelegate) =>
      oldDelegate.dias != dias || oldDelegate.mesCorto != mesCorto;
}

class _BarrasHorasImpactoNuevo extends CustomPainter {
  final List<int> horas;
  final int activa;

  const _BarrasHorasImpactoNuevo(this.horas, this.activa);

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(0, 0, size.width, size.height - 18);
    final maximo = [1, ...horas].reduce((a, b) => a > b ? a : b);
    final ancho = chart.width / 30;
    for (var i = 0; i < horas.length; i++) {
      final alto = 10 + (horas[i] / maximo) * (chart.height - 12);
      final x = (i / 23) * (chart.width - ancho);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, chart.bottom - alto, ancho, alto),
        const Radius.circular(3),
      );
      canvas.drawRRect(
        rect,
        Paint()
          ..color = i == activa
              ? _PaginaImpacto4LifeNuevaState._azulVivo
              : const Color(0xFFDDE3FA),
      );
    }
    final texto = TextPainter(textDirection: TextDirection.ltr);
    final etiquetas = {6: '6 AM', 12: '12 PM', 18: '6 PM', 23: '12 AM'};
    etiquetas.forEach((hora, label) {
      final x = (hora / 23) * chart.width;
      texto.text = TextSpan(
        text: label,
        style: const TextStyle(
            color: _PaginaImpacto4LifeNuevaState._textoSuave,
            fontSize: 12,
            fontWeight: FontWeight.w800),
      );
      texto.layout();
      texto.paint(
          canvas,
          Offset((x - texto.width / 2).clamp(0, size.width - texto.width),
              chart.bottom + 5));
    });
  }

  @override
  bool shouldRepaint(covariant _BarrasHorasImpactoNuevo oldDelegate) {
    return oldDelegate.horas != horas || oldDelegate.activa != activa;
  }
}

class PaginaImpacto4Life extends StatefulWidget {
  const PaginaImpacto4Life({super.key});

  @override
  State<PaginaImpacto4Life> createState() => _PaginaImpacto4LifeState();
}

class _PaginaImpacto4LifeState extends State<PaginaImpacto4Life> {
  List<Map<String, dynamic>> _eventos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final eventos = await ImpactoService.cargarEventos();
    if (!mounted) return;
    setState(() {
      _eventos = eventos;
      _cargando = false;
    });
  }

  DateTime? _fechaEvento(Map<String, dynamic> evento) {
    final raw = evento['fecha']?.toString();
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  String _claveMes(DateTime fecha) {
    final mes = fecha.month.toString().padLeft(2, '0');
    return '${fecha.year}-$mes';
  }

  String _tituloMes(String clave) {
    final partes = clave.split('-');
    final anio = int.tryParse(partes.first) ?? DateTime.now().year;
    final mes = int.tryParse(partes.last) ?? DateTime.now().month;
    const nombres = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    final ultimoDia = DateTime(anio, mes + 1, 0).day;
    return '${nombres[mes - 1]} $anio - del 1 al $ultimoDia';
  }

  Map<String, List<Map<String, dynamic>>> _eventosPorMes() {
    final grupos = <String, List<Map<String, dynamic>>>{};
    for (final evento in _eventos) {
      final fecha = _fechaEvento(evento);
      if (fecha == null) continue;
      grupos.putIfAbsent(_claveMes(fecha), () => []).add(evento);
    }
    return grupos;
  }

  _ResumenImpactoMes _resumenMes(List<Map<String, dynamic>> eventos) {
    final diagnosticos =
        eventos.where((e) => e['tipo'] == 'diagnostico').length;
    final consultasProducto =
        eventos.where((e) => e['tipo'] == 'consulta_producto').length;
    final calculadoras =
        eventos.where((e) => e['tipo'] == 'calculadora_productos').length;
    final productos = eventos
        .map((e) => e['datos'])
        .whereType<Map>()
        .expand((datos) {
          final lista = datos['productos'];
          if (lista is List) return lista.map((e) => '$e');
          final producto = datos['producto']?.toString();
          return producto == null || producto.isEmpty
              ? const Iterable<String>.empty()
              : [producto];
        })
        .toSet()
        .toList();

    return _ResumenImpactoMes(
      diagnosticos: diagnosticos,
      consultasProducto: consultasProducto,
      calculadoras: calculadoras,
      productos: productos,
    );
  }

  @override
  Widget build(BuildContext context) {
    final grupos = _eventosPorMes();
    final claves = grupos.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tu impacto 4Life"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : claves.isEmpty
              ? const Center(
                  child: Text(
                    "Aun no hay diagnósticos ni consultas registradas.",
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: claves.length,
                  itemBuilder: (context, index) {
                    final clave = claves[index];
                    final resumen = _resumenMes(grupos[clave] ?? []);
                    return _TarjetaImpactoGrafica(
                      titulo: _tituloMes(clave),
                      resumen: resumen,
                    );
                  },
                ),
    );
  }
}

class _ResumenImpactoMes {
  final int diagnosticos;
  final int consultasProducto;
  final int calculadoras;
  final List<String> productos;

  const _ResumenImpactoMes({
    required this.diagnosticos,
    required this.consultasProducto,
    required this.calculadoras,
    required this.productos,
  });

  int get total => diagnosticos + consultasProducto + calculadoras;
}

class _TarjetaImpactoGrafica extends StatelessWidget {
  final String titulo;
  final _ResumenImpactoMes resumen;

  const _TarjetaImpactoGrafica({
    required this.titulo,
    required this.resumen,
  });

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);
    final maximo = [
      resumen.diagnosticos,
      resumen.consultasProducto,
      resumen.calculadoras,
      1,
    ].reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Color(0xFF12248B),
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 112,
                height: 112,
                child: CustomPaint(
                  painter: _GraficoCircularImpacto(
                    diagnosticos: resumen.diagnosticos,
                    consultasProducto: resumen.consultasProducto,
                    calculadoras: resumen.calculadoras,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${resumen.total}',
                          style: const TextStyle(
                            color: azul,
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'acciones',
                          style: TextStyle(
                            color: Color(0xFF68708C),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    _BarraImpacto(
                      etiqueta: 'Diagnósticos',
                      valor: resumen.diagnosticos,
                      maximo: maximo,
                      color: const Color(0xFF14983E),
                    ),
                    const SizedBox(height: 12),
                    _BarraImpacto(
                      etiqueta: 'Productos',
                      valor: resumen.consultasProducto,
                      maximo: maximo,
                      color: azul,
                    ),
                    const SizedBox(height: 12),
                    _BarraImpacto(
                      etiqueta: 'Calculadora',
                      valor: resumen.calculadoras,
                      maximo: maximo,
                      color: const Color(0xFFF29A00),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (resumen.productos.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Productos consultados',
              style: TextStyle(
                color: Color(0xFF12248B),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final producto in resumen.productos.take(8))
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF1FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      producto,
                      style: const TextStyle(
                        color: azul,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BarraImpacto extends StatelessWidget {
  final String etiqueta;
  final int valor;
  final int maximo;
  final Color color;

  const _BarraImpacto({
    required this.etiqueta,
    required this.valor,
    required this.maximo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final porcentaje = maximo == 0 ? 0.0 : (valor / maximo).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                etiqueta,
                style: const TextStyle(
                  color: Color(0xFF27315F),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '$valor',
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: porcentaje,
            minHeight: 10,
            color: color,
            backgroundColor: const Color(0xFFE8EBF6),
          ),
        ),
      ],
    );
  }
}

class _GraficoCircularImpacto extends CustomPainter {
  final int diagnosticos;
  final int consultasProducto;
  final int calculadoras;

  const _GraficoCircularImpacto({
    required this.diagnosticos,
    required this.consultasProducto,
    required this.calculadoras,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = diagnosticos + consultasProducto + calculadoras;
    final centro = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: centro, radius: (size.width / 2) - 7);
    final base = Paint()
      ..color = const Color(0xFFE8EBF6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 6.28318, false, base);
    if (total == 0) return;

    final segmentos = [
      (diagnosticos, const Color(0xFF14983E)),
      (consultasProducto, const Color(0xFF2839C7)),
      (calculadoras, const Color(0xFFF29A00)),
    ];
    var inicio = -1.5708;
    for (final segmento in segmentos) {
      if (segmento.$1 <= 0) continue;
      final sweep = (segmento.$1 / total) * 6.28318;
      final paint = Paint()
        ..color = segmento.$2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, inicio, sweep, false, paint);
      inicio += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _GraficoCircularImpacto oldDelegate) {
    return oldDelegate.diagnosticos != diagnosticos ||
        oldDelegate.consultasProducto != consultasProducto ||
        oldDelegate.calculadoras != calculadoras;
  }
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
    String titulo,
    String resultado,
    Map<String, String> datos, {
    String tipo = 'diagnostico',
  }) async {
    final registro = {
      'fecha': DateTime.now().toString().substring(0, 16),
      'titulo': titulo,
      'nombre': datos['nombre'] ?? '',
      'resultado': resultado,
      'datos': datos,
      'tipo': tipo,
    };

    registros.insert(0, registro);

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('historial_pacientes') ?? [];
    raw.insert(0, jsonEncode(registro));
    await prefs.setStringList('historial_pacientes', raw);

    try {
      await FirebaseFirestore.instance.collection('diagnosticos').add({
        ...registro,
        'creadoEn': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('No se pudo guardar el diagnostico en Firebase: $e');
    }

    await ImpactoService.registrar(
      tipo: tipo,
      titulo: titulo,
      datos: {
        'nombre': datos['nombre'] ?? '',
        'sintomas': datos['sintomas'] ?? '',
        'objetivoFisico': datos['objetivoFisico'] ?? '',
      },
    );
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
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _generoSeleccionado;
  ArchivoAdjuntoIA? _adjunto;
  bool cargando = false;
  bool _grabandoAudio = false;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(
        text: widget.infoPrevia?['datos']?['nombre'] ?? "");
    edadController =
        TextEditingController(text: widget.infoPrevia?['datos']?['edad'] ?? "");
    _generoSeleccionado = widget.infoPrevia?['datos']?['genero'];
    historialController = TextEditingController();
    nombreController.addListener(_actualizarProgresoFormulario);
    edadController.addListener(_actualizarProgresoFormulario);
    historialController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _actualizarProgresoFormulario() {
    if (mounted) setState(() {});
  }

  int get _camposCompletosFormulario {
    var completos = 0;
    if (nombreController.text.trim().isNotEmpty) completos++;
    if (edadController.text.trim().isNotEmpty) completos++;
    if ((_generoSeleccionado ?? '').trim().isNotEmpty) completos++;
    if (historialController.text.trim().isNotEmpty ||
        _adjunto?.esAudio == true) {
      completos++;
    }
    return completos;
  }

  double get _progresoFormulario => _camposCompletosFormulario / 4;

  Future<void> generarDiagnostico() async {
    if (historialController.text.isEmpty && _adjunto == null) return;
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

    final perfilAsesor = await PerfilService.cargar();
    final saludoAsesor = perfilAsesor.tieneNombre
        ? "Inicia el reporte con este saludo personalizado: Hola, como estas, mi nombre es ${perfilAsesor.nombre.trim()}. Luego continua con el diagnostico."
        : "Inicia con un saludo empatico breve y luego continua con el diagnostico.";

    final prompt = """
    $contextoAnterior
    SÍNTOMAS ACTUALES: ${historialController.text}
    DATOS: Nombre: ${nombreController.text}, Edad: ${edadController.text}, Género: $_generoSeleccionado.
    $saludoAsesor
    
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
      final content = [
        if (_adjunto == null)
          Content.text(prompt)
        else
          Content.multi([
            TextPart(
              _adjunto!.esAudio
                  ? "$prompt\n\nAnaliza la nota de voz adjunta. Extrae los sintomas, contexto y datos relevantes mencionados por el paciente para orientar la recomendacion; no guardes ni menciones que el audio fue almacenado."
                  : "$prompt\n\nAnaliza tambien el archivo adjunto. Extrae solo la informacion relevante para orientar la recomendacion y usala como contexto complementario; no afirmes diagnosticos medicos definitivos.",
            ),
            DataPart(_adjunto!.mimeType, _adjunto!.bytes),
          ]),
      ];
      final response = await model.generateContent(content);
      String textoFinal = response.text ?? "Sin respuesta";

      await HistorialService.guardar(
          "Diagnóstico: ${nombreController.text}", textoFinal, {
        'nombre': nombreController.text,
        'edad': edadController.text,
        'genero': _generoSeleccionado!,
        'sintomas':
            historialController.text.trim().isEmpty && _adjunto?.esAudio == true
                ? 'Sintomas enviados por nota de voz (audio no guardado)'
                : historialController.text,
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
            tooltip: "Escuchar respuesta",
            icon: const Icon(Icons.volume_up_rounded),
            onPressed: () => ServicioTextoVoz.reproducir(mensaje),
          ),
          IconButton(
            tooltip: "Detener audio",
            icon: const Icon(Icons.stop_circle_outlined),
            onPressed: ServicioTextoVoz.detener,
          ),
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

  Future<void> _tomarFotoDiagnostico() async {
    final imagen = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 88,
    );
    if (imagen == null) return;

    final bytes = await imagen.readAsBytes();
    if (!mounted) return;
    setState(() {
      _adjunto = ArchivoAdjuntoIA(
        nombre: imagen.name,
        mimeType: imagen.mimeType ?? 'image/jpeg',
        bytes: bytes,
      );
    });
  }

  Future<void> _seleccionarArchivoDiagnostico() async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'webp'],
      withData: true,
    );
    final archivo = resultado?.files.single;
    final bytes = archivo?.bytes;
    if (archivo == null || bytes == null) return;

    final extension = (archivo.extension ?? '').toLowerCase();
    final mime = switch (extension) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };

    if (!mounted) return;
    setState(() {
      _adjunto = ArchivoAdjuntoIA(
        nombre: archivo.name,
        mimeType: mime,
        bytes: bytes,
      );
    });
  }

  Future<void> _alternarAudioDiagnostico() async {
    if (_grabandoAudio) {
      final path = await _audioRecorder.stop();
      if (!mounted) return;
      setState(() => _grabandoAudio = false);
      if (path == null) return;

      final archivo = File(path);
      final bytes = await archivo.readAsBytes();
      await archivo.delete().catchError((_) => archivo);
      if (bytes.isEmpty || !mounted) return;

      setState(() {
        _adjunto = ArchivoAdjuntoIA(
          nombre: 'Nota de voz para diagnostico.m4a',
          mimeType: 'audio/mp4',
          bytes: bytes,
        );
      });
      return;
    }

    if (!await _audioRecorder.hasPermission()) {
      _mostrarDialogoSimple(
        "Permiso de microfono",
        "Activa el permiso del microfono para grabar la nota de voz.",
      );
      return;
    }

    final carpetaTemporal = await getTemporaryDirectory();
    final path =
        '${carpetaTemporal.path}/diagnostico_${DateTime.now().microsecondsSinceEpoch}.m4a';
    await _audioRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        numChannels: 1,
        bitRate: 64000,
      ),
      path: path,
    );
    if (!mounted) return;
    setState(() => _grabandoAudio = true);
  }

  void _quitarAdjuntoDiagnostico() {
    setState(() => _adjunto = null);
  }

  @override
  void dispose() {
    if (_grabandoAudio) {
      unawaited(_audioRecorder.cancel());
    }
    _audioRecorder.dispose();
    nombreController.dispose();
    edadController.dispose();
    historialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFormularioDiagnosticoNuevo();
  }

  // ignore: unused_element
  Widget _buildFormularioDiagnosticoAnterior(BuildContext context) {
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

  Widget _buildFormularioDiagnosticoNuevo() {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Stack(
        children: [
          Container(
            height: 286,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF172B98), Color(0xFF07125E)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              child: Column(
                children: [
                  _encabezadoDiagnostico(),
                  const SizedBox(height: 48),
                  _tarjetaProgreso(),
                  const SizedBox(height: 22),
                  _tarjetaCampoDiagnostico(
                    titulo: "Nombre completo",
                    icono: Icons.person_outline_rounded,
                    child: _campoTextoDiagnostico(
                      controller: nombreController,
                      hint: "Ingresa tu nombre",
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampoDiagnostico(
                    titulo: "Edad",
                    icono: Icons.calendar_month_rounded,
                    child: _campoTextoDiagnostico(
                      controller: edadController,
                      hint: "Ingresa tu edad",
                      prefixIcon: Icons.calendar_month_outlined,
                      keyboardType: TextInputType.number,
                      suffixText: "Años",
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampoDiagnostico(
                    titulo: "Genero",
                    icono: Icons.transgender_rounded,
                    child: _selectorGeneroDiagnostico(),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampoDiagnostico(
                    titulo: "Sintomas actuales",
                    icono: Icons.medical_services_outlined,
                    child: _campoSintomasDiagnostico(),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaAdjuntoDiagnostico(),
                  const SizedBox(height: 20),
                  _tarjetaConfidencialidad(),
                  const SizedBox(height: 26),
                  _botonGenerarDiagnostico(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _encabezadoDiagnostico() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          iconSize: 34,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Formulario de Diagnostico",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Completa los datos para un diagnostico preciso",
                style: TextStyle(
                  color: Color(0xFFD9DFFF),
                  fontSize: 18,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          borderRadius: BorderRadius.circular(38),
          onTap: _mostrarAyudaDiagnostico,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.help_outline_rounded, color: Colors.white, size: 34),
                SizedBox(height: 3),
                Text(
                  "Ayuda",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tarjetaProgreso() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2E7FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fact_check_outlined,
                  color: Color(0xFF4865F4),
                  size: 54,
                ),
              ),
              const SizedBox(width: 22),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Completa el formulario",
                      style: TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      "Proporciona informacion precisa para mejores resultados.",
                      style: TextStyle(
                        color: Color(0xFF3F4A82),
                        fontSize: 18,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF1FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$_camposCompletosFormulario de 4",
                  style: const TextStyle(
                    color: Color(0xFF4565F0),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: _progresoFormulario,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E8FF),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF4865F4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaCampoDiagnostico({
    required String titulo,
    required IconData icono,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE3E7FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icono, color: const Color(0xFF4059EA), size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoTextoDiagnostico({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    String? suffixText,
    TextInputAction? textInputAction,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: _inputDecoracionDiagnostico(
        hint: hint,
        prefixIcon: prefixIcon,
        suffixText: suffixText,
      ),
    );
  }

  Widget _selectorGeneroDiagnostico() {
    return DropdownButtonFormField<String>(
      initialValue: _generoSeleccionado,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF12248B), size: 32),
      decoration: _inputDecoracionDiagnostico(hint: "Selecciona una opcion"),
      hint: const Text(
        "Selecciona una opcion",
        style: TextStyle(
          color: Color(0xFF6B7192),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
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
    );
  }

  Widget _campoSintomasDiagnostico() {
    final conteo = historialController.text.characters.length;
    return Stack(
      children: [
        TextField(
          controller: historialController,
          minLines: 6,
          maxLines: 6,
          maxLength: 500,
          textInputAction: TextInputAction.newline,
          decoration: _inputDecoracionDiagnostico(
            hint: "Describe tus sintomas actuales...",
            alignLabelWithHint: true,
          ).copyWith(counterText: ""),
        ),
        Positioned(
          right: 18,
          bottom: 16,
          child: Text(
            "$conteo/500",
            style: const TextStyle(
              color: Color(0xFF4C5687),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tarjetaAdjuntoDiagnostico() {
    return _tarjetaCampoDiagnostico(
      titulo: "Archivo para analizar",
      icono: Icons.attach_file_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: 120,
                child: OutlinedButton.icon(
                  onPressed: _tomarFotoDiagnostico,
                  icon: const Icon(Icons.photo_camera_rounded),
                  label: const Text("Camara"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF12248B),
                    minimumSize: const Size(0, 48),
                    side: const BorderSide(color: Color(0xFFD1D5E3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 124,
                child: OutlinedButton.icon(
                  onPressed: _seleccionarArchivoDiagnostico,
                  icon: const Icon(Icons.attach_file_rounded),
                  label: const Text("Archivo"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF12248B),
                    minimumSize: const Size(0, 48),
                    side: const BorderSide(color: Color(0xFFD1D5E3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 128,
                child: OutlinedButton.icon(
                  onPressed: cargando ? null : _alternarAudioDiagnostico,
                  icon: Icon(_grabandoAudio
                      ? Icons.stop_circle_outlined
                      : Icons.mic_none_rounded),
                  label: Text(_grabandoAudio ? "Detener" : "Audio"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _grabandoAudio
                        ? const Color(0xFFD33B3B)
                        : const Color(0xFF12248B),
                    minimumSize: const Size(0, 48),
                    side: BorderSide(
                      color: _grabandoAudio
                          ? const Color(0xFFD33B3B)
                          : const Color(0xFFD1D5E3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_adjunto != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE1E4F0)),
              ),
              child: Row(
                children: [
                  Icon(
                    _adjunto!.esAudio
                        ? Icons.mic_none_rounded
                        : _adjunto!.esPdf
                            ? Icons.picture_as_pdf_rounded
                            : Icons.image_outlined,
                    color: const Color(0xFF4059EA),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _adjunto!.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF27315F),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: "Quitar archivo",
                    onPressed: _quitarAdjuntoDiagnostico,
                    icon: const Icon(Icons.close_rounded),
                    color: const Color(0xFF12248B),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          _burbujaPrivacidadAdjunto(),
        ],
      ),
    );
  }

  Widget _burbujaPrivacidadAdjunto() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCDEBE2)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline_rounded, color: Color(0xFF08735F), size: 20),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              "Este documento, foto o audio no se guarda dentro de la app.",
              style: TextStyle(
                color: Color(0xFF175B50),
                fontSize: 13,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoracionDiagnostico({
    required String hint,
    IconData? prefixIcon,
    String? suffixText,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hint,
      alignLabelWithHint: alignLabelWithHint,
      hintStyle: const TextStyle(
        color: Color(0xFF6B7192),
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, color: const Color(0xFF535B86), size: 28),
      suffixIcon: suffixText == null
          ? null
          : Container(
              width: 96,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFFE5E7F0), width: 1.2),
                ),
              ),
              child: Text(
                suffixText,
                style: const TextStyle(
                  color: Color(0xFF12248B),
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC8CDE0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF4059EA), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD74A4A), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD74A4A), width: 1.8),
      ),
    );
  }

  Widget _tarjetaConfidencialidad() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF0FF), Color(0xFFF5F7FF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFF5367F2),
            child: Icon(Icons.info_rounded, color: Colors.white, size: 30),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tu informacion es confidencial",
                  style: TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Todos los datos ingresados estan protegidos y se utilizan unicamente para generar tu diagnostico personalizado.",
                  style: TextStyle(
                    color: Color(0xFF17246B),
                    fontSize: 17,
                    height: 1.4,
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

  Widget _botonGenerarDiagnostico() {
    return InkWell(
      borderRadius: BorderRadius.circular(36),
      onTap: cargando ? null : generarDiagnostico,
      child: Container(
        height: 76,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF172394), Color(0xFF0B176B)],
          ),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: cargando
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fact_check_outlined,
                        color: Colors.white, size: 34),
                    SizedBox(width: 18),
                    Text(
                      "GENERAR DIAGNOSTICO",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _mostrarAyudaDiagnostico() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ayuda"),
        content: const Text(
          "Completa nombre, edad, genero y sintomas actuales. Mientras mas claro sea el contexto, mas util sera el diagnostico generado.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Entendido"),
          ),
        ],
      ),
    );
  }
}

class FormularioCambioFisico extends StatefulWidget {
  const FormularioCambioFisico({super.key});

  @override
  State<FormularioCambioFisico> createState() => _FormularioCambioFisicoState();
}

class _FormularioCambioFisicoState extends State<FormularioCambioFisico> {
  final nombreController = TextEditingController();
  final edadController = TextEditingController();
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  final objetivoController = TextEditingController();
  String? _generoSeleccionado;
  String? _contexturaSeleccionada;
  bool cargando = false;

  static const Map<String, String> _contexturas = {
    'Ectomorfo':
        'Complexion delgada, extremidades largas y huesos finos. Metabolismo rapido; les cuesta subir de peso y ganar masa muscular.',
    'Mesomorfo':
        'Complexion atletica, naturalmente musculoso y fuerte. Metabolismo eficiente; ganan masa muscular con facilidad y mantienen un peso estable rapidamente.',
    'Endomorfo':
        'Estructura osea mas ancha, cuerpo suave y redondeado. Metabolismo lento; tienden a acumular grasa con mayor facilidad, pero tambien pueden desarrollar buena masa muscular.',
  };

  @override
  void initState() {
    super.initState();
    for (final controller in [
      nombreController,
      edadController,
      pesoController,
      alturaController,
      objetivoController,
    ]) {
      controller.addListener(_actualizar);
    }
  }

  void _actualizar() {
    if (mounted) setState(() {});
  }

  int get _camposCompletos {
    var completos = 0;
    if (nombreController.text.trim().isNotEmpty) completos++;
    if (edadController.text.trim().isNotEmpty) completos++;
    if ((_generoSeleccionado ?? '').trim().isNotEmpty) completos++;
    if (pesoController.text.trim().isNotEmpty) completos++;
    if (alturaController.text.trim().isNotEmpty) completos++;
    if ((_contexturaSeleccionada ?? '').trim().isNotEmpty) completos++;
    if (objetivoController.text.trim().isNotEmpty) completos++;
    return completos;
  }

  double get _progreso => _camposCompletos / 7;

  Future<void> generarCambioFisico() async {
    if (_camposCompletos < 7) {
      _mostrarDialogoSimple(
        "Datos incompletos",
        "Completa todos los campos para generar la recomendacion.",
      );
      return;
    }

    setState(() => cargando = true);

    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: 'AIzaSyB3ea3TYD72dtfGyP9kSrjyot7RzMk0ZXk',
    );

    final perfilAsesor = await PerfilService.cargar();
    final saludoAsesor = perfilAsesor.tieneNombre
        ? "Inicia el reporte con este saludo personalizado: Hola, como estas, mi nombre es ${perfilAsesor.nombre.trim()}. Luego continua con la guia."
        : "Inicia con un saludo empatico breve y luego continua con la guia.";

    final prompt = """
    DATOS PARA CAMBIO FISICO:
    Nombre: ${nombreController.text}
    Edad: ${edadController.text}
    Genero: $_generoSeleccionado
    Peso: ${pesoController.text} kg
    Altura: ${alturaController.text} m
    Contextura: $_contexturaSeleccionada - ${_contexturas[_contexturaSeleccionada] ?? ''}
    Objetivo fisico: ${objetivoController.text}
    $saludoAsesor

    Actua como asesor profesional de bienestar, composicion corporal y suplementos 4Life. Genera una guia responsable, clara y lista para compartir por WhatsApp.

    REGLA CRITICA DE PRODUCTOS:
    - Debes recomendar UNICAMENTE productos de esta lista: $catalogoCambioFisico4Life.
    - Recomienda maximo 3 o 4 productos.
    - No inventes productos, no uses medicamentos, no recomiendes marcas externas y no menciones productos fuera de la lista.

    Instrucciones:
    1. Usa asteriscos para titulos en negrita de WhatsApp.
    2. Enfoca el analisis en peso, altura, genero, contextura y objetivo fisico.
    3. No prometas resultados exactos ni milagrosos.
    4. Para cada producto incluye dosis general por horario si corresponde.
    5. Agrega 3 recomendaciones de habitos: alimentacion, entrenamiento y descanso.

    Estructura obligatoria:

    *SALUDO Y ANALISIS FISICO*
    [Analisis breve del perfil y objetivo]

    *PLAN DE APOYO 4LIFE (Max. 3-4 productos)*

    *1. [Nombre exacto del producto]*
    - *Dosis manana:* [Cantidad]
    - *Dosis tarde:* [Cantidad, si aplica]
    - *Dosis noche:* [Cantidad, si aplica]
    - *Apoyo principal:* [Explicacion breve]

    [Repetir solo hasta 3 o 4 productos]

    *HABITOS PARA EL OBJETIVO*
    - [Consejo de alimentacion]
    - [Consejo de entrenamiento]
    - [Consejo de descanso/seguimiento]

    *Nota responsable:* Esta guia es de apoyo general para bienestar y composicion corporal; no sustituye una evaluacion medica, nutricional o deportiva profesional.""";

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final textoFinal = response.text ?? "Sin respuesta";

      await HistorialService.guardar(
        "Cambio fisico: ${nombreController.text}",
        textoFinal,
        {
          'nombre': nombreController.text,
          'edad': edadController.text,
          'genero': _generoSeleccionado!,
          'peso': pesoController.text,
          'altura': alturaController.text,
          'contextura': _contexturaSeleccionada!,
          'objetivoFisico': objetivoController.text,
        },
        tipo: 'cambio_fisico',
      );

      _mostrarResultado(textoFinal);
    } catch (e) {
      _mostrarDialogoSimple("Error", "No se pudo conectar con la IA.");
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  void _mostrarResultado(String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Resultado de Cambio Fisico"),
        content: SingleChildScrollView(child: Text(mensaje)),
        actions: [
          IconButton(
            tooltip: "Escuchar respuesta",
            icon: const Icon(Icons.volume_up_rounded),
            onPressed: () => ServicioTextoVoz.reproducir(mensaje),
          ),
          IconButton(
            tooltip: "Detener audio",
            icon: const Icon(Icons.stop_circle_outlined),
            onPressed: ServicioTextoVoz.detener,
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: mensaje));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copiado al portapapeles")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => Share.share(mensaje),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoSimple(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(titulo), content: Text(mensaje)),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    edadController.dispose();
    pesoController.dispose();
    alturaController.dispose();
    objetivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Stack(
        children: [
          Container(
            height: 286,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF172B98), Color(0xFF07125E)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              child: Column(
                children: [
                  _encabezado(),
                  const SizedBox(height: 48),
                  _tarjetaProgreso(),
                  const SizedBox(height: 22),
                  _tarjetaCampo(
                    titulo: "Nombre completo",
                    icono: Icons.person_outline_rounded,
                    child: _campoTexto(
                      controller: nombreController,
                      hint: "Ingresa tu nombre",
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Edad",
                    icono: Icons.calendar_month_rounded,
                    child: _campoTexto(
                      controller: edadController,
                      hint: "Ingresa tu edad",
                      prefixIcon: Icons.calendar_month_outlined,
                      keyboardType: TextInputType.number,
                      suffixText: "Años",
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Genero",
                    icono: Icons.transgender_rounded,
                    child: _selectorGenero(),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Peso en kilogramos",
                    icono: Icons.monitor_weight_outlined,
                    child: _campoTexto(
                      controller: pesoController,
                      hint: "Ej. 72",
                      prefixIcon: Icons.monitor_weight_outlined,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      suffixText: "Kg",
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Altura en metros",
                    icono: Icons.height_rounded,
                    child: _campoTexto(
                      controller: alturaController,
                      hint: "Ej. 1.70",
                      prefixIcon: Icons.height_rounded,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      suffixText: "m",
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Contextura",
                    icono: Icons.accessibility_new_rounded,
                    child: _selectorContextura(),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Objetivo fisico",
                    icono: Icons.flag_outlined,
                    child: _campoObjetivo(),
                  ),
                  const SizedBox(height: 20),
                  _tarjetaInfo(),
                  const SizedBox(height: 26),
                  _botonGenerar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _encabezado() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          iconSize: 34,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ficha de Cambio Fisico",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Completa los datos para una guia corporal personalizada",
                style: TextStyle(
                  color: Color(0xFFD9DFFF),
                  fontSize: 18,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tarjetaProgreso() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2E7FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: Color(0xFF4865F4),
                  size: 54,
                ),
              ),
              const SizedBox(width: 22),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Completa la ficha",
                      style: TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      "La guia se adapta al perfil fisico y objetivo.",
                      style: TextStyle(
                        color: Color(0xFF3F4A82),
                        fontSize: 18,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF1FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$_camposCompletos de 7",
                  style: const TextStyle(
                    color: Color(0xFF4565F0),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: _progreso,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E8FF),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF4865F4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaCampo({
    required String titulo,
    required IconData icono,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE3E7FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icono, color: const Color(0xFF4059EA), size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoTexto({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    String? suffixText,
    TextInputAction? textInputAction,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: _inputDecoracion(
        hint: hint,
        prefixIcon: prefixIcon,
        suffixText: suffixText,
      ),
    );
  }

  Widget _selectorGenero() {
    return DropdownButtonFormField<String>(
      initialValue: _generoSeleccionado,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF12248B), size: 32),
      decoration: _inputDecoracion(hint: "Selecciona una opcion"),
      items: const [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
      ],
      onChanged: (valor) => setState(() => _generoSeleccionado = valor),
    );
  }

  Widget _selectorContextura() {
    final descripcion = _contexturas[_contexturaSeleccionada];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _contexturaSeleccionada,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF12248B), size: 32),
          decoration: _inputDecoracion(hint: "Selecciona una contextura"),
          items: _contexturas.keys
              .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
              .toList(),
          onChanged: (valor) => setState(() => _contexturaSeleccionada = valor),
        ),
        if (descripcion != null) ...[
          const SizedBox(height: 12),
          Text(
            descripcion,
            style: const TextStyle(
              color: Color(0xFF4C5687),
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _campoObjetivo() {
    final conteo = objetivoController.text.characters.length;
    return Stack(
      children: [
        TextField(
          controller: objetivoController,
          minLines: 6,
          maxLines: 6,
          maxLength: 500,
          textInputAction: TextInputAction.newline,
          decoration: _inputDecoracion(
            hint: "Describe el objetivo fisico...",
            alignLabelWithHint: true,
          ).copyWith(counterText: ""),
        ),
        Positioned(
          right: 18,
          bottom: 16,
          child: Text(
            "$conteo/500",
            style: const TextStyle(
              color: Color(0xFF4C5687),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoracion({
    required String hint,
    IconData? prefixIcon,
    String? suffixText,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hint,
      alignLabelWithHint: alignLabelWithHint,
      hintStyle: const TextStyle(
        color: Color(0xFF6B7192),
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, color: const Color(0xFF535B86), size: 28),
      suffixIcon: suffixText == null
          ? null
          : Container(
              width: 76,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFFE5E7F0), width: 1.2),
                ),
              ),
              child: Text(
                suffixText,
                style: const TextStyle(
                  color: Color(0xFF12248B),
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC8CDE0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF4059EA), width: 1.8),
      ),
    );
  }

  Widget _tarjetaInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF0FF), Color(0xFFF5F7FF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFF5367F2),
            child: Icon(Icons.info_rounded, color: Colors.white, size: 30),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              "La recomendacion se genera solo con los datos corporales ingresados y productos permitidos para cambio fisico.",
              style: TextStyle(
                color: Color(0xFF17246B),
                fontSize: 17,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonGenerar() {
    return InkWell(
      borderRadius: BorderRadius.circular(36),
      onTap: cargando ? null : generarCambioFisico,
      child: Container(
        height: 76,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF172394), Color(0xFF0B176B)],
          ),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: cargando
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fitness_center_rounded,
                        color: Colors.white, size: 34),
                    SizedBox(width: 18),
                    Text(
                      "GENERAR GUIA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
        ),
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
  List<String> _busquedasRecientes = [];

  static const String _prefsRecientesKey = 'consultas_productos_recientes';
  static const List<String> _ejemplosPopulares = [
    'Transfer factor plus',
    'Riovida stix',
    'Renuvo',
    'Bioefa',
  ];

  @override
  void initState() {
    super.initState();
    _cargarRecientes();
  }

  Future<void> _cargarRecientes() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _busquedasRecientes = prefs.getStringList(_prefsRecientesKey) ?? [];
    });
  }

  Future<void> _guardarReciente(String busqueda) async {
    final texto = busqueda.trim();
    if (texto.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final actualizadas = [
      texto,
      ..._busquedasRecientes.where(
        (item) => normalizarTexto(item) != normalizarTexto(texto),
      ),
    ].take(6).toList();

    await prefs.setStringList(_prefsRecientesKey, actualizadas);
    if (!mounted) return;
    setState(() => _busquedasRecientes = actualizadas);
  }

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

    Producto consultado:
    "$productoParaIa"

    Si el usuario lo escribio con errores, trabaja directamente con el producto correcto.
    No digas que fue una coincidencia ni que el texto estaba mal escrito.

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
      final precioProducto = productoIdentificado == null
          ? buscarProductoConPrecio(productoBuscado)
          : buscarProductoConPrecio(productoIdentificado);
      await ImpactoService.registrar(
        tipo: 'consulta_producto',
        titulo: productoIdentificado ?? productoBuscado,
        datos: {
          'busqueda': productoBuscado,
          'producto': productoIdentificado ?? productoParaIa,
        },
      );

      if (!mounted) return;
      await _guardarReciente(productoIdentificado ?? productoBuscado);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (c) => _dialogoResultado(
          dialogContext: c,
          titulo: productoIdentificado ?? "Info: $productoBuscado",
          resultado: resultado,
          imagenProducto: imagenProducto,
          productoIdentificado: productoIdentificado,
          precioProducto: precioProducto,
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
      backgroundColor: const Color(0xFFF7F7FB),
      body: Stack(
        children: [
          Container(
            height: 252,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF172B98), Color(0xFF07125E)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              child: Column(
                children: [
                  _encabezadoConsulta(),
                  const SizedBox(height: 32),
                  _tarjetaBusqueda(),
                  const SizedBox(height: 18),
                  _tarjetaConsejo(),
                  const SizedBox(height: 20),
                  _botonConsultar(),
                  const SizedBox(height: 22),
                  _tarjetaRecientes(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _encabezadoConsulta() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          iconSize: 34,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Consultar Productos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  height: 1.1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 9),
              Text(
                "Busca informacion de suplementos",
                style: TextStyle(
                  color: Color(0xFFD9DFFF),
                  fontSize: 19,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tarjetaBusqueda() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Busca el producto que necesitas",
                      style: TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 24,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Encuentra informacion detallada, precios y LP: Life Points (Puntos de Vida).",
                      style: TextStyle(
                        color: Color(0xFF293573),
                        fontSize: 18,
                        height: 1.42,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _ilustracionBusqueda(),
            ],
          ),
          const SizedBox(height: 28),
          TextField(
            controller: controller,
            minLines: 1,
            maxLines: 1,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => consultar(),
            decoration: InputDecoration(
              hintText: "Escribe el nombre del producto",
              hintStyle: const TextStyle(
                color: Color(0xFF858AA5),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF666C8F),
                size: 33,
              ),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: "Limpiar",
                      onPressed: () => setState(controller.clear),
                      icon: const Icon(Icons.cancel_rounded),
                      color: const Color(0xFF666C8F),
                    ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFD6D9E6), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFF4056E8), width: 1.7),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          const Text(
            "Ejemplos populares:",
            style: TextStyle(
              color: Color(0xFF12248B),
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final ejemplo in _ejemplosPopulares) _chipEjemplo(ejemplo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipEjemplo(String texto) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        setState(() => controller.text = texto);
        consultar();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF1FF),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            color: Color(0xFF4565F0),
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _ilustracionBusqueda() {
    return SizedBox(
      width: 104,
      height: 112,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            bottom: 6,
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFE8ECFF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF2839C7),
                size: 38,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 4,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFF2839C7),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2839C7).withValues(alpha: 0.20),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 4,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFDDE5FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 8,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF1FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaConsejo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF2FF), Color(0xFFF7F8FF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFF5367F2),
            child: Icon(Icons.info_rounded, color: Colors.white, size: 31),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Consejo",
                  style: TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Escribe el nombre exacto o parte del producto para obtener mejores resultados.",
                  style: TextStyle(
                    color: Color(0xFF09196B),
                    fontSize: 18,
                    height: 1.35,
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

  Widget _botonConsultar() {
    return InkWell(
      borderRadius: BorderRadius.circular(36),
      onTap: consultando ? null : consultar,
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF172394), Color(0xFF0B176B)],
          ),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: consultando
              ? const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_rounded, color: Colors.white, size: 34),
                    SizedBox(width: 16),
                    Text(
                      "Consultar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _tarjetaRecientes() {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: _busquedasRecientes.isEmpty ? null : _mostrarRecientes,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF1FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: Color(0xFF12248B),
                size: 36,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Busquedas recientes",
                    style: TextStyle(
                      color: Color(0xFF12248B),
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _busquedasRecientes.isEmpty
                        ? "Aun no tienes consultas recientes"
                        : "Ver productos consultados recientemente",
                    style: const TextStyle(
                      color: Color(0xFF2F3C7D),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF5A607E),
              size: 36,
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarRecientes() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8DCEB),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Busquedas recientes",
                style: TextStyle(
                  color: Color(0xFF12248B),
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              for (final item in _busquedasRecientes)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.history_rounded,
                    color: Color(0xFF12248B),
                  ),
                  title: Text(
                    item,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => controller.text = item);
                    consultar();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogoResultado({
    required BuildContext dialogContext,
    required String titulo,
    required String resultado,
    required String? imagenProducto,
    required String? productoIdentificado,
    required ProductoPrecio? precioProducto,
  }) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      titulo,
                      style: const TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: "Cerrar",
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (imagenProducto != null) ...[
                        Container(
                          height: 220,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FF),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE1E4F0)),
                          ),
                          child: Image.asset(
                            imagenProducto,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      if (precioProducto != null) ...[
                        _precioResumenProducto(precioProducto),
                        const SizedBox(height: 14),
                      ],
                      Text(
                        resultado,
                        style: const TextStyle(
                          color: Color(0xFF27315F),
                          fontSize: 15.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    tooltip: "Escuchar respuesta",
                    icon: const Icon(Icons.volume_up_rounded),
                    color: const Color(0xFF12248B),
                    onPressed: () => ServicioTextoVoz.reproducir(resultado),
                  ),
                  IconButton(
                    tooltip: "Detener audio",
                    icon: const Icon(Icons.stop_circle_outlined),
                    color: const Color(0xFF12248B),
                    onPressed: ServicioTextoVoz.detener,
                  ),
                  IconButton(
                    tooltip: "Copiar",
                    icon: const Icon(Icons.copy_rounded),
                    color: const Color(0xFF12248B),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: resultado));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Copiado al portapapeles")),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: "Compartir",
                    icon: const Icon(Icons.share_rounded),
                    color: const Color(0xFF12248B),
                    onPressed: () async {
                      if (imagenProducto == null ||
                          productoIdentificado == null) {
                        await Share.share(resultado);
                        return;
                      }

                      final imagen = await imagenProductoComoPng(
                          imagenProducto, productoIdentificado);
                      await Share.shareXFiles([imagen], text: resultado);
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text("Cerrar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _precioResumenProducto(ProductoPrecio producto) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _datoPrecio("Afiliado", '\$${producto.afiliado.toStringAsFixed(2)}'),
          const SizedBox(height: 6),
          _datoPrecio("Publico", '\$${producto.publico.toStringAsFixed(2)}'),
          const SizedBox(height: 6),
          _datoPrecio(
            "LP: Life Points (Puntos de Vida)",
            producto.lp?.toString() ?? 'Sin dato',
          ),
        ],
      ),
    );
  }

  Widget _datoPrecio(String etiqueta, String valor) {
    return Row(
      children: [
        Expanded(
          child: Text(
            etiqueta,
            style: const TextStyle(
              color: Color(0xFF46527E),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          valor,
          style: const TextStyle(
            color: Color(0xFF12248B),
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
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
  List<LineaProductoPrecio> _productos = [];
  List<String> _noEncontrados = [];

  void _agregarProducto(ProductoPrecio producto, {int cantidad = 1}) {
    final indice = _productos.indexWhere(
      (item) => item.producto.nombre == producto.nombre,
    );
    setState(() {
      if (indice == -1) {
        _productos = [
          ..._productos,
          LineaProductoPrecio(producto: producto, cantidad: cantidad),
        ];
      } else {
        final actualizada = [..._productos];
        final actual = actualizada[indice];
        actualizada[indice] = actual.copyWith(
          cantidad: (actual.cantidad + cantidad).clamp(1, 999).toInt(),
        );
        _productos = actualizada;
      }
      _noEncontrados = [];
    });
  }

  void _agregarDesdeTexto() {
    final consultas = dividirConsultaProductos(_controller.text);
    if (consultas.isEmpty) return;

    final noEncontrados = <String>[];
    var agregados = 0;

    for (final consulta in consultas) {
      final item = extraerConsultaConCantidad(consulta);
      final producto = buscarProductoConPrecio(item.texto);
      if (producto == null) {
        noEncontrados.add(consulta);
        continue;
      }
      final indice = _productos.indexWhere(
        (linea) => linea.producto.nombre == producto.nombre,
      );
      if (indice == -1) {
        _productos = [
          ..._productos,
          LineaProductoPrecio(producto: producto, cantidad: item.cantidad),
        ];
      } else {
        final actualizada = [..._productos];
        final actual = actualizada[indice];
        actualizada[indice] = actual.copyWith(
          cantidad: (actual.cantidad + item.cantidad).clamp(1, 999).toInt(),
        );
        _productos = actualizada;
      }
      agregados += item.cantidad;
    }

    setState(() {
      _noEncontrados = noEncontrados;
    });
    _controller.clear();

    if (agregados > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$agregados producto(s) agregado(s)")),
      );
    }
  }

  void _quitarProducto(ProductoPrecio producto) {
    setState(() {
      _productos = _productos
          .where((item) => item.producto.nombre != producto.nombre)
          .toList();
    });
  }

  void _cambiarCantidad(ProductoPrecio producto, int cambio) {
    final indice = _productos.indexWhere(
      (item) => item.producto.nombre == producto.nombre,
    );
    if (indice == -1) return;

    setState(() {
      final actualizada = [..._productos];
      final actual = actualizada[indice];
      final nuevaCantidad = actual.cantidad + cambio;
      if (nuevaCantidad <= 0) {
        actualizada.removeAt(indice);
      } else {
        actualizada[indice] = actual.copyWith(
          cantidad: nuevaCantidad.clamp(1, 999).toInt(),
        );
      }
      _productos = actualizada;
    });
  }

  void _limpiarSeleccion() {
    setState(() {
      _productos = [];
      _noEncontrados = [];
      _controller.clear();
    });
  }

  Future<void> _calcular() async {
    _agregarDesdeTexto();
    if (_productos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona al menos un producto")),
      );
      return;
    }

    unawaited(ImpactoService.registrar(
      tipo: 'calculadora_productos',
      titulo: 'Calculadora de precios',
      guardarEnFirebase: false,
      datos: {
        'cantidad': _cantidadTotalProductos,
        'productos': _productos
            .map((p) => {'nombre': p.producto.nombre, 'cantidad': p.cantidad})
            .toList(),
        'noEncontrados': _noEncontrados,
      },
    ));

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6DAEA),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Resultado",
                style: TextStyle(
                  color: Color(0xFF13288E),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              _resumenTotal("Afiliado", _precio(_totalAfiliado)),
              _resumenTotal("Publico", _precio(_totalPublico)),
              _resumenTotal(
                  "LP: Life Points (Puntos de Vida)", _totalLp.toString()),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () =>
                    ServicioTextoVoz.reproducir(_resumenCompartir()),
                icon: const Icon(Icons.volume_up_rounded),
                label: const Text("Escuchar resultado"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF17218D),
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Color(0xFF17218D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => Share.share(_resumenCompartir()),
                icon: const Icon(Icons.share_rounded),
                label: const Text("Compartir resultado"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF17218D),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int get _cantidadTotalProductos =>
      _productos.fold(0, (total, p) => total + p.cantidad);

  double get _totalAfiliado => _productos.fold(
      0, (total, p) => total + (p.producto.afiliado * p.cantidad));

  double get _totalPublico => _productos.fold(
      0, (total, p) => total + (p.producto.publico * p.cantidad));

  int get _totalLp => _productos.fold(
      0, (total, p) => total + ((p.producto.lp ?? 0) * p.cantidad));

  String _precio(double valor) => '\$${valor.toStringAsFixed(2)}';

  String _resumenCompartir() {
    final buffer = StringBuffer('Consulta de precios 4Life\n\n');
    for (final linea in _productos) {
      final producto = linea.producto;
      buffer.writeln('${linea.cantidad} x ${producto.nombre}');
      buffer
          .writeln('Afiliado: ${_precio(producto.afiliado * linea.cantidad)}');
      buffer.writeln('Publico: ${_precio(producto.publico * linea.cantidad)}');
      buffer.writeln(
          'LP: Life Points (Puntos de Vida): ${(producto.lp ?? 0) * linea.cantidad}\n');
    }
    buffer.writeln('Total afiliado: ${_precio(_totalAfiliado)}');
    buffer.writeln('Total publico: ${_precio(_totalPublico)}');
    buffer.writeln('Total LP: Life Points (Puntos de Vida): $_totalLp');
    return buffer.toString();
  }

  void _abrirCatalogo() {
    final productosCatalogo = [...productosConPrecio4Life]
      ..sort((a, b) => normalizarTexto(a.nombre).compareTo(
            normalizarTexto(b.nombre),
          ));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        minChildSize: 0.55,
        maxChildSize: 0.94,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8DCEB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Catalogo",
                        style: TextStyle(
                          color: Color(0xFF11258B),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: "Cerrar",
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.86,
                  ),
                  itemCount: productosCatalogo.length,
                  itemBuilder: (context, index) {
                    final producto = productosCatalogo[index];
                    final imagen = imagenesProducto4Life[producto.nombre];
                    final cantidad = _productos
                        .where(
                            (item) => item.producto.nombre == producto.nombre)
                        .fold<int>(0, (total, item) => total + item.cantidad);
                    final seleccionado = cantidad > 0;
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        _agregarProducto(producto);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: seleccionado
                              ? const Color(0xFFE9ECFF)
                              : const Color(0xFFF8F9FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: seleccionado
                                ? const Color(0xFF17218D)
                                : const Color(0xFFE1E4F0),
                            width: seleccionado ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF17218D)
                                  .withValues(alpha: 0.07),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: imagen == null
                                  ? const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Color(0xFF17218D),
                                    )
                                  : Image.asset(
                                      imagen,
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                    ),
                            ),
                            if (seleccionado)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: const Color(0xFF17218D),
                                  child: Text(
                                    'x$cantidad',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Stack(
        children: [
          Container(
            height: 230,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF132890), Color(0xFF0B176B)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              child: Column(
                children: [
                  _encabezado(),
                  const SizedBox(height: 26),
                  _tarjetaSeleccion(),
                  const SizedBox(height: 18),
                  _tarjetaProductosSeleccionados(),
                  const SizedBox(height: 18),
                  _botonCalcular(),
                  const SizedBox(height: 18),
                  _accionesSecundarias(),
                  const SizedBox(height: 18),
                  _tarjetaAyuda(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _encabezado() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          iconSize: 34,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 42, height: 42),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Consultora y calculadora",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Consulta precios y LP: Life Points (Puntos de Vida)",
                style: TextStyle(
                  color: Color(0xFFDCE2FF),
                  fontSize: 20,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.help_outline_rounded, color: Colors.white, size: 32),
              SizedBox(height: 3),
              Text(
                "Ayuda",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tarjetaSeleccion() {
    return _contenedorTarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selecciona producto(s)",
                      style: TextStyle(
                        color: Color(0xFF11258B),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      "Busca y anade uno o varios productos para consultar precios y LP: Life Points (Puntos de Vida).",
                      style: TextStyle(
                        color: Color(0xFF47527E),
                        fontSize: 18,
                        height: 1.38,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _ilustracionProductos(),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            minLines: 1,
            maxLines: 2,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _agregarDesdeTexto(),
            decoration: InputDecoration(
              hintText: "Buscar producto(s)",
              hintStyle: const TextStyle(
                color: Color(0xFF858AA5),
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF6E748F),
                size: 34,
              ),
              suffixIcon: IconButton(
                tooltip: "Agregar",
                onPressed: _agregarDesdeTexto,
                icon: const Icon(Icons.add_circle_rounded),
                color: const Color(0xFF17218D),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFD1D5E3), width: 1.4),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFF17218D), width: 1.7),
              ),
            ),
          ),
          const SizedBox(height: 18),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _abrirCatalogo,
            child: Container(
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD1D5E3), width: 1.4),
              ),
              child: const Row(
                children: [
                  Icon(Icons.format_list_bulleted_rounded,
                      color: Color(0xFF12248B), size: 34),
                  SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      "Explorar catalogo",
                      style: TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: Color(0xFF12248B), size: 34),
                ],
              ),
            ),
          ),
          if (_noEncontrados.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              "No encontrados: ${_noEncontrados.join(', ')}",
              style: const TextStyle(
                color: Color(0xFFC0392B),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _ilustracionProductos() {
    return SizedBox(
      width: 108,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            bottom: 8,
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: const Color(0xFFE8ECFF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.calculate_outlined,
                color: Color(0xFF2839C7),
                size: 38,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 4,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFF2839C7),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2839C7).withValues(alpha: 0.20),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          const Positioned(
            right: 8,
            top: 8,
            child: Icon(
              Icons.add_circle,
              size: 28,
              color: Color(0xFF17218D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaProductosSeleccionados() {
    return _contenedorTarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Productos seleccionados",
                  style: TextStyle(
                    color: Color(0xFF11258B),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EAFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  "$_cantidadTotalProductos productos",
                  style: const TextStyle(
                    color: Color(0xFF2832A1),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (_productos.isEmpty) _estadoVacio() else _listaSeleccionados(),
        ],
      ),
    );
  }

  Widget _estadoVacio() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(18, 4, 18, 22),
        child: Column(
          children: [
            CircleAvatar(
              radius: 46,
              backgroundColor: Color(0xFFECEEFF),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF3143B8),
                size: 46,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Aun no has agregado productos",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF3B467A),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Busca y selecciona los productos que deseas consultar.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF58618C),
                fontSize: 17,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listaSeleccionados() {
    return Column(
      children: [
        for (final linea in _productos)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E4F0)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  child: Image.asset(
                    imagenesProducto4Life[linea.producto.nombre] ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.inventory_2_outlined),
                    filterQuality: FilterQuality.high,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        linea.producto.nombre,
                        style: const TextStyle(
                          color: Color(0xFF152179),
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${_precio(linea.producto.afiliado)} afiliado  |  LP: Life Points (Puntos de Vida) ${linea.producto.lp ?? 0}",
                        style: const TextStyle(
                          color: Color(0xFF687092),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _controlCantidad(linea),
                IconButton(
                  tooltip: "Quitar",
                  onPressed: () => _quitarProducto(linea.producto),
                  icon: const Icon(Icons.close_rounded),
                  color: const Color(0xFF17218D),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _controlCantidad(LineaProductoPrecio linea) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFDDE1F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: "Restar",
            visualDensity: VisualDensity.compact,
            onPressed: () => _cambiarCantidad(linea.producto, -1),
            icon: const Icon(Icons.remove_rounded, size: 18),
            color: const Color(0xFF17218D),
          ),
          Text(
            '${linea.cantidad}',
            style: const TextStyle(
              color: Color(0xFF12248B),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          IconButton(
            tooltip: "Sumar",
            visualDensity: VisualDensity.compact,
            onPressed: () => _cambiarCantidad(linea.producto, 1),
            icon: const Icon(Icons.add_rounded, size: 18),
            color: const Color(0xFF17218D),
          ),
        ],
      ),
    );
  }

  Widget _botonCalcular() {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: _calcular,
      child: Container(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 26),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF172394), Color(0xFF0B176B)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.calculate_outlined, color: Colors.white, size: 38),
            SizedBox(width: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Calcular",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    "Consulta precios y LP: Life Points (Puntos de Vida)",
                    style: TextStyle(
                      color: Color(0xFFDDE3FF),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.white, size: 42),
          ],
        ),
      ),
    );
  }

  Widget _accionesSecundarias() {
    return Container(
      height: 86,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E6EF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111A5B).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _accionSecundaria(
              icono: Icons.copy_rounded,
              texto: "Limpiar seleccion",
              onTap: _limpiarSeleccion,
            ),
          ),
          Container(width: 1, height: 42, color: const Color(0xFFE0E3EF)),
          Expanded(
            child: _accionSecundaria(
              icono: Icons.share_rounded,
              texto: "Compartir lista",
              onTap: _productos.isEmpty
                  ? null
                  : () => Share.share(_resumenCompartir()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accionSecundaria({
    required IconData icono,
    required String texto,
    required VoidCallback? onTap,
  }) {
    final activo = onTap != null;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icono,
            color: activo ? const Color(0xFF12248B) : const Color(0xFF9AA0B6),
            size: 30,
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              texto,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color:
                    activo ? const Color(0xFF12248B) : const Color(0xFF9AA0B6),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaAyuda() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE5FF), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: Color(0xFF4865DF),
            child: Icon(Icons.info_rounded, color: Colors.white, size: 30),
          ),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Como funciona?",
                  style: TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Selecciona uno o varios productos y presiona calcular para obtener los precios y LP: Life Points (Puntos de Vida).",
                  style: TextStyle(
                    color: Color(0xFF46527E),
                    fontSize: 17,
                    height: 1.38,
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

  Widget _contenedorTarjeta({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _resumenTotal(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: const TextStyle(
                color: Color(0xFF46527E),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              color: Color(0xFF12248B),
              fontSize: 20,
              fontWeight: FontWeight.w900,
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
  String _tipoSeleccionado = 'diagnostico';

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
      _aplicarFiltros();
    });
  }

  String _tipoRegistro(Map<String, dynamic> registro) {
    return registro['tipo']?.toString() ?? 'diagnostico';
  }

  bool _esCambioFisico(Map<String, dynamic> registro) {
    return _tipoRegistro(registro) == 'cambio_fisico';
  }

  void _aplicarFiltros() {
    final busqueda = _searchController.text.toLowerCase().trim();
    _historialFiltrado = _todoElHistorial.where((paciente) {
      if (_tipoRegistro(paciente) != _tipoSeleccionado) return false;
      final nombre = _nombrePaciente(paciente).toLowerCase();
      final fecha = paciente['fecha']?.toString().toLowerCase() ?? '';
      final resultado = paciente['resultado']?.toString().toLowerCase() ?? '';
      final titulo = paciente['titulo']?.toString().toLowerCase() ?? '';
      final datos = paciente['datos'];
      final objetivo = datos is Map
          ? (datos['objetivoFisico']?.toString().toLowerCase() ?? '')
          : '';
      return nombre.contains(busqueda) ||
          fecha.contains(busqueda) ||
          resultado.contains(busqueda) ||
          titulo.contains(busqueda) ||
          objetivo.contains(busqueda);
    }).toList();
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
    setState(() {
      _aplicarFiltros();
    });
  }

  void _cambiarTipoHistorial(String tipo) {
    setState(() {
      _tipoSeleccionado = tipo;
      _aplicarFiltros();
    });
  }

  void _reDiagnosticar(Map<String, dynamic> pacienteViejo) {
    final nombre = _nombrePaciente(pacienteViejo);
    final resultado =
        pacienteViejo['resultado']?.toString() ?? "Sin resultado guardado";
    final esCambio = _esCambioFisico(pacienteViejo);
    final nuevaPreguntaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(esCambio ? "Ajustar cambio fisico" : "Re-evaluar a $nombre"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${esCambio ? 'Guia anterior' : 'Diagnostico anterior'}:\n$resultado",
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nuevaPreguntaController,
              decoration: const InputDecoration(
                labelText: "Que cambio o que nueva duda tienes?",
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
                  "Tomando como base ${esCambio ? 'la guia de cambio fisico anterior' : 'el diagnostico anterior'} de este paciente: $resultado. "
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
    final objetivo =
        datos is Map ? datos['objetivoFisico']?.toString() ?? "" : "";
    final esCambio = _esCambioFisico(pacienteViejo);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("${esCambio ? 'Cambio fisico' : 'Reporte'} de $nombre"),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Fecha: $fecha"),
                if (!esCambio && sintomas.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    "Sintomas registrados:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(sintomas),
                ],
                if (esCambio && objetivo.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    "Objetivo fisico:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(objetivo),
                ],
                const SizedBox(height: 12),
                Text(
                  esCambio
                      ? "Guia de cambio fisico:"
                      : "Reporte o diagnostico:",
                  style: const TextStyle(fontWeight: FontWeight.bold),
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

  String _fechaPaciente(dynamic valor) {
    final texto = valor?.toString() ?? '';
    final fecha = DateTime.tryParse(texto);
    if (fecha == null) return texto.isEmpty ? 'Sin fecha' : texto;
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
  }

  String _horaPaciente(dynamic valor) {
    final texto = valor?.toString() ?? '';
    final fecha = DateTime.tryParse(texto);
    if (fecha == null) return '--:--';
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  _EstadoPaciente _estadoPaciente(Map<String, dynamic> registro) {
    final resultado = registro['resultado']?.toString().trim() ?? '';
    if (resultado.isEmpty) {
      return const _EstadoPaciente(
        texto: 'Pendiente',
        icono: Icons.schedule_rounded,
        color: Color(0xFFF29A00),
      );
    }
    if (_esCambioFisico(registro)) {
      return const _EstadoPaciente(
        texto: 'Cambio fisico completo',
        icono: Icons.fitness_center_rounded,
        color: Color(0xFF14983E),
      );
    }
    return const _EstadoPaciente(
      texto: 'Diagnóstico completo',
      icono: Icons.check_circle_outline,
      color: Color(0xFF14983E),
    );
  }

  Color _colorAvatar(String nombre) {
    final colores = [
      const Color(0xFFDDE8FF),
      const Color(0xFFD8F4DA),
      const Color(0xFFE8DBFF),
      const Color(0xFFD8F3F8),
    ];
    if (nombre.isEmpty) return colores.first;
    return colores[nombre.codeUnitAt(0) % colores.length];
  }

  Color _colorInicial(String nombre) {
    final colores = [
      const Color(0xFF1D65C1),
      const Color(0xFF128E32),
      const Color(0xFF5A34C9),
      const Color(0xFF11899A),
    ];
    if (nombre.isEmpty) return colores.first;
    return colores[nombre.codeUnitAt(0) % colores.length];
  }

  void _nuevoDiagnostico() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _tipoSeleccionado == 'cambio_fisico'
            ? const FormularioCambioFisico()
            : const FormularioPaciente(),
      ),
    ).then((_) => _cargarDatos());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _selectorTipoHistorial() {
    return Container(
      height: 58,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _opcionTipoHistorial(
              texto: 'Diagnosticos',
              icono: Icons.medical_services_outlined,
              tipo: 'diagnostico',
            ),
          ),
          Expanded(
            child: _opcionTipoHistorial(
              texto: 'Cambios fisicos',
              icono: Icons.fitness_center_rounded,
              tipo: 'cambio_fisico',
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcionTipoHistorial({
    required String texto,
    required IconData icono,
    required String tipo,
  }) {
    final activo = _tipoSeleccionado == tipo;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _cambiarTipoHistorial(tipo),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: activo ? const Color(0xFFEDEEFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icono,
              color: activo ? const Color(0xFF2839C7) : const Color(0xFF68708C),
              size: 22,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                texto,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: activo
                      ? const Color(0xFF2839C7)
                      : const Color(0xFF68708C),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);
    const azulOscuro = Color(0xFF111B7D);
    final cantidad = _historialFiltrado.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              height: 112,
              padding: EdgeInsets.only(
                left: 22,
                right: 22,
                top: MediaQuery.of(context).padding.top + 12,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [azul, azulOscuro],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 32),
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 24),
                  const Expanded(
                    child: Text(
                      'Historial de Pacientes',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 31,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Filtros',
                    icon: const Icon(Icons.filter_list_rounded, size: 34),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 138),
                    children: [
                      Container(
                        height: 86,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filtrarHistorial,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                            color: Color(0xFF0D1430),
                            fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Buscar paciente, fecha o registro...',
                            hintStyle: TextStyle(
                              color: Color(0xFF747A9E),
                              fontSize: 20,
                            ),
                            icon: Icon(
                              Icons.search,
                              color: Color(0xFF68709D),
                              size: 34,
                            ),
                            suffixIcon: Icon(
                              Icons.calendar_today_outlined,
                              color: azul,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _selectorTipoHistorial(),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _tipoSeleccionado == 'cambio_fisico'
                                  ? 'Cambios fisicos'
                                  : 'Diagnosticos de enfermedades',
                              style: const TextStyle(
                                color: Color(0xFF646B88),
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            '$cantidad ${cantidad == 1 ? 'resultado' : 'resultados'}',
                            style: const TextStyle(
                              color: azul,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      if (_historialFiltrado.isEmpty)
                        const _EstadoHistorialVacio(
                          texto: 'No se encontraron registros',
                        )
                      else
                        ..._historialFiltrado.map((item) {
                          final nombre = _nombrePaciente(item);
                          return _TarjetaPacienteHistorial(
                            nombre: nombre,
                            inicial:
                                nombre.isEmpty ? '?' : nombre[0].toUpperCase(),
                            fecha: _fechaPaciente(item['fecha']),
                            hora: _horaPaciente(item['fecha']),
                            estado: _estadoPaciente(item),
                            colorAvatar: _colorAvatar(nombre),
                            colorInicial: _colorInicial(nombre),
                            onVer: () => _verReporteAnterior(item),
                            onRepetir: () => _reDiagnosticar(item),
                            onAbrir: () => _verReporteAnterior(item),
                          );
                        }),
                    ],
                  ),
                  Positioned(
                    right: 28,
                    bottom: 72,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 88,
                          height: 88,
                          child: FloatingActionButton(
                            heroTag: 'nuevo-diagnostico-historial',
                            backgroundColor: azul,
                            foregroundColor: Colors.white,
                            elevation: 9,
                            shape: const CircleBorder(),
                            onPressed: _nuevoDiagnostico,
                            child: const Icon(Icons.add, size: 40),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _tipoSeleccionado == 'cambio_fisico'
                              ? 'Nuevo cambio'
                              : 'Nuevo diagnostico',
                          style: TextStyle(
                            color: azul,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
        child: Container(
          height: 82,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.history,
                  texto: 'Historial',
                  activo: true,
                ),
              ),
              Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.people_outline,
                  texto: 'Pacientes',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaDatosPaciente(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.bar_chart,
                  texto: 'Estadísticas',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaImpacto4LifeNueva(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoPaciente {
  final String texto;
  final IconData icono;
  final Color color;

  const _EstadoPaciente({
    required this.texto,
    required this.icono,
    required this.color,
  });
}

class _TarjetaPacienteHistorial extends StatelessWidget {
  final String nombre;
  final String inicial;
  final String fecha;
  final String hora;
  final _EstadoPaciente estado;
  final Color colorAvatar;
  final Color colorInicial;
  final VoidCallback onVer;
  final VoidCallback onRepetir;
  final VoidCallback onAbrir;

  const _TarjetaPacienteHistorial({
    required this.nombre,
    required this.inicial,
    required this.fecha,
    required this.hora,
    required this.estado,
    required this.colorAvatar,
    required this.colorInicial,
    required this.onVer,
    required this.onRepetir,
    required this.onAbrir,
  });

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);

    return Container(
      height: 156,
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        elevation: 1.5,
        shadowColor: Colors.black.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onAbrir,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Row(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: colorAvatar,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    inicial,
                    style: TextStyle(
                      color: colorInicial,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              nombre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF10162F),
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: azul,
                            size: 36,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xFF68708C),
                            size: 20,
                          ),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              fecha,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF68708C),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.access_time,
                            color: Color(0xFF68708C),
                            size: 20,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            hora,
                            style: const TextStyle(
                              color: Color(0xFF68708C),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  estado.icono,
                                  color: estado.color,
                                  size: 20,
                                ),
                                const SizedBox(width: 7),
                                Flexible(
                                  child: Text(
                                    estado.texto,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: estado.color,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _BotonAccionPaciente(
                            icono: Icons.visibility_outlined,
                            texto: 'Ver',
                            onTap: onVer,
                            relleno: false,
                          ),
                          const SizedBox(width: 10),
                          _BotonAccionPaciente(
                            icono: Icons.refresh,
                            texto: 'Repetir',
                            onTap: onRepetir,
                            relleno: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BotonAccionPaciente extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  final bool relleno;

  const _BotonAccionPaciente({
    required this.icono,
    required this.texto,
    required this.onTap,
    required this.relleno,
  });

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);

    return SizedBox(
      width: relleno ? 98 : 82,
      height: 40,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icono, size: 22),
        label: Text(texto),
        style: OutlinedButton.styleFrom(
          backgroundColor: relleno ? const Color(0xFFEDEEFF) : Colors.white,
          foregroundColor: azul,
          side: BorderSide(
            color: relleno ? const Color(0xFFEDEEFF) : const Color(0xFFD6D9F1),
            width: 1.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
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
  List<Map<String, dynamic>> _conversacionesFiltradas = [];
  final TextEditingController _busquedaController = TextEditingController();
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
      _conversacionesFiltradas = _filtrar(datos, _busquedaController.text);
      _cargando = false;
    });
  }

  List<Map<String, dynamic>> _filtrar(
    List<Map<String, dynamic>> conversaciones,
    String query,
  ) {
    final texto = query.trim().toLowerCase();
    if (texto.isEmpty) return conversaciones;
    return conversaciones.where((chat) {
      final titulo = chat['titulo']?.toString().toLowerCase() ?? '';
      final fecha = chat['fecha']?.toString().toLowerCase() ?? '';
      final mensajes =
          _mensajes(chat).map((m) => m['texto'] ?? '').join(' ').toLowerCase();
      return titulo.contains(texto) ||
          fecha.contains(texto) ||
          mensajes.contains(texto);
    }).toList();
  }

  void _buscar(String query) {
    setState(() {
      _conversacionesFiltradas = _filtrar(_conversaciones, query);
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

  String _fechaLegible(dynamic valor) {
    final texto = valor?.toString() ?? '';
    final fecha = DateTime.tryParse(texto);
    if (fecha == null) return texto.isEmpty ? 'Sin fecha' : texto;
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year} · $hora:$minuto';
  }

  _CategoriaChat _categoriaPara(String titulo) {
    final t = titulo.toLowerCase();
    if (t.contains('sueño') ||
        t.contains('sueno') ||
        t.contains('insomnio') ||
        t.contains('descanso')) {
      return const _CategoriaChat(
        texto: 'Sueño y descanso',
        icono: Icons.nightlight_round,
        color: Color(0xFF5E46D8),
        fondo: Color(0xFFEAE6FF),
      );
    }
    if (t.contains('dolor') ||
        t.contains('lesion') ||
        t.contains('lesión') ||
        t.contains('espalda') ||
        t.contains('migraña')) {
      return const _CategoriaChat(
        texto: 'Dolor y lesiones',
        icono: Icons.accessibility_new_rounded,
        color: Color(0xFF2876DF),
        fondo: Color(0xFFE7F1FF),
      );
    }
    if (t.contains('gastritis') ||
        t.contains('digest') ||
        t.contains('estomago') ||
        t.contains('estómago')) {
      return const _CategoriaChat(
        texto: 'Salud digestiva',
        icono: Icons.local_fire_department_outlined,
        color: Color(0xFFC45B20),
        fondo: Color(0xFFFFE8D8),
      );
    }
    if (t.contains('prote') ||
        t.contains('creatina') ||
        t.contains('vitamina') ||
        t.contains('suplement')) {
      return const _CategoriaChat(
        texto: 'Suplementos',
        icono: Icons.spa_outlined,
        color: Color(0xFF3F9A4B),
        fondo: Color(0xFFE1F4E2),
      );
    }
    return const _CategoriaChat(
      texto: 'Salud general',
      icono: Icons.health_and_safety_outlined,
      color: Color(0xFF3047CC),
      fondo: Color(0xFFE8ECFF),
    );
  }

  void _nuevoChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaginaChatbot()),
    ).then((_) => _cargar());
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);
    const azulOscuro = Color(0xFF111B7D);
    final cantidad = _conversacionesFiltradas.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              height: 112,
              padding: EdgeInsets.only(
                left: 22,
                right: 22,
                top: MediaQuery.of(context).padding.top + 12,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [azul, azulOscuro],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 32),
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 22),
                  const Expanded(
                    child: Text(
                      'Historial de chats',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Filtros',
                    icon: const Icon(Icons.filter_list_rounded, size: 34),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  _cargando
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 138),
                          children: [
                            Container(
                              height: 86,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _busquedaController,
                                onChanged: _buscar,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                  color: Color(0xFF0D1430),
                                  fontSize: 20,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Buscar en el historial...',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF747A9E),
                                    fontSize: 20,
                                  ),
                                  icon: Icon(
                                    Icons.search,
                                    color: Color(0xFF68709D),
                                    size: 34,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: azul,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 26),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Conversaciones recientes',
                                    style: TextStyle(
                                      color: Color(0xFF646B88),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$cantidad ${cantidad == 1 ? 'conversación' : 'conversaciones'}',
                                  style: const TextStyle(
                                    color: azul,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            if (_conversaciones.isEmpty)
                              const _EstadoHistorialVacio(
                                texto: 'No hay conversaciones guardadas',
                              )
                            else if (_conversacionesFiltradas.isEmpty)
                              const _EstadoHistorialVacio(
                                texto: 'No se encontraron conversaciones',
                              )
                            else
                              ..._conversacionesFiltradas.map((chat) {
                                final id = chat['id']?.toString() ?? '';
                                final titulo =
                                    chat['titulo']?.toString() ?? 'Chat 4Life';
                                return _TarjetaConversacion(
                                  titulo: titulo,
                                  fecha: _fechaLegible(chat['fecha']),
                                  categoria: _categoriaPara(titulo),
                                  onAbrir: () => _abrirChat(chat),
                                  onEliminar:
                                      id.isEmpty ? null : () => _eliminar(id),
                                );
                              }),
                          ],
                        ),
                  Positioned(
                    right: 28,
                    bottom: 72,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 88,
                          height: 88,
                          child: FloatingActionButton(
                            heroTag: 'nuevo-chat-historial',
                            backgroundColor: azul,
                            foregroundColor: Colors.white,
                            elevation: 9,
                            shape: const CircleBorder(),
                            onPressed: _nuevoChat,
                            child: const Icon(Icons.add, size: 40),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Nuevo chat',
                          style: TextStyle(
                            color: azul,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
        child: Container(
          height: 82,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.history,
                  texto: 'Historial',
                  activo: true,
                ),
              ),
              Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.people_outline,
                  texto: 'Pacientes',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaDatosPaciente(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.bar_chart,
                  texto: 'Estadísticas',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaImpacto4LifeNueva(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriaChat {
  final String texto;
  final IconData icono;
  final Color color;
  final Color fondo;

  const _CategoriaChat({
    required this.texto,
    required this.icono,
    required this.color,
    required this.fondo,
  });
}

class _TarjetaConversacion extends StatelessWidget {
  final String titulo;
  final String fecha;
  final _CategoriaChat categoria;
  final VoidCallback onAbrir;
  final VoidCallback? onEliminar;

  const _TarjetaConversacion({
    required this.titulo,
    required this.fecha,
    required this.categoria,
    required this.onAbrir,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);

    return Container(
      height: 142,
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        elevation: 1.5,
        shadowColor: Colors.black.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onAbrir,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Row(
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDEEFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: azul,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 26),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF10162F),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xFF68708C),
                            size: 20,
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              fecha,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF68708C),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: categoria.fondo,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                categoria.icono,
                                color: categoria.color,
                                size: 17,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                categoria.texto,
                                style: TextStyle(
                                  color: categoria.color,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: 'Eliminar',
                  onPressed: onEliminar,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F1F8),
                    fixedSize: const Size(58, 58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFF5E637C),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: azul,
                  size: 36,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EstadoHistorialVacio extends StatelessWidget {
  final String texto;

  const _EstadoHistorialVacio({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      alignment: Alignment.center,
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF646B88),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ItemNavegacionHistorial extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool activo;
  final VoidCallback? onTap;

  const _ItemNavegacionHistorial({
    required this.icono,
    required this.texto,
    this.activo = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = activo ? const Color(0xFF2839C7) : const Color(0xFF737892);

    return Material(
      color: activo ? const Color(0xFFEDEEFF) : Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: activo ? null : onTap,
        child: SizedBox(
          height: 62,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: color, size: 27),
              const SizedBox(width: 9),
              Flexible(
                child: Text(
                  texto,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 17,
                    fontWeight: activo ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaginaChatbot extends StatefulWidget {
  final String titulo;
  final bool modoLlamada;
  final String? consultaInicial;
  final String? conversacionId;
  final List<Map<String, String>>? mensajesIniciales;

  const PaginaChatbot({
    super.key,
    this.titulo = "Asesor IA 4Life",
    this.modoLlamada = false,
    this.consultaInicial,
    this.conversacionId,
    this.mensajesIniciales,
  });

  @override
  State<PaginaChatbot> createState() => _PaginaChatbotState();
}

class _PaginaChatbotState extends State<PaginaChatbot> {
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final List<Map<String, String>> mensajes = [];
  ArchivoAdjuntoIA? _adjunto;
  bool enviando = false;
  bool _grabandoAudio = false;
  String _estadoLlamada = "Conectando...";
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
    if (widget.modoLlamada) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _iniciarLlamada();
      });
    }
  }

  Future<void> _iniciarLlamada() async {
    const saludo =
        "Buen dia. Soy DoctorSuplementos. En que te puedo ayudar el dia de hoy?";
    if (!mounted) return;
    setState(() => _estadoLlamada = "DoctorSuplementos esta hablando...");
    await ServicioTextoVoz.reproducir(saludo);
    if (!mounted) return;
    setState(() => _estadoLlamada = "Toca el microfono para hablar");
  }

  Future<void> enviarMensaje() async {
    final textoUsuario = _controller.text.trim();
    if ((textoUsuario.isEmpty && _adjunto == null) || enviando) return;
    final textoVisible = textoUsuario.isEmpty
        ? (_adjunto?.esAudio == true
            ? "Analiza esta nota de voz."
            : "Analiza el archivo adjunto.")
        : textoUsuario;

    setState(() {
      mensajes.add({"rol": "usuario", "texto": textoVisible});
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
    final productoCoincidente = buscarProductoPermitido(textoVisible);
    final instruccionProducto = productoCoincidente == null
        ? ""
        : "Si la consulta menciona un producto mal escrito, responde directamente sobre $productoCoincidente. No digas que fue una coincidencia ni que estaba mal escrito.";
    final instruccionVoz = widget.modoLlamada
        ? "Esta es una llamada de voz. Responde de forma natural, breve y directa, sin listas extensas ni formatos visuales. No saludes de nuevo en cada respuesta."
        : "";

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
    $instruccionProducto
    $instruccionVoz
    Mantén un tono claro, práctico y responsable. Si la pregunta parece médica, recomienda consultar a un profesional de salud.

    Conversación actual:
    $historialPrevio

    Consulta actual:
    $textoVisible
    """;

    try {
      final response = await model.generateContent([
        if (_adjunto == null)
          Content.text(promptLimpioParaChatbot)
        else
          Content.multi([
            TextPart(
              _adjunto!.esAudio
                  ? "$promptLimpioParaChatbot\n\nAnaliza la nota de voz adjunta como contexto temporal. Extrae la consulta y responde con base en el audio. No menciones que fue guardado, porque no se guarda en la app."
                  : "$promptLimpioParaChatbot\n\nAnaliza el archivo adjunto como contexto temporal. No menciones que fue guardado, porque no se guarda en la app.",
            ),
            DataPart(_adjunto!.mimeType, _adjunto!.bytes),
          ]),
      ]);
      final respuestaIA = response.text ?? "No pude generar una respuesta.";

      if (!mounted) return;
      setState(() {
        mensajes.add({"rol": "ia", "texto": respuestaIA});
        _adjunto = null;
        if (widget.modoLlamada) {
          _estadoLlamada = "DoctorSuplementos esta respondiendo...";
        }
      });
      await ChatHistoryService.guardarConversacion(_conversacionId, mensajes);
      if (widget.modoLlamada) {
        await ServicioTextoVoz.reproducir(respuestaIA);
        if (mounted) {
          setState(() => _estadoLlamada = "Toca el microfono para hablar");
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        mensajes.add({
          "rol": "ia",
          "texto": "No se pudo conectar con la IA. Intenta nuevamente."
        });
        if (widget.modoLlamada) {
          _estadoLlamada = "No pude responder. Intenta nuevamente";
        }
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
    if (_grabandoAudio) {
      unawaited(_audioRecorder.cancel());
    }
    if (widget.modoLlamada) {
      unawaited(ServicioTextoVoz.detener());
    }
    _audioRecorder.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> tomarFotoChat() async {
    final imagen = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 88,
    );
    if (imagen == null) return;

    final bytes = await imagen.readAsBytes();
    if (!mounted) return;
    setState(() {
      _adjunto = ArchivoAdjuntoIA(
        nombre: imagen.name,
        mimeType: imagen.mimeType ?? 'image/jpeg',
        bytes: bytes,
      );
    });
  }

  Future<void> seleccionarArchivoChat() async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'webp'],
      withData: true,
    );
    final archivo = resultado?.files.single;
    final bytes = archivo?.bytes;
    if (archivo == null || bytes == null) return;

    final extension = (archivo.extension ?? '').toLowerCase();
    final mime = switch (extension) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };

    if (!mounted) return;
    setState(() {
      _adjunto = ArchivoAdjuntoIA(
        nombre: archivo.name,
        mimeType: mime,
        bytes: bytes,
      );
    });
  }

  Future<void> alternarAudioChat() async {
    if (_grabandoAudio) {
      final path = await _audioRecorder.stop();
      if (!mounted) return;
      setState(() => _grabandoAudio = false);
      if (path == null) return;

      final archivo = File(path);
      final bytes = await archivo.readAsBytes();
      await archivo.delete().catchError((_) => archivo);
      if (bytes.isEmpty || !mounted) return;

      setState(() {
        _adjunto = ArchivoAdjuntoIA(
          nombre: 'Nota de voz para el asesor.m4a',
          mimeType: 'audio/mp4',
          bytes: bytes,
        );
      });
      return;
    }

    if (!await _audioRecorder.hasPermission()) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Permiso de microfono"),
          content: Text(
            "Activa el permiso del microfono para grabar la nota de voz.",
          ),
        ),
      );
      return;
    }

    final carpetaTemporal = await getTemporaryDirectory();
    final path =
        '${carpetaTemporal.path}/chat_${DateTime.now().microsecondsSinceEpoch}.m4a';
    await _audioRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        numChannels: 1,
        bitRate: 64000,
      ),
      path: path,
    );
    if (!mounted) return;
    setState(() => _grabandoAudio = true);
  }

  Future<void> alternarLlamadaVoz() async {
    if (enviando) return;

    if (_grabandoAudio) {
      final path = await _audioRecorder.stop();
      if (!mounted) return;
      setState(() {
        _grabandoAudio = false;
        _estadoLlamada = "Procesando tu pregunta...";
      });
      if (path == null) {
        setState(() => _estadoLlamada = "Toca el microfono para hablar");
        return;
      }

      final archivo = File(path);
      final bytes = await archivo.readAsBytes();
      await archivo.delete().catchError((_) => archivo);
      if (bytes.isEmpty || !mounted) return;

      setState(() {
        _adjunto = ArchivoAdjuntoIA(
          nombre: 'Pregunta de voz.m4a',
          mimeType: 'audio/mp4',
          bytes: bytes,
        );
      });
      await enviarMensaje();
      return;
    }

    await ServicioTextoVoz.detener();
    if (!await _audioRecorder.hasPermission()) {
      if (!mounted) return;
      setState(() => _estadoLlamada = "Se necesita acceso al microfono");
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Permiso de microfono"),
          content: Text(
            "Activa el permiso del microfono para conversar con DoctorSuplementos.",
          ),
        ),
      );
      return;
    }

    final carpetaTemporal = await getTemporaryDirectory();
    final path =
        '${carpetaTemporal.path}/chat_live_${DateTime.now().microsecondsSinceEpoch}.m4a';
    await _audioRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        numChannels: 1,
        bitRate: 64000,
      ),
      path: path,
    );
    if (!mounted) return;
    setState(() {
      _grabandoAudio = true;
      _estadoLlamada = "Te estoy escuchando...";
    });
  }

  void quitarAdjuntoChat() {
    setState(() => _adjunto = null);
  }

  @override
  Widget build(BuildContext context) {
    return widget.modoLlamada ? _buildChatLiveVoz() : _buildChatbotNuevo();
  }

  // ignore: unused_element
  Widget _buildChatbotAnterior(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
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

extension _PaginaChatbotUi on _PaginaChatbotState {
  Widget _buildChatLiveVoz() {
    final escuchando = _grabandoAudio;
    final ocupado = enviando;

    return PopScope(
      onPopInvokedWithResult: (_, __) {
        unawaited(ServicioTextoVoz.detener());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF07125E),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF172B98),
                Color(0xFF101B79),
                Color(0xFF071044),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: "Finalizar llamada",
                        onPressed: () {
                          ServicioTextoVoz.detener();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        iconSize: 32,
                      ),
                      const Expanded(
                        child: Text(
                          "Chat Live 4Life",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: 174,
                  height: 174,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.24),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6578FF).withValues(alpha: 0.28),
                        blurRadius: escuchando ? 52 : 28,
                        spreadRadius: escuchando ? 18 : 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 132,
                      height: 132,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.health_and_safety_rounded,
                        color: Color(0xFF172394),
                        size: 72,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                const Text(
                  "DoctorSuplementos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    _estadoLlamada,
                    key: ValueKey(_estadoLlamada),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFD9DFFF),
                      fontSize: 17,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (ocupado) ...[
                  const SizedBox(height: 22),
                  const SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ],
                const Spacer(),
                Semantics(
                  button: true,
                  label: escuchando
                      ? "Detener y enviar pregunta"
                      : "Hablar con DoctorSuplementos",
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: ocupado ? null : alternarLlamadaVoz,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: escuchando
                            ? const Color(0xFFE94352)
                            : ocupado
                                ? const Color(0xFF6670A8)
                                : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.22),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Icon(
                        escuchando ? Icons.stop_rounded : Icons.mic_rounded,
                        color:
                            escuchando ? Colors.white : const Color(0xFF172394),
                        size: 56,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  escuchando
                      ? "Toca para enviar tu pregunta"
                      : "Toca para hablar",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 42),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatbotNuevo() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: Stack(
        children: [
          Container(
            height: 206,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF172B98), Color(0xFF07125E)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _encabezadoChatbot(),
                Expanded(
                  child: mensajes.isEmpty
                      ? _estadoInicialChat()
                      : _listaMensajesChat(),
                ),
                if (enviando)
                  const LinearProgressIndicator(
                    minHeight: 3,
                    color: Color(0xFF4059EA),
                    backgroundColor: Color(0xFFE5E8FF),
                  ),
                _barraEntradaChat(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _encabezadoChatbot() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            iconSize: 34,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    height: 1.1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Tu asistente inteligente de suplementos",
                  style: TextStyle(
                    color: Color(0xFFD9DFFF),
                    fontSize: 18,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: "Historial de chats",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaginaHistorialChatbot(),
              ),
            ),
            icon: const Icon(Icons.history_rounded, color: Colors.white),
            iconSize: 38,
          ),
        ],
      ),
    );
  }

  Widget _estadoInicialChat() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          _tarjetaBienvenidaChat(),
          const SizedBox(height: 82),
          _ilustracionConversacion(),
          const SizedBox(height: 30),
          const Text(
            "En que puedo ayudarte hoy?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF12248B),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "Haz una pregunta para iniciar la conversacion.\nEstoy aqui para ayudarte.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF4D5689),
              fontSize: 17,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaBienvenidaChat() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF1FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: Color(0xFF4D66F2),
                  size: 76,
                ),
              ),
              const SizedBox(width: 26),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hola, soy tu Asesor IA 4Life",
                      style: TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 22,
                        height: 1.18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      "Estoy aqui para ayudarte con informacion sobre productos, beneficios, dosis y recomendaciones personalizadas.",
                      style: TextStyle(
                        color: Color(0xFF4D5689),
                        fontSize: 17,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _preguntaRapida(
                  icono: Icons.medication_liquid_outlined,
                  texto: "Recomiendame un suplemento para tener mas energia",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _preguntaRapida(
                  icono: Icons.shield_outlined,
                  texto: "Cual es la funcion del Transfer Factor 4Life?",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _preguntaRapida(
                  icono: Icons.favorite_border_rounded,
                  texto: "Que productos apoyan el sistema inmunologico?",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _preguntaRapida({
    required IconData icono,
    required String texto,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        _controller.text = texto;
        enviarMensaje();
      },
      child: Container(
        height: 112,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF1FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icono, color: const Color(0xFF4D66F2), size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF12248B),
                  fontSize: 14.5,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ilustracionConversacion() {
    return SizedBox(
      width: 230,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 18,
            child: Container(
              width: 150,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF0B176B).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 10,
            child: Container(
              width: 126,
              height: 92,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF526BFA), Color(0xFF263BCB)],
                ),
                borderRadius: BorderRadius.circular(34),
              ),
              child: const Center(
                child: Text(
                  "...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    height: 0.72,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 18,
            child: Container(
              width: 98,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE3FF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.notes_rounded,
                color: Color(0xFF7E8FD4),
                size: 48,
              ),
            ),
          ),
          const Positioned(
            left: 0,
            top: 24,
            child: Icon(Icons.auto_awesome, color: Color(0xFFC4CCFA), size: 26),
          ),
          const Positioned(
            right: 16,
            top: 0,
            child: Icon(Icons.auto_awesome, color: Color(0xFFC4CCFA), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _listaMensajesChat() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      itemCount: mensajes.length,
      itemBuilder: (context, i) {
        final esIA = mensajes[i]["rol"] == "ia";
        final texto = mensajes[i]["texto"] ?? "";
        return _burbujaMensaje(esIA: esIA, texto: texto);
      },
    );
  }

  Widget _burbujaMensaje({
    required bool esIA,
    required String texto,
  }) {
    return Align(
      alignment: esIA ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 620),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        decoration: BoxDecoration(
          color: esIA ? Colors.white : const Color(0xFF172394),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: esIA ? const Radius.circular(4) : null,
            bottomRight: esIA ? null : const Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              esIA ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              esIA ? "Asesor IA" : "Tu",
              style: TextStyle(
                color: esIA ? const Color(0xFF12248B) : Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              texto,
              style: TextStyle(
                color: esIA ? const Color(0xFF27315F) : Colors.white,
                fontSize: 15.5,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (esIA) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: "Escuchar respuesta",
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.volume_up_rounded, size: 21),
                    color: const Color(0xFF4059EA),
                    onPressed: () => ServicioTextoVoz.reproducir(texto),
                  ),
                  IconButton(
                    tooltip: "Detener audio",
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.stop_circle_outlined, size: 21),
                    color: const Color(0xFF4059EA),
                    onPressed: ServicioTextoVoz.detener,
                  ),
                  IconButton(
                    tooltip: "Copiar",
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    color: const Color(0xFF4059EA),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: texto));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Copiado al portapapeles")),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: "Compartir",
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.share_rounded, size: 20),
                    color: const Color(0xFF4059EA),
                    onPressed: () => Share.share(texto),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _barraEntradaChat() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_adjunto != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE1E4F0)),
              ),
              child: Row(
                children: [
                  Icon(
                    _adjunto!.esAudio
                        ? Icons.mic_none_rounded
                        : _adjunto!.esPdf
                            ? Icons.picture_as_pdf_rounded
                            : Icons.image_outlined,
                    color: const Color(0xFF4059EA),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _adjunto!.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF27315F),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: "Quitar archivo",
                    visualDensity: VisualDensity.compact,
                    onPressed: quitarAdjuntoChat,
                    icon: const Icon(Icons.close_rounded),
                    color: const Color(0xFF12248B),
                  ),
                ],
              ),
            ),
          ],
          Container(
            padding: const EdgeInsets.fromLTRB(18, 6, 8, 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD6D9E6), width: 1.5),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: "Tomar foto",
                  visualDensity: VisualDensity.compact,
                  onPressed: enviando ? null : tomarFotoChat,
                  icon: const Icon(Icons.photo_camera_rounded),
                  color: const Color(0xFF535B86),
                ),
                IconButton(
                  tooltip: "Adjuntar archivo",
                  visualDensity: VisualDensity.compact,
                  onPressed: enviando ? null : seleccionarArchivoChat,
                  icon: const Icon(Icons.attach_file_rounded),
                  color: const Color(0xFF535B86),
                ),
                IconButton(
                  tooltip: _grabandoAudio ? "Detener audio" : "Grabar audio",
                  visualDensity: VisualDensity.compact,
                  onPressed: enviando ? null : alternarAudioChat,
                  icon: Icon(_grabandoAudio
                      ? Icons.stop_circle_outlined
                      : Icons.mic_none_rounded),
                  color: _grabandoAudio
                      ? const Color(0xFFD33B3B)
                      : const Color(0xFF535B86),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => enviarMensaje(),
                    decoration: const InputDecoration(
                      hintText: "Pregunta lo que sea...",
                      hintStyle: TextStyle(
                        color: Color(0xFF8C91A8),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(32),
                  onTap: enviando ? null : enviarMensaje,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF172394), Color(0xFF0B176B)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.health_and_safety_outlined,
                  color: Color(0xFF5C6592), size: 22),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  "La informacion proporcionada por la IA no sustituye el consejo de un profesional de la salud.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF5C6592),
                    fontSize: 13.5,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded,
                  color: Color(0xFF08735F), size: 18),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Este documento, foto o audio no se guarda dentro de la app.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF175B50),
                    fontSize: 12.5,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
