part of '../main.dart';

class ConsultaProductoPagina extends StatefulWidget {
  const ConsultaProductoPagina({super.key});

  @override
  State<ConsultaProductoPagina> createState() => _ConsultaProductoPaginaState();
}

class _ConsultaProductoPaginaState extends State<ConsultaProductoPagina> {
  final controller = TextEditingController();
  bool consultando = false;
  List<String> _busquedasRecientes = [];

  static const String _prefsRecientesKey = 'consultas_productos_recientes';
  static const List<String> _ejemplosPopulares = [
    'Transfer factor plus',
    'Riovida stix',
    'Renuvo',
    'Bioefa',
  ];

  @override
  void initState() {
    super.initState();
    _cargarRecientes();
  }

  Future<void> _cargarRecientes() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _busquedasRecientes = prefs.getStringList(_prefsRecientesKey) ?? [];
    });
  }

  Future<void> _guardarReciente(String busqueda) async {
    final texto = busqueda.trim();
    if (texto.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final actualizadas = [
      texto,
      ..._busquedasRecientes.where(
        (item) => normalizarTexto(item) != normalizarTexto(texto),
      ),
    ].take(6).toList();

    await prefs.setStringList(_prefsRecientesKey, actualizadas);
    if (!mounted) return;
    setState(() => _busquedasRecientes = actualizadas);
  }

  Future<void> consultar() async {
    final productoBuscado = controller.text.trim();
    if (productoBuscado.isEmpty || consultando) return;

    setState(() => consultando = true);
    final productoCoincidenteLocal = buscarProductoPermitido(productoBuscado);
    final productoParaIa = productoCoincidenteLocal ?? productoBuscado;

    final model =
        GenerativeModel(model: 'gemini-3.1-flash-lite', apiKey: geminiApiKey);
    final idioma = await IdiomaService.cargar();
    final instruccionIdioma = await IdiomaService.instruccionIa();
    final prompt = """
    IDIOMA OBLIGATORIO:
    $instruccionIdioma

    Actua como un asesor experto de productos 4Life.

    Producto consultado:
    "$productoParaIa"

    Si el usuario lo escribio con errores, trabaja directamente con el producto correcto.
    No digas que fue una coincidencia ni que el texto estaba mal escrito.

    REGLA OBLIGATORIA: Solo puedes identificar, describir o recomendar productos de esta lista:
    $catalogoPermitido4Life.
    Si el usuario pregunta por un producto fuera de la lista, indica que no esta en el catalogo permitido
    y sugiere que escriba uno de los productos autorizados.

    REGLA DE DIFERENCIACION OBLIGATORIA:
    No mezcles productos con nombres parecidos. Transfer factor tri factor y Transfer factor plus son productos distintos.
    Riovida stix, Riovida burst y Energy go stix tambien son productos distintos.
    Si el nombre consultado contiene "tri factor", responde solo sobre Transfer factor tri factor.
    Si contiene "plus", responde solo sobre Transfer factor plus.
    Si contiene "riovida stix" o "riovida", responde solo sobre Riovida stix, salvo que diga "burst".
    Si contiene "riovida burst" o "burst", responde solo sobre Riovida burst.
    Si contiene "energy", "energy go" o "go stix", responde solo sobre Energy go stix.

    Responde en el idioma obligatorio indicado arriba, claro y ordenado, con esta estructura traducida al idioma seleccionado:

    Producto identificado:
    [Nombre correcto del producto]

    Descripcion:
    [Para que se usa o que respalda]

    Ingredientes o componentes principales:
    [Lista breve]

    Indicaciones de uso:
    [Uso sugerido de bienestar, sin prometer curas]

    Contraindicaciones o precauciones:
    [Advertencias responsables]

    Dosis sugerida:
    [Dosis general si la conoces. Si no estas seguro, indicalo y recomienda revisar la etiqueta oficial]

    Nota:
    Incluye obligatoriamente esta idea: Este producto no es medicina, no diagnostica, no trata, no cura ni previene enfermedades. Es un suplemento de bienestar y no reemplaza la indicacion de un profesional de salud.
    No inventes informacion si no estas seguro. No recomiendes medicamentos, marcas externas ni productos fuera del catalogo permitido.
    """;
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final resultado = _asegurarNotaNoMedicina(
        response.text ?? "No pude generar una respuesta.",
        idioma,
      );
      final productoIdentificado = productoDesdeTexto(resultado) ??
          productoCoincidenteLocal ??
          buscarProductoPermitido(productoBuscado);
      final imagenProducto = productoIdentificado == null
          ? null
          : imagenesProducto4Life[productoIdentificado];
      final precioProducto = productoIdentificado == null
          ? buscarProductoConPrecio(productoBuscado)
          : buscarProductoConPrecio(productoIdentificado);
      await ImpactoService.registrar(
        tipo: 'consulta_producto',
        titulo: productoIdentificado ?? productoBuscado,
        datos: {
          'busqueda': productoBuscado,
          'producto': productoIdentificado ?? productoParaIa,
        },
      );

      if (!mounted) return;
      await _guardarReciente(productoIdentificado ?? productoBuscado);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (c) => _dialogoResultado(
          dialogContext: c,
          titulo: productoIdentificado ?? "Info: $productoBuscado",
          resultado: resultado,
          imagenProducto: imagenProducto,
          productoIdentificado: productoIdentificado,
          precioProducto: precioProducto,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text("Error"),
          content: const Text("No se pudo consultar el producto con la IA."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c), child: const Text("Cerrar")),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => consultando = false);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Stack(
        children: [
          Container(
            height: 252,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF172B98), Color(0xFF07125E)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              child: Column(
                children: [
                  _encabezadoConsulta(),
                  const SizedBox(height: 32),
                  _tarjetaBusqueda(),
                  const SizedBox(height: 18),
                  _tarjetaConsejo(),
                  const SizedBox(height: 20),
                  _botonConsultar(),
                  const SizedBox(height: 22),
                  _tarjetaRecientes(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _encabezadoConsulta() {
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
                txtApp("Consultar Productos", "Product Consultation"),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  height: 1.1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                txtApp(
                  "Busca informacion de suplementos",
                  "Search supplement information",
                ),
                style: const TextStyle(
                  color: Color(0xFFD9DFFF),
                  fontSize: 19,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tarjetaBusqueda() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
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
                      txtApp(
                        "Busca el producto que necesitas",
                        "Find the product you need",
                      ),
                      style: const TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 24,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      txtApp(
                        "Encuentra informacion detallada, precios y LP.",
                        "Find detailed information, prices, and LP.",
                      ),
                      style: const TextStyle(
                        color: Color(0xFF293573),
                        fontSize: 18,
                        height: 1.42,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _ilustracionBusqueda(),
            ],
          ),
          const SizedBox(height: 28),
          TextField(
            controller: controller,
            minLines: 1,
            maxLines: 1,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => consultar(),
            decoration: InputDecoration(
              hintText: txtApp(
                "Escribe el nombre del producto",
                "Enter the product name",
              ),
              hintStyle: const TextStyle(
                color: Color(0xFF858AA5),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF666C8F),
                size: 33,
              ),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: "Limpiar",
                      onPressed: () => setState(controller.clear),
                      icon: const Icon(Icons.cancel_rounded),
                      color: const Color(0xFF666C8F),
                    ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFD6D9E6), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFF4056E8), width: 1.7),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          Text(
            txtApp("Ejemplos populares:", "Popular examples:"),
            style: const TextStyle(
              color: Color(0xFF12248B),
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final ejemplo in _ejemplosPopulares) _chipEjemplo(ejemplo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipEjemplo(String texto) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        setState(() => controller.text = texto);
        consultar();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF1FF),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            color: Color(0xFF4565F0),
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _ilustracionBusqueda() {
    return SizedBox(
      width: 104,
      height: 112,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            bottom: 6,
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFE8ECFF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
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
                Icons.search_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 4,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFDDE5FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 8,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF1FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaConsejo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF2FF), Color(0xFFF7F8FF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFF5367F2),
            child: Icon(Icons.info_rounded, color: Colors.white, size: 31),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txtApp("Consejo", "Tip"),
                  style: const TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  txtApp(
                    "Escribe el nombre exacto o parte del producto para obtener mejores resultados.",
                    "Enter the exact name or part of the product for better results.",
                  ),
                  style: const TextStyle(
                    color: Color(0xFF09196B),
                    fontSize: 18,
                    height: 1.35,
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

  Widget _botonConsultar() {
    return InkWell(
      borderRadius: BorderRadius.circular(36),
      onTap: consultando ? null : consultar,
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF172394), Color(0xFF0B176B)],
          ),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: consultando
              ? const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_rounded,
                        color: Colors.white, size: 34),
                    const SizedBox(width: 16),
                    Text(
                      txtApp("Consultar", "Search"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _tarjetaRecientes() {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: _busquedasRecientes.isEmpty ? null : _mostrarRecientes,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF1FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: Color(0xFF12248B),
                size: 36,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txtApp("Busquedas recientes", "Recent searches"),
                    style: const TextStyle(
                      color: Color(0xFF12248B),
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _busquedasRecientes.isEmpty
                        ? txtApp(
                            "Aun no tienes consultas recientes",
                            "You do not have recent searches yet",
                          )
                        : txtApp(
                            "Ver productos consultados recientemente",
                            "View recently searched products",
                          ),
                    style: const TextStyle(
                      color: Color(0xFF2F3C7D),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF5A607E),
              size: 36,
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarRecientes() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8DCEB),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Busquedas recientes",
                style: TextStyle(
                  color: Color(0xFF12248B),
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              for (final item in _busquedasRecientes)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.history_rounded,
                    color: Color(0xFF12248B),
                  ),
                  title: Text(
                    item,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => controller.text = item);
                    consultar();
                  },
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
  }) {
    final ingles = IdiomaService.actual.value == IdiomaApp.ingles;
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
                                  _precioResumenProducto(precioProducto),
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
                                    child:
                                        _precioResumenProducto(precioProducto),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      for (final seccion
                          in _seccionesResultadoProducto(resultado))
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

  Widget _precioResumenProducto(ProductoPrecio producto) {
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
    ];
    final textoConPrecios = precioProducto == null
        ? resultado
        : '$resultado\n\n${idioma == IdiomaApp.ingles ? 'Prices' : 'Precios'}:\n'
            '${idioma == IdiomaApp.ingles ? 'Member' : 'Afiliado'}: \$${precioProducto.afiliado.toStringAsFixed(2)}\n'
            '${idioma == IdiomaApp.ingles ? 'Retail' : 'Publico'}: \$${precioProducto.publico.toStringAsFixed(2)}\n'
            'LP: ${precioProducto.lp ?? 0}';
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

  String _asegurarNotaNoMedicina(String resultado, IdiomaApp idioma) {
    final notaNoMedicina = idioma == IdiomaApp.ingles
        ? 'This product is not medicine, does not diagnose, treat, cure, or prevent diseases. It is a wellness supplement and does not replace guidance from a healthcare professional.'
        : 'Este producto no es medicina, no diagnostica, no trata, no cura ni previene enfermedades. Es un suplemento de bienestar y no reemplaza la indicacion de un profesional de salud.';
    final normalizado = normalizarTexto(resultado);
    if ((normalizado.contains('no es medicina') &&
            normalizado.contains('no reemplaza')) ||
        (normalizado.contains('not medicine') &&
            normalizado.contains('does not replace'))) {
      return resultado;
    }

    final limpio = resultado.trimRight();
    if (normalizarTexto(limpio).contains('nota') ||
        normalizarTexto(limpio).contains('note')) {
      return '$limpio\n$notaNoMedicina';
    }
    return idioma == IdiomaApp.ingles
        ? '$limpio\n\nNote:\n$notaNoMedicina'
        : '$limpio\n\nNota:\n$notaNoMedicina';
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
