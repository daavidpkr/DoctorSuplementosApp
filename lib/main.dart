import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/servicio_texto_voz.dart';
import 'services/servicio_version.dart';
import 'services/servicio_compartir.dart';
import 'ui/pantalla_resultado_ficha.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

part 'core/catalogo_productos.dart';
part 'core/servicios_app.dart';
part 'core/servicios_historial.dart';
part 'features/inicio.dart';
part 'features/inicio_legacy.dart';
part 'features/perfil.dart';
part 'features/impacto.dart';
part 'features/diagnostico.dart';
part 'features/cambio_fisico.dart';
part 'features/consulta_productos.dart';
part 'features/calculadora_precios.dart';
part 'features/diccionario.dart';
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
  await inicializarVariablesEntorno();
  await inicializarFirebaseSeguro();
  await IdiomaService.inicializar();
  await PaisService.inicializar();
  runApp(const DoctorSuplementos());
}

Future<void> inicializarVariablesEntorno() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('No se pudo cargar .env: $e');
  }
}

String get geminiApiKey {
  final apiKey = dotenv.env['API_KEY']?.trim() ?? '';
  if (apiKey.isEmpty) {
    throw StateError('Falta configurar API_KEY en el archivo .env.');
  }
  return apiKey;
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
    return ValueListenableBuilder<IdiomaApp>(
      valueListenable: IdiomaService.actual,
      builder: (context, idioma, _) {
        return MaterialApp(
          key: ValueKey('app-${idioma.codigo}'),
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
            scaffoldBackgroundColor: const Color(0xFFF5F5EE),
            primaryColor: const Color(0xFF1A237E),
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

        return const PantallaPrincipal();
      },
    );
  }
}
