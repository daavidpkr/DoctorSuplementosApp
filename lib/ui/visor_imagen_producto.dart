import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagenProductoAmpliable extends StatefulWidget {
  final String? imagenAsset;
  final String nombreProducto;
  final bool ingles;

  const ImagenProductoAmpliable({
    super.key,
    required this.imagenAsset,
    required this.nombreProducto,
    required this.ingles,
  });

  @override
  State<ImagenProductoAmpliable> createState() =>
      _ImagenProductoAmpliableState();
}

class _ImagenProductoAmpliableState extends State<ImagenProductoAmpliable> {
  bool _falloCarga = false;

  bool get _puedeAmpliarse => widget.imagenAsset != null && !_falloCarga;

  @override
  void didUpdateWidget(covariant ImagenProductoAmpliable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagenAsset != widget.imagenAsset) {
      _falloCarga = false;
    }
  }

  void _registrarErrorDeCarga() {
    if (_falloCarga) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _falloCarga = true);
    });
  }

  Future<void> _abrirVisor() async {
    final asset = widget.imagenAsset;
    if (asset == null || _falloCarga) return;
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.94),
      transitionDuration: const Duration(milliseconds: 180),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      pageBuilder: (context, animation, secondaryAnimation) =>
          VisorImagenProducto(
        imagenAsset: asset,
        nombreProducto: widget.nombreProducto,
        ingles: widget.ingles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final etiqueta = widget.ingles
        ? 'Enlarge image of ${widget.nombreProducto}'
        : 'Ampliar imagen de ${widget.nombreProducto}';
    final contenido = Stack(
      fit: StackFit.expand,
      children: [
        if (widget.imagenAsset == null || _falloCarga)
          const Icon(
            Icons.inventory_2_outlined,
            color: Color(0xFF12248B),
            size: 54,
          )
        else
          Image.asset(
            widget.imagenAsset!,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) {
              _registrarErrorDeCarga();
              return const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF12248B),
                size: 54,
              );
            },
          ),
        if (_puedeAmpliarse)
          Positioned(
            right: 5,
            bottom: 5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF12248B).withValues(alpha: 0.88),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 5),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.zoom_in_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
            ),
          ),
      ],
    );

    return Container(
      key: const ValueKey('imagen-producto-ampliable'),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E4F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: _puedeAmpliarse
          ? Semantics(
              button: true,
              label: etiqueta,
              child: Tooltip(
                message: etiqueta,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _abrirVisor,
                    borderRadius: BorderRadius.circular(12),
                    child: contenido,
                  ),
                ),
              ),
            )
          : contenido,
    );
  }
}

class VisorImagenProducto extends StatefulWidget {
  final String imagenAsset;
  final String nombreProducto;
  final bool ingles;

  const VisorImagenProducto({
    super.key,
    required this.imagenAsset,
    required this.nombreProducto,
    required this.ingles,
  });

  @override
  State<VisorImagenProducto> createState() => _VisorImagenProductoState();
}

class _VisorImagenProductoState extends State<VisorImagenProducto> {
  static const double _escalaMinima = 1;
  static const double _escalaMaxima = 5;
  static const double _escalaDobleToque = 2.5;

  final TransformationController _transformacion = TransformationController();
  double _escala = _escalaMinima;
  Offset _ultimoDobleToque = Offset.zero;

  @override
  void dispose() {
    _transformacion.dispose();
    super.dispose();
  }

  void _cerrar() => Navigator.of(context).pop();

  void _actualizarEscala() {
    final nueva = _transformacion.value
        .getMaxScaleOnAxis()
        .clamp(_escalaMinima, _escalaMaxima)
        .toDouble();
    if ((nueva - _escala).abs() > 0.001) {
      setState(() => _escala = nueva);
    }
  }

  void _establecerEscala(double escala, Offset puntoLocal) {
    final siguiente = escala.clamp(_escalaMinima, _escalaMaxima).toDouble();
    if (siguiente == _escalaMinima) {
      _transformacion.value = Matrix4.identity();
    } else {
      final puntoEscena = _transformacion.toScene(puntoLocal);
      _transformacion.value = Matrix4.identity()
        ..translateByDouble(puntoLocal.dx, puntoLocal.dy, 0, 1)
        ..scaleByDouble(siguiente, siguiente, siguiente, 1)
        ..translateByDouble(-puntoEscena.dx, -puntoEscena.dy, 0, 1);
    }
    setState(() => _escala = siguiente);
  }

  void _manejarRueda(PointerSignalEvent evento) {
    if (evento is! PointerScrollEvent) return;
    final factor = evento.scrollDelta.dy < 0 ? 1.18 : 1 / 1.18;
    _establecerEscala(_escala * factor, evento.localPosition);
  }

  void _alternarDobleToque() {
    _establecerEscala(
      _escala > _escalaMinima + 0.01 ? _escalaMinima : _escalaDobleToque,
      _ultimoDobleToque,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cerrar =
        widget.ingles ? 'Close image viewer' : 'Cerrar visor de imagen';
    final instrucciones = widget.ingles
        ? 'Image viewer for ${widget.nombreProducto}. Pinch, use the mouse wheel, or double tap to zoom.'
        : 'Visor de ${widget.nombreProducto}. Pellizca, usa la rueda del mouse o toca dos veces para ampliar.';

    return Material(
      key: const ValueKey('visor-imagen-producto'),
      color: Colors.transparent,
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.escape): _cerrar,
        },
        child: Focus(
          autofocus: true,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Semantics(
                    button: true,
                    label: cerrar,
                    child: GestureDetector(
                      key: const ValueKey('fondo-visor-imagen'),
                      behavior: HitTestBehavior.opaque,
                      onTap: _cerrar,
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  top: 64,
                  bottom: 20,
                  child: Semantics(
                    image: true,
                    label: instrucciones,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      onDoubleTapDown: (detalle) {
                        _ultimoDobleToque = detalle.localPosition;
                      },
                      onDoubleTap: _alternarDobleToque,
                      child: Listener(
                        onPointerSignal: _manejarRueda,
                        child: InteractiveViewer(
                          transformationController: _transformacion,
                          minScale: _escalaMinima,
                          maxScale: _escalaMaxima,
                          panEnabled: _escala > _escalaMinima + 0.01,
                          scaleEnabled: true,
                          onInteractionUpdate: (_) => _actualizarEscala(),
                          onInteractionEnd: (_) => _actualizarEscala(),
                          child: SizedBox.expand(
                            child: Image.asset(
                              widget.imagenAsset,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton.filled(
                    key: const ValueKey('cerrar-visor-imagen'),
                    tooltip: cerrar,
                    onPressed: _cerrar,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF111111),
                    ),
                    icon: const Icon(Icons.close_rounded),
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
