part of '../main.dart';

class PaginaInventarioLocal extends StatefulWidget {
  const PaginaInventarioLocal({super.key});

  @override
  State<PaginaInventarioLocal> createState() => _PaginaInventarioLocalState();
}

class _PaginaInventarioLocalState extends State<PaginaInventarioLocal> {
  static const String _prefsKey = 'inventario_local_4life';
  static const Color _azul = Color(0xFF172394);
  static const Color _azulOscuro = Color(0xFF07125E);
  static const Color _tinta = Color(0xFF111B59);
  static const Color _texto = Color(0xFF465074);

  final TextEditingController _busquedaController = TextEditingController();
  Map<String, int> _stock = {};
  bool _cargando = true;
  late List<String> _ordenProductos;

  @override
  void initState() {
    super.initState();
    _ordenProductos = productosConPrecio4Life.map((p) => p.nombre).toList()
      ..sort();
    _cargarInventario();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  Future<void> _cargarInventario() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    final inventario = <String, int>{};

    if (raw != null && raw.isNotEmpty) {
      try {
        final datos = jsonDecode(raw) as Map<String, dynamic>;
        for (final entry in datos.entries) {
          final producto = buscarProductoConPrecio(entry.key);
          if (producto == null) continue;
          final cantidad = int.tryParse(entry.value.toString()) ?? 0;
          inventario[producto.nombre] = cantidad.clamp(0, 999).toInt();
        }
      } catch (e) {
        debugPrint('Local inventory could not be loaded: $e');
      }
    }

    for (final producto in productosConPrecio4Life) {
      inventario.putIfAbsent(producto.nombre, () => 0);
    }

    if (!mounted) return;
    setState(() {
      _stock = inventario;
      _cargando = false;
    });
  }

  Future<void> _guardarInventario() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_stock));
  }

  Future<void> _actualizarStock(ProductoPrecio producto, int cantidad) async {
    setState(() {
      _stock = {
        ..._stock,
        producto.nombre: cantidad.clamp(0, 999).toInt(),
      };
    });
    await _guardarInventario();
  }

  Future<void> _ajustarStock(ProductoPrecio producto, int cambio) {
    final actual = _stock[producto.nombre] ?? 0;
    return _actualizarStock(producto, actual + cambio);
  }

  Future<void> _limpiarInventario() async {
    setState(() {
      _stock = {
        for (final producto in productosConPrecio4Life) producto.nombre: 0,
      };
    });
    await _guardarInventario();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_t('Inventario limpiado', 'Inventory cleared'))),
    );
  }

  Future<void> _editarStock(ProductoPrecio producto) async {
    final controller = TextEditingController(
      text: (_stock[producto.nombre] ?? 0).toString(),
    );
    final cantidad = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_t('Actualizar stock', 'Update stock')),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText: producto.nombre,
            suffixText: _t('unidades', 'units'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t('Cancelar', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final valor = int.tryParse(controller.text.trim()) ?? 0;
              Navigator.pop(context, valor);
            },
            child: Text(_t('Guardar', 'Save')),
          ),
        ],
      ),
    );
    controller.dispose();

    if (cantidad == null) return;
    await _actualizarStock(producto, cantidad);
  }

  Future<void> _copiarInventario() async {
    await Clipboard.setData(ClipboardData(text: _textoInventario()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_t('Inventario copiado', 'Inventory copied'))),
    );
  }

  Future<void> _compartirInventario() {
    final fecha = DateTime.now();
    final productosConStock = _productos
        .where((producto) => (_stock[producto.nombre] ?? 0) > 0)
        .toList();

    return ServicioCompartir.mostrarOpciones(
      context,
      DocumentoCompartible(
        titulo: _t('INVENTARIO LOCAL 4LIFE', '4LIFE LOCAL INVENTORY'),
        nombreArchivo: _t('INVENTARIO LOCAL 4LIFE', '4LIFE LOCAL INVENTORY'),
        fecha: fecha,
        secciones: [
          SeccionDocumento(
            titulo: _t('Resumen de inventario', 'Inventory summary'),
            contenido:
                '${_t('Productos con stock', 'Products in stock')}: $_productosActivos\n'
                '${_t('Unidades totales', 'Total units')}: $_unidadesTotales\n'
                '${_t('Valor afiliado estimado', 'Estimated member value')}: ${_precio(_valorAfiliado)}\n'
                '${_t('Valor publico estimado', 'Estimated retail value')}: ${_precio(_valorPublico)}',
          ),
        ],
        productos: productosConStock
            .map(
              (producto) => ProductoDocumento(
                nombre: '${_stock[producto.nombre] ?? 0} x ${producto.nombre}',
                imagenAsset: imagenesProducto4Life[producto.nombre],
                indicaciones: [
                  '${_t('LP por unidad', 'LP per unit')}: ${producto.lp ?? 0}',
                  '${_t('Afiliado por unidad', 'Member per unit')}: ${_precio(producto.afiliado)}',
                  '${_t('Publico por unidad', 'Retail per unit')}: ${_precio(producto.publico)}',
                ],
              ),
            )
            .toList(),
      ),
      ingles: IdiomaService.actual.value == IdiomaApp.ingles,
    );
  }

  List<ProductoPrecio> get _productos {
    final busqueda = normalizarTexto(_busquedaController.text);
    final porNombre = {
      for (final producto in productosConPrecio4Life) producto.nombre: producto,
    };
    final productos = [
      for (final nombre in _ordenProductos)
        if (porNombre[nombre] != null) porNombre[nombre]!,
    ];

    if (busqueda.isEmpty) return productos;
    return productos
        .where(
          (producto) => normalizarTexto(producto.nombre).contains(busqueda),
        )
        .toList();
  }

  int get _unidadesTotales =>
      _stock.values.fold(0, (total, cantidad) => total + cantidad);

  int get _productosActivos =>
      _stock.values.where((cantidad) => cantidad > 0).length;

  double get _valorAfiliado => productosConPrecio4Life.fold(
        0,
        (total, producto) =>
            total + (producto.afiliado * (_stock[producto.nombre] ?? 0)),
      );

  double get _valorPublico => productosConPrecio4Life.fold(
        0,
        (total, producto) =>
            total + (producto.publico * (_stock[producto.nombre] ?? 0)),
      );

  int get _lpDisponible => productosConPrecio4Life.fold(
        0,
        (total, producto) =>
            total + ((producto.lp ?? 0) * (_stock[producto.nombre] ?? 0)),
      );

  String _precio(double valor) => '\$${valor.toStringAsFixed(2)}';
  String _t(String es, String en) => txtApp(es, en);

  String _textoInventario() {
    final buffer = StringBuffer(
      '${_t('Inventario local 4Life', '4Life Local Inventory')}\n\n',
    );
    buffer.writeln(
      '${_t('Productos con stock', 'Products in stock')}: $_productosActivos',
    );
    buffer.writeln(
      '${_t('Unidades totales', 'Total units')}: $_unidadesTotales',
    );
    buffer.writeln('${_t('LP disponible', 'Available LP')}: $_lpDisponible');
    buffer.writeln(
      '${_t('Valor afiliado estimado', 'Estimated member value')}: ${_precio(_valorAfiliado)}',
    );
    buffer.writeln(
      '${_t('Valor publico estimado', 'Estimated retail value')}: ${_precio(_valorPublico)}\n',
    );

    for (final producto in productosConPrecio4Life) {
      final cantidad = _stock[producto.nombre] ?? 0;
      if (cantidad <= 0) continue;
      buffer.writeln('$cantidad x ${producto.nombre}');
      buffer.writeln('LP: ${(producto.lp ?? 0) * cantidad}');
      buffer.writeln(
        '${_t('Valor afiliado', 'Member value')}: ${_precio(producto.afiliado * cantidad)}',
      );
      buffer.writeln(
        '${_t('Valor publico', 'Retail value')}: ${_precio(producto.publico * cantidad)}\n',
      );
    }

    if (_productosActivos == 0) {
      buffer.writeln(_t(
        'No hay productos marcados como disponibles.',
        'No products are currently marked as available.',
      ));
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Stack(
        children: [
          Container(
            height: 286,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_azul, _azulOscuro],
              ),
            ),
          ),
          SafeArea(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _encabezado(),
                        const SizedBox(height: 30),
                        _tarjetaResumen(),
                        const SizedBox(height: 16),
                        _tarjetaBusqueda(),
                        const SizedBox(height: 16),
                        _accionesInventario(),
                        const SizedBox(height: 16),
                        _listaInventario(),
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
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _t('Inventario local', 'My Local Inventory'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                _t(
                  'Control privado de stock para entrega inmediata',
                  'Private stock control for immediate delivery',
                ),
                style: const TextStyle(
                  color: Color(0xFFD9DFFF),
                  fontSize: 18,
                  height: 1.22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.inventory_2_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
      ],
    );
  }

  Widget _tarjetaResumen() {
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
                      _t('Disponible ahora', 'Available now'),
                      style: const TextStyle(
                        color: _azul,
                        fontSize: 24,
                        height: 1.12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _t(
                        'Conoce exactamente cuantos productos tienes listos para entregar sin salir de la app.',
                        'Know exactly how many bottles are ready for delivery without leaving the app.',
                      ),
                      style: const TextStyle(
                        color: _texto,
                        fontSize: 17,
                        height: 1.36,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              _medidorStock(),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _datoResumen(_t('Productos', 'Products'), '$_productosActivos'),
              _datoResumen(_t('Unidades', 'Units'), '$_unidadesTotales'),
              _datoResumen('LP', '$_lpDisponible'),
              _datoResumen(_t('Afiliado', 'Member'), _precio(_valorAfiliado)),
              _datoResumen(_t('Publico', 'Retail'), _precio(_valorPublico)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _medidorStock() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFFECEEFF),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$_unidadesTotales',
            style: const TextStyle(
              color: _azul,
              fontSize: 26,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _t('UNID.', 'UNITS'),
            style: const TextStyle(
              color: _texto,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _datoResumen(String etiqueta, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E4F0)),
      ),
      child: Text(
        '$etiqueta: $valor',
        style: const TextStyle(
          color: _tinta,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _tarjetaBusqueda() {
    return _contenedorTarjeta(
      padding: const EdgeInsets.all(18),
      child: TextField(
        controller: _busquedaController,
        textInputAction: TextInputAction.search,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: _t('Buscar inventario', 'Search inventory'),
          hintStyle: const TextStyle(
            color: Color(0xFF858AA5),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF666C8F),
            size: 32,
          ),
          suffixIcon: _busquedaController.text.isEmpty
              ? null
              : IconButton(
                  tooltip: _t('Limpiar', 'Clear'),
                  onPressed: () {
                    _busquedaController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.cancel_rounded),
                  color: const Color(0xFF666C8F),
                ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD6D9E6), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _azul, width: 1.7),
          ),
        ),
      ),
    );
  }

  Widget _accionesInventario() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E6EF)),
        boxShadow: [
          BoxShadow(
            color: _azulOscuro.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _accionInventario(
              icono: Icons.copy_rounded,
              texto: _t('Copiar', 'Copy'),
              onTap: _copiarInventario,
            ),
          ),
          Container(width: 1, height: 42, color: const Color(0xFFE0E3EF)),
          Expanded(
            child: _accionInventario(
              icono: Icons.share_rounded,
              texto: _t('Compartir', 'Share'),
              onTap: _compartirInventario,
            ),
          ),
          Container(width: 1, height: 42, color: const Color(0xFFE0E3EF)),
          Expanded(
            child: _accionInventario(
              icono: Icons.delete_sweep_rounded,
              texto: _t('Limpiar', 'Clear'),
              onTap: _limpiarInventario,
            ),
          ),
        ],
      ),
    );
  }

  Widget _accionInventario({
    required IconData icono,
    required String texto,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, color: _azul, size: 28),
          const SizedBox(width: 12),
          Text(
            texto,
            style: const TextStyle(
              color: _azul,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaInventario() {
    final productos = _productos;
    return _contenedorTarjeta(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _t('Stock fisico', 'Physical stock'),
                  style: const TextStyle(
                    color: _azul,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EAFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  '${productos.length} ${_t('items', 'items')}',
                  style: const TextStyle(
                    color: _azul,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (productos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  _t(
                    'No hay productos para esta busqueda.',
                    'No products match this search.',
                  ),
                  style: const TextStyle(
                    color: _texto,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else
            for (final producto in productos) _filaProducto(producto),
        ],
      ),
    );
  }

  Widget _filaProducto(ProductoPrecio producto) {
    final cantidad = _stock[producto.nombre] ?? 0;
    final activo = cantidad > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: activo ? const Color(0xFFF2F6FF) : const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: activo ? const Color(0xFFC9D5FF) : const Color(0xFFE1E4F0),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 54,
            height: 54,
            child: Image.asset(
              imagenesProducto4Life[producto.nombre] ?? '',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.inventory_2_outlined),
              filterQuality: FilterQuality.high,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _editarStock(producto),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: const TextStyle(
                        color: _tinta,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LP ${producto.lp ?? 0}  |  ${_precio(producto.afiliado)} ${_t('afiliado', 'member')}',
                      style: const TextStyle(
                        color: _texto,
                        fontSize: 13,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _controlStock(producto, cantidad),
        ],
      ),
    );
  }

  Widget _controlStock(ProductoPrecio producto, int cantidad) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDE1F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: _t('Quitar uno', 'Remove one'),
            visualDensity: VisualDensity.compact,
            onPressed: cantidad <= 0 ? null : () => _ajustarStock(producto, -1),
            icon: const Icon(Icons.remove_rounded, size: 18),
            color: _azul,
          ),
          InkWell(
            onTap: () => _editarStock(producto),
            child: SizedBox(
              width: 32,
              child: Text(
                '$cantidad',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _azul,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: _t('Agregar uno', 'Add one'),
            visualDensity: VisualDensity.compact,
            onPressed: () => _ajustarStock(producto, 1),
            icon: const Icon(Icons.add_rounded, size: 18),
            color: _azul,
          ),
        ],
      ),
    );
  }

  Widget _contenedorTarjeta({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(22),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _azulOscuro.withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
