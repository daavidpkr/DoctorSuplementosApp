part of '../main.dart';

enum TipoPrecioCalculadora { miTienda, afiliado, publico }

class PaginaCalculadoraPrecios extends StatefulWidget {
  const PaginaCalculadoraPrecios({super.key});

  @override
  State<PaginaCalculadoraPrecios> createState() =>
      _PaginaCalculadoraPreciosState();
}

class _PaginaCalculadoraPreciosState extends State<PaginaCalculadoraPrecios> {
  final TextEditingController _controller = TextEditingController();
  List<LineaProductoPrecio> _productos = [];
  List<String> _noEncontrados = [];
  String _busquedaTexto = '';
  TipoPrecioCalculadora _tipoPrecio = TipoPrecioCalculadora.miTienda;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_busquedaTexto == _controller.text) return;
      if (!mounted) return;
      setState(() => _busquedaTexto = _controller.text);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _mostrarSelectorPrecio(resaltarActual: false);
    });
  }

  String get _etiquetaTipoPrecio {
    switch (_tipoPrecio) {
      case TipoPrecioCalculadora.miTienda:
        return txtApp('MiTienda', 'MyStore');
      case TipoPrecioCalculadora.afiliado:
        return txtApp('Afiliado', 'Member');
      case TipoPrecioCalculadora.publico:
        return txtApp('Publico', 'Retail');
    }
  }

  double? _precioProductoSeleccionado(ProductoPrecio producto) {
    switch (_tipoPrecio) {
      case TipoPrecioCalculadora.miTienda:
        return precioPromocionalMiTienda(producto.nombre);
      case TipoPrecioCalculadora.afiliado:
        return producto.afiliado;
      case TipoPrecioCalculadora.publico:
        return producto.publico;
    }
  }

  bool get _mostrarLp => _tipoPrecio == TipoPrecioCalculadora.afiliado;

  bool _productoDisponibleParaPrecio(ProductoPrecio producto) =>
      _precioProductoSeleccionado(producto) != null;

  String _mensajeNoDisponible(ProductoPrecio producto) {
    return txtApp(
      '${producto.nombre} no dispone de precio $_etiquetaTipoPrecio.',
      '${producto.nombre} does not have a $_etiquetaTipoPrecio price.',
    );
  }

  void _aplicarTipoPrecio(TipoPrecioCalculadora tipo) {
    setState(() {
      _tipoPrecio = tipo;
      _productos = _productos
          .where((linea) => _productoDisponibleParaPrecio(linea.producto))
          .toList();
      _noEncontrados = [];
    });
  }

  Future<void> _mostrarSelectorPrecio({bool resaltarActual = true}) async {
    final tipoActivo = resaltarActual ? _tipoPrecio : null;
    final seleccionado = await showDialog<TipoPrecioCalculadora>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                txtApp('Elige el precio a calcular', 'Choose price type'),
                style: const TextStyle(
                  color: Color(0xFF13288E),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                txtApp(
                  'La selección mostrará solo productos con ese precio disponible.',
                  'Selection will show only products with that price available.',
                ),
                style: const TextStyle(
                  color: Color(0xFF58618C),
                  fontSize: 14,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _opcionTipoPrecioDialogo(
                dialogContext,
                TipoPrecioCalculadora.miTienda,
                tipoActivo,
                Icons.storefront_rounded,
                txtApp('MiTienda', 'MyStore'),
              ),
              _opcionTipoPrecioDialogo(
                dialogContext,
                TipoPrecioCalculadora.afiliado,
                tipoActivo,
                Icons.person_outline_rounded,
                txtApp('Afiliado', 'Member'),
              ),
              _opcionTipoPrecioDialogo(
                dialogContext,
                TipoPrecioCalculadora.publico,
                tipoActivo,
                Icons.groups_2_outlined,
                txtApp('Publico', 'Retail'),
              ),
            ],
          ),
        ),
      ),
    );
    if (seleccionado != null) _aplicarTipoPrecio(seleccionado);
  }

  Widget _opcionTipoPrecioDialogo(
    BuildContext dialogContext,
    TipoPrecioCalculadora tipo,
    TipoPrecioCalculadora? tipoActivo,
    IconData icono,
    String titulo,
  ) {
    final activo = tipoActivo == tipo;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pop(dialogContext, tipo),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: activo ? const Color(0xFFEFF2FF) : const Color(0xFFF8F9FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: activo ? const Color(0xFF17218D) : const Color(0xFFE1E4F0),
              width: activo ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icono, color: const Color(0xFF17218D), size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (activo)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF17218D),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _agregarProducto(ProductoPrecio producto, {int cantidad = 1}) {
    if (!_productoDisponibleParaPrecio(producto)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_mensajeNoDisponible(producto))),
      );
      return;
    }
    final indice = _productos.indexWhere(
      (item) => item.producto.nombre == producto.nombre,
    );
    setState(() {
      if (indice == -1) {
        _productos = [
          ..._productos,
          LineaProductoPrecio(producto: producto, cantidad: cantidad),
        ];
      } else {
        final actualizada = [..._productos];
        final actual = actualizada[indice];
        actualizada[indice] = actual.copyWith(
          cantidad: (actual.cantidad + cantidad).clamp(1, 999).toInt(),
        );
        _productos = actualizada;
      }
      _noEncontrados = [];
    });
  }

  void _agregarDesdeTexto() {
    final consultas = dividirConsultaProductos(_controller.text);
    if (consultas.isEmpty) return;

    final noEncontrados = <String>[];
    var agregados = 0;

    for (final consulta in consultas) {
      final item = extraerConsultaConCantidad(consulta);
      final producto = buscarProductoConPrecio(item.texto);
      if (producto == null) {
        noEncontrados.add(consulta);
        continue;
      }
      if (!_productoDisponibleParaPrecio(producto)) {
        noEncontrados.add(_mensajeNoDisponible(producto));
        continue;
      }
      final indice = _productos.indexWhere(
        (linea) => linea.producto.nombre == producto.nombre,
      );
      if (indice == -1) {
        _productos = [
          ..._productos,
          LineaProductoPrecio(producto: producto, cantidad: item.cantidad),
        ];
      } else {
        final actualizada = [..._productos];
        final actual = actualizada[indice];
        actualizada[indice] = actual.copyWith(
          cantidad: (actual.cantidad + item.cantidad).clamp(1, 999).toInt(),
        );
        _productos = actualizada;
      }
      agregados += item.cantidad;
    }

    setState(() {
      _noEncontrados = noEncontrados;
    });
    _controller.clear();

    if (agregados > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$agregados producto(s) agregado(s)")),
      );
    }
  }

  void _quitarProducto(ProductoPrecio producto) {
    setState(() {
      _productos = _productos
          .where((item) => item.producto.nombre != producto.nombre)
          .toList();
    });
  }

  void _cambiarCantidad(ProductoPrecio producto, int cambio) {
    final indice = _productos.indexWhere(
      (item) => item.producto.nombre == producto.nombre,
    );
    if (indice == -1) return;

    setState(() {
      final actualizada = [..._productos];
      final actual = actualizada[indice];
      final nuevaCantidad = actual.cantidad + cambio;
      if (nuevaCantidad <= 0) {
        actualizada.removeAt(indice);
      } else {
        actualizada[indice] = actual.copyWith(
          cantidad: nuevaCantidad.clamp(1, 999).toInt(),
        );
      }
      _productos = actualizada;
    });
  }

  void _limpiarSeleccion() {
    setState(() {
      _productos = [];
      _noEncontrados = [];
      _controller.clear();
    });
  }

  Future<void> _calcular() async {
    _agregarDesdeTexto();
    if (_productos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            txtApp(
              "Selecciona al menos un producto",
              "Select at least one product",
            ),
          ),
        ),
      );
      return;
    }

    unawaited(ImpactoService.registrar(
      tipo: 'calculadora_productos',
      titulo: 'Calculadora de precios',
      guardarEnFirebase: false,
      datos: {
        'cantidad': _cantidadTotalProductos,
        'productos': _productos
            .map((p) => {'nombre': p.producto.nombre, 'cantidad': p.cantidad})
            .toList(),
        'tipoPrecio': _etiquetaTipoPrecio,
        'noEncontrados': _noEncontrados,
      },
    ));

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6DAEA),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                txtApp("Resultado", "Result"),
                style: const TextStyle(
                  color: Color(0xFF13288E),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              _resumenTotal(_etiquetaTipoPrecio, _precio(_totalSeleccionado)),
              if (_mostrarLp) _resumenTotal("LP", _totalLp.toString()),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () =>
                    ServicioTextoVoz.reproducir(_resumenCompartir()),
                icon: const Icon(Icons.volume_up_rounded),
                label: Text(txtApp("Escuchar resultado", "Listen to result")),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF17218D),
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Color(0xFF17218D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _compartirResultado,
                icon: const Icon(Icons.share_rounded),
                label: Text(txtApp("Compartir resultado", "Share result")),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF17218D),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int get _cantidadTotalProductos =>
      _productos.fold(0, (total, p) => total + p.cantidad);

  double get _totalSeleccionado => _productos.fold(0, (total, p) {
        final precio = _precioProductoSeleccionado(p.producto) ?? 0;
        return total + (precio * p.cantidad);
      });

  int get _totalLp => _productos.fold(
      0, (total, p) => total + ((p.producto.lp ?? 0) * p.cantidad));

  String _precio(double valor) => '\$${valor.toStringAsFixed(2)}';

  String _resumenCompartir() {
    final buffer = StringBuffer('Consulta de precios 4Life\n\n');
    for (final linea in _productos) {
      final producto = linea.producto;
      final precio = _precioProductoSeleccionado(producto) ?? 0;
      buffer.writeln('${linea.cantidad} x ${producto.nombre}');
      buffer.writeln(
          'Precio $_etiquetaTipoPrecio: ${_precio(precio * linea.cantidad)}');
      if (_mostrarLp) {
        buffer.writeln('LP: ${(producto.lp ?? 0) * linea.cantidad}');
      }
      buffer.writeln();
    }
    buffer
        .writeln('Total $_etiquetaTipoPrecio: ${_precio(_totalSeleccionado)}');
    if (_mostrarLp) buffer.writeln('Total LP: $_totalLp');
    return buffer.toString();
  }

  Future<void> _compartirResultado() {
    final fecha = DateTime.now();
    final productosInformativos = _productos
        .map(
          (linea) => ProductoDocumento(
            nombre: '${linea.cantidad} x ${linea.producto.nombre}',
            imagenAsset: imagenesProducto4Life[linea.producto.nombre],
          ),
        )
        .toList();

    return ServicioCompartir.mostrarOpciones(
      context,
      DocumentoCompartible(
        titulo: 'COTIZACIÓN DE PRODUCTOS 4LIFE',
        nombreArchivo: 'COTIZACION PRODUCTOS 4LIFE',
        fecha: fecha,
        secciones: [
          SeccionDocumento(
            titulo: 'Resumen de la cotización',
            contenido: 'Tipo de precio: $_etiquetaTipoPrecio\n'
                'Total $_etiquetaTipoPrecio: ${_precio(_totalSeleccionado)}'
                '${_mostrarLp ? '\nTotal LP: $_totalLp' : ''}',
          ),
        ],
        productos: _productos
            .map(
              (linea) => ProductoDocumento(
                nombre: '${linea.cantidad} x ${linea.producto.nombre}',
                imagenAsset: imagenesProducto4Life[linea.producto.nombre],
                indicaciones: [
                  'Precio $_etiquetaTipoPrecio: '
                      '${_precio((_precioProductoSeleccionado(linea.producto) ?? 0) * linea.cantidad)}',
                  if (_mostrarLp)
                    'LP: ${(linea.producto.lp ?? 0) * linea.cantidad}',
                ],
              ),
            )
            .toList(),
      ),
      documentoInformativo: DocumentoCompartible(
        titulo: 'PRODUCTOS 4LIFE',
        nombreArchivo: 'COTIZACION PRODUCTOS 4LIFE',
        fecha: fecha,
        secciones: const [
          SeccionDocumento(
            titulo: 'Productos seleccionados',
            contenido:
                'Lista informativa de productos 4Life. No incluye precios ni LP.',
          ),
        ],
        productos: productosInformativos,
      ),
    );
  }

  void _abrirCatalogo() {
    final productosCatalogo =
        productosConPrecio4Life.where(_productoDisponibleParaPrecio).toList()
          ..sort((a, b) => normalizarTexto(a.nombre).compareTo(
                normalizarTexto(b.nombre),
              ));
    final busquedaCatalogoController = TextEditingController();
    var busquedaCatalogo = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        minChildSize: 0.55,
        maxChildSize: 0.94,
        builder: (context, scrollController) {
          return StatefulBuilder(
            builder: (context, actualizarCatalogo) {
              final productosFiltrados = _filtrarProductosInteligente(
                productosCatalogo,
                busquedaCatalogo,
              );
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 46,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8DCEB),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            txtApp(
                              "Productos con precio $_etiquetaTipoPrecio",
                              "$_etiquetaTipoPrecio products",
                            ),
                            style: const TextStyle(
                              color: Color(0xFF11258B),
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: txtApp("Cerrar", "Close"),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      controller: busquedaCatalogoController,
                      onChanged: (valor) => actualizarCatalogo(
                        () => busquedaCatalogo = valor,
                      ),
                      decoration: InputDecoration(
                        hintText: txtApp(
                          'Buscar por nombre, beneficio o componente',
                          'Search by name, benefit, or ingredient',
                        ),
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: busquedaCatalogo.isEmpty
                            ? null
                            : IconButton(
                                tooltip: txtApp('Limpiar', 'Clear'),
                                onPressed: () => actualizarCatalogo(() {
                                  busquedaCatalogoController.clear();
                                  busquedaCatalogo = '';
                                }),
                                icon: const Icon(Icons.close_rounded),
                              ),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FF),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDE3FF),
                            width: 1.3,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF17218D),
                            width: 1.7,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.86,
                      ),
                      itemCount: productosFiltrados.length,
                      itemBuilder: (context, index) {
                        final producto = productosFiltrados[index];
                        final imagen = imagenesProducto4Life[producto.nombre];
                        final cantidad = _productos
                            .where((item) =>
                                item.producto.nombre == producto.nombre)
                            .fold<int>(
                              0,
                              (total, item) => total + item.cantidad,
                            );
                        final seleccionado = cantidad > 0;
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            _agregarProducto(producto);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: seleccionado
                                  ? const Color(0xFFE9ECFF)
                                  : const Color(0xFFF8F9FF),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: seleccionado
                                    ? const Color(0xFF17218D)
                                    : const Color(0xFFE1E4F0),
                                width: seleccionado ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF17218D)
                                      .withValues(alpha: 0.07),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: imagen == null
                                      ? const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Color(0xFF17218D),
                                        )
                                      : Image.asset(
                                          imagen,
                                          fit: BoxFit.contain,
                                          filterQuality: FilterQuality.high,
                                        ),
                                ),
                                if (seleccionado)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor:
                                          const Color(0xFF17218D),
                                      child: Text(
                                        'x$cantidad',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    ).whenComplete(busquedaCatalogoController.dispose);
  }

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Stack(
        children: [
          Container(
            height: 230,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF132890), Color(0xFF0B176B)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              child: Column(
                children: [
                  _encabezado(),
                  const SizedBox(height: 26),
                  _tarjetaSeleccion(),
                  const SizedBox(height: 18),
                  _tarjetaProductosSeleccionados(),
                  const SizedBox(height: 18),
                  _botonCalcular(),
                  const SizedBox(height: 18),
                  _accionesSecundarias(),
                  const SizedBox(height: 18),
                  _tarjetaAyuda(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _encabezado() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          iconSize: 34,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 42, height: 42),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                txtApp("Consultora y calculadora", "Consultant and calculator"),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                txtApp("Consulta precios y LP", "Check prices and LP"),
                style: const TextStyle(
                  color: Color(0xFFDCE2FF),
                  fontSize: 20,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.help_outline_rounded,
                  color: Colors.white, size: 32),
              const SizedBox(height: 3),
              Text(
                txtApp("Ayuda", "Help"),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tarjetaSeleccion() {
    return _contenedorTarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txtApp("Selecciona producto(s)", "Select product(s)"),
                      style: const TextStyle(
                        color: Color(0xFF11258B),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      txtApp(
                        "Busca y anade uno o varios productos para consultar precios y LP.",
                        "Search and add one or more products to check prices and LP.",
                      ),
                      style: const TextStyle(
                        color: Color(0xFF47527E),
                        fontSize: 18,
                        height: 1.38,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _ilustracionProductos(),
            ],
          ),
          const SizedBox(height: 24),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _mostrarSelectorPrecio(),
            child: Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD1D5E3), width: 1.4),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.payments_rounded,
                    color: Color(0xFF12248B),
                    size: 30,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      txtApp(
                        'Precio activo: $_etiquetaTipoPrecio',
                        'Active price: $_etiquetaTipoPrecio',
                      ),
                      style: const TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.expand_more_rounded,
                    color: Color(0xFF12248B),
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            minLines: 1,
            maxLines: 2,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _agregarDesdeTexto(),
            decoration: InputDecoration(
              hintText: txtApp("Buscar producto(s)", "Search product(s)"),
              hintStyle: const TextStyle(
                color: Color(0xFF858AA5),
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF6E748F),
                size: 34,
              ),
              suffixIcon: IconButton(
                tooltip: txtApp("Agregar", "Add"),
                onPressed: _agregarDesdeTexto,
                icon: const Icon(Icons.add_circle_rounded),
                color: const Color(0xFF17218D),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFD1D5E3), width: 1.4),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFF17218D), width: 1.7),
              ),
            ),
          ),
          _sugerenciasBusquedaTexto(),
          const SizedBox(height: 18),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _abrirCatalogo,
            child: Container(
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD1D5E3), width: 1.4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.format_list_bulleted_rounded,
                      color: Color(0xFF12248B), size: 34),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      txtApp("Explorar catalogo", "Browse catalog"),
                      style: const TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFF12248B), size: 34),
                ],
              ),
            ),
          ),
          if (_noEncontrados.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              "No encontrados: ${_noEncontrados.join(', ')}",
              style: const TextStyle(
                color: Color(0xFFC0392B),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _ilustracionProductos() {
    return SizedBox(
      width: 108,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            bottom: 8,
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: const Color(0xFFE8ECFF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.calculate_outlined,
                color: Color(0xFF2839C7),
                size: 38,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 4,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFF2839C7),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2839C7).withValues(alpha: 0.20),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          const Positioned(
            right: 8,
            top: 8,
            child: Icon(
              Icons.add_circle,
              size: 28,
              color: Color(0xFF17218D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sugerenciasBusquedaTexto() {
    final consulta = _busquedaTexto.trim();
    if (consulta.length < 2) return const SizedBox.shrink();
    final productosBase =
        productosConPrecio4Life.where(_productoDisponibleParaPrecio).toList();
    final sugerencias = _filtrarProductosInteligente(productosBase, consulta)
        .take(5)
        .toList();
    if (sugerencias.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          for (final producto in sugerencias)
            _sugerenciaProductoTexto(producto),
        ],
      ),
    );
  }

  Widget _sugerenciaProductoTexto(ProductoPrecio producto) {
    final imagen = imagenesProducto4Life[producto.nombre];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _agregarProducto(producto);
          _controller.clear();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E4F0)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: imagen == null
                    ? const Icon(Icons.inventory_2_outlined)
                    : Image.asset(
                        imagen,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  producto.nombre,
                  style: const TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(Icons.add_circle_rounded, color: Color(0xFF17218D)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tarjetaProductosSeleccionados() {
    return _contenedorTarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  txtApp("Productos seleccionados", "Selected products"),
                  style: const TextStyle(
                    color: Color(0xFF11258B),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EAFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  txtApp(
                    "$_cantidadTotalProductos productos",
                    "$_cantidadTotalProductos products",
                  ),
                  style: const TextStyle(
                    color: Color(0xFF2832A1),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (_productos.isEmpty) _estadoVacio() else _listaSeleccionados(),
        ],
      ),
    );
  }

  Widget _estadoVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 46,
              backgroundColor: Color(0xFFECEEFF),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF3143B8),
                size: 46,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              txtApp(
                "Aun no has agregado productos",
                "You have not added products yet",
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF3B467A),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              txtApp(
                "Busca y selecciona los productos que deseas consultar.",
                "Search and select the products you want to consult.",
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF58618C),
                fontSize: 17,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listaSeleccionados() {
    return Column(
      children: [
        for (final linea in _productos)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E4F0)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  child: Image.asset(
                    imagenesProducto4Life[linea.producto.nombre] ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.inventory_2_outlined),
                    filterQuality: FilterQuality.high,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        linea.producto.nombre,
                        style: const TextStyle(
                          color: Color(0xFF152179),
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _detallePrecioProducto(linea),
                    ],
                  ),
                ),
                _controlCantidad(linea),
                IconButton(
                  tooltip: "Quitar",
                  onPressed: () => _quitarProducto(linea.producto),
                  icon: const Icon(Icons.close_rounded),
                  color: const Color(0xFF17218D),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _controlCantidad(LineaProductoPrecio linea) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFDDE1F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: "Restar",
            visualDensity: VisualDensity.compact,
            onPressed: () => _cambiarCantidad(linea.producto, -1),
            icon: const Icon(Icons.remove_rounded, size: 18),
            color: const Color(0xFF17218D),
          ),
          Text(
            '${linea.cantidad}',
            style: const TextStyle(
              color: Color(0xFF12248B),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          IconButton(
            tooltip: "Sumar",
            visualDensity: VisualDensity.compact,
            onPressed: () => _cambiarCantidad(linea.producto, 1),
            icon: const Icon(Icons.add_rounded, size: 18),
            color: const Color(0xFF17218D),
          ),
        ],
      ),
    );
  }

  Widget _detallePrecioProducto(LineaProductoPrecio linea) {
    final precio = _precioProductoSeleccionado(linea.producto) ?? 0;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _chipPrecioSeleccionado(
          _etiquetaTipoPrecio,
          _precio(precio),
        ),
        if (_mostrarLp)
          _chipPrecioSeleccionado('LP', '${linea.producto.lp ?? 0}'),
      ],
    );
  }

  Widget _chipPrecioSeleccionado(String etiqueta, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2FF),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFDDE3FF)),
      ),
      child: Text(
        '$etiqueta $valor',
        style: const TextStyle(
          color: Color(0xFF12248B),
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _botonCalcular() {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: _calcular,
      child: Container(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 26),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF172394), Color(0xFF0B176B)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.calculate_outlined, color: Colors.white, size: 38),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txtApp("Calcular", "Calculate"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    txtApp("Consulta precios y LP", "Check prices and LP"),
                    style: const TextStyle(
                      color: Color(0xFFDDE3FF),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Colors.white, size: 42),
          ],
        ),
      ),
    );
  }

  Widget _accionesSecundarias() {
    return Container(
      height: 86,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E6EF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111A5B).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _accionSecundaria(
              icono: Icons.copy_rounded,
              texto: txtApp("Limpiar selección", "Clear selection"),
              onTap: _limpiarSeleccion,
            ),
          ),
          Container(width: 1, height: 42, color: const Color(0xFFE0E3EF)),
          Expanded(
            child: _accionSecundaria(
              icono: Icons.share_rounded,
              texto: txtApp("Compartir lista", "Share list"),
              onTap: _productos.isEmpty ? null : _compartirResultado,
            ),
          ),
        ],
      ),
    );
  }

  Widget _accionSecundaria({
    required IconData icono,
    required String texto,
    required VoidCallback? onTap,
  }) {
    final activo = onTap != null;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icono,
            color: activo ? const Color(0xFF12248B) : const Color(0xFF9AA0B6),
            size: 30,
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              texto,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color:
                    activo ? const Color(0xFF12248B) : const Color(0xFF9AA0B6),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaAyuda() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE5FF), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: Color(0xFF4865DF),
            child: Icon(Icons.info_rounded, color: Colors.white, size: 30),
          ),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Como funciona?",
                  style: TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Selecciona uno o varios productos y presiona calcular para obtener los precios y LP.",
                  style: TextStyle(
                    color: Color(0xFF46527E),
                    fontSize: 17,
                    height: 1.38,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenedorTarjeta({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _resumenTotal(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: const TextStyle(
                color: Color(0xFF46527E),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              color: Color(0xFF12248B),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// --- PANTALLA: HISTORIAL ---
