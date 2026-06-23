part of '../main.dart';

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
  static const PerfilAsesor porDefecto = PerfilAsesor(
    nombre: 'Socio',
    fotoBase64: '',
    codigoSocio: '',
    telefonoSocio: '',
  );

  final String nombre;
  final String fotoBase64;
  final String codigoSocio;
  final String telefonoSocio;

  const PerfilAsesor({
    required this.nombre,
    required this.fotoBase64,
    this.codigoSocio = '',
    this.telefonoSocio = '',
  });

  bool get tieneNombre => nombre.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'nombre': nombre.trim(),
        'fotoBase64': fotoBase64,
        'codigoSocio': codigoSocio.trim(),
        'telefonoSocio': telefonoSocio.trim(),
      };

  factory PerfilAsesor.fromJson(Map<String, dynamic> json) {
    return PerfilAsesor(
      nombre: json['nombre']?.toString() ?? '',
      fotoBase64: json['fotoBase64']?.toString() ?? '',
      codigoSocio: json['codigoSocio']?.toString() ?? '',
      telefonoSocio: json['telefonoSocio']?.toString() ?? '',
    );
  }
}

class PerfilService {
  static const String prefsKey = 'perfil_asesor_4life';
  static const String _documentId = 'perfil_principal';

  static Future<PerfilAsesor> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(prefsKey);
    if (raw != null && raw.isNotEmpty) {
      return PerfilAsesor.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }

    return PerfilAsesor.porDefecto;
  }

  static Future<void> guardar(PerfilAsesor perfil) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, jsonEncode(perfil.toJson()));

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

enum IdiomaApp {
  espanol('es', 'Español', 'Spanish'),
  ingles('en', 'English', 'English');

  final String codigo;
  final String etiqueta;
  final String etiquetaIngles;

  const IdiomaApp(this.codigo, this.etiqueta, this.etiquetaIngles);
}

enum PaisApp {
  ecuador('ec', 'Ecuador', 'Ecuador'),
  estadosUnidos('us', 'Estados Unidos', 'United States');

  final String codigo;
  final String etiqueta;
  final String etiquetaIngles;

  const PaisApp(this.codigo, this.etiqueta, this.etiquetaIngles);
}

class PaisService {
  static const String prefsKey = 'pais_app_4life';
  static final ValueNotifier<PaisApp> actual =
      ValueNotifier<PaisApp>(PaisApp.ecuador);

  static Future<void> inicializar() async {
    actual.value = await cargar();
  }

  static Future<PaisApp> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final codigo = prefs.getString(prefsKey) ?? PaisApp.ecuador.codigo;
    return _desdeCodigo(codigo);
  }

  static Future<void> guardar(PaisApp pais) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, pais.codigo);
    actual.value = pais;
  }

  static PaisApp _desdeCodigo(String codigo) {
    return PaisApp.values.firstWhere(
      (pais) => pais.codigo == codigo,
      orElse: () => PaisApp.ecuador,
    );
  }
}

class IdiomaService {
  static const String prefsKey = 'idioma_app_4life';
  static final ValueNotifier<IdiomaApp> actual =
      ValueNotifier<IdiomaApp>(IdiomaApp.espanol);

  static const Map<String, Map<String, String>> _textos = {
    'hello_adviser': {'es': '¡Hola, Asesor!', 'en': 'Hello, Adviser!'},
    'hero_subtitle': {
      'es': 'Gestiona, asesora y mejora la vida de más personas.',
      'en': 'Manage, advise, and improve more lives.',
    },
    'impact': {'es': 'Tu impacto 4Life', 'en': 'Your 4Life impact'},
    'consult_products': {
      'es': 'Consultar producto(s)',
      'en': 'Product consultation',
    },
    'consult_products_desc': {
      'es': 'Explora el catálogo y descubre todos nuestros productos.',
      'en': 'Explore the catalog and discover all products.',
    },
    'price_calculator': {
      'es': 'Calculadora de precios',
      'en': 'Price calculator',
    },
    'price_calculator_desc': {
      'es': 'Calcula precios, LP y totales para uno o varios productos.',
      'en': 'Calculate prices, LP, and totals for one or more products.',
    },
    'consumption_optimizer': {
      'es': 'Optimizador de consumo',
      'en': 'Consumption Block Optimizer',
    },
    'consumption_optimizer_desc': {
      'es': 'Genera paquetes maestros desde una meta mínima de LP.',
      'en': 'Build master packs from a minimum LP goal.',
    },
    'local_inventory': {
      'es': 'Inventario local',
      'en': 'My Local Inventory',
    },
    'local_inventory_desc': {
      'es': 'Controla el stock físico disponible para entrega inmediata.',
      'en': 'Track physical stock available for immediate delivery.',
    },
    'ab_comparator': {
      'es': 'Comparador A/B',
      'en': 'A/B Comparator',
    },
    'ab_comparator_desc': {
      'es':
          'Compara dos suplementos lado a lado según la necesidad del cliente.',
      'en': 'Compare two supplements side by side for client needs.',
    },
    'diagnosis': {'es': 'Diagnóstico', 'en': 'Diagnosis'},
    'diagnosis_desc': {
      'es': 'Evalúa y conoce las necesidades de tus clientes.',
      'en': "Evaluate and understand your clients' needs.",
    },
    'body_change': {'es': 'Cambio físico', 'en': 'Body transformation'},
    'body_change_desc': {
      'es': 'Crea una guía personalizada para objetivos corporales.',
      'en': 'Create a personalized guide for body goals.',
    },
    'history': {'es': 'Historial', 'en': 'History'},
    'history_desc': {
      'es': 'Revisa tus consultas, diagnósticos y recomendaciones previas.',
      'en': 'Review previous consultations, diagnoses, and recommendations.',
    },
    'chat_live_desc': {
      'es':
          'Pregunta en tiempo real y recibe respuestas personalizadas de la IA.',
      'en': 'Ask in real time and receive personalized AI answers.',
    },
    'ai_adviser': {'es': 'Asesor IA 4Life', 'en': '4Life AI Adviser'},
    'ai_adviser_desc': {
      'es': 'Obtén recomendaciones personalizadas con inteligencia artificial.',
      'en': 'Get personalized recommendations with artificial intelligence.',
    },
    'testimonials': {'es': 'Testimonios', 'en': 'Testimonials'},
    'testimonials_desc': {
      'es': 'Mira historias reales en video para compartir inspiracion.',
      'en': 'Watch real video stories to share inspiration.',
    },
    'profile': {'es': 'Perfil', 'en': 'Profile'},
    'profile_desc': {
      'es': 'Guarda tu nombre y foto para personalizar la app.',
      'en': 'Save your name and photo to personalize the app.',
    },
    'dictionary': {'es': 'Diccionario', 'en': 'Dictionary'},
    'dictionary_desc': {
      'es': 'Consulta conceptos clave sobre productos y bienestar.',
      'en': 'Check key concepts about products and wellness.',
    },
    'quick_access': {'es': 'Accesos rápidos', 'en': 'Quick access'},
    'catalog': {'es': 'Catálogo', 'en': 'Catalog'},
    'prices': {'es': 'Precios', 'en': 'Prices'},
    'diagnoses': {'es': 'Diagnósticos', 'en': 'Diagnoses'},
    'chats': {'es': 'Chats', 'en': 'Chats'},
    'home': {'es': 'Inicio', 'en': 'Home'},
    'consultations': {'es': 'Consultas', 'en': 'Consultations'},
    'clients': {'es': 'Clientes', 'en': 'Clients'},
  };

  static Future<void> inicializar() async {
    actual.value = await cargar();
  }

  static Future<IdiomaApp> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final codigo = prefs.getString(prefsKey) ?? IdiomaApp.espanol.codigo;
    return _desdeCodigo(codigo);
  }

  static Future<void> guardar(IdiomaApp idioma) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, idioma.codigo);
    actual.value = idioma;
  }

  static String texto(String clave) {
    final idioma = actual.value.codigo;
    return _textos[clave]?[idioma] ?? _textos[clave]?['es'] ?? clave;
  }

  static IdiomaApp _desdeCodigo(String codigo) {
    return IdiomaApp.values.firstWhere(
      (idioma) => idioma.codigo == codigo,
      orElse: () => IdiomaApp.espanol,
    );
  }

  static Future<String> instruccionIa() async {
    final idioma = await cargar();
    return idioma == IdiomaApp.ingles
        ? 'Respond only in English, even if the user writes or speaks in Spanish. Translate all headings, explanations, notes, diagnoses, product descriptions, doses, recommendations and share-ready content into English. Keep official 4Life product names unchanged.'
        : 'Responde solo en espanol, incluso si el usuario escribe o habla en ingles. Manten todo el contenido, encabezados, notas, diagnosticos, productos, dosis, recomendaciones y fichas en espanol.';
  }

  static Future<String> etiquetaContenido() async {
    final idioma = await cargar();
    return idioma == IdiomaApp.ingles ? 'English' : 'español';
  }
}

String txtApp(String espanol, String ingles) {
  return IdiomaService.actual.value == IdiomaApp.ingles ? ingles : espanol;
}

class ImpactoService {
  static const String prefsKey = 'impacto_4life';

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
    final raw = prefs.getStringList(prefsKey) ?? [];
    raw.insert(0, jsonEncode(registro));
    await prefs.setStringList(prefsKey, raw);

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
    final raw = prefs.getStringList(prefsKey) ?? [];
    return raw.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }
}

class InstalacionInicialService {
  static const String _key = 'instalacion_inicial_configurada_v1';

  static Future<bool> prepararSiEsPrimeraInstalacion() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_key) == true) return false;

    final tieneDatosPrevios = prefs.containsKey(PerfilService.prefsKey) ||
        prefs.containsKey(HistorialService.prefsKey) ||
        prefs.containsKey(ChatHistoryService.prefsKey) ||
        prefs.containsKey(ImpactoService.prefsKey);

    if (tieneDatosPrevios) {
      await prefs.setBool(_key, true);
      return false;
    }

    await prefs.setString(
      PerfilService.prefsKey,
      jsonEncode(PerfilAsesor.porDefecto.toJson()),
    );
    await prefs.setStringList(HistorialService.prefsKey, []);
    await prefs.setStringList(ChatHistoryService.prefsKey, []);
    await prefs.setStringList(ImpactoService.prefsKey, []);
    await prefs.setString(IdiomaService.prefsKey, IdiomaApp.espanol.codigo);
    await prefs.setString(PaisService.prefsKey, PaisApp.ecuador.codigo);
    IdiomaService.actual.value = IdiomaApp.espanol;
    PaisService.actual.value = PaisApp.ecuador;
    await prefs.setBool(_key, true);
    return true;
  }
}
