import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../ui/pantalla_actualizacion_obligatoria.dart';

class ServicioVersion {
  static const String _versionPorDefecto = '0.0.0';
  static const String _urlPorDefecto =
      'https://doctorsuplementos-4bbb1.web.app';

  static Future<void> validarVersion(BuildContext context) async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setDefaults({
        'version_minima_android': _versionPorDefecto,
        'version_minima_ios': _versionPorDefecto,
        'version_minima_desktop': _versionPorDefecto,
        'url_descarga_android': _urlPorDefecto,
        'url_descarga_ios': _urlPorDefecto,
        'url_descarga_desktop': _urlPorDefecto,
      });
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 5),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await remoteConfig.fetchAndActivate();

      final packageInfo = await PackageInfo.fromPlatform();
      final versionActual = packageInfo.version;
      final sufijo = _sufijoPlataforma();
      final versionMinima =
          remoteConfig.getString('version_minima_$sufijo').trim();
      final urlDescarga = remoteConfig.getString('url_descarga_$sufijo').trim();

      if (!context.mounted ||
          !esVersionInferior(versionActual, versionMinima)) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PantallaBloqueoVersion(
            versionActual: versionActual,
            versionMinima: versionMinima,
            urlDescarga: urlDescarga.isEmpty ? _urlPorDefecto : urlDescarga,
          ),
        ),
      );
    } catch (error) {
      debugPrint('No se pudo validar la version de la app: $error');
    }
  }

  @visibleForTesting
  static bool esVersionInferior(String actual, String minima) {
    if (minima.trim().isEmpty) return false;

    final actualPartes = actual.split('.').map(int.parse).toList();
    final minimaPartes = minima.split('.').map(int.parse).toList();
    final cantidad = actualPartes.length > minimaPartes.length
        ? actualPartes.length
        : minimaPartes.length;

    for (var i = 0; i < cantidad; i++) {
      final actualParte = i < actualPartes.length ? actualPartes[i] : 0;
      final minimaParte = i < minimaPartes.length ? minimaPartes[i] : 0;
      if (actualParte < minimaParte) return true;
      if (actualParte > minimaParte) return false;
    }
    return false;
  }

  static String _sufijoPlataforma() {
    if (kIsWeb) return 'desktop';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      _ => 'desktop',
    };
  }
}
