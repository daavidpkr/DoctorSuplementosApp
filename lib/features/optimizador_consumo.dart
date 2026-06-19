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

  void _generarPaquetes() {
    final meta = _metaLp.clamp(1, 999).toInt();
    final paquetes = _OptimizadorConsumo.generar(meta);
    setState(() => _paquetes = paquetes);

    unawaited(ImpactoService.registrar(
      tipo: 'optimizador_consumo',
      titulo: 'Consumption Block Optimizer',
      guardarEnFirebase: false,
      datos: {
        'metaLp': meta,
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

  Future<void> _copiarPaquete(PaqueteConsumo paquete) async {
    await Clipboard.setData(ClipboardData(text: _textoPaquete(paquete)));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Master pack copied')),
    );
  }

  Future<void> _compartirPaquete(PaqueteConsumo paquete) {
    final fecha = DateTime.now();
    return ServicioCompartir.mostrarOpciones(
      context,
      DocumentoCompartible(
        titulo: '4LIFE MASTER CONSUMPTION PACK',
        nombreArchivo: '4LIFE MASTER CONSUMPTION PACK',
        texto: _textoPaquete(paquete),
        fecha: fecha,
        secciones: [
          SeccionDocumento(
            titulo: 'Consumption target',
            contenido: 'Minimum LP target: ${paquete.metaLp}\n'
                'Pack LP: ${paquete.totalLp}\n'
                'LP above target: ${paquete.excedenteLp}\n'
                'Member total: ${_precio(paquete.totalAfiliado)}\n'
                'Retail total: ${_precio(paquete.totalPublico)}',
          ),
        ],
        productos: paquete.lineas
            .map(
              (linea) => ProductoDocumento(
                nombre: '${linea.cantidad} x ${linea.producto.nombre}',
                imagenAsset: imagenesProducto4Life[linea.producto.nombre],
                indicaciones: [
                  'LP: ${(linea.producto.lp ?? 0) * linea.cantidad}',
                  'Member: ${_precio(linea.producto.afiliado * linea.cantidad)}',
                  'Retail: ${_precio(linea.producto.publico * linea.cantidad)}',
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  String _textoPaquete(PaqueteConsumo paquete) {
    final buffer = StringBuffer('4Life Master Consumption Pack\n\n');
    buffer.writeln('Minimum LP target: ${paquete.metaLp}');
    buffer.writeln('Pack LP: ${paquete.totalLp}');
    buffer.writeln('LP above target: ${paquete.excedenteLp}\n');
    for (final linea in paquete.lineas) {
      buffer.writeln('${linea.cantidad} x ${linea.producto.nombre}');
      buffer.writeln('LP: ${(linea.producto.lp ?? 0) * linea.cantidad}');
      buffer.writeln(
          'Member: ${_precio(linea.producto.afiliado * linea.cantidad)}');
      buffer.writeln(
          'Retail: ${_precio(linea.producto.publico * linea.cantidad)}\n');
    }
    buffer.writeln('Member total: ${_precio(paquete.totalAfiliado)}');
    buffer.writeln('Retail total: ${_precio(paquete.totalPublico)}');
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
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Consumption Block Optimizer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 9),
              Text(
                'Reverse calculator for predictable master packs',
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set the LP target',
                      style: TextStyle(
                        color: _azul,
                        fontSize: 24,
                        height: 1.12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Enter the minimum volume and generate mathematically aligned packs for duplication.',
                      style: TextStyle(
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
            onTap: _generarPaquetes,
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
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      color: Colors.white, size: 31),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Generate master packs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
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
          const Text(
            'LP GOAL',
            style: TextStyle(
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
                  ? 'Enter a valid target to generate packs.'
                  : 'Best match: ${mejor.totalLp} LP with ${mejor.excedenteLp} LP above target.',
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
                      'Master Pack $indice',
                      style: const TextStyle(
                        color: _azul,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${paquete.lineas.length} products engineered for ${paquete.metaLp}+ LP',
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
              _datoPaquete('Member', _precio(paquete.totalAfiliado)),
              _datoPaquete('Retail', _precio(paquete.totalPublico)),
              _datoPaquete('Extra LP', '${paquete.excedenteLp}'),
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
                  label: const Text('Copy'),
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
                  label: const Text('Share'),
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
                  'Member ${_precio(linea.producto.afiliado * linea.cantidad)}',
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
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_rounded, color: _azul, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'These packs are planning references based on the current product list, prices, and LP values in the app.',
              style: TextStyle(
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
  static List<PaqueteConsumo> generar(int metaLp) {
    final productos = productosConPrecio4Life
        .where((producto) => (producto.lp ?? 0) > 0)
        .toList()
      ..sort((a, b) => (b.lp ?? 0).compareTo(a.lp ?? 0));
    final maxLp = (metaLp + 24).clamp(metaLp, 1024).toInt();
    final mejoresPorLp = <int, List<LineaProductoPrecio>>{0: []};

    for (final producto in productos) {
      final lp = producto.lp ?? 0;
      final snapshot = Map<int, List<LineaProductoPrecio>>.from(mejoresPorLp);

      for (final entry in snapshot.entries) {
        for (var cantidad = 1; cantidad <= 5; cantidad++) {
          final nuevoLp = entry.key + (lp * cantidad);
          if (nuevoLp > maxLp) continue;

          final lineas = [
            ...entry.value,
            LineaProductoPrecio(producto: producto, cantidad: cantidad),
          ];
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

    return _diversificar(paquetes).take(4).toList();
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

  static List<PaqueteConsumo> _diversificar(List<PaqueteConsumo> paquetes) {
    final seleccionados = <PaqueteConsumo>[];
    final firmas = <String>{};

    for (final paquete in paquetes) {
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
