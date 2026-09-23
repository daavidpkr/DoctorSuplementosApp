import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';
import 'services/servicio_texto_voz.dart';
import 'services/servicio_version.dart';
import 'services/servicio_compartir.dart';
import 'platform/archivo_plataforma.dart';
import 'platform/error_red.dart';
import 'platform/pdfjs_loader.dart';
import 'ui/pantalla_resultado_ficha.dart';
import 'ui/visor_imagen_producto.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

part 'core/catalogo_productos.dart';
part 'core/catalogo_productos_usa.dart';
part 'core/datos_catalogo_usa.dart';
part 'core/cliente_ia.dart';
part 'core/servicio_autenticacion_firebase.dart';
part 'core/servicios_app.dart';
part 'core/servicios_historial.dart';
part 'ui/selector_estilizado.dart';
part 'features/inicio.dart';
part 'features/inicio_legacy.dart';
part 'features/perfil.dart';
part 'features/seleccion_pais.dart';
part 'features/impacto.dart';
part 'features/diagnostico.dart';
part 'features/cambio_fisico.dart';
part 'features/consulta_productos.dart';
part 'features/catalogos_pdf.dart';
part 'features/calculadora_precios.dart';
part 'features/optimizador_consumo.dart';
part 'features/optimizador_acelerado.dart';
part 'features/inventario_local.dart';
part 'features/comparador_ab.dart';
part 'features/testimonios.dart';
part 'features/diccionario.dart';
part 'features/mapa_anatomico.dart';
part 'features/historial.dart';
part 'features/chatbot.dart';

const FirebaseOptions _firebaseOptionsEscritorio = FirebaseOptions(
  apiKey: 'AIzaSyDY1ZyaLp8i8KVtcEnyUzgNFz0b0M191kA',
  appId: '1:916760929366:android:13656f89d780918867c7f7',
  messagingSenderId: '916760929366',
  projectId: 'doctorsuplementos-4bbb1',
  storageBucket: 'doctorsuplementos-4bbb1.firebasestorage.app',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseInicializado = await inicializarFirebaseSeguro();
  if (firebaseInicializado) {
    await AutenticacionFirebaseService.autenticarSilenciosamente();
  }
  await IdiomaService.inicializar();
  await PaisService.inicializar();
  runApp(const DoctorSuplementos());
}

String get copyrightOwner {
  const owner = String.fromEnvironment('COPYRIGHT_OWNER');
  return owner.isEmpty ? 'DoctorSuplementos' : owner;
}

Future<bool> inicializarFirebaseSeguro() async {
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
    AutenticacionFirebaseService.habilitarFirebase();
    return true;
  } catch (e) {
    debugPrint('Firebase no se pudo inicializar en este dispositivo: $e');
    return false;
  }
}

class DoctorSuplementos extends StatelessWidget {
  const DoctorSuplementos({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<IdiomaApp>(
      valueListenable: IdiomaService.actual,
      builder: (context, idioma, _) {
        return MaterialApp.router(
          key: const ValueKey('doctor-suplementos-app'),
          debugShowCheckedModeBanner: false,
          title: idioma == IdiomaApp.ingles
              ? 'Doctor Supplements'
              : 'Doctor de Suplementos',
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
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF5F5EE),
            primaryColor: const Color(0xFF1A237E),
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF1A237E)),
            focusColor: const Color(0xFF536DFE).withValues(alpha: 0.24),
          ),
          routerConfig: configuracionRutasApp,
        );
      },
    );
  }
}

abstract final class RutasApp {
  static const catalogoAfiliado = '/catalogo-afiliado';
  static const catalogoMiTienda = '/catalogo-mitienda';
  static const catalogosPdf = '/catalogos-pdf';
  static const calculadoraPrecios = '/calculadora-precios';
  static const optimizadorConsumo = '/optimizador-consumo';
  static const optimizadorAcelerado = '/optimizador-acelerado';
  static const inventarioLocal = '/inventario-local';
  static const comparadorAB = '/comparador-ab';
  static const diagnostico = '/diagnostico';
  static const cambioFisico = '/cambio-fisico';
  static const historial = '/historial';
  static const chatLive = '/chat-live';
  static const asesorIa = '/asesor-ia';
  static const historialChatsIa = '/historial-chats-ia';
  static const testimonios = '/testimonios';
  static const diccionario = '/diccionario';
  static const mapaAnatomico = '/mapa-anatomico';
  static const impacto = '/impacto';
  static const perfil = '/perfil';
}

Widget? construirPantallaRuta(String? ruta) => switch (ruta) {
      RutasApp.catalogoAfiliado => const ConsultaProductoPagina(),
      RutasApp.catalogoMiTienda => const ConsultaProductoPagina(
          tipo: TipoCatalogoProducto.miTienda,
        ),
      RutasApp.catalogosPdf => const PaginaCatalogosPdf4Life(),
      RutasApp.calculadoraPrecios => const PaginaCalculadoraPrecios(),
      RutasApp.optimizadorConsumo => const PaginaOptimizadorConsumo(),
      RutasApp.optimizadorAcelerado => const PaginaOptimizadorAcelerado(),
      RutasApp.inventarioLocal => const PaginaInventarioLocal(),
      RutasApp.comparadorAB => const PaginaComparadorAB(),
      RutasApp.diagnostico => const FormularioPaciente(),
      RutasApp.cambioFisico => const FormularioCambioFisico(),
      RutasApp.historial => const PaginaHistorial(),
      RutasApp.chatLive => const PaginaChatbot(
          titulo: 'Chat Live 4Life',
          modoLlamada: true,
        ),
      RutasApp.asesorIa => const PaginaChatbot(),
      RutasApp.historialChatsIa => const PaginaHistorialChatbot(),
      RutasApp.testimonios => const PaginaTestimonios4Life(),
      RutasApp.diccionario => const PaginaDiccionario4Life(),
      RutasApp.mapaAnatomico => const PaginaMapaAnatomico(),
      RutasApp.impacto => const PaginaImpacto4LifeNueva(),
      RutasApp.perfil => const PaginaPerfil(),
      _ => null,
    };

Route<dynamic>? generarRutaApp(RouteSettings settings) {
  final pantalla = construirPantallaRuta(settings.name);
  if (pantalla == null) return null;
  return MaterialPageRoute<void>(
    settings: settings,
    builder: (_) => pantalla,
  );
}

class _AnalizadorRutasApp extends RouteInformationParser<String> {
  const _AnalizadorRutasApp();

  @override
  Future<String> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final fragmento = routeInformation.uri.fragment;
    final ruta = fragmento.startsWith('/')
        ? Uri.parse(fragmento).path
        : routeInformation.uri.path;
    return construirPantallaRuta(ruta) == null ? '/' : ruta;
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(uri: Uri(path: configuration));
  }
}

class _DelegadoRutasApp extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String _ruta = '/';
  Completer<void>? _rutaPendiente;

  @override
  String get currentConfiguration => _ruta;

  Future<void> abrir(String ruta) {
    if (construirPantallaRuta(ruta) == null || ruta == _ruta) {
      return Future<void>.value();
    }
    _completarRutaPendiente();
    _ruta = ruta;
    _rutaPendiente = Completer<void>();
    notifyListeners();
    return _rutaPendiente!.future;
  }

  void _completarRutaPendiente() {
    final pendiente = _rutaPendiente;
    if (pendiente != null && !pendiente.isCompleted) pendiente.complete();
    _rutaPendiente = null;
  }

  void _cambiarRuta(String ruta) {
    if (ruta == _ruta) return;
    _completarRutaPendiente();
    _ruta = ruta;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    final ruta =
        construirPantallaRuta(configuration) == null ? '/' : configuration;
    _cambiarRuta(ruta);
  }

  @override
  Future<bool> popRoute() async {
    if (_ruta == '/') return false;
    _cambiarRuta('/');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final pantalla = construirPantallaRuta(_ruta);
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage<void>(
          key: ValueKey('arranque-app'),
          name: '/',
          child: ArranqueDoctorSuplementos(),
        ),
        if (pantalla != null)
          MaterialPage<void>(
            key: ValueKey(_ruta),
            name: _ruta,
            child: pantalla,
          ),
      ],
      onDidRemovePage: (page) {
        if (page.name == _ruta) _cambiarRuta('/');
      },
    );
  }
}

final _delegadoRutasApp = _DelegadoRutasApp();

final configuracionRutasApp = RouterConfig<String>(
  routeInformationProvider: PlatformRouteInformationProvider(
    initialRouteInformation: RouteInformation(uri: Uri.base),
  ),
  routeInformationParser: const _AnalizadorRutasApp(),
  routerDelegate: _delegadoRutasApp,
  backButtonDispatcher: RootBackButtonDispatcher(),
);

Future<void> abrirRutaApp(BuildContext _, String ruta) {
  return _delegadoRutasApp.abrir(ruta);
}

// --- PANTALLA PRINCIPAL ---

class ArranqueDoctorSuplementos extends StatefulWidget {
  const ArranqueDoctorSuplementos({super.key});

  @override
  State<ArranqueDoctorSuplementos> createState() =>
      _ArranqueDoctorSuplementosState();
}

class _ArranqueDoctorSuplementosState extends State<ArranqueDoctorSuplementos> {
  late final Future<bool> _primeraInstalacionFuture;
  bool _mostrandoPerfilInicial = false;
  bool _perfilInicialPreparado = false;
  // Solo dura mientras vive este arranque; no se persiste entre sesiones.
  bool _seleccionConfirmada = false;

  @override
  void initState() {
    super.initState();
    _primeraInstalacionFuture =
        InstalacionInicialService.prepararSiEsPrimeraInstalacion();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _primeraInstalacionFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFFF7F7FB),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true && !_perfilInicialPreparado) {
          _mostrandoPerfilInicial = true;
          _perfilInicialPreparado = true;
        }

        if (_mostrandoPerfilInicial) {
          return PaginaPerfil(
            onPerfilGuardado: () {
              if (mounted) {
                setState(() => _mostrandoPerfilInicial = false);
              }
            },
          );
        }

        if (!_seleccionConfirmada) {
          return PaginaSeleccionPais(
            onContinuar: () {
              if (mounted) {
                setState(() => _seleccionConfirmada = true);
              }
            },
          );
        }

        return const PantallaPrincipal();
      },
    );
  }
}
