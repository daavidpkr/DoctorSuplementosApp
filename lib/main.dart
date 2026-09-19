import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';
import 'services/servicio_texto_voz.dart';
import 'services/servicio_version.dart';
import 'services/servicio_compartir.dart';
import 'ui/pantalla_resultado_ficha.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
        return MaterialApp(
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
          ),
          home: const ArranqueDoctorSuplementos(),
        );
      },
    );
  }
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
