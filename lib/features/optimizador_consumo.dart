part of '../main.dart';

class PaginaOptimizadorConsumo extends StatefulWidget {
  const PaginaOptimizadorConsumo({super.key});

  @override
  State<PaginaOptimizadorConsumo> createState() =>
      _PaginaOptimizadorConsumoState();
}

class _PaginaOptimizadorConsumoState extends State<PaginaOptimizadorConsumo> {
  final TextEditingController _metaController =
      TextEditingController(text: '150');
  List<PaqueteConsumo> _paquetes = [];
  List<ProductoPrecio> _productosObligatorios = [];
  int _variacionPaquetes = 0;

  static const Color _azul = Color(0xFF172394);
  static const Color _azulOscuro = Color(0xFF07125E);
  static const Color _tinta = Color(0xFF111B59);
  static const Color _texto = Color(0xFF465074);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _generarPaquetes());
  }

  @override
  void dispose() {
    _metaController.dispose();
    super.dispose();
  }

  int get _metaLp => int.tryParse(_metaController.text.trim()) ?? 150;
  String _t(String es, String en) => txtApp(es, en);

  Future<bool> _confirmarExceso150() async {
    final meta = _metaLp;
    final lpFijo = _productosObligatorios.fold<int>(
      0,
      (total, producto) => total + (producto.lp ?? 0),
    );
    if (meta <= 150 && lpFijo <= 150) return true;

    final continuar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_t('Se paso de 150 LP', 'Over 150 LP')),
        content: Text(
          _t(
            'La meta o los productos escogidos superan los 150 LP. Estas seguro de continuar?',
            'The goal or selected products are over 150 LP. Are you sure you want to continue?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_t('Cancelar', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_t('Continuar', 'Continue')),
          ),
        ],
      ),
    );
    return continuar ?? false;
  }

  Future<void> _generarPaquetesDesdeBoton() async {
    if (!await _confirmarExceso150()) return;
    _variacionPaquetes++;
    _generarPaquetes();
  }

  void _generarPaquetes() {
    final meta = _metaLp.clamp(1, 999).toInt();
    final paquetes = _OptimizadorConsumo.generar(
      meta,
      obligatorios: _productosObligatorios,
      variacion: _variacionPaquetes,
    );
    setState(() => _paquetes = paquetes);

    unawaited(ImpactoService.registrar(
      tipo: 'optimizador_consumo',
      titulo: _t('Optimizador de consumo', 'Consumption Block Optimizer'),
      guardarEnFirebase: false,
      datos: {
        'metaLp': meta,
        'obligatorios':
            _productosObligatorios.map((producto) => producto.nombre).toList(),
        'paquetes': paquetes
            .map((paquete) => {
                  'lp': paquete.totalLp,
                  'productos': paquete.lineas
                      .map((linea) => {
                            'nombre': linea.producto.nombre,
                            'cantidad': linea.cantidad,
                          })
                      .toList(),
                })
            .toList(),
      },
    ));
  }

  void _ajustarMeta(int cambio) {
    final nuevaMeta = (_metaLp + cambio).clamp(1, 999).toInt();
    _metaController.text = nuevaMeta.toString();
    _generarPaquetes();
  }

  Future<void> _escogerProductosObligatorios() async {
    final seleccion = await showModalBottomSheet<List<ProductoPrecio>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _SelectorProductosObligatorios(
        seleccionados: _productosObligatorios,
        titulo: _t('Productos obligatorios', 'Required products'),
        buscar: _t('Buscar producto', 'Search product'),
        ayuda: _t(
          'Escoge hasta 3 productos para incluirlos en todos los planes.',
          'Choose up to 3 products to include in every plan.',
        ),
        limpiar: _t('Limpiar', 'Clear'),
        aplicar: _t('Aplicar', 'Apply'),
        maximoTexto: _t('Maximo 3 productos', 'Maximum 3 products'),
        afiliado: _t('Afiliado', 'Member'),
      ),
    );
    if (seleccion == null) return;
    setState(() => _productosObligatorios = seleccion);
    _generarPaquetes();
  }

  Future<void> _copiarPaquete(PaqueteConsumo paquete) async {
    await Clipboard.setData(ClipboardData(text: _textoPaquete(paquete)));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(_t('Paquete maestro copiado', 'Master pack copied'))),
    );
  }

  Future<void> _compartirPaquete(PaqueteConsumo paquete) {
    final fecha = DateTime.now();
    return ServicioCompartir.mostrarOpciones(
      context,
      DocumentoCompartible(
        titulo: _t(
          'PAQUETE MAESTRO DE CONSUMO 4LIFE',
          '4LIFE MASTER CONSUMPTION PACK',
        ),
        nombreArchivo: _t(
          'PAQUETE MAESTRO DE CONSUMO 4LIFE',
          '4LIFE MASTER CONSUMPTION PACK',
        ),
        texto: _textoPaquete(paquete),
        fecha: fecha,
        secciones: [
          SeccionDocumento(
            titulo: _t('Meta de consumo', 'Consumption goal'),
            contenido:
                '${_t('Meta mínima de LP', 'Minimum LP goal')}: ${paquete.metaLp}\n'
                '${_t('LP del paquete', 'Pack LP')}: ${paquete.totalLp}\n'
                '${_t('LP sobre la meta', 'LP above goal')}: ${paquete.excedenteLp}\n'
                '${_t('Total afiliado', 'Member total')}: ${_precio(paquete.totalAfiliado)}\n'
                '${_t('Total público', 'Retail total')}: ${_precio(paquete.totalPublico)}',
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
                  '${_t('Público', 'Retail')}: ${_precio(linea.producto.publico * linea.cantidad)}',
                ],
              ),
            )
            .toList(),
      ),
      ingles: IdiomaService.actual.value == IdiomaApp.ingles,
    );
  }

  String _textoPaquete(PaqueteConsumo paquete) {
    final buffer = StringBuffer(
      '${_t('Paquete maestro de consumo 4Life', '4Life Master Consumption Pack')}\n\n',
    );
    buffer.writeln(
        '${_t('Meta mínima de LP', 'Minimum LP goal')}: ${paquete.metaLp}');
    buffer.writeln('${_t('LP del paquete', 'Pack LP')}: ${paquete.totalLp}');
    buffer.writeln(
        '${_t('LP sobre la meta', 'LP above goal')}: ${paquete.excedenteLp}\n');
    for (final linea in paquete.lineas) {
      buffer.writeln('${linea.cantidad} x ${linea.producto.nombre}');
      buffer.writeln('LP: ${(linea.producto.lp ?? 0) * linea.cantidad}');
      buffer.writeln(
          '${_t('Afiliado', 'Member')}: ${_precio(linea.producto.afiliado * linea.cantidad)}');
      buffer.writeln(
          '${_t('Público', 'Retail')}: ${_precio(linea.producto.publico * linea.cantidad)}\n');
    }
    buffer.writeln(
        '${_t('Total afiliado', 'Member total')}: ${_precio(paquete.totalAfiliado)}');
    buffer.writeln(
        '${_t('Total público', 'Retail total')}: ${_precio(paquete.totalPublico)}');
    return buffer.toString();
  }

  String _precio(double valor) => '\$${valor.toStringAsFixed(2)}';

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
                  _tarjetaMeta(),
                  const SizedBox(height: 18),
                  _tarjetaProductosObligatorios(),
                  const SizedBox(height: 18),
                  _tarjetaResumen(),
                  const SizedBox(height: 18),
                  for (var i = 0; i < _paquetes.length; i++) ...[
                    _tarjetaPaquete(_paquetes[i], i + 1),
                    const SizedBox(height: 14),
                  ],
                  _tarjetaNota(),
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
                _t('Optimizador de consumo', 'Consumption Block Optimizer'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                _t(
                  'Calculadora inversa para paquetes maestros predecibles',
                  'Reverse calculator for predictable master packs',
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
            Icons.view_module_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
      ],
    );
  }

  Widget _tarjetaMeta() {
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
                      _t('Define la meta de LP', 'Set the LP goal'),
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
                        'Ingresa el volumen mínimo y genera paquetes alineados matemáticamente para duplicación.',
                        'Enter the minimum volume and generate mathematically aligned packs for duplication.',
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
              _medidorLp(),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _botonPaso(Icons.remove_rounded, () => _ajustarMeta(-10)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _metaController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _generarPaquetes(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _tinta,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                  decoration: InputDecoration(
                    suffixText: 'LP',
                    suffixStyle: const TextStyle(
                      color: _azul,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFD1D5E3),
                        width: 1.4,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _azul, width: 1.7),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _botonPaso(Icons.add_rounded, () => _ajustarMeta(10)),
            ],
          ),
          const SizedBox(height: 18),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _generarPaquetesDesdeBoton,
            child: Container(
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_azul, _azulOscuro]),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: _azulOscuro.withValues(alpha: 0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded,
                      color: Colors.white, size: 31),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _t('Generar paquetes maestros', 'Generate master packs'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: Colors.white, size: 34),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _medidorLp() {
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
            '${_metaLp.clamp(1, 999)}',
            style: const TextStyle(
              color: _azul,
              fontSize: 25,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _t('META LP', 'LP GOAL'),
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

  Widget _botonPaso(IconData icono, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFECEEFF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(icono, color: _azul, size: 28),
      ),
    );
  }

  Widget _tarjetaProductosObligatorios() {
    final resumen = _productosObligatorios.isEmpty
        ? _t('Sin productos fijos: el optimizador elegirá el mejor plan.',
            'No fixed products: the optimizer will choose the best plan.')
        : _productosObligatorios.map((producto) => producto.nombre).join(' + ');
    final lpFijo = _productosObligatorios.fold<int>(
      0,
      (total, producto) => total + (producto.lp ?? 0),
    );

    return _contenedorTarjeta(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _t('Productos obligatorios', 'Required products'),
                  style: const TextStyle(
                    color: _azul,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _escogerProductosObligatorios,
                icon: const Icon(Icons.tune_rounded),
                label: Text(_t('Escoger', 'Choose')),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            resumen,
            style: const TextStyle(
              color: _tinta,
              fontSize: 15,
              height: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _datoPaquete(_t('LP fijo', 'Fixed LP'), '$lpFijo'),
        ],
      ),
    );
  }

  Widget _tarjetaResumen() {
    final mejor = _paquetes.isEmpty ? null : _paquetes.first;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE5FF), width: 1.4),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: _azul,
            child: Icon(Icons.track_changes_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              mejor == null
                  ? _t(
                      'Ingresa una meta válida para generar paquetes.',
                      'Enter a valid goal to generate packs.',
                    )
                  : _t(
                      'Mejor opción: ${mejor.totalLp} LP con ${mejor.excedenteLp} LP sobre la meta.',
                      'Best match: ${mejor.totalLp} LP with ${mejor.excedenteLp} LP above goal.',
                    ),
              style: const TextStyle(
                color: _tinta,
                fontSize: 16,
                height: 1.3,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaPaquete(PaqueteConsumo paquete, int indice) {
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
                      _t('Paquete maestro $indice', 'Master Pack $indice'),
                      style: const TextStyle(
                        color: _azul,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _t(
                        '${paquete.lineas.length} productos maximo para ${paquete.metaLp}+ LP',
                        '${paquete.lineas.length} products max for ${paquete.metaLp}+ LP',
                      ),
                      style: const TextStyle(
                        color: _texto,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _chipLp(paquete),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _datoPaquete(
                  _t('Afiliado', 'Member'), _precio(paquete.totalAfiliado)),
              _datoPaquete(
                  _t('Público', 'Retail'), _precio(paquete.totalPublico)),
              _datoPaquete(
                  _t('LP extra', 'Extra LP'), '${paquete.excedenteLp}'),
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

  Widget _chipLp(PaqueteConsumo paquete) {
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

  Widget _tarjetaNota() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E6EF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: _azul, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _t(
                'Estos paquetes son referencias de planificación basadas en la lista actual de productos, precios y valores LP de la app.',
                'These packs are planning references based on the current product list, prices, and LP values in the app.',
              ),
              style: const TextStyle(
                color: _texto,
                fontSize: 14,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
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

class PaqueteConsumo {
  final int metaLp;
  final List<LineaProductoPrecio> lineas;

  const PaqueteConsumo({
    required this.metaLp,
    required this.lineas,
  });

  int get totalLp => lineas.fold(
        0,
        (total, linea) => total + ((linea.producto.lp ?? 0) * linea.cantidad),
      );

  int get excedenteLp => totalLp - metaLp;

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

class _OptimizadorConsumo {
  static List<PaqueteConsumo> generar(
    int metaLp, {
    List<ProductoPrecio> obligatorios = const [],
    int variacion = 0,
  }) {
    final productos = productosConPrecio4Life
        .where((producto) => (producto.lp ?? 0) > 0)
        .toList()
      ..sort((a, b) => (b.lp ?? 0).compareTo(a.lp ?? 0));
    final obligatoriosUnicos = <String, ProductoPrecio>{};
    for (final producto in obligatorios) {
      if ((producto.lp ?? 0) > 0) {
        obligatoriosUnicos[producto.nombre] = producto;
      }
    }
    final baseLineas = obligatoriosUnicos.values
        .map((producto) => LineaProductoPrecio(producto: producto, cantidad: 1))
        .toList();
    final baseLp = baseLineas.fold<int>(
      0,
      (total, linea) => total + (linea.producto.lp ?? 0),
    );
    final maxLp =
        (metaLp + 24).clamp(metaLp > baseLp ? metaLp : baseLp, 1024).toInt();
    final mejoresPorLp = <int, List<LineaProductoPrecio>>{
      baseLp: baseLineas,
    };

    for (final producto in productos) {
      final lp = producto.lp ?? 0;
      final snapshot = Map<int, List<LineaProductoPrecio>>.from(mejoresPorLp);

      for (final entry in snapshot.entries) {
        for (var cantidad = 1; cantidad <= 5; cantidad++) {
          final nuevoLp = entry.key + (lp * cantidad);
          if (nuevoLp > maxLp) continue;

          final lineas = _compactarLineas([
            ...entry.value,
            LineaProductoPrecio(producto: producto, cantidad: cantidad),
          ]);
          if (_cantidadProductosDistintos(lineas) > 3) continue;
          final actual = mejoresPorLp[nuevoLp];
          if (actual == null || _esMejor(lineas, actual)) {
            mejoresPorLp[nuevoLp] = lineas;
          }
        }
      }
    }

    final paquetes = mejoresPorLp.entries
        .where((entry) => entry.key >= metaLp && entry.value.isNotEmpty)
        .map(
          (entry) => PaqueteConsumo(
            metaLp: metaLp,
            lineas: _ordenarLineas(entry.value),
          ),
        )
        .toList()
      ..sort(_compararPaquetes);

    return _diversificar(paquetes, variacion: variacion).take(4).toList();
  }

  static int _cantidadProductosDistintos(List<LineaProductoPrecio> lineas) {
    return lineas.map((linea) => linea.producto.nombre).toSet().length;
  }

  static bool _esMejor(
    List<LineaProductoPrecio> candidato,
    List<LineaProductoPrecio> actual,
  ) {
    final cantidadCandidato =
        candidato.fold(0, (total, linea) => total + linea.cantidad);
    final cantidadActual =
        actual.fold(0, (total, linea) => total + linea.cantidad);
    if (cantidadCandidato != cantidadActual) {
      return cantidadCandidato < cantidadActual;
    }

    final costoCandidato = candidato.fold(
      0.0,
      (total, linea) => total + (linea.producto.afiliado * linea.cantidad),
    );
    final costoActual = actual.fold(
      0.0,
      (total, linea) => total + (linea.producto.afiliado * linea.cantidad),
    );
    return costoCandidato < costoActual;
  }

  static int _compararPaquetes(PaqueteConsumo a, PaqueteConsumo b) {
    final excedente = a.excedenteLp.compareTo(b.excedenteLp);
    if (excedente != 0) return excedente;
    final lineas = a.lineas.length.compareTo(b.lineas.length);
    if (lineas != 0) return lineas;
    final cantidad = a.cantidadProductos.compareTo(b.cantidadProductos);
    if (cantidad != 0) return cantidad;
    return a.totalAfiliado.compareTo(b.totalAfiliado);
  }

  static List<LineaProductoPrecio> _ordenarLineas(
      List<LineaProductoPrecio> lineas) {
    final ordenadas = [...lineas]..sort(
        (a, b) => (b.producto.lp ?? 0).compareTo(a.producto.lp ?? 0),
      );
    return ordenadas;
  }

  static List<LineaProductoPrecio> _compactarLineas(
      List<LineaProductoPrecio> lineas) {
    final porProducto = <String, LineaProductoPrecio>{};
    for (final linea in lineas) {
      final actual = porProducto[linea.producto.nombre];
      porProducto[linea.producto.nombre] = LineaProductoPrecio(
        producto: linea.producto,
        cantidad: (actual?.cantidad ?? 0) + linea.cantidad,
      );
    }
    return porProducto.values.toList();
  }

  static List<PaqueteConsumo> _diversificar(
    List<PaqueteConsumo> paquetes, {
    required int variacion,
  }) {
    final seleccionados = <PaqueteConsumo>[];
    final firmas = <String>{};
    if (paquetes.isEmpty) return seleccionados;

    final ventana = paquetes.take(24).toList();
    final inicio = ventana.isEmpty ? 0 : variacion.abs() % ventana.length;
    final orden = [
      ...ventana.skip(inicio),
      ...ventana.take(inicio),
      ...paquetes.skip(ventana.length),
    ];

    for (final paquete in orden) {
      final firma = paquete.lineas
          .map((linea) => '${linea.producto.nombre}:${linea.cantidad}')
          .join('|');
      if (firmas.add(firma)) {
        seleccionados.add(paquete);
      }
      if (seleccionados.length >= 4) break;
    }

    return seleccionados;
  }
}

class _SelectorProductosObligatorios extends StatefulWidget {
  final List<ProductoPrecio> seleccionados;
  final String titulo;
  final String buscar;
  final String ayuda;
  final String limpiar;
  final String aplicar;
  final String maximoTexto;
  final String afiliado;

  const _SelectorProductosObligatorios({
    required this.seleccionados,
    required this.titulo,
    required this.buscar,
    required this.ayuda,
    required this.limpiar,
    required this.aplicar,
    required this.maximoTexto,
    required this.afiliado,
  });

  @override
  State<_SelectorProductosObligatorios> createState() =>
      _SelectorProductosObligatoriosState();
}

class _SelectorProductosObligatoriosState
    extends State<_SelectorProductosObligatorios> {
  final TextEditingController _controller = TextEditingController();
  late final Set<String> _seleccionados =
      widget.seleccionados.map((producto) => producto.nombre).toSet();
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
          (producto) => normalizarTexto(producto.nombre).contains(busqueda),
        )
        .toList();
  }

  void _alternar(ProductoPrecio producto) {
    setState(() {
      if (_seleccionados.contains(producto.nombre)) {
        _seleccionados.remove(producto.nombre);
      } else if (_seleccionados.length < 3) {
        _seleccionados.add(producto.nombre);
      }
    });
  }

  void _aplicar() {
    final seleccion = productosConPrecio4Life
        .where((producto) => _seleccionados.contains(producto.nombre))
        .toList();
    Navigator.pop(context, seleccion);
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.titulo,
                style: const TextStyle(
                  color: Color(0xFF172394),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.ayuda,
                style: const TextStyle(
                  color: Color(0xFF465074),
                  fontSize: 14,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              onChanged: (valor) => setState(() => _busqueda = valor),
              decoration: InputDecoration(
                hintText: widget.buscar,
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
            const SizedBox(height: 10),
            if (_seleccionados.length >= 3)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.maximoTexto,
                  style: const TextStyle(
                    color: Color(0xFF9A5A00),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _productos.length,
                itemBuilder: (context, index) {
                  final producto = _productos[index];
                  final seleccionado = _seleccionados.contains(producto.nombre);
                  return CheckboxListTile(
                    value: seleccionado,
                    onChanged: (_) => _alternar(producto),
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      producto.nombre,
                      style: const TextStyle(
                        color: Color(0xFF111B59),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: Text(
                      '${widget.afiliado} \$${producto.afiliado.toStringAsFixed(2)} | LP ${producto.lp ?? 0}',
                    ),
                    secondary: SizedBox(
                      width: 46,
                      height: 46,
                      child: Image.asset(
                        imagenesProducto4Life[producto.nombre] ?? '',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.inventory_2_outlined),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(_seleccionados.clear);
                    },
                    child: Text(widget.limpiar),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _aplicar,
                    child: Text(widget.aplicar),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
