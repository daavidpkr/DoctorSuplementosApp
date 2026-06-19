part of '../main.dart';

class PaginaComparadorAB extends StatefulWidget {
  const PaginaComparadorAB({super.key});

  @override
  State<PaginaComparadorAB> createState() => _PaginaComparadorABState();
}

class _PaginaComparadorABState extends State<PaginaComparadorAB> {
  static const Color _azul = Color(0xFF172394);
  static const Color _azulOscuro = Color(0xFF07125E);
  static const Color _tinta = Color(0xFF111B59);
  static const Color _texto = Color(0xFF465074);

  late ProductoPrecio _productoA;
  late ProductoPrecio _productoB;

  @override
  void initState() {
    super.initState();
    _productoA = productosConPrecio4Life.firstWhere(
      (producto) => producto.nombre == 'Transfer factor plus',
      orElse: () => productosConPrecio4Life.first,
    );
    _productoB = productosConPrecio4Life.firstWhere(
      (producto) => producto.nombre == 'Transfer factor tri factor',
      orElse: () => productosConPrecio4Life.length > 1
          ? productosConPrecio4Life[1]
          : productosConPrecio4Life.first,
    );
  }

  Future<void> _seleccionarProducto(bool esA) async {
    final seleccionado = await showModalBottomSheet<ProductoPrecio>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _SelectorProductoAB(
        seleccionado: esA ? _productoA : _productoB,
      ),
    );
    if (seleccionado == null) return;
    setState(() {
      if (esA) {
        _productoA = seleccionado;
      } else {
        _productoB = seleccionado;
      }
    });
  }

  Future<void> _copiarComparacion() async {
    await Clipboard.setData(ClipboardData(text: _textoComparacion()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comparison copied')),
    );
  }

  Future<void> _compartirComparacion() {
    final fecha = DateTime.now();
    return ServicioCompartir.mostrarOpciones(
      context,
      DocumentoCompartible(
        titulo: '4LIFE A/B SUPPLEMENT COMPARISON',
        nombreArchivo: '4LIFE A B COMPARISON',
        texto: _textoComparacion(),
        fecha: fecha,
        secciones: [
          SeccionDocumento(
            titulo: 'Quick decision',
            contenido: _decisionRapida(),
          ),
        ],
        productos: [_productoA, _productoB]
            .map(
              (producto) => ProductoDocumento(
                nombre: producto.nombre,
                imagenAsset: imagenesProducto4Life[producto.nombre],
                indicaciones: [
                  'Focus: ${_enfoqueProducto(producto)}',
                  'Member: ${_precio(producto.afiliado)}',
                  'Retail: ${_precio(producto.publico)}',
                  'LP: ${producto.lp ?? 0}',
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  String _textoComparacion() {
    final buffer = StringBuffer('4Life A/B Supplement Comparison\n\n');
    buffer.writeln('Product A: ${_productoA.nombre}');
    buffer.writeln('Focus: ${_enfoqueProducto(_productoA)}');
    buffer.writeln('Member: ${_precio(_productoA.afiliado)}');
    buffer.writeln('Retail: ${_precio(_productoA.publico)}');
    buffer.writeln('LP: ${_productoA.lp ?? 0}\n');
    buffer.writeln('Product B: ${_productoB.nombre}');
    buffer.writeln('Focus: ${_enfoqueProducto(_productoB)}');
    buffer.writeln('Member: ${_precio(_productoB.afiliado)}');
    buffer.writeln('Retail: ${_precio(_productoB.publico)}');
    buffer.writeln('LP: ${_productoB.lp ?? 0}\n');
    buffer.writeln('Quick decision: ${_decisionRapida()}');
    return buffer.toString();
  }

  String _precio(double valor) => '\$${valor.toStringAsFixed(2)}';

  String _lpPorDolar(ProductoPrecio producto) {
    if (producto.afiliado <= 0) return '0.00';
    return ((producto.lp ?? 0) / producto.afiliado).toStringAsFixed(2);
  }

  String _decisionRapida() {
    final lpA = _productoA.lp ?? 0;
    final lpB = _productoB.lp ?? 0;
    final valorA = _productoA.afiliado <= 0 ? 0 : lpA / _productoA.afiliado;
    final valorB = _productoB.afiliado <= 0 ? 0 : lpB / _productoB.afiliado;

    if (_enfoqueProducto(_productoA) != _enfoqueProducto(_productoB)) {
      return 'Choose ${_productoA.nombre} for ${_enfoqueProducto(_productoA).toLowerCase()} needs, or ${_productoB.nombre} for ${_enfoqueProducto(_productoB).toLowerCase()} needs.';
    }
    if (valorA > valorB) {
      return '${_productoA.nombre} gives more LP per member dollar.';
    }
    if (valorB > valorA) {
      return '${_productoB.nombre} gives more LP per member dollar.';
    }
    return 'Both products are close; decide by client preference, format, and wellness goal.';
  }

  String _enfoqueProducto(ProductoPrecio producto) {
    final nombre = normalizarTexto(producto.nombre);
    if (nombre.contains('energy')) return 'Energy and daily performance';
    if (nombre.contains('riovida')) return 'Antioxidant nutrition';
    if (nombre.contains('protf') || nombre.contains('nutrastart')) {
      return 'Protein and nutrition';
    }
    if (nombre.contains('glucoach')) return 'Glucose metabolism support';
    if (nombre.contains('bcv')) return 'Cardiovascular wellness';
    if (nombre.contains('malepro')) return 'Men wellness';
    if (nombre.contains('colageno') || nombre.contains('belle vie')) {
      return 'Beauty and connective tissue support';
    }
    if (nombre.contains('bioefa')) return 'Essential fatty acid support';
    if (nombre.contains('fibre') || nombre.contains('preo')) {
      return 'Digestive wellness';
    }
    if (nombre.contains('kbu')) return 'Kidney and urinary wellness';
    if (nombre.contains('vistari')) return 'Vision support';
    if (nombre.contains('renuvo')) return 'Healthy aging support';
    if (nombre.contains('tf boost')) return 'Targeted immune support';
    if (nombre.contains('transfer factor') || nombre.contains('agpro')) {
      return 'Immune system support';
    }
    if (nombre.contains('crema') ||
        nombre.contains('tonico') ||
        nombre.contains('limpiador') ||
        nombre.contains('suero')) {
      return 'Personal care';
    }
    return 'General wellness';
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _encabezado(),
                  const SizedBox(height: 30),
                  _tarjetaSelector(),
                  const SizedBox(height: 16),
                  _comparacionPrincipal(),
                  const SizedBox(height: 16),
                  _tablaMetricas(),
                  const SizedBox(height: 16),
                  _decisionCard(),
                  const SizedBox(height: 16),
                  _acciones(),
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
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A/B Comparator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 9),
              Text(
                'Put two supplements face to face',
                style: TextStyle(
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
            Icons.compare_arrows_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
      ],
    );
  }

  Widget _tarjetaSelector() {
    return _contenedorTarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select two products',
            style: TextStyle(
              color: _azul,
              fontSize: 24,
              height: 1.12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Compare focus, LP, member price, retail price, and decision signals side by side.',
            style: TextStyle(
              color: _texto,
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _selectorProducto(
                  etiqueta: 'Product A',
                  producto: _productoA,
                  onTap: () => _seleccionarProducto(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _selectorProducto(
                  etiqueta: 'Product B',
                  producto: _productoB,
                  onTap: () => _seleccionarProducto(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectorProducto({
    required String etiqueta,
    required ProductoPrecio producto,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 94),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE1E4F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              etiqueta,
              style: const TextStyle(
                color: _azul,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              producto.nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _tinta,
                fontSize: 15,
                height: 1.12,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Row(
              children: [
                Text(
                  'Change',
                  style: TextStyle(
                    color: _texto,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 3),
                Icon(Icons.keyboard_arrow_down_rounded,
                    color: _texto, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _comparacionPrincipal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _productoHero(_productoA, 'A')),
        const SizedBox(width: 12),
        Expanded(child: _productoHero(_productoB, 'B')),
      ],
    );
  }

  Widget _productoHero(ProductoPrecio producto, String etiqueta) {
    return _contenedorTarjeta(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE9EAFF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Product $etiqueta',
                style: const TextStyle(
                  color: _azul,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 126,
            child: Image.asset(
              imagenesProducto4Life[producto.nombre] ?? '',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.inventory_2_outlined, size: 76),
              filterQuality: FilterQuality.high,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            producto.nombre,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _tinta,
              fontSize: 16,
              height: 1.15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _enfoqueProducto(producto),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _texto,
              fontSize: 13,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tablaMetricas() {
    return _contenedorTarjeta(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Side-by-side table',
            style: TextStyle(
              color: _azul,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          _filaMetrica('Wellness focus', _enfoqueProducto(_productoA),
              _enfoqueProducto(_productoB)),
          _filaMetrica('Member price', _precio(_productoA.afiliado),
              _precio(_productoB.afiliado)),
          _filaMetrica('Retail price', _precio(_productoA.publico),
              _precio(_productoB.publico)),
          _filaMetrica('LP', '${_productoA.lp ?? 0}', '${_productoB.lp ?? 0}'),
          _filaMetrica('LP per member dollar', _lpPorDolar(_productoA),
              _lpPorDolar(_productoB)),
        ],
      ),
    );
  }

  Widget _filaMetrica(String etiqueta, String valorA, String valorB) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E4F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: const TextStyle(
              color: _azul,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _valorMetrica('A', valorA)),
              const SizedBox(width: 10),
              Expanded(child: _valorMetrica('B', valorB)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _valorMetrica(String etiqueta, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE9EAFF),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            etiqueta,
            style: const TextStyle(
              color: _azul,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            valor,
            style: const TextStyle(
              color: _tinta,
              fontSize: 14,
              height: 1.22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _decisionCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE5FF), width: 1.4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: _azul,
            child: Icon(Icons.track_changes_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick decision',
                  style: TextStyle(
                    color: _azul,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _decisionRapida(),
                  style: const TextStyle(
                    color: _tinta,
                    fontSize: 15,
                    height: 1.32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _acciones() {
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
            child: _accion(
              icono: Icons.copy_rounded,
              texto: 'Copy',
              onTap: _copiarComparacion,
            ),
          ),
          Container(width: 1, height: 42, color: const Color(0xFFE0E3EF)),
          Expanded(
            child: _accion(
              icono: Icons.share_rounded,
              texto: 'Share',
              onTap: _compartirComparacion,
            ),
          ),
        ],
      ),
    );
  }

  Widget _accion({
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

class _SelectorProductoAB extends StatefulWidget {
  final ProductoPrecio seleccionado;

  const _SelectorProductoAB({required this.seleccionado});

  @override
  State<_SelectorProductoAB> createState() => _SelectorProductoABState();
}

class _SelectorProductoABState extends State<_SelectorProductoAB> {
  final TextEditingController _controller = TextEditingController();
  String _busqueda = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<ProductoPrecio> get _productos {
    final busqueda = normalizarTexto(_busqueda);
    final productos = [...productosConPrecio4Life]
      ..sort((a, b) => a.nombre.compareTo(b.nombre));
    if (busqueda.isEmpty) return productos;
    return productos
        .where(
            (producto) => normalizarTexto(producto.nombre).contains(busqueda))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 18,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD8DCEB),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 18),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose supplement',
                style: TextStyle(
                  color: Color(0xFF172394),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              onChanged: (valor) => setState(() => _busqueda = valor),
              decoration: InputDecoration(
                hintText: 'Search product',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _busqueda.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _controller.clear();
                          setState(() => _busqueda = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFFD6D9E6), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFF172394), width: 1.7),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _productos.length,
                itemBuilder: (context, index) {
                  final producto = _productos[index];
                  final seleccionado =
                      producto.nombre == widget.seleccionado.nombre;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    leading: SizedBox(
                      width: 48,
                      height: 48,
                      child: Image.asset(
                        imagenesProducto4Life[producto.nombre] ?? '',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.inventory_2_outlined),
                      ),
                    ),
                    title: Text(
                      producto.nombre,
                      style: const TextStyle(
                        color: Color(0xFF111B59),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: Text(
                      'Member \$${producto.afiliado.toStringAsFixed(2)} | LP ${producto.lp ?? 0}',
                    ),
                    trailing: seleccionado
                        ? const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF10A884))
                        : const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.pop(context, producto),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
