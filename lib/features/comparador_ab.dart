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
      (producto) => producto.nombre == 'Transfer factor MAX',
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
      SnackBar(content: Text(_t('Comparación copiada', 'Comparison copied'))),
    );
  }

  Future<void> _compartirComparacion() {
    final fecha = DateTime.now();
    return ServicioCompartir.mostrarOpciones(
      context,
      DocumentoCompartible(
        titulo: _t(
          'COMPARACIÓN A/B DE SUPLEMENTOS 4LIFE',
          '4LIFE A/B SUPPLEMENT COMPARISON',
        ),
        nombreArchivo: _t(
          'COMPARACIÓN A B 4LIFE',
          '4LIFE A B COMPARISON',
        ),
        fecha: fecha,
        secciones: [
          SeccionDocumento(
            titulo: _t('Decisión rápida', 'Quick decision'),
            contenido: _decisionRapida(),
          ),
        ],
        productos: [_productoA, _productoB]
            .map(
              (producto) => ProductoDocumento(
                nombre: producto.nombre,
                imagenAsset: imagenesProducto4Life[producto.nombre],
                indicaciones: [
                  '${_t('Enfoque', 'Focus')}: ${_enfoqueProducto(producto)}',
                  '${_t('Calidad principal', 'Main quality')}: ${_senalCalidad(producto)}',
                  '${_t('Especializacion', 'Specialization')}: ${_nivelEspecializacion(producto)}',
                  '${_t('Formato', 'Format')}: ${_formatoProducto(producto)}',
                ],
              ),
            )
            .toList(),
      ),
      ingles: IdiomaService.actual.value == IdiomaApp.ingles,
    );
  }

  String _textoComparacion() {
    final buffer = StringBuffer(
      '${_t('Comparación A/B de suplementos 4Life', '4Life A/B Supplement Comparison')}\n\n',
    );
    buffer.writeln('${_t('Producto A', 'Product A')}: ${_productoA.nombre}');
    buffer
        .writeln('${_t('Enfoque', 'Focus')}: ${_enfoqueProducto(_productoA)}');
    buffer.writeln(
        '${_t('Calidad principal', 'Main quality')}: ${_senalCalidad(_productoA)}');
    buffer.writeln(
        '${_t('Especializacion', 'Specialization')}: ${_nivelEspecializacion(_productoA)}');
    buffer
        .writeln('${_t('Formato', 'Format')}: ${_formatoProducto(_productoA)}');
    buffer.writeln(
        '${_t('Componentes', 'Components')}: ${_componentesProducto(_productoA)}');
    buffer.writeln(
        '${_t('Como funciona', 'How it works')}: ${_funcionProducto(_productoA)}');
    buffer.writeln();
    buffer.writeln('${_t('Producto B', 'Product B')}: ${_productoB.nombre}');
    buffer
        .writeln('${_t('Enfoque', 'Focus')}: ${_enfoqueProducto(_productoB)}');
    buffer.writeln(
        '${_t('Calidad principal', 'Main quality')}: ${_senalCalidad(_productoB)}');
    buffer.writeln(
        '${_t('Especializacion', 'Specialization')}: ${_nivelEspecializacion(_productoB)}');
    buffer
        .writeln('${_t('Formato', 'Format')}: ${_formatoProducto(_productoB)}');
    buffer.writeln(
        '${_t('Componentes', 'Components')}: ${_componentesProducto(_productoB)}');
    buffer.writeln(
        '${_t('Como funciona', 'How it works')}: ${_funcionProducto(_productoB)}');
    buffer.writeln();
    buffer.writeln(
        '${_t('Decisión rápida', 'Quick decision')}: ${_decisionRapida()}');
    buffer.writeln(
        '\n${_t('Lectura comparativa', 'Comparative reading')}: ${_lecturaComparativa()}');
    return buffer.toString();
  }

  String _t(String es, String en) => txtApp(es, en);

  InformacionProductoCatalogo _informacion(ProductoPrecio producto) =>
      informacionProductoCatalogo(producto.nombre);

  String _limpiarDetalle(String texto) => texto
      .split('\n')
      .map((linea) => linea.replaceFirst(RegExp(r'^\s*[-•]\s*'), '').trim())
      .where((linea) => linea.isNotEmpty)
      .join(' ');

  String _componentesProducto(ProductoPrecio producto) =>
      _limpiarDetalle(_informacion(producto).componentes);

  String _funcionProducto(ProductoPrecio producto) =>
      _limpiarDetalle(_informacion(producto).descripcion);

  String _usoProducto(ProductoPrecio producto) =>
      _limpiarDetalle(_informacion(producto).uso);

  String _decisionRapida() {
    if (_productoA.nombre == _productoB.nombre) {
      return _t(
        'Seleccionaste el mismo producto en A y B: su formula, funcionamiento y uso son iguales. Cambia uno para obtener una comparacion real.',
        'You selected the same product for A and B: formula, function, and use are identical. Change one to get a real comparison.',
      );
    }
    if (_enfoqueProducto(_productoA) != _enfoqueProducto(_productoB)) {
      return _t(
        '${_productoA.nombre} conviene cuando se busca ${_enfoqueProducto(_productoA).toLowerCase()}, porque su formula se orienta a: ${_funcionProducto(_productoA)} En cambio, ${_productoB.nombre} conviene para ${_enfoqueProducto(_productoB).toLowerCase()}, porque: ${_funcionProducto(_productoB)}',
        '${_productoA.nombre} fits ${_enfoqueProducto(_productoA).toLowerCase()} because its formula is designed for: ${_funcionProducto(_productoA)} By contrast, ${_productoB.nombre} fits ${_enfoqueProducto(_productoB).toLowerCase()} because: ${_funcionProducto(_productoB)}',
      );
    }
    final calidadA = _pesoCalidad(_productoA);
    final calidadB = _pesoCalidad(_productoB);
    if (calidadA > calidadB) {
      return _t(
        '${_productoA.nombre} es la opcion mas especializada para este objetivo porque ${_funcionProducto(_productoA).toLowerCase()} y contiene ${_componentesProducto(_productoA)} ${_productoB.nombre} ofrece un apoyo mas amplio basado en ${_componentesProducto(_productoB)}',
        '${_productoA.nombre} is the more specialized option for this goal because ${_funcionProducto(_productoA).toLowerCase()} and contains ${_componentesProducto(_productoA)} ${_productoB.nombre} offers broader support based on ${_componentesProducto(_productoB)}',
      );
    }
    if (calidadB > calidadA) {
      return _t(
        '${_productoB.nombre} es la opcion mas especializada para este objetivo porque ${_funcionProducto(_productoB).toLowerCase()} y contiene ${_componentesProducto(_productoB)} ${_productoA.nombre} ofrece un apoyo mas amplio basado en ${_componentesProducto(_productoA)}',
        '${_productoB.nombre} is the more specialized option for this goal because ${_funcionProducto(_productoB).toLowerCase()} and contains ${_componentesProducto(_productoB)} ${_productoA.nombre} offers broader support based on ${_componentesProducto(_productoA)}',
      );
    }
    return _t(
      'Ambos cubren un enfoque parecido, pero no son iguales: ${_productoA.nombre} se diferencia por ${_componentesProducto(_productoA)}, mientras ${_productoB.nombre} incorpora ${_componentesProducto(_productoB)}. Decide segun el objetivo y el uso indicado de cada formula.',
      'Both cover a similar focus, but they are not identical: ${_productoA.nombre} differs through ${_componentesProducto(_productoA)}, while ${_productoB.nombre} includes ${_componentesProducto(_productoB)}. Decide according to the goal and intended use of each formula.',
    );
  }

  String _lecturaComparativa() {
    if (_productoA.nombre == _productoB.nombre) return _decisionRapida();
    return _t(
      '${_productoA.nombre}: ${_funcionProducto(_productoA)} Sus componentes son ${_componentesProducto(_productoA)} Su uso recomendado es: ${_usoProducto(_productoA)}\n\n${_productoB.nombre}: ${_funcionProducto(_productoB)} Sus componentes son ${_componentesProducto(_productoB)} Su uso recomendado es: ${_usoProducto(_productoB)}\n\nLa diferencia practica esta en el objetivo de cada formula, sus componentes y la forma en que se integra a la rutina; no solamente en que sus nombres o formatos sean distintos.',
      '${_productoA.nombre}: ${_funcionProducto(_productoA)} Its components are ${_componentesProducto(_productoA)} Intended use: ${_usoProducto(_productoA)}\n\n${_productoB.nombre}: ${_funcionProducto(_productoB)} Its components are ${_componentesProducto(_productoB)} Intended use: ${_usoProducto(_productoB)}\n\nThe practical difference lies in each formula goal, its components, and how it fits the routine—not merely in different names or formats.',
    );
  }

  int _pesoCalidad(ProductoPrecio producto) {
    final nivel = _nivelEspecializacion(producto);
    if (nivel == _t('Muy especifico', 'Highly specific')) return 3;
    if (nivel == _t('Especifico', 'Specific')) return 2;
    return 1;
  }

  String _senalCalidad(ProductoPrecio producto) {
    final nombre = normalizarTexto(producto.nombre);
    if (nombre.contains('max') ||
        nombre.contains('tri factor') ||
        nombre.contains('glucoach') ||
        nombre.contains('bcv') ||
        nombre.contains('malepro')) {
      return _t('Soporte especializado', 'Specialized support');
    }
    if (nombre.contains('plus') ||
        nombre.contains('riovida') ||
        nombre.contains('protf') ||
        nombre.contains('collagen') ||
        nombre.contains('colageno')) {
      return _t('Soporte principal de rutina', 'Primary routine support');
    }
    if (nombre.contains('stix') ||
        nombre.contains('go') ||
        nombre.contains('burst')) {
      return _t('Soporte practico y portatil', 'Practical portable support');
    }
    return _t('Soporte complementario', 'Complementary support');
  }

  String _nivelEspecializacion(ProductoPrecio producto) {
    final enfoque = _enfoqueProducto(producto);
    if (enfoque == _t('Bienestar general', 'General wellness')) {
      return _t('Amplio', 'Broad');
    }
    final nombre = normalizarTexto(producto.nombre);
    if (nombre.contains('max') ||
        nombre.contains('tri factor') ||
        nombre.contains('tf boost') ||
        nombre.contains('glucoach') ||
        nombre.contains('bcv')) {
      return _t('Muy especifico', 'Highly specific');
    }
    return _t('Especifico', 'Specific');
  }

  String _formatoProducto(ProductoPrecio producto) {
    final nombre = normalizarTexto(producto.nombre);
    if (nombre.contains('stix') || nombre.contains('go')) {
      return _t('Stix portatil', 'Portable stix');
    }
    if (nombre.contains('jugo') || nombre.contains('burst')) {
      return _t('Bebida o toma diaria', 'Drink or daily serving');
    }
    if (nombre.contains('crema') ||
        nombre.contains('tonico') ||
        nombre.contains('limpiador') ||
        nombre.contains('suero')) {
      return _t('Topico', 'Topical');
    }
    return _t('Capsulas o suplemento base', 'Capsules or core supplement');
  }

  String _enfoqueProducto(ProductoPrecio producto) {
    final nombre = normalizarTexto(producto.nombre);
    if (nombre.contains('energy')) {
      return _t('Energía y rendimiento diario', 'Energy and daily performance');
    }
    if (nombre.contains('riovida')) {
      return _t('Nutrición antioxidante', 'Antioxidant nutrition');
    }
    if (nombre.contains('protf') || nombre.contains('nutrastart')) {
      return _t('Proteína y nutrición', 'Protein and nutrition');
    }
    if (nombre.contains('glucoach')) {
      return _t(
          'Apoyo al metabolismo de la glucosa', 'Glucose metabolism support');
    }
    if (nombre.contains('bcv')) {
      return _t('Bienestar cardiovascular', 'Cardiovascular wellness');
    }
    if (nombre.contains('malepro')) {
      return _t('Bienestar masculino', 'Men wellness');
    }
    if (nombre.contains('colageno') || nombre.contains('belle vie')) {
      return _t('Belleza y apoyo al tejido conectivo',
          'Beauty and connective tissue support');
    }
    if (nombre.contains('bioefa')) {
      return _t(
          'Apoyo de ácidos grasos esenciales', 'Essential fatty acid support');
    }
    if (nombre.contains('fibre') || nombre.contains('preo')) {
      return _t('Bienestar digestivo', 'Digestive wellness');
    }
    if (nombre.contains('kbu')) {
      return _t('Bienestar renal y urinario', 'Kidney and urinary wellness');
    }
    if (nombre.contains('vistari')) return _t('Apoyo visual', 'Vision support');
    if (nombre.contains('renuvo')) {
      return _t('Apoyo al envejecimiento saludable', 'Healthy aging support');
    }
    if (nombre.contains('tf boost')) {
      return _t('Apoyo inmune específico', 'Targeted immune support');
    }
    if (nombre.contains('transfer factor') || nombre.contains('agpro')) {
      return _t('Apoyo al sistema inmune', 'Immune system support');
    }
    if (nombre.contains('crema') ||
        nombre.contains('tonico') ||
        nombre.contains('limpiador') ||
        nombre.contains('suero')) {
      return _t('Cuidado personal', 'Personal care');
    }
    return _t('Bienestar general', 'General wellness');
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
                  _lecturaCard(),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _t('Comparador A/B', 'A/B Comparator'),
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
                  'Compara dos suplementos frente a frente',
                  'Put two supplements face to face',
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
          Text(
            _t('Selecciona dos productos', 'Select two products'),
            style: const TextStyle(
              color: _azul,
              fontSize: 24,
              height: 1.12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _t(
              'Compara enfoque, calidad, especializacion, formato y senales de decision lado a lado.',
              'Compare focus, quality, specialization, format, and decision signals side by side.',
            ),
            style: const TextStyle(
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
                  etiqueta: _t('Producto A', 'Product A'),
                  producto: _productoA,
                  onTap: () => _seleccionarProducto(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _selectorProducto(
                  etiqueta: _t('Producto B', 'Product B'),
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
            Row(
              children: [
                Text(
                  _t('Cambiar', 'Change'),
                  style: const TextStyle(
                    color: _texto,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(Icons.keyboard_arrow_down_rounded,
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
                _t('Producto $etiqueta', 'Product $etiqueta'),
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
          Text(
            _t('Tabla comparativa', 'Side-by-side table'),
            style: const TextStyle(
              color: _azul,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          _filaMetrica(_t('Enfoque de bienestar', 'Wellness focus'),
              _enfoqueProducto(_productoA), _enfoqueProducto(_productoB)),
          _filaMetrica(_t('Calidad principal', 'Main quality'),
              _senalCalidad(_productoA), _senalCalidad(_productoB)),
          _filaMetrica(
              _t('Especializacion', 'Specialization'),
              _nivelEspecializacion(_productoA),
              _nivelEspecializacion(_productoB)),
          _filaMetrica(_t('Formato', 'Format'), _formatoProducto(_productoA),
              _formatoProducto(_productoB)),
          _filaMetrica(
              _t('Componentes', 'Components'),
              _componentesProducto(_productoA),
              _componentesProducto(_productoB)),
          _filaMetrica(_t('Como funciona', 'How it works'),
              _funcionProducto(_productoA), _funcionProducto(_productoB)),
          _filaMetrica(_t('Uso recomendado', 'Intended use'),
              _usoProducto(_productoA), _usoProducto(_productoB)),
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
                Text(
                  _t('Decisión rápida', 'Quick decision'),
                  style: const TextStyle(
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

  Widget _lecturaCard() {
    return _contenedorTarjeta(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFF1487A8),
            child: Icon(Icons.notes_rounded, color: Colors.white, size: 27),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t('Lectura comparativa', 'Comparative reading'),
                  style: const TextStyle(
                    color: _azul,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _lecturaComparativa(),
                  style: const TextStyle(
                    color: _tinta,
                    fontSize: 14.5,
                    height: 1.38,
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
              texto: _t('Copiar', 'Copy'),
              onTap: _copiarComparacion,
            ),
          ),
          Container(width: 1, height: 42, color: const Color(0xFFE0E3EF)),
          Expanded(
            child: _accion(
              icono: Icons.share_rounded,
              texto: _t('Compartir', 'Share'),
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

  String _resumenCalidad(ProductoPrecio producto) {
    final nombre = normalizarTexto(producto.nombre);
    final enfoque = nombre.contains('riovida')
        ? txtApp('Antioxidante', 'Antioxidant')
        : nombre.contains('transfer factor') ||
                nombre.contains('tf boost') ||
                nombre.contains('agpro')
            ? txtApp('Inmune', 'Immune')
            : nombre.contains('energy')
                ? txtApp('Energia', 'Energy')
                : txtApp('Bienestar', 'Wellness');
    return '$enfoque | ${txtApp('Seleccionable', 'Selectable')}';
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
                txtApp('Elegir suplemento', 'Choose supplement'),
                style: const TextStyle(
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
                hintText: txtApp('Buscar producto', 'Search product'),
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
                      _resumenCalidad(producto),
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
