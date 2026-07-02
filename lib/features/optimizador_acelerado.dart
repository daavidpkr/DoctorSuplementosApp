part of '../main.dart';

class PaginaOptimizadorAcelerado extends StatefulWidget {
  const PaginaOptimizadorAcelerado({super.key});

  @override
  State<PaginaOptimizadorAcelerado> createState() =>
      _PaginaOptimizadorAceleradoState();
}

class _PaginaOptimizadorAceleradoState
    extends State<PaginaOptimizadorAcelerado> {
  static const int _metaLp = 400;
  static const Color _azul = Color(0xFF172394);
  static const Color _azulOscuro = Color(0xFF07125E);
  static const Color _tinta = Color(0xFF111B59);
  static const Color _texto = Color(0xFF465074);

  late final List<PaqueteAcelerado> _predeterminados;
  late List<PaqueteAcelerado> _sugeridos;
  int? _seleccionado;
  int _variacion = 0;

  @override
  void initState() {
    super.initState();
    _predeterminados = _crearPredeterminados();
    _sugeridos = _crearSugeridos();
  }

  String _t(String es, String en) => txtApp(es, en);
  String _precio(double valor) => '\$${valor.toStringAsFixed(2)}';

  ProductoPrecio _producto(String nombre) {
    return productosConPrecio4Life.firstWhere(
      (producto) => producto.nombre == nombre,
      orElse: () => productosConPrecio4Life.first,
    );
  }

  List<LineaProductoPrecio> _lineas(List<MapEntry<String, int>> items) {
    return items
        .map(
          (item) => LineaProductoPrecio(
            producto: _producto(item.key),
            cantidad: item.value,
          ),
        )
        .toList();
  }

  List<PaqueteAcelerado> _crearPredeterminados() {
    return [
      PaqueteAcelerado(
        nombre: _t('Paquete acelerado 1', 'Accelerated pack 1'),
        metaLp: _metaLp,
        incluyeMochila: true,
        fijo: true,
        lineas: _lineas(const [
          MapEntry('Transfer factor plus', 2),
          MapEntry('Preo biotics', 2),
          MapEntry('Bioefa', 2),
          MapEntry('Riovida stix', 2),
          MapEntry('Glutamine prime', 2),
          MapEntry('Colageno tipo i', 2),
          MapEntry('Renuvo', 1),
          MapEntry('TF Boost', 2),
          MapEntry('Energy go stix', 1),
          MapEntry('Riovida burst', 1),
        ]),
      ),
      PaqueteAcelerado(
        nombre: _t('Paquete acelerado 2', 'Accelerated pack 2'),
        metaLp: _metaLp,
        incluyeMochila: true,
        fijo: true,
        lineas: _lineas(const [
          MapEntry('Transfer factor plus', 5),
          MapEntry('Transfer factor tri factor', 5),
          MapEntry('Riovida burst', 3),
        ]),
      ),
    ];
  }

  List<PaqueteAcelerado> _crearSugeridos() {
    final generados = _OptimizadorConsumo.generar(
      _metaLp,
      variacion: _variacion,
    );
    return [
      for (var i = 0; i < generados.length; i++)
        PaqueteAcelerado(
          nombre: _t('Sugerido ${i + 1}', 'Suggested ${i + 1}'),
          metaLp: _metaLp,
          lineas: generados[i].lineas,
        ),
    ];
  }

  void _variarSugeridos() {
    setState(() {
      _variacion++;
      _sugeridos = _crearSugeridos();
    });
  }

  Future<void> _copiarPaquete(PaqueteAcelerado paquete) async {
    await Clipboard.setData(ClipboardData(text: _textoPaquete(paquete)));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_t('Paquete copiado', 'Pack copied'))),
    );
  }

  Future<void> _compartirPaquete(PaqueteAcelerado paquete) {
    return ServicioCompartir.mostrarOpciones(
      context,
      DocumentoCompartible(
        titulo: _t(
          'PAQUETE ACELERADO 4LIFE',
          '4LIFE ACCELERATED PACK',
        ),
        nombreArchivo: paquete.nombre,
        fecha: DateTime.now(),
        secciones: [
          SeccionDocumento(
            titulo: _t('Resumen del paquete', 'Pack summary'),
            contenido: '${_t('Meta fija', 'Fixed goal')}: $_metaLp LP\n'
                '${_t('LP del paquete', 'Pack LP')}: ${paquete.totalLp}\n'
                '${_t('Total de productos', 'Total products')}: ${paquete.cantidadProductos}\n'
                '${_t('Total afiliado', 'Member total')}: ${_precio(paquete.totalAfiliado)}\n'
                '${_t('Mochila', 'Backpack')}: ${paquete.incluyeMochila ? _t('Incluida', 'Included') : _t('No incluida', 'Not included')}',
          ),
        ],
        productos: paquete.lineas
            .map(
              (linea) => ProductoDocumento(
                nombre: '${linea.cantidad} x ${linea.producto.nombre}',
                imagenAsset: imagenesProducto4Life[linea.producto.nombre],
                indicaciones: [
                  'LP: ${(linea.producto.lp ?? 0) * linea.cantidad}',
                  '${_t('Afiliado', 'Member')}: ${_precio(linea.producto.afiliado * linea.cantidad)}',
                  '${_t('Publico', 'Retail')}: ${_precio(linea.producto.publico * linea.cantidad)}',
                ],
              ),
            )
            .toList(),
      ),
      ingles: IdiomaService.actual.value == IdiomaApp.ingles,
    );
  }

  String _textoPaquete(PaqueteAcelerado paquete) {
    final buffer = StringBuffer('${paquete.nombre}\n\n');
    buffer.writeln('${_t('Meta fija', 'Fixed goal')}: $_metaLp LP');
    buffer.writeln('${_t('LP del paquete', 'Pack LP')}: ${paquete.totalLp}');
    buffer.writeln(
      '${_t('Total de productos', 'Total products')}: ${paquete.cantidadProductos}',
    );
    buffer.writeln(
      '${_t('Mochila', 'Backpack')}: ${paquete.incluyeMochila ? _t('Incluida', 'Included') : _t('No incluida', 'Not included')}\n',
    );
    for (final linea in paquete.lineas) {
      buffer.writeln('${linea.cantidad} x ${linea.producto.nombre}');
      buffer.writeln('LP: ${(linea.producto.lp ?? 0) * linea.cantidad}');
      buffer.writeln(
        '${_t('Afiliado', 'Member')}: ${_precio(linea.producto.afiliado * linea.cantidad)}\n',
      );
    }
    buffer.writeln(
      '${_t('Total afiliado', 'Member total')}: ${_precio(paquete.totalAfiliado)}',
    );
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _encabezado(),
                  const SizedBox(height: 30),
                  _selectorPredeterminados(),
                  if (_seleccionado != null) ...[
                    const SizedBox(height: 16),
                    _tarjetaPaquete(_predeterminados[_seleccionado!]),
                  ],
                  const SizedBox(height: 18),
                  _encabezadoSugeridos(),
                  const SizedBox(height: 12),
                  for (final paquete in _sugeridos) ...[
                    _tarjetaPaquete(paquete),
                    const SizedBox(height: 14),
                  ],
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
                _t(
                  'Optimizador de paquetes acelerados',
                  'Accelerated Pack Optimizer',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                _t(
                  'Meta fija de 400 LP con paquetes predeterminados y sugeridos',
                  'Fixed 400 LP goal with preset and suggested packs',
                ),
                style: const TextStyle(
                  color: Color(0xFFD9DFFF),
                  fontSize: 17,
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
            Icons.rocket_launch_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
      ],
    );
  }

  Widget _selectorPredeterminados() {
    return _contenedorTarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t('Paquetes fijos con mochila', 'Fixed packs with backpack'),
            style: const TextStyle(
              color: _azul,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _t(
              'Estos dos paquetes nunca se mueven y siempre incluyen mochila. Los demas paquetes sugeridos no incluyen mochila.',
              'These two packs never change and always include a backpack. The suggested packs below do not include a backpack.',
            ),
            style: const TextStyle(
              color: _texto,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _botonPredeterminado(0)),
              const SizedBox(width: 10),
              Expanded(child: _botonPredeterminado(1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _botonPredeterminado(int indice) {
    final activo = _seleccionado == indice;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _seleccionado = indice),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        constraints: const BoxConstraints(minHeight: 58),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: activo ? _azul : const Color(0xFFF0F3FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: activo ? _azul : const Color(0xFFDDE3FF)),
        ),
        child: Text(
          _predeterminados[indice].nombre,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: activo ? Colors.white : _azul,
            fontSize: 14,
            height: 1.15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _encabezadoSugeridos() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _t('Paquetes sugeridos de 400 LP', 'Suggested 400 LP packs'),
            style: const TextStyle(
              color: _tinta,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: _variarSugeridos,
          icon: const Icon(Icons.shuffle_rounded),
          label: Text(_t('Variar', 'Vary')),
        ),
      ],
    );
  }

  Widget _tarjetaPaquete(PaqueteAcelerado paquete) {
    return _contenedorTarjeta(
      padding: const EdgeInsets.all(18),
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
                      paquete.nombre,
                      style: const TextStyle(
                        color: _azul,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      paquete.fijo
                          ? _t(
                              'Predeterminado fijo. Incluye mochila.',
                              'Fixed preset. Backpack included.',
                            )
                          : _t(
                              'Sugerencia matematica. No incluye mochila.',
                              'Mathematical suggestion. Backpack not included.',
                            ),
                      style: const TextStyle(
                        color: _texto,
                        fontSize: 14,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _chipLp(paquete),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _datoPaquete(_t('Meta fija', 'Fixed goal'), '$_metaLp LP'),
              _datoPaquete(
                _t('Productos', 'Products'),
                '${paquete.cantidadProductos}',
              ),
              _datoPaquete(
                _t('Mochila', 'Backpack'),
                paquete.incluyeMochila
                    ? _t('Incluida', 'Included')
                    : _t('No incluida', 'Not included'),
              ),
              _datoPaquete(
                _t('Afiliado', 'Member'),
                _precio(paquete.totalAfiliado),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final linea in paquete.lineas) _lineaProducto(linea),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copiarPaquete(paquete),
                  icon: const Icon(Icons.copy_rounded),
                  label: Text(_t('Copiar', 'Copy')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _azul,
                    side: const BorderSide(color: _azul),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _compartirPaquete(paquete),
                  icon: const Icon(Icons.share_rounded),
                  label: Text(_t('Compartir', 'Share')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _azul,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipLp(PaqueteAcelerado paquete) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EAFF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '${paquete.totalLp} LP',
        style: const TextStyle(
          color: _azul,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _datoPaquete(String etiqueta, String valor) {
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

  Widget _lineaProducto(LineaProductoPrecio linea) {
    return Container(
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
            width: 54,
            height: 54,
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
                  '${linea.cantidad} x ${linea.producto.nombre}',
                  style: const TextStyle(
                    color: _tinta,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'LP ${(linea.producto.lp ?? 0) * linea.cantidad}  |  '
                  '${_t('Afiliado', 'Member')} ${_precio(linea.producto.afiliado * linea.cantidad)}',
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

class PaqueteAcelerado {
  final String nombre;
  final int metaLp;
  final List<LineaProductoPrecio> lineas;
  final bool incluyeMochila;
  final bool fijo;

  const PaqueteAcelerado({
    required this.nombre,
    required this.metaLp,
    required this.lineas,
    this.incluyeMochila = false,
    this.fijo = false,
  });

  int get totalLp => lineas.fold(
        0,
        (total, linea) => total + ((linea.producto.lp ?? 0) * linea.cantidad),
      );

  int get cantidadProductos =>
      lineas.fold(0, (total, linea) => total + linea.cantidad);

  double get totalAfiliado => lineas.fold(
        0,
        (total, linea) => total + (linea.producto.afiliado * linea.cantidad),
      );

  double get totalPublico => lineas.fold(
        0,
        (total, linea) => total + (linea.producto.publico * linea.cantidad),
      );
}
