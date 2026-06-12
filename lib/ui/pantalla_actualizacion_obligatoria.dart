import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PantallaActualizacionObligatoria extends StatelessWidget {
  final String versionActual;
  final String versionMinima;
  final String urlDescarga;

  const PantallaActualizacionObligatoria({
    super.key,
    required this.versionActual,
    required this.versionMinima,
    required this.urlDescarga,
  });

  Future<void> _abrirDescarga(BuildContext context) async {
    final uri = Uri.tryParse(urlDescarga);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir el enlace de descarga.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF111B7D);
    const azulIntenso = Color(0xFF2839C7);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: azul,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF111B7D),
                  Color(0xFF1A237E),
                  Color(0xFF071044),
                ],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(28, 34, 28, 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5EE),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 28,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 48,
                        backgroundColor: azulIntenso,
                        child: Icon(
                          Icons.system_update_alt_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Actualizacion obligatoria',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: azul,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Tu version $versionActual ya no es compatible. '
                        'Instala la version $versionMinima o una posterior '
                        'para continuar usando DoctorSuplementos.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF4D5578),
                          fontSize: 17,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => _abrirDescarga(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: azulIntenso,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          icon: const Icon(Icons.open_in_browser_rounded),
                          label: const Text(
                            'Descargar nueva version',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'El enlace se abrira en tu navegador.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF747A9E),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
