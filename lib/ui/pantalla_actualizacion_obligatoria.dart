import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/actualizador_service.dart';

class PantallaBloqueoVersion extends StatefulWidget {
  const PantallaBloqueoVersion({
    super.key,
    required this.versionActual,
    required this.versionMinima,
    required this.urlDescarga,
  });

  final String versionActual;
  final String versionMinima;
  final String urlDescarga;

  @override
  State<PantallaBloqueoVersion> createState() => _PantallaBloqueoVersionState();
}

class _PantallaBloqueoVersionState extends State<PantallaBloqueoVersion> {
  final ActualizadorService _actualizador = ActualizadorService();

  double _progreso = 0;
  bool _descargando = false;
  bool _ingles = false;
  String? _error;

  bool get _urlConfigurada => widget.urlDescarga.trim().isNotEmpty;
  String _t(String es, String en) => _ingles ? en : es;

  @override
  void initState() {
    super.initState();
    _cargarIdioma();
  }

  Future<void> _cargarIdioma() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _ingles = prefs.getString('idioma_app_4life') == 'en');
  }

  Future<void> _descargar() async {
    if (_descargando || !_urlConfigurada) return;

    setState(() {
      _descargando = true;
      _progreso = 0;
      _error = null;
    });

    try {
      await _actualizador.descargarEInstalar(
        widget.urlDescarga.trim(),
        (progreso) {
          if (!mounted) return;
          setState(() => _progreso = progreso);
        },
      );
    } on ActualizacionException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _error = _t(
          'Ocurrió un error inesperado durante la actualización.',
          'An unexpected error occurred during the update.',
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _descargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF111B7D);
    const azulIntenso = Color(0xFF2839C7);
    const crema = Color(0xFFF5F5EE);
    final porcentaje = (_progreso * 100).round();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: azul,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(28, 34, 28, 30),
                    decoration: BoxDecoration(
                      color: crema,
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
                            color: crema,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _t('Actualización obligatoria', 'Required update'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: azul,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _t(
                            'Tu versión ${widget.versionActual} ya no es compatible. '
                                'Instala la versión ${widget.versionMinima} o una posterior '
                                'para continuar usando DoctorSuplementos.',
                            'Your version ${widget.versionActual} is no longer compatible. '
                                'Install version ${widget.versionMinima} or later '
                                'to continue using DoctorSuplementos.',
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF4D5578),
                            fontSize: 17,
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_descargando || _progreso > 0) ...[
                          const SizedBox(height: 28),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: _progreso,
                              minHeight: 12,
                              color: azulIntenso,
                              backgroundColor: const Color(0xFFE5E0C8),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _progreso >= 1
                                ? _t('Abriendo instalador...',
                                    'Opening installer...')
                                : _t('Descargando $porcentaje%',
                                    'Downloading $porcentaje%'),
                            style: const TextStyle(
                              color: azul,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                        if (_error != null) ...[
                          const SizedBox(height: 20),
                          _MensajeEstado(
                            icono: Icons.error_outline_rounded,
                            texto: _error!,
                            color: const Color(0xFFB3261E),
                          ),
                        ],
                        if (!_urlConfigurada) ...[
                          const SizedBox(height: 20),
                          _MensajeEstado(
                            icono: Icons.link_off_rounded,
                            texto: _t(
                              'No se configuró una URL directa para el APK.',
                              'A direct APK URL has not been configured.',
                            ),
                            color: const Color(0xFF9A5A00),
                          ),
                        ],
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _descargando || !_urlConfigurada
                                ? null
                                : _descargar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: azulIntenso,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  azulIntenso.withValues(alpha: 0.45),
                              disabledForegroundColor:
                                  Colors.white.withValues(alpha: 0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: Icon(
                              _descargando
                                  ? Icons.downloading_rounded
                                  : Icons.download_rounded,
                            ),
                            label: Text(
                              _descargando
                                  ? _t('Descargando actualización...',
                                      'Downloading update...')
                                  : _error == null
                                      ? _t('Descargar nueva versión',
                                          'Download new version')
                                      : _t('Intentar nuevamente', 'Try again'),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _t(
                            'Al terminar, Android abrirá el instalador.',
                            'When it finishes, Android will open the installer.',
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
      ),
    );
  }
}

class _MensajeEstado extends StatelessWidget {
  const _MensajeEstado({
    required this.icono,
    required this.texto,
    required this.color,
  });

  final IconData icono;
  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Icon(icono, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(
                color: color,
                fontSize: 13,
                height: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
