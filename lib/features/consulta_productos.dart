part of '../main.dart';

enum TipoCatalogoProducto { afiliado, miTienda }

class ConsultaProductoPagina extends StatefulWidget {
  final TipoCatalogoProducto tipo;

  const ConsultaProductoPagina({
    super.key,
    this.tipo = TipoCatalogoProducto.afiliado,
  });

  @override
  State<ConsultaProductoPagina> createState() => _ConsultaProductoPaginaState();
}

class _ConsultaProductoPaginaState extends State<ConsultaProductoPagina> {
  bool get _esMiTienda => widget.tipo == TipoCatalogoProducto.miTienda;

  String get _tituloCatalogo => _esMiTienda
      ? txtApp('Catalogo MiTienda', 'MyStore Catalog')
      : txtApp('Catalogo Afiliado', 'Member Catalog');

  List<ProductoPrecio> get _productosCatalogo {
    final productos = _esMiTienda
        ? [...productosMiTienda4Life]
        : [...productosConPrecio4Life];
    productos.sort(
      (a, b) => normalizarTexto(a.nombre).compareTo(normalizarTexto(b.nombre)),
    );
    return productos;
  }

  Future<void> _abrirProducto(ProductoPrecio producto) async {
    final idioma = await IdiomaService.cargar();
    final resultado = _informacionPredeterminadaProducto(producto, idioma);
    final precioPromocional = precioPromocionalMiTienda(producto.nombre);
    await ImpactoService.registrar(
      tipo: _esMiTienda ? 'catalogo_mitienda' : 'catalogo_afiliado',
      titulo: producto.nombre,
      datos: {
        'producto': producto.nombre,
        'afiliado': producto.afiliado,
        'publico': producto.publico,
        'lp': producto.lp,
        if (precioPromocional != null) 'promocional': precioPromocional,
      },
    );
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (c) => _dialogoResultado(
        dialogContext: c,
        titulo: producto.nombre,
        resultado: resultado,
        imagenProducto: imagenesProducto4Life[producto.nombre],
        productoIdentificado: producto.nombre,
        precioProducto: producto,
        precioPromocional: precioPromocional,
      ),
    );
  }

  String _informacionPredeterminadaProducto(
    ProductoPrecio producto,
    IdiomaApp idioma,
  ) {
    final esIngles = idioma == IdiomaApp.ingles;
    final info = informacionProductoCatalogo(producto.nombre);
    if (esIngles) {
      return '''
Description:
${info.descripcion}

Main ingredients or components:
${info.componentes}

Directions for use:
${info.uso}

Contraindications or precautions:
${info.precauciones}

Suggested dosage:
${info.dosis}

Note:
This product is not medicine, does not diagnose, treat, cure, or prevent diseases. It is a wellness supplement and does not replace guidance from a healthcare professional.
''';
    }

    return '''
Descripcion:
${info.descripcion}

Ingredientes o componentes principales:
${info.componentes}

Indicaciones de uso:
${info.uso}

Contraindicaciones o precauciones:
${info.precauciones}

Dosis sugerida:
${info.dosis}

Nota:
Este producto no es medicina, no diagnostica, no trata, no cura ni previene enfermedades. Es un suplemento de bienestar y no reemplaza la indicacion de un profesional de salud.
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _encabezadoConsulta(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final ancho = constraints.maxWidth;
                  final columnas = ancho >= 760
                      ? 3
                      : ancho >= 520
                          ? 3
                          : 2;
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnas,
                      mainAxisSpacing: 26,
                      crossAxisSpacing: 26,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: _productosCatalogo.length,
                    itemBuilder: (context, index) {
                      return _tarjetaProductoCatalogo(
                        _productosCatalogo[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _encabezadoConsulta() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 18, 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _tituloCatalogo,
              style: const TextStyle(
                color: Color(0xFF12248B),
                fontSize: 34,
                height: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            tooltip: txtApp("Cerrar", "Close"),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            color: const Color(0xFF3F3B46),
            iconSize: 38,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaProductoCatalogo(ProductoPrecio producto) {
    final imagen = imagenesProducto4Life[producto.nombre];
    final ingles = IdiomaService.actual.value == IdiomaApp.ingles;
    final precioPromocional = precioPromocionalMiTienda(producto.nombre);
    final textoPrecio = _esMiTienda
        ? '${ingles ? 'Promo' : 'Promocional'} \$${(precioPromocional ?? producto.afiliado).toStringAsFixed(2)} | LP ${producto.lp ?? 0}'
        : precioPromocional == null
            ? '${ingles ? 'Member' : 'Afiliado'} \$${producto.afiliado.toStringAsFixed(2)} | LP ${producto.lp ?? 0}'
            : '${ingles ? 'Member' : 'Afiliado'} \$${producto.afiliado.toStringAsFixed(2)} | Promo \$${precioPromocional.toStringAsFixed(2)}';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () => _abrirProducto(producto),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFE),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: const Color(0xFFE0E3EF), width: 1.6),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF12248B).withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FC),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: imagen == null
                      ? const Icon(
                          Icons.inventory_2_outlined,
                          color: Color(0xFF12248B),
                          size: 46,
                        )
                      : Image.asset(
                          imagen,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.inventory_2_outlined,
                            color: Color(0xFF12248B),
                            size: 46,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                producto.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF18215E),
                  fontSize: 13,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  textoPrecio,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
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
    required double? precioPromocional,
  }) {
    final ingles = IdiomaService.actual.value == IdiomaApp.ingles;
    final secciones = _seccionesResultadoProducto(resultado);
    final guionCapsula = _textoCapsulaAudioProducto(
      titulo: productoIdentificado ?? titulo,
      resultado: resultado,
      secciones: secciones,
      ingles: ingles,
    );
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
                    tooltip: ingles ? "Close" : "Cerrar",
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
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compacta = constraints.maxWidth < 430;
                          final imagen = imagenProducto == null
                              ? const SizedBox.shrink()
                              : Container(
                                  height: 220,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FF),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFE1E4F0),
                                    ),
                                  ),
                                  child: Image.asset(
                                    imagenProducto,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.inventory_2_outlined,
                                      color: Color(0xFF12248B),
                                      size: 54,
                                    ),
                                  ),
                                );
                          if (compacta) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (imagenProducto != null) imagen,
                                if (imagenProducto != null &&
                                    precioProducto != null)
                                  const SizedBox(height: 12),
                                if (precioProducto != null)
                                  _precioResumenProducto(
                                    precioProducto,
                                    precioPromocional: precioPromocional,
                                  ),
                              ],
                            );
                          }
                          return SizedBox(
                            height: 230,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (imagenProducto != null)
                                  Expanded(child: imagen),
                                if (imagenProducto != null &&
                                    precioProducto != null)
                                  const SizedBox(width: 12),
                                if (precioProducto != null)
                                  Expanded(
                                    child: _precioResumenProducto(
                                      precioProducto,
                                      precioPromocional: precioPromocional,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _capsulaAudioProducto(
                        guion: guionCapsula,
                        ingles: ingles,
                      ),
                      const SizedBox(height: 4),
                      for (final seccion in secciones)
                        _seccionResultadoProducto(seccion.key, seccion.value),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    tooltip: ingles ? "Listen to answer" : "Escuchar respuesta",
                    icon: const Icon(Icons.volume_up_rounded),
                    color: const Color(0xFF12248B),
                    onPressed: () => ServicioTextoVoz.reproducir(resultado),
                  ),
                  IconButton(
                    tooltip: ingles ? "Stop audio" : "Detener audio",
                    icon: const Icon(Icons.stop_circle_outlined),
                    color: const Color(0xFF12248B),
                    onPressed: ServicioTextoVoz.detener,
                  ),
                  IconButton(
                    tooltip: ingles ? "Copy" : "Copiar",
                    icon: const Icon(Icons.copy_rounded),
                    color: const Color(0xFF12248B),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: resultado));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ingles ? "Copied" : "Copiado al portapapeles",
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: ingles ? "Share" : "Compartir",
                    icon: const Icon(Icons.share_rounded),
                    color: const Color(0xFF12248B),
                    onPressed: () => _compartirConsultaProducto(
                      titulo: titulo,
                      resultado: resultado,
                      imagenProducto: imagenProducto,
                      productoIdentificado: productoIdentificado,
                      precioProducto: precioProducto,
                      precioPromocional: precioPromocional,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(ingles ? "Close" : "Cerrar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _capsulaAudioProducto({
    required String guion,
    required bool ingles,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE3FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF12248B),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.podcasts_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingles ? 'Quick audio capsule' : 'Capsula de audio',
                  style: const TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  ingles
                      ? 'Cellular education and product function in a short podcast-style track.'
                      : 'Educacion celular y funcionamiento del producto en formato agil tipo podcast.',
                  style: const TextStyle(
                    color: Color(0xFF27315F),
                    fontSize: 13.5,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF12248B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 22),
                      label: Text(
                        ingles ? 'Play capsule' : 'Reproducir capsula',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      onPressed: () => ServicioTextoVoz.reproducir(guion),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF12248B),
                        side: const BorderSide(color: Color(0xFFBFC8FF)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.stop_circle_outlined, size: 22),
                      label: Text(
                        ingles ? 'Stop' : 'Detener',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      onPressed: ServicioTextoVoz.detener,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _precioResumenProducto(
    ProductoPrecio producto, {
    required double? precioPromocional,
  }) {
    final ingles = IdiomaService.actual.value == IdiomaApp.ingles;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E4F0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _datoPrecio(
            ingles ? "Member" : "Afiliado",
            '\$${producto.afiliado.toStringAsFixed(2)}',
            Icons.person_outline_rounded,
          ),
          const Divider(height: 1),
          _datoPrecio(
            ingles ? "Retail" : "Publico",
            '\$${producto.publico.toStringAsFixed(2)}',
            Icons.groups_2_outlined,
          ),
          const Divider(height: 1),
          _datoPrecio(
            "LP",
            producto.lp?.toString() ?? (ingles ? 'No data' : 'Sin dato'),
            Icons.star_outline_rounded,
          ),
          if (precioPromocional != null) ...[
            const Divider(height: 1),
            _datoPrecio(
              ingles ? "Promo" : "Promocional",
              '\$${precioPromocional.toStringAsFixed(2)}',
              Icons.local_offer_outlined,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _compartirConsultaProducto({
    required String titulo,
    required String resultado,
    required String? imagenProducto,
    required String? productoIdentificado,
    required ProductoPrecio? precioProducto,
    required double? precioPromocional,
  }) async {
    final idioma = await IdiomaService.cargar();
    final notaNoMedicina = idioma == IdiomaApp.ingles
        ? 'This product is not medicine, does not diagnose, treat, cure, or prevent diseases. It is a wellness supplement and does not replace guidance from a healthcare professional.'
        : 'Este producto no es medicina, no diagnostica, no trata, no cura ni previene enfermedades. Es un suplemento de bienestar y no reemplaza la indicacion de un profesional de salud.';
    final secciones = _seccionesResultadoProducto(resultado);
    final dosis = secciones
        .where(
          (seccion) =>
              normalizarTexto(seccion.key).contains('dosis sugerida') ||
              normalizarTexto(seccion.key).contains('suggested dosage') ||
              normalizarTexto(seccion.key).contains('indicaciones de uso') ||
              normalizarTexto(seccion.key).contains('directions for use'),
        )
        .map((seccion) => seccion.value)
        .where((texto) => texto.trim().isNotEmpty)
        .toList();
    final detalle = secciones
        .where(
          (seccion) =>
              normalizarTexto(seccion.key).contains('descripcion') ||
              normalizarTexto(seccion.key).contains('description'),
        )
        .map((seccion) => seccion.value)
        .join('\n');
    final nombre = productoIdentificado ?? titulo;
    final indicacionesConPrecios = [
      ...dosis,
      if (precioProducto != null) ...[
        '${idioma == IdiomaApp.ingles ? 'Member price' : 'Precio afiliado'}: \$${precioProducto.afiliado.toStringAsFixed(2)}',
        '${idioma == IdiomaApp.ingles ? 'Retail price' : 'Precio publico'}: \$${precioProducto.publico.toStringAsFixed(2)}',
        'LP: ${precioProducto.lp ?? 0}',
      ],
      if (precioPromocional != null)
        '${idioma == IdiomaApp.ingles ? 'Promotional price' : 'Precio promocional'}: \$${precioPromocional.toStringAsFixed(2)}',
    ];
    final textoConPrecios = precioProducto == null
        ? resultado
        : '$resultado\n\n${idioma == IdiomaApp.ingles ? 'Prices' : 'Precios'}:\n'
            '${idioma == IdiomaApp.ingles ? 'Member' : 'Afiliado'}: \$${precioProducto.afiliado.toStringAsFixed(2)}\n'
            '${idioma == IdiomaApp.ingles ? 'Retail' : 'Publico'}: \$${precioProducto.publico.toStringAsFixed(2)}\n'
            'LP: ${precioProducto.lp ?? 0}'
            '${precioPromocional == null ? '' : '\n${idioma == IdiomaApp.ingles ? 'Promotional' : 'Promocional'}: \$${precioPromocional.toStringAsFixed(2)}'}';
    if (!mounted) return;

    return ServicioCompartir.mostrarOpciones(
      context,
      DocumentoCompartible(
        titulo: idioma == IdiomaApp.ingles
            ? 'PRODUCT REPORT ${nombre.toUpperCase()}'
            : 'INFORME DEL PRODUCTO ${nombre.toUpperCase()}',
        nombreArchivo:
            idioma == IdiomaApp.ingles ? 'REPORT $nombre' : 'INFORME $nombre',
        texto: textoConPrecios,
        fecha: DateTime.now(),
        secciones: secciones
            .where(
              (seccion) =>
                  !normalizarTexto(seccion.key)
                      .contains('producto identificado') &&
                  !normalizarTexto(seccion.key)
                      .contains('product identified') &&
                  !normalizarTexto(seccion.key).contains('dosis sugerida') &&
                  !normalizarTexto(seccion.key).contains('suggested dosage') &&
                  !normalizarTexto(seccion.key)
                      .contains('indicaciones de uso') &&
                  !normalizarTexto(seccion.key).contains('directions for use'),
            )
            .map(
              (seccion) => SeccionDocumento(
                titulo: seccion.key,
                contenido: seccion.value,
              ),
            )
            .toList(),
        productos: [
          ProductoDocumento(
            nombre: nombre,
            imagenAsset: imagenProducto,
            indicaciones: indicacionesConPrecios,
            detalle: detalle,
          ),
        ],
        nota: notaNoMedicina,
        adjuntarImagenEnTexto: true,
      ),
      documentoInformativo: DocumentoCompartible(
        titulo: idioma == IdiomaApp.ingles
            ? 'PRODUCT REPORT ${nombre.toUpperCase()}'
            : 'INFORME DEL PRODUCTO ${nombre.toUpperCase()}',
        nombreArchivo:
            idioma == IdiomaApp.ingles ? 'REPORT $nombre' : 'INFORME $nombre',
        texto: resultado,
        fecha: DateTime.now(),
        secciones: secciones
            .where(
              (seccion) =>
                  !normalizarTexto(seccion.key)
                      .contains('producto identificado') &&
                  !normalizarTexto(seccion.key)
                      .contains('product identified') &&
                  !normalizarTexto(seccion.key).contains('dosis sugerida') &&
                  !normalizarTexto(seccion.key).contains('suggested dosage') &&
                  !normalizarTexto(seccion.key)
                      .contains('indicaciones de uso') &&
                  !normalizarTexto(seccion.key).contains('directions for use'),
            )
            .map(
              (seccion) => SeccionDocumento(
                titulo: seccion.key,
                contenido: seccion.value,
              ),
            )
            .toList(),
        productos: [
          ProductoDocumento(
            nombre: nombre,
            imagenAsset: imagenProducto,
            detalle: detalle,
          ),
        ],
        nota: notaNoMedicina,
        adjuntarImagenEnTexto: true,
      ),
      ingles: idioma == IdiomaApp.ingles,
    );
  }

  Widget _datoPrecio(String etiqueta, String valor, IconData icono) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icono, color: const Color(0xFF3539C7)),
          ),
          const SizedBox(width: 10),
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
            valor,
            style: const TextStyle(
              color: Color(0xFF1227A7),
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  List<MapEntry<String, String>> _seccionesResultadoProducto(String resultado) {
    const titulos = [
      'Producto identificado',
      'Product identified',
      'Descripcion',
      'Description',
      'Ingredientes o componentes principales',
      'Main ingredients or components',
      'Indicaciones de uso',
      'Directions for use',
      'Contraindicaciones o precauciones',
      'Contraindications or precautions',
      'Dosis sugerida',
      'Suggested dosage',
      'Nota',
      'Note',
    ];
    final secciones = <String, List<String>>{};
    String? actual;
    for (final lineaOriginal in resultado.replaceAll('\r', '').split('\n')) {
      final linea = lineaOriginal
          .replaceAll(RegExp(r'[*#_`]'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (linea.isEmpty) continue;
      final titulo = titulos.cast<String?>().firstWhere(
            (item) =>
                item != null &&
                normalizarTexto(linea).startsWith(normalizarTexto(item)),
            orElse: () => null,
          );
      if (titulo != null) {
        actual = titulo;
        secciones.putIfAbsent(titulo, () => []);
        final contenido = linea.replaceFirst(RegExp(r'^[^:]+:\s*'), '');
        if (contenido != linea && contenido.isNotEmpty) {
          secciones[titulo]!.add(contenido);
        }
      } else {
        actual ??= 'Información del producto';
        secciones.putIfAbsent(actual, () => []).add(linea);
      }
    }
    return secciones.entries
        .map((entry) => MapEntry(entry.key, entry.value.join('\n')))
        .where((entry) => entry.value.trim().isNotEmpty)
        .toList();
  }

  String _textoCapsulaAudioProducto({
    required String titulo,
    required String resultado,
    required List<MapEntry<String, String>> secciones,
    required bool ingles,
  }) {
    String seccion(List<String> claves) {
      for (final entry in secciones) {
        final tituloNormalizado = normalizarTexto(entry.key);
        for (final clave in claves) {
          if (tituloNormalizado.contains(normalizarTexto(clave))) {
            return entry.value.trim();
          }
        }
      }
      return '';
    }

    final descripcion = seccion(['Descripcion', 'Description']);
    final componentes = seccion([
      'Ingredientes o componentes principales',
      'Main ingredients or components',
    ]);
    final uso = seccion(['Indicaciones de uso', 'Directions for use']);
    final dosis = seccion(['Dosis sugerida', 'Suggested dosage']);
    final precauciones = seccion([
      'Contraindicaciones o precauciones',
      'Contraindications or precautions',
    ]);
    final nota = seccion(['Nota', 'Note']);
    final base = descripcion.isEmpty && componentes.isEmpty
        ? resultado
        : [
            if (descripcion.isNotEmpty) descripcion,
            if (componentes.isNotEmpty) componentes,
            if (uso.isNotEmpty) uso,
            if (dosis.isNotEmpty) dosis,
            if (precauciones.isNotEmpty) precauciones,
            if (nota.isNotEmpty) nota,
          ].join('\n');

    if (ingles) {
      return '''
Audio capsule about $titulo.
In this quick cellular education track, review the product while you read its information.
$base
Remember: this is wellness education, not medical advice. This product is not medicine and does not replace guidance from a healthcare professional.
'''
          .trim();
    }

    return '''
Capsula de audio sobre $titulo.
En esta pista breve de educacion celular, revisa el producto mientras lees su informacion.
$base
Recuerda: esto es educacion de bienestar, no consejo medico. Este producto no es medicina y no reemplaza la indicacion de un profesional de salud.
'''
        .trim();
  }

  Widget _seccionResultadoProducto(String titulo, String contenido) {
    final iconos = <String, IconData>{
      'Producto identificado': Icons.description_outlined,
      'Product identified': Icons.description_outlined,
      'Descripcion': Icons.assignment_outlined,
      'Description': Icons.assignment_outlined,
      'Ingredientes o componentes principales': Icons.science_outlined,
      'Main ingredients or components': Icons.science_outlined,
      'Indicaciones de uso': Icons.calendar_month_outlined,
      'Directions for use': Icons.calendar_month_outlined,
      'Contraindicaciones o precauciones': Icons.health_and_safety_outlined,
      'Contraindications or precautions': Icons.health_and_safety_outlined,
      'Dosis sugerida': Icons.medication_outlined,
      'Suggested dosage': Icons.medication_outlined,
      'Nota': Icons.info_outline_rounded,
      'Note': Icons.info_outline_rounded,
    };
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7F0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EFFF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              iconos[titulo] ?? Icons.auto_awesome_outlined,
              color: const Color(0xFF2639BD),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  contenido,
                  style: const TextStyle(
                    color: Color(0xFF27315F),
                    fontSize: 14.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
