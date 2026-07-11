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
  final TextEditingController _busquedaController = TextEditingController();
  bool _modoMultiple = false;
  String _busqueda = '';
  final Set<String> _seleccionMultiple = {};

  bool get _esMiTienda => widget.tipo == TipoCatalogoProducto.miTienda;

  String get _tituloCatalogo => _esMiTienda
      ? txtApp('Galería de productos MiTienda', 'MyStore Product Gallery')
      : txtApp('Galería de productos Afiliado', 'Member Product Gallery');

  List<ProductoPrecio> get _productosCatalogo {
    final productos = _esMiTienda
        ? [...productosMiTienda4Life]
        : [...productosConPrecio4Life];
    productos.sort(
      (a, b) => normalizarTexto(a.nombre).compareTo(normalizarTexto(b.nombre)),
    );
    return productos;
  }

  List<ProductoPrecio> get _productosSeleccionados => _productosCatalogo
      .where((producto) => _seleccionMultiple.contains(producto.nombre))
      .toList();

  List<ProductoPrecio> get _productosFiltradosCatalogo =>
      _filtrarProductosInteligente(_productosCatalogo, _busqueda);

  List<ProductoPrecio> _filtrarProductosInteligente(
    List<ProductoPrecio> productos,
    String consulta,
  ) {
    final textoConsulta = normalizarTexto(consulta);
    if (textoConsulta.isEmpty) return productos;
    final palabras = textoConsulta
        .split(RegExp(r'\s+'))
        .where((palabra) => palabra.length > 1)
        .toList();
    final puntuados = <MapEntry<ProductoPrecio, int>>[];
    for (final producto in productos) {
      final info = informacionProductoCatalogo(producto.nombre);
      final texto = normalizarTexto(
        '${producto.nombre} ${info.descripcion} ${info.componentes} '
        '${info.uso} ${info.precauciones}',
      );
      var puntaje = texto.contains(textoConsulta) ? 10 : 0;
      for (final palabra in palabras) {
        if (texto.contains(palabra)) puntaje += 3;
        if (normalizarTexto(producto.nombre).startsWith(palabra)) puntaje += 4;
      }
      if (puntaje > 0) puntuados.add(MapEntry(producto, puntaje));
    }
    puntuados.sort((a, b) {
      final puntaje = b.value.compareTo(a.value);
      if (puntaje != 0) return puntaje;
      return normalizarTexto(a.key.nombre).compareTo(
        normalizarTexto(b.key.nombre),
      );
    });
    return puntuados.map((entry) => entry.key).toList();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  void _alternarSeleccionMultiple(ProductoPrecio producto) {
    setState(() {
      if (_seleccionMultiple.contains(producto.nombre)) {
        _seleccionMultiple.remove(producto.nombre);
      } else {
        _seleccionMultiple.add(producto.nombre);
      }
    });
  }

  void _cambiarModoMultiple(bool activo) {
    setState(() {
      _modoMultiple = activo;
      if (!activo) _seleccionMultiple.clear();
    });
  }

  Future<void> _abrirProducto(ProductoPrecio producto) async {
    final idioma = IdiomaService.actual.value;
    final resultado = _informacionPredeterminadaProducto(producto, idioma);
    final precioPromocional = precioPromocionalMiTienda(producto.nombre);
    if (!mounted) return;
    unawaited(ImpactoService.registrar(
      tipo: _esMiTienda ? 'catalogo_mitienda' : 'catalogo_afiliado',
      titulo: producto.nombre,
      datos: {
        'producto': producto.nombre,
        'afiliado': producto.afiliado,
        'publico': producto.publico,
        'lp': producto.lp,
        if (precioPromocional != null) 'promocional': precioPromocional,
      },
    ));
    await showDialog(
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
Descripción:
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
Este producto no es medicina, no diagnostica, no trata, no cura ni previene enfermedades. Es un suplemento de bienestar y no reemplaza la indicación de un profesional de salud.
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
            _selectorModoConsulta(),
            _barraBusquedaCatalogo(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final ancho = constraints.maxWidth;
                  final productos = _productosFiltradosCatalogo;
                  return GridView.builder(
                    padding: EdgeInsets.fromLTRB(
                      ancho < 420 ? 12 : 24,
                      10,
                      ancho < 420 ? 12 : 24,
                      28,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: ancho < 420 ? 12 : 20,
                      crossAxisSpacing: ancho < 420 ? 10 : 18,
                      childAspectRatio: ancho < 420 ? 0.70 : 0.92,
                    ),
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      return _tarjetaProductoCatalogo(
                        productos[index],
                      );
                    },
                  );
                },
              ),
            ),
            if (_modoMultiple) _barraSeleccionMultiple(),
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

  Widget _selectorModoConsulta() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
      child: Container(
        height: 46,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDDE3FF)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _opcionModoConsulta(
                activo: !_modoMultiple,
                icono: Icons.touch_app_rounded,
                texto: txtApp('Individual', 'Single'),
                onTap: () => _cambiarModoMultiple(false),
              ),
            ),
            Expanded(
              child: _opcionModoConsulta(
                activo: _modoMultiple,
                icono: Icons.checklist_rounded,
                texto: txtApp('Multiple', 'Multiple'),
                onTap: () => _cambiarModoMultiple(true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barraBusquedaCatalogo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
      child: TextField(
        controller: _busquedaController,
        onChanged: (valor) => setState(() => _busqueda = valor),
        decoration: InputDecoration(
          hintText: txtApp(
            'Buscar por nombre, beneficio o componente',
            'Search by name, benefit, or ingredient',
          ),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _busqueda.isEmpty
              ? null
              : IconButton(
                  tooltip: txtApp('Limpiar', 'Clear'),
                  onPressed: () {
                    _busquedaController.clear();
                    setState(() => _busqueda = '');
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDDE3FF), width: 1.3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF12248B), width: 1.7),
          ),
        ),
      ),
    );
  }

  Widget _opcionModoConsulta({
    required bool activo,
    required IconData icono,
    required String texto,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(11),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: activo ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: activo
              ? [
                  BoxShadow(
                    color: const Color(0xFF0B176B).withValues(alpha: 0.08),
                    blurRadius: 9,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              color: activo ? const Color(0xFF12248B) : const Color(0xFF5C6592),
              size: 19,
            ),
            const SizedBox(width: 7),
            Text(
              texto,
              style: TextStyle(
                color:
                    activo ? const Color(0xFF12248B) : const Color(0xFF5C6592),
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barraSeleccionMultiple() {
    final cantidad = _seleccionMultiple.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF12248B).withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              txtApp(
                '$cantidad producto(s) seleccionados',
                '$cantidad selected product(s)',
              ),
              style: const TextStyle(
                color: Color(0xFF12248B),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          TextButton(
            onPressed:
                cantidad == 0 ? null : () => setState(_seleccionMultiple.clear),
            child: Text(txtApp('Limpiar', 'Clear')),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: cantidad == 0 ? null : _abrirConsultaMultiple,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF12248B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.fact_check_rounded),
            label: Text(txtApp('Consultar', 'Review')),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirConsultaMultiple() async {
    final productos = _productosSeleccionados;
    if (productos.isEmpty) return;
    await ImpactoService.registrar(
      tipo: _esMiTienda ? 'catalogo_mitienda_multiple' : 'catalogo_multiple',
      titulo: txtApp('Consulta multiple', 'Multiple review'),
      datos: {
        'productos': productos.map((producto) => producto.nombre).toList(),
      },
    );
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => _dialogoConsultaMultiple(
        dialogContext,
        productos,
      ),
    );
  }

  Widget _dialogoConsultaMultiple(
    BuildContext dialogContext,
    List<ProductoPrecio> productos,
  ) {
    final ingles = IdiomaService.actual.value == IdiomaApp.ingles;
    final totalLp = productos.fold<int>(
      0,
      (total, producto) => total + (producto.lp ?? 0),
    );
    final totalAfiliado = productos.fold<double>(
      0,
      (total, producto) => total + producto.afiliado,
    );
    final totalPublico = productos.fold<double>(
      0,
      (total, producto) => total + producto.publico,
    );
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
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
                      txtApp('Consulta multiple', 'Multiple review'),
                      style: const TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: ingles ? 'Close' : 'Cerrar',
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (!_esMiTienda) _resumenMultiple('LP', '$totalLp'),
                  _resumenMultiple(
                    ingles ? 'Member' : 'Afiliado',
                    '\$${totalAfiliado.toStringAsFixed(2)}',
                  ),
                  _resumenMultiple(
                    ingles ? 'Retail' : 'Publico',
                    '\$${totalPublico.toStringAsFixed(2)}',
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final producto in productos)
                        _filaProductoMultiple(producto),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    tooltip: ingles ? 'Copy' : 'Copiar',
                    icon: const Icon(Icons.copy_rounded),
                    color: const Color(0xFF12248B),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: _textoConsultaMultiple(productos)),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(ingles ? 'Copied' : 'Copiado')),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: ingles ? 'Share' : 'Compartir',
                    icon: const Icon(Icons.share_rounded),
                    color: const Color(0xFF12248B),
                    onPressed: () => _compartirConsultaMultiple(productos),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(ingles ? 'Close' : 'Cerrar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resumenMultiple(String etiqueta, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$etiqueta: $valor',
        style: const TextStyle(
          color: Color(0xFF12248B),
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _filaProductoMultiple(ProductoPrecio producto) {
    final info = informacionProductoCatalogo(producto.nombre);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _abrirProducto(producto),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE1E4F0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76,
                height: 76,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  imagenesProducto4Life[producto.nombre] ?? '',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.inventory_2_outlined),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: const TextStyle(
                        color: Color(0xFF111B59),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _esMiTienda
                          ? '${txtApp('Afiliado', 'Member')} \$${producto.afiliado.toStringAsFixed(2)} | ${txtApp('Público', 'Retail')} \$${producto.publico.toStringAsFixed(2)} | ${txtApp('Promo', 'Promo')} \$${(precioPromocionalMiTienda(producto.nombre) ?? 0).toStringAsFixed(2)}'
                          : '${txtApp('Afiliado', 'Member')} \$${producto.afiliado.toStringAsFixed(2)} | LP ${producto.lp ?? 0} | ${txtApp('Público', 'Retail')} \$${producto.publico.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF465074),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      info.descripcion,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF27315F),
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF12248B),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _textoPrecioCatalogo(
    ProductoPrecio producto, {
    required double? precioPromocional,
    required bool ingles,
  }) {
    final promo = precioPromocional;
    return [
      '${ingles ? 'Member' : 'Afiliado'} \$${producto.afiliado.toStringAsFixed(2)}',
      'LP ${producto.lp ?? 0}',
      if (!_esMiTienda && producto.lpCanje != null)
        '${ingles ? 'Exchange LP' : 'LP canje'} ${producto.lpCanje}',
      '${ingles ? 'Retail' : 'Público'} \$${producto.publico.toStringAsFixed(2)}',
      if (_esMiTienda && promo != null)
        '${ingles ? 'Promo' : 'Promocional'} \$${promo.toStringAsFixed(2)}',
    ].join('\n');
  }

  Widget _textoPrecioTarjeta(String textoPrecio) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        textoPrecio,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF12248B),
          fontSize: 10,
          height: 1.18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  String _textoConsultaMultiple(List<ProductoPrecio> productos) {
    final buffer = StringBuffer(
      txtApp('Consulta multiple de productos 4Life\n\n',
          'Multiple 4Life product review\n\n'),
    );
    for (final producto in productos) {
      final info = informacionProductoCatalogo(producto.nombre);
      buffer.writeln(producto.nombre);
      buffer.writeln(
          '${txtApp('Afiliado', 'Member')}: \$${producto.afiliado.toStringAsFixed(2)}');
      buffer.writeln(
          '${txtApp('Público', 'Retail')}: \$${producto.publico.toStringAsFixed(2)}');
      if (!_esMiTienda) buffer.writeln('LP: ${producto.lp ?? 0}');
      buffer.writeln(
          '${txtApp('Descripción', 'Description')}: ${info.descripcion}');
      buffer.writeln(
          '${txtApp('Componentes', 'Components')}: ${info.componentes}');
      buffer.writeln('${txtApp('Uso', 'Use')}: ${info.uso}');
      buffer.writeln(
          '${txtApp('Precauciones', 'Precautions')}: ${info.precauciones}');
      buffer.writeln('${txtApp('Dosis', 'Dosage')}: ${info.dosis}\n');
    }
    return buffer.toString();
  }

  Future<void> _compartirConsultaMultiple(List<ProductoPrecio> productos) {
    final ingles = IdiomaService.actual.value == IdiomaApp.ingles;
    return ServicioCompartir.mostrarOpciones(
      context,
      DocumentoCompartible(
        titulo: ingles
            ? 'MULTIPLE PRODUCT REVIEW'
            : 'CONSULTA MULTIPLE DE PRODUCTOS',
        nombreArchivo:
            ingles ? 'MULTIPLE PRODUCT REVIEW' : 'CONSULTA MULTIPLE PRODUCTOS',
        fecha: DateTime.now(),
        secciones: [
          SeccionDocumento(
            titulo: ingles ? 'Summary' : 'Resumen',
            contenido: _textoConsultaMultiple(productos),
          ),
        ],
        productos: productos
            .map(
              (producto) => ProductoDocumento(
                nombre: producto.nombre,
                imagenAsset: imagenesProducto4Life[producto.nombre],
                indicaciones: [
                  '${ingles ? 'Member' : 'Afiliado'}: \$${producto.afiliado.toStringAsFixed(2)}',
                  '${ingles ? 'Retail' : 'Público'}: \$${producto.publico.toStringAsFixed(2)}',
                  if (!_esMiTienda) 'LP: ${producto.lp ?? 0}',
                ],
                detalle: [
                  informacionProductoCatalogo(producto.nombre).descripcion,
                  informacionProductoCatalogo(producto.nombre).componentes,
                  informacionProductoCatalogo(producto.nombre).uso,
                  informacionProductoCatalogo(producto.nombre).precauciones,
                  informacionProductoCatalogo(producto.nombre).dosis,
                ].join('\n\n'),
              ),
            )
            .toList(),
      ),
      ingles: ingles,
    );
  }

  Widget _tarjetaProductoCatalogo(ProductoPrecio producto) {
    final imagen = imagenesProducto4Life[producto.nombre];
    final ingles = IdiomaService.actual.value == IdiomaApp.ingles;
    final precioPromocional = precioPromocionalMiTienda(producto.nombre);
    final seleccionado = _seleccionMultiple.contains(producto.nombre);
    final textoPrecio = _textoPrecioCatalogo(
      producto,
      precioPromocional: precioPromocional,
      ingles: ingles,
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () => _modoMultiple
            ? _alternarSeleccionMultiple(producto)
            : _abrirProducto(producto),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFE),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: seleccionado
                  ? const Color(0xFF12248B)
                  : const Color(0xFFE0E3EF),
              width: seleccionado ? 2.2 : 1.6,
            ),
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
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FC),
                          borderRadius: BorderRadius.circular(8),
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
                    if (_modoMultiple)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Icon(
                          seleccionado
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: seleccionado
                              ? const Color(0xFF12248B)
                              : const Color(0xFF9AA2C0),
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                producto.nombre,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF18215E),
                  fontSize: 12,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              _textoPrecioTarjeta(textoPrecio),
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
          if (!_esMiTienda) ...[
            if (producto.lpCanje != null) ...[
              const Divider(height: 1),
              _datoPrecio(
                ingles ? "Exchange LP" : "LP canje",
                producto.lpCanje.toString(),
                Icons.redeem_outlined,
              ),
            ],
          ],
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
        : 'Este producto no es medicina, no diagnostica, no trata, no cura ni previene enfermedades. Es un suplemento de bienestar y no reemplaza la indicación de un profesional de salud.';
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
        '${idioma == IdiomaApp.ingles ? 'Retail price' : 'Precio público'}: \$${precioProducto.publico.toStringAsFixed(2)}',
        'LP: ${precioProducto.lp ?? 0}',
      ],
      if (precioPromocional != null)
        '${idioma == IdiomaApp.ingles ? 'Promotional price' : 'Precio promocional'}: \$${precioPromocional.toStringAsFixed(2)}',
    ];
    if (!mounted) return;

    return ServicioCompartir.mostrarOpciones(
      context,
      DocumentoCompartible(
        titulo: idioma == IdiomaApp.ingles
            ? 'PRODUCT REPORT ${nombre.toUpperCase()}'
            : 'INFORME DEL PRODUCTO ${nombre.toUpperCase()}',
        nombreArchivo:
            idioma == IdiomaApp.ingles ? 'REPORT $nombre' : 'INFORME $nombre',
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
      ),
      documentoInformativo: DocumentoCompartible(
        titulo: idioma == IdiomaApp.ingles
            ? 'PRODUCT REPORT ${nombre.toUpperCase()}'
            : 'INFORME DEL PRODUCTO ${nombre.toUpperCase()}',
        nombreArchivo:
            idioma == IdiomaApp.ingles ? 'REPORT $nombre' : 'INFORME $nombre',
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
      'Descripción',
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

  Widget _seccionResultadoProducto(String titulo, String contenido) {
    final iconos = <String, IconData>{
      'Producto identificado': Icons.description_outlined,
      'Product identified': Icons.description_outlined,
      'Descripción': Icons.assignment_outlined,
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
