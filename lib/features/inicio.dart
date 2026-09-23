part of '../main.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  late Future<PerfilAsesor> _perfilFuture;
  late final PageController _pageController;
  final Set<String> _categoriasAbiertas = <String>{};
  int _paginaActual = 0;
  bool _animandoPagina = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _perfilFuture = PerfilService.cargar();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ServicioVersion.validarVersion(context);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _recargarPerfil() {
    setState(() {
      _perfilFuture = PerfilService.cargar();
    });
  }

  void _alternarCategoria(String id) {
    setState(() {
      if (_categoriasAbiertas.contains(id)) {
        _categoriasAbiertas.remove(id);
      } else {
        _categoriasAbiertas.add(id);
      }
    });
  }

  Future<void> _irAPagina(int pagina) async {
    if (_animandoPagina ||
        pagina == _paginaActual ||
        pagina < 0 ||
        pagina > 1) {
      return;
    }
    setState(() => _animandoPagina = true);
    try {
      await _pageController.animateToPage(
        pagina,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    } finally {
      if (mounted) setState(() => _animandoPagina = false);
    }
  }

  Future<void> _abrirRuta(String ruta) async {
    await abrirRutaApp(context, ruta);
    if (mounted && ruta == RutasApp.perfil) _recargarPerfil();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<IdiomaApp>(
      valueListenable: IdiomaService.actual,
      builder: (context, idioma, _) => ValueListenableBuilder<PaisApp>(
        valueListenable: PaisService.actual,
        builder: (context, pais, _) => _construirInicio(context),
      ),
    );
  }

  Widget _construirInicio(BuildContext context) {
    final catalogoAfiliado = _FichaInicio(
      titulo: IdiomaService.texto('consult_products'),
      descripcion: IdiomaService.texto('consult_products_desc'),
      icono: Icons.grid_view_rounded,
      colores: const [Color(0xFF2E3192), Color(0xFF151B7C)],
      ruta: RutasApp.catalogoAfiliado,
    );
    final catalogoMiTienda = _FichaInicio(
      titulo: IdiomaService.texto('mitienda_catalog'),
      descripcion: IdiomaService.texto('mitienda_catalog_desc'),
      icono: Icons.storefront_rounded,
      colores: const [Color(0xFF118B48), Color(0xFF0B6B38)],
      ruta: RutasApp.catalogoMiTienda,
    );
    final catalogosPdf = _FichaInicio(
      titulo: txtApp('Catálogos PDF', 'PDF Catalogs'),
      descripcion: txtApp(
        'Consulta y comparte los catálogos oficiales en PDF.',
        'View and share the official PDF catalogs.',
      ),
      icono: Icons.picture_as_pdf_rounded,
      colores: const [Color(0xFF2E3192), Color(0xFF151B7C)],
      ruta: RutasApp.catalogosPdf,
    );
    final calculadoraPrecios = _FichaInicio(
      titulo: IdiomaService.texto('price_calculator'),
      descripcion: IdiomaService.texto('price_calculator_desc'),
      icono: Icons.calculate_rounded,
      colores: const [Color(0xFF008C7E), Color(0xFF006B61)],
      ruta: RutasApp.calculadoraPrecios,
    );
    final optimizadorConsumo = _FichaInicio(
      titulo: IdiomaService.texto('consumption_optimizer'),
      descripcion: IdiomaService.texto('consumption_optimizer_desc'),
      icono: Icons.view_module_rounded,
      colores: const [Color(0xFF172394), Color(0xFF07125E)],
      ruta: RutasApp.optimizadorConsumo,
    );
    final optimizadorAcelerado = _FichaInicio(
      titulo: IdiomaService.texto('accelerated_optimizer'),
      descripcion: IdiomaService.texto('accelerated_optimizer_desc'),
      icono: Icons.rocket_launch_rounded,
      colores: const [Color(0xFF172394), Color(0xFF0B6B88)],
      ruta: RutasApp.optimizadorAcelerado,
    );
    final inventarioLocal = _FichaInicio(
      titulo: IdiomaService.texto('local_inventory'),
      descripcion: IdiomaService.texto('local_inventory_desc'),
      icono: Icons.inventory_2_rounded,
      colores: const [Color(0xFF3047CC), Color(0xFF172394)],
      ruta: RutasApp.inventarioLocal,
    );
    final comparadorAB = _FichaInicio(
      titulo: IdiomaService.texto('ab_comparator'),
      descripcion: IdiomaService.texto('ab_comparator_desc'),
      icono: Icons.compare_arrows_rounded,
      colores: const [Color(0xFF1487A8), Color(0xFF172394)],
      ruta: RutasApp.comparadorAB,
    );
    final diagnostico = _FichaInicio(
      titulo: IdiomaService.texto('diagnosis'),
      descripcion: IdiomaService.texto('diagnosis_desc'),
      icono: Icons.medical_services_rounded,
      colores: const [Color(0xFF1457E8), Color(0xFF1531A6)],
      ruta: RutasApp.diagnostico,
    );
    final cambioFisico = _FichaInicio(
      titulo: IdiomaService.texto('body_change'),
      descripcion: IdiomaService.texto('body_change_desc'),
      icono: Icons.fitness_center_rounded,
      colores: const [Color(0xFF1457E8), Color(0xFF1531A6)],
      ruta: RutasApp.cambioFisico,
    );
    final historial = _FichaInicio(
      titulo: IdiomaService.texto('history'),
      descripcion: IdiomaService.texto('history_desc'),
      icono: Icons.history_rounded,
      colores: const [Color(0xFF8051D4), Color(0xFF6047B7)],
      ruta: RutasApp.historial,
    );
    final chatLive = _FichaInicio(
      titulo: "Chat Live 4Life",
      descripcion: IdiomaService.texto('chat_live_desc'),
      icono: Icons.forum_rounded,
      colores: const [Color(0xFF6A4DE8), Color(0xFF3C2AAE)],
      ruta: RutasApp.chatLive,
    );
    final asesorIa = _FichaInicio(
      titulo: IdiomaService.texto('ai_adviser'),
      descripcion: IdiomaService.texto('ai_adviser_desc'),
      icono: Icons.chat_rounded,
      colores: const [Color(0xFF1487A8), Color(0xFF087394)],
      ruta: RutasApp.asesorIa,
    );
    final historialChatsIa = _FichaInicio(
      titulo: txtApp('Historial de chats IA', 'AI chat history'),
      descripcion: txtApp(
        'Revisa conversaciones del Asesor IA y Chat Live.',
        'Review AI Adviser and Chat Live conversations.',
      ),
      icono: Icons.forum_outlined,
      colores: const [Color(0xFF6A4DE8), Color(0xFF3C2AAE)],
      ruta: RutasApp.historialChatsIa,
    );
    final testimonios = _FichaInicio(
      titulo: IdiomaService.texto('testimonials'),
      descripcion: IdiomaService.texto('testimonials_desc'),
      icono: Icons.ondemand_video_rounded,
      colores: const [Color(0xFF3047CC), Color(0xFF172394)],
      ruta: RutasApp.testimonios,
    );
    final diccionario = _FichaInicio(
      titulo: IdiomaService.texto('dictionary'),
      descripcion: IdiomaService.texto('dictionary_desc'),
      icono: Icons.menu_book_rounded,
      colores: const [Color(0xFF3047CC), Color(0xFF172394)],
      ruta: RutasApp.diccionario,
    );
    final mapaAnatomico = _FichaInicio(
      titulo: txtApp('Mapa Anatómico Interactivo', 'Interactive Anatomy Map'),
      descripcion: txtApp(
        'Explora órganos, enfermedades y productos de apoyo.',
        'Explore organs, conditions, and support products.',
      ),
      icono: Icons.accessibility_new_rounded,
      colores: const [Color(0xFF3047CC), Color(0xFF172394)],
      ruta: RutasApp.mapaAnatomico,
    );
    final perfil = _FichaInicio(
      titulo: IdiomaService.texto('profile'),
      descripcion: IdiomaService.texto('profile_desc'),
      icono: Icons.person_rounded,
      colores: const [Color(0xFF455A64), Color(0xFF263238)],
      ruta: RutasApp.perfil,
    );

    final accesosRapidos = <_FichaInicio>[
      catalogoAfiliado,
      catalogoMiTienda,
      catalogosPdf,
      calculadoraPrecios,
      diagnostico,
      chatLive,
      asesorIa,
    ];
    final categorias = <_CategoriaInicio>[
      _CategoriaInicio(
        id: 'catalogos',
        titulo: txtApp('Catálogos', 'Catalogs'),
        descripcion: txtApp(
          'Galerías de productos y catálogos PDF.',
          'Product galleries and PDF catalogs.',
        ),
        icono: Icons.view_list_rounded,
        colores: const [Color(0xFF2E3192), Color(0xFF151B7C)],
        fichas: [catalogoAfiliado, catalogoMiTienda, catalogosPdf],
      ),
      _CategoriaInicio(
        id: 'panel_rendimiento',
        titulo: txtApp('Panel de Rendimiento', 'Performance Panel'),
        descripcion: txtApp(
          'Calculadoras y optimizadores para planificar compras.',
          'Calculators and optimizers for purchase planning.',
        ),
        icono: Icons.speed_rounded,
        colores: const [Color(0xFF008C7E), Color(0xFF006B61)],
        fichas: [
          calculadoraPrecios,
          optimizadorConsumo,
          optimizadorAcelerado,
        ],
      ),
      _CategoriaInicio(
        id: 'diagnosticos',
        titulo: txtApp('Diagnósticos', 'Diagnoses'),
        descripcion: txtApp(
          'Diagnóstico, cambio físico e historial.',
          'Diagnosis, body transformation, and history.',
        ),
        icono: Icons.assignment_turned_in_rounded,
        colores: const [Color(0xFF1457E8), Color(0xFF1531A6)],
        fichas: [diagnostico, cambioFisico, historial],
      ),
      _CategoriaInicio(
        id: 'analisis_control',
        titulo: txtApp('Análisis y Control', 'Analysis and Control'),
        descripcion: txtApp(
          'Inventario local y comparador A/B.',
          'Local inventory and A/B comparator.',
        ),
        icono: Icons.analytics_rounded,
        colores: const [Color(0xFF1487A8), Color(0xFF172394)],
        fichas: [inventarioLocal, comparadorAB],
      ),
      _CategoriaInicio(
        id: 'asistentes_ia',
        titulo: txtApp('Asistentes IA', 'AI Assistants'),
        descripcion: txtApp(
          'Chat Live y Asesor IA 4Life.',
          'Chat Live and 4Life AI Adviser.',
        ),
        icono: Icons.auto_awesome_rounded,
        colores: const [Color(0xFF6A4DE8), Color(0xFF3C2AAE)],
        fichas: [chatLive, asesorIa, historialChatsIa],
      ),
      _CategoriaInicio(
        id: 'recursos_aprendizaje',
        titulo: txtApp(
          'Recursos y Centro de Aprendizaje',
          'Resources and Learning Center',
        ),
        descripcion: txtApp(
          'Testimonios, diccionario y mapa anatómico.',
          'Testimonials, dictionary, and anatomy map.',
        ),
        icono: Icons.school_rounded,
        colores: const [Color(0xFF3047CC), Color(0xFF172394)],
        fichas: [testimonios, diccionario, mapaAnatomico],
      ),
    ];
    return _inicioPaginado(
      context,
      accesosRapidos: accesosRapidos,
      categorias: categorias,
      perfil: perfil,
    );
  }

  Widget _inicioPaginado(
    BuildContext context, {
    required List<_FichaInicio> accesosRapidos,
    required List<_CategoriaInicio> categorias,
    required _FichaInicio perfil,
  }) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, viewport) {
                  final heroHeight =
                      viewport.maxWidth - 32 < 360 ? 222.0 : 158.0;
                  const altoControles = 56.0;
                  const espacioVerticalFijo = 8.0 + 18.0;
                  final altoDisponible = viewport.maxHeight -
                      heroHeight -
                      altoControles -
                      espacioVerticalFijo;
                  final altoEspacioTarjeta =
                      (altoDisponible / 7).clamp(66.0, 82.0).toDouble();
                  final altoPaginas = altoEspacioTarjeta * 7 +
                      _altoCategoriasAbiertas(
                        categorias,
                        altoEspacioTarjeta,
                      );

                  return SingleChildScrollView(
                    key: const ValueKey('desplazamiento-general-inicio'),
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: viewport.maxHeight),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: FutureBuilder<PerfilAsesor>(
                              future: _perfilFuture,
                              builder: (context, snapshot) {
                                return _heroAsesor(context, snapshot.data);
                              },
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: altoPaginas,
                            child: ScrollConfiguration(
                              behavior:
                                  ScrollConfiguration.of(context).copyWith(
                                dragDevices: const {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                  PointerDeviceKind.trackpad,
                                  PointerDeviceKind.stylus,
                                },
                              ),
                              child: PageView(
                                key: const ValueKey('paginas-inicio'),
                                controller: _pageController,
                                onPageChanged: (pagina) {
                                  if (_paginaActual != pagina) {
                                    setState(() => _paginaActual = pagina);
                                  }
                                },
                                children: [
                                  Padding(
                                    key: const ValueKey(
                                        'pagina-accesos-rapidos'),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [
                                        for (final ficha in accesosRapidos)
                                          _tarjetaMenu(
                                            context,
                                            ficha: ficha,
                                            alturaEspacio: altoEspacioTarjeta,
                                            compacta: true,
                                            claveSemantica:
                                                'principal-${ficha.ruta}',
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    key: const ValueKey(
                                        'pagina-todas-funciones'),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [
                                        for (final categoria in categorias)
                                          _tarjetaCategoria(
                                            context,
                                            id: categoria.id,
                                            titulo: categoria.titulo,
                                            descripcion: categoria.descripcion,
                                            icono: categoria.icono,
                                            colores: categoria.colores,
                                            fichas: categoria.fichas,
                                            alturaEspacio: altoEspacioTarjeta,
                                            compacta: true,
                                          ),
                                        _tarjetaMenu(
                                          context,
                                          ficha: perfil,
                                          alturaEspacio: altoEspacioTarjeta,
                                          compacta: true,
                                          claveSemantica:
                                              'general-${perfil.ruta}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _controlesPaginas(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _barraInferior(context),
          ],
        ),
      ),
    );
  }

  double _altoCategoriasAbiertas(
    List<_CategoriaInicio> categorias,
    double altoEspacioTarjeta,
  ) {
    return categorias.fold<double>(0, (total, categoria) {
      if (!_categoriasAbiertas.contains(categoria.id)) return total;
      return total + 16 + categoria.fichas.length * altoEspacioTarjeta;
    });
  }

  Future<void> _seleccionarMercadoEIdioma() async {
    var paisTemporal = PaisService.actual.value;
    var idiomaTemporal = IdiomaService.actual.value;
    final aplicar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, actualizarDialogo) => AlertDialog(
          key: const ValueKey('selector-pais-idioma-inicio'),
          title: Text(txtApp('País e idioma', 'Country and language')),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    txtApp('Selecciona el mercado', 'Select the market'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  for (final pais in PaisApp.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        key: ValueKey('opcion-pais-${pais.codigo}'),
                        onTap: () =>
                            actualizarDialogo(() => paisTemporal = pais),
                        leading: ExcludeSemantics(
                          child: _InsigniaPais(pais: pais),
                        ),
                        title: Text(txtApp(pais.etiqueta, pais.etiquetaIngles)),
                        trailing: Icon(
                          paisTemporal == pais
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: paisTemporal == pais
                              ? const Color(0xFF2839C7)
                              : const Color(0xFF8D94AD),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: paisTemporal == pais
                                ? const Color(0xFF2839C7)
                                : const Color(0xFFDDE1F1),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    txtApp('Selecciona el idioma', 'Select the language'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  for (final idioma in IdiomaApp.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        key: ValueKey('opcion-idioma-${idioma.codigo}'),
                        onTap: () =>
                            actualizarDialogo(() => idiomaTemporal = idioma),
                        leading: const Icon(Icons.language_rounded),
                        title: Text(
                          idioma == IdiomaApp.espanol ? 'Español' : 'English',
                        ),
                        trailing: Icon(
                          idiomaTemporal == idioma
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: idiomaTemporal == idioma
                              ? const Color(0xFF2839C7)
                              : const Color(0xFF8D94AD),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: idiomaTemporal == idioma
                                ? const Color(0xFF2839C7)
                                : const Color(0xFFDDE1F1),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(txtApp('Cancelar', 'Cancel')),
            ),
            FilledButton(
              key: const ValueKey('solicitar-confirmacion-mercado'),
              onPressed: () async {
                final confirmado = await showDialog<bool>(
                  context: dialogContext,
                  builder: (confirmationContext) => AlertDialog(
                    title: Text(txtApp('Confirmar cambio', 'Confirm change')),
                    content: Text(txtApp(
                      'Se aplicarán ${paisTemporal.etiqueta} y ${idiomaTemporal == IdiomaApp.espanol ? 'Español' : 'English'} en todos los módulos.',
                      '${paisTemporal.etiquetaIngles} and ${idiomaTemporal == IdiomaApp.espanol ? 'Spanish' : 'English'} will be applied to every module.',
                    )),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(confirmationContext, false),
                        child: Text(txtApp('Cancelar', 'Cancel')),
                      ),
                      FilledButton(
                        key: const ValueKey('confirmar-cambio-mercado'),
                        onPressed: () =>
                            Navigator.pop(confirmationContext, true),
                        child: Text(txtApp('Confirmar', 'Confirm')),
                      ),
                    ],
                  ),
                );
                if (confirmado == true && dialogContext.mounted) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: Text(txtApp('Aplicar', 'Apply')),
            ),
          ],
        ),
      ),
    );
    if (aplicar != true) return;
    await PaisService.guardar(paisTemporal);
    await IdiomaService.guardar(idiomaTemporal);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(txtApp('Cambios aplicados', 'Changes applied'))),
    );
  }

  Widget _heroAsesor(BuildContext context, PerfilAsesor? perfil) {
    final nombre = perfil?.nombre.trim() ?? '';
    final saludo = nombre.isEmpty
        ? IdiomaService.texto('hello_adviser')
        : txtApp("¡Hola, $nombre!", "Hello, $nombre!");
    return LayoutBuilder(builder: (context, constraints) {
      final estrecho = constraints.maxWidth < 360;
      return Container(
        height: estrecho ? 222 : 158,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF3FF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF071451).withValues(alpha: 0.13),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -42,
              child: Container(
                width: 156,
                height: 156,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFBFCBFF).withValues(alpha: 0.28),
                ),
              ),
            ),
            Positioned(
              right: 48,
              top: 16,
              child: estrecho
                  ? const SizedBox.shrink()
                  : Icon(
                      Icons.science_rounded,
                      size: 58,
                      color: const Color(0xFF1B2A99).withValues(alpha: 0.32),
                    ),
            ),
            Positioned(
              right: 34,
              top: 15,
              child: estrecho
                  ? const SizedBox.shrink()
                  : CustomPaint(
                      size: const Size(76, 56),
                      painter: _MoleculaPainter(),
                    ),
            ),
            Positioned(
              right: 14,
              bottom: 14,
              child: ValueListenableBuilder<PaisApp>(
                valueListenable: PaisService.actual,
                builder: (context, pais, _) => Tooltip(
                  message: txtApp(
                      'Cambiar país e idioma', 'Change country and language'),
                  child: Semantics(
                    label: txtApp(
                      'País seleccionado: ${pais.etiqueta}. Cambiar país e idioma',
                      'Selected country: ${pais.etiquetaIngles}. Change country and language',
                    ),
                    button: true,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        key: ValueKey('bandera-pais-${pais.codigo}'),
                        borderRadius: BorderRadius.circular(12),
                        onTap: _seleccionarMercadoEIdioma,
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: ExcludeSemantics(
                            child: _InsigniaPais(pais: pais),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                estrecho ? 18 : 24,
                estrecho ? 18 : 24,
                estrecho ? 18 : 120,
                estrecho ? 66 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    saludo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF101A5B),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    IdiomaService.texto('hero_subtitle'),
                    style: const TextStyle(
                      color: Color(0xFF25315F),
                      fontSize: 12,
                      height: 1.25,
                    ),
                  ),
                  const Spacer(),
                  Semantics(
                    key: const ValueKey('acceso-impacto'),
                    button: true,
                    label: IdiomaService.texto('impact'),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _abrirRuta(RutasApp.impacto),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF101A70),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.track_changes_rounded,
                                    color: Colors.white, size: 15),
                                const SizedBox(width: 7),
                                Text(
                                  IdiomaService.texto('impact'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded,
                                    color: Colors.white, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _tarjetaMenu(
    BuildContext context, {
    required _FichaInicio ficha,
    EdgeInsets margin = const EdgeInsets.only(bottom: 10),
    String? claveSemantica,
    double? alturaEspacio,
    bool compacta = false,
  }) {
    final tamanoIcono = compacta ? 42.0 : 60.0;
    final tarjeta = Container(
      margin: compacta ? const EdgeInsets.only(bottom: 4) : margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1A5F).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Semantics(
        key: ValueKey(claveSemantica ?? 'acceso-${ficha.ruta}'),
        button: true,
        label: ficha.titulo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _abrirRuta(ficha.ruta),
            child: Padding(
              padding: compacta
                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 4)
                  : const EdgeInsets.all(15),
              child: Row(
                children: [
                  Container(
                    width: tamanoIcono,
                    height: tamanoIcono,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: ficha.colores,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      ficha.icono,
                      color: Colors.white,
                      size: compacta ? 24 : 34,
                    ),
                  ),
                  SizedBox(width: compacta ? 10 : 18),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ficha.titulo,
                          maxLines: compacta ? 2 : null,
                          overflow: compacta ? TextOverflow.ellipsis : null,
                          style: TextStyle(
                            color: const Color(0xFF111B59),
                            fontSize: compacta ? 12.5 : 18,
                            fontWeight: FontWeight.w900,
                            height: compacta ? 1 : 1.05,
                          ),
                        ),
                        SizedBox(height: compacta ? 1 : 5),
                        Text(
                          ficha.descripcion,
                          maxLines: compacta ? 2 : null,
                          overflow: compacta ? TextOverflow.ellipsis : null,
                          style: TextStyle(
                            color: const Color(0xFF465074),
                            fontSize: compacta ? 10 : 12,
                            height: compacta ? 1.05 : 1.22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: compacta ? 4 : 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: const Color(0xFF071451),
                    size: compacta ? 24 : 31,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (alturaEspacio == null) return tarjeta;
    return SizedBox(height: alturaEspacio, child: tarjeta);
  }

  Widget _tarjetaCategoria(
    BuildContext context, {
    required String id,
    required String titulo,
    required String descripcion,
    required IconData icono,
    required List<Color> colores,
    required List<_FichaInicio> fichas,
    required double alturaEspacio,
    required bool compacta,
  }) {
    final abierta = _categoriasAbiertas.contains(id);
    return Column(
      children: [
        SizedBox(
          height: alturaEspacio,
          child: Container(
            margin: EdgeInsets.only(bottom: abierta ? 2 : 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0E1A5F).withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Semantics(
              key: ValueKey('categoria-$id'),
              button: true,
              expanded: abierta,
              label: titulo,
              hint: abierta
                  ? txtApp('Contraer categoria', 'Collapse category')
                  : txtApp('Expandir categoria', 'Expand category'),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _alternarCategoria(id),
                  child: Padding(
                    padding: compacta
                        ? const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          )
                        : const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          width: compacta ? 42 : 60,
                          height: compacta ? 42 : 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: colores,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            icono,
                            color: Colors.white,
                            size: compacta ? 24 : 34,
                          ),
                        ),
                        SizedBox(width: compacta ? 10 : 18),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titulo,
                                maxLines: compacta ? 2 : null,
                                overflow:
                                    compacta ? TextOverflow.ellipsis : null,
                                style: TextStyle(
                                  color: const Color(0xFF111B59),
                                  fontSize: compacta ? 12.5 : 18,
                                  fontWeight: FontWeight.w900,
                                  height: compacta ? 1 : 1.05,
                                ),
                              ),
                              SizedBox(height: compacta ? 1 : 5),
                              Text(
                                descripcion,
                                maxLines: compacta ? 2 : null,
                                overflow:
                                    compacta ? TextOverflow.ellipsis : null,
                                style: TextStyle(
                                  color: const Color(0xFF465074),
                                  fontSize: compacta ? 10 : 12,
                                  height: compacta ? 1.05 : 1.22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: compacta ? 4 : 8),
                        AnimatedRotation(
                          turns: abierta ? 0.25 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: const Color(0xFF071451),
                            size: compacta ? 24 : 31,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            builder: (context, valor, child) => Opacity(
              opacity: valor,
              child: Transform.translate(
                offset: Offset(0, 8 * (1 - valor)),
                child: child,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 0, 12),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      builder: (context, valor, child) => Transform.scale(
                        scaleY: valor,
                        alignment: Alignment.topCenter,
                        child: Opacity(opacity: valor, child: child),
                      ),
                      child: Container(
                        width: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2839C7),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: fichas
                            .map(
                              (ficha) => _tarjetaMenu(
                                context,
                                ficha: ficha,
                                margin: const EdgeInsets.only(bottom: 6),
                                claveSemantica: 'subacceso-$id-${ficha.ruta}',
                                alturaEspacio: alturaEspacio,
                                compacta: compacta,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          crossFadeState:
              abierta ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 180),
        ),
      ],
    );
  }

  Widget _controlesPaginas() {
    final esPrimera = _paginaActual == 0;
    final etiqueta = esPrimera
        ? IdiomaService.texto('quick_access')
        : txtApp('Todas las funciones', 'All features');
    return SizedBox(
      height: 56,
      child: Semantics(
        container: true,
        label: txtApp(
          '$etiqueta, página ${_paginaActual + 1} de 2',
          '$etiqueta, page ${_paginaActual + 1} of 2',
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              key: const ValueKey('pagina-anterior'),
              tooltip: txtApp('Página anterior', 'Previous page'),
              onPressed:
                  esPrimera || _animandoPagina ? null : () => _irAPagina(0),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$etiqueta ${_paginaActual + 1}/2',
                    key: const ValueKey('selector-pagina-inicio'),
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFF111B59),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              key: const ValueKey('pagina-siguiente'),
              tooltip: txtApp('Página siguiente', 'Next page'),
              onPressed:
                  esPrimera && !_animandoPagina ? () => _irAPagina(1) : null,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barraInferior(BuildContext context) {
    return Container(
      height: 66,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
      decoration: BoxDecoration(
        color: const Color(0xFF071363),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _itemBarra(
            context,
            IdiomaService.texto('home'),
            Icons.home_outlined,
            null,
            seleccionado: true,
          ),
          _itemBarra(
            context,
            IdiomaService.texto('consultations'),
            Icons.search_rounded,
            RutasApp.catalogoAfiliado,
          ),
          _itemBarra(
            context,
            IdiomaService.texto('clients'),
            Icons.groups_2_outlined,
            RutasApp.historial,
          ),
          _itemBarra(
            context,
            IdiomaService.texto('profile'),
            Icons.person_outline_rounded,
            RutasApp.perfil,
          ),
        ],
      ),
    );
  }

  Widget _itemBarra(
    BuildContext context,
    String texto,
    IconData icono,
    String? ruta, {
    bool seleccionado = false,
  }) {
    final contenido = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icono, color: Colors.white, size: 20),
        const SizedBox(height: 3),
        Text(
          texto,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
        child: seleccionado
            ? Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF273BB1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: contenido,
              )
            : InkWell(
                borderRadius: BorderRadius.circular(9),
                onTap: ruta == null ? null : () => _abrirRuta(ruta),
                child: contenido,
              ),
      ),
    );
  }
}

class _FichaInicio {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final List<Color> colores;
  final String ruta;

  const _FichaInicio({
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.colores,
    required this.ruta,
  });
}

class _CategoriaInicio {
  final String id;
  final String titulo;
  final String descripcion;
  final IconData icono;
  final List<Color> colores;
  final List<_FichaInicio> fichas;

  const _CategoriaInicio({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.colores,
    required this.fichas,
  });
}

class _MoleculaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF9FAEE8).withValues(alpha: 0.62)
      ..strokeWidth = 1.3;
    final nodePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final nodeBorder = Paint()
      ..color = const Color(0xFF93A4E2).withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final points = [
      Offset(size.width * .10, size.height * .76),
      Offset(size.width * .28, size.height * .52),
      Offset(size.width * .25, size.height * .22),
      Offset(size.width * .48, size.height * .35),
      Offset(size.width * .68, size.height * .16),
      Offset(size.width * .82, size.height * .42),
      Offset(size.width * .94, size.height * .70),
      Offset(size.width * .64, size.height * .66),
    ];

    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }
    canvas.drawLine(points[1], points[7], linePaint);
    canvas.drawLine(points[3], points[6], linePaint);

    for (final point in points) {
      canvas.drawCircle(point, 3.2, nodePaint);
      canvas.drawCircle(point, 3.2, nodeBorder);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
