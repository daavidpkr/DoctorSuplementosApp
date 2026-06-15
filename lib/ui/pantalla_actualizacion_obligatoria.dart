import 'package:flutter/material.dart';

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
  String? _error;

  bool get _urlConfigurada => widget.urlDescarga.trim().isNotEmpty;

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
        () => _error = 'Ocurrio un error inesperado durante la actualizacion.',
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
                          'Tu version ${widget.versionActual} ya no es compatible. '
                          'Instala la version ${widget.versionMinima} o una posterior '
                          'para continuar usando DoctorSuplementos.',
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
                                ? 'Abriendo instalador...'
                                : 'Descargando $porcentaje%',
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
                          const _MensajeEstado(
                            icono: Icons.link_off_rounded,
                            texto:
                                'No se configuro una URL directa para el APK.',
                            color: Color(0xFF9A5A00),
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
                                  ? 'Descargando actualización...'
                                  : _error == null
                                      ? 'Descargar nueva versión'
                                      : 'Intentar nuevamente',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Al terminar, Android abrira el instalador.',
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
