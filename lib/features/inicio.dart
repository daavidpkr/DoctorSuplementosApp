part of '../main.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  late Future<PerfilAsesor> _perfilFuture;

  @override
  void initState() {
    super.initState();
    _perfilFuture = PerfilService.cargar();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ServicioVersion.validarVersion(context);
    });
  }

  void _recargarPerfil() {
    setState(() {
      _perfilFuture = PerfilService.cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<PerfilAsesor>(
                      future: _perfilFuture,
                      builder: (context, snapshot) {
                        return _heroAsesor(context, snapshot.data);
                      },
                    ),
                    const SizedBox(height: 18),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('consult_products'),
                      descripcion: IdiomaService.texto('consult_products_desc'),
                      icono: Icons.grid_view_rounded,
                      colores: const [Color(0xFF2E3192), Color(0xFF151B7C)],
                      destino: const ConsultaProductoPagina(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('mitienda_catalog'),
                      descripcion: IdiomaService.texto('mitienda_catalog_desc'),
                      icono: Icons.storefront_rounded,
                      colores: const [Color(0xFF118B48), Color(0xFF0B6B38)],
                      destino: const ConsultaProductoPagina(
                        tipo: TipoCatalogoProducto.miTienda,
                      ),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('price_calculator'),
                      descripcion: IdiomaService.texto('price_calculator_desc'),
                      icono: Icons.calculate_rounded,
                      colores: const [Color(0xFF008C7E), Color(0xFF006B61)],
                      destino: const PaginaCalculadoraPrecios(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('consumption_optimizer'),
                      descripcion:
                          IdiomaService.texto('consumption_optimizer_desc'),
                      icono: Icons.view_module_rounded,
                      colores: const [Color(0xFF172394), Color(0xFF07125E)],
                      destino: const PaginaOptimizadorConsumo(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('accelerated_optimizer'),
                      descripcion:
                          IdiomaService.texto('accelerated_optimizer_desc'),
                      icono: Icons.rocket_launch_rounded,
                      colores: const [Color(0xFF172394), Color(0xFF0B6B88)],
                      destino: const PaginaOptimizadorAcelerado(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('local_inventory'),
                      descripcion: IdiomaService.texto('local_inventory_desc'),
                      icono: Icons.inventory_2_rounded,
                      colores: const [Color(0xFF3047CC), Color(0xFF172394)],
                      destino: const PaginaInventarioLocal(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('ab_comparator'),
                      descripcion: IdiomaService.texto('ab_comparator_desc'),
                      icono: Icons.compare_arrows_rounded,
                      colores: const [Color(0xFF1487A8), Color(0xFF172394)],
                      destino: const PaginaComparadorAB(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('diagnosis'),
                      descripcion: IdiomaService.texto('diagnosis_desc'),
                      icono: Icons.medical_services_rounded,
                      colores: const [Color(0xFF1457E8), Color(0xFF1531A6)],
                      destino: const FormularioPaciente(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('body_change'),
                      descripcion: IdiomaService.texto('body_change_desc'),
                      icono: Icons.fitness_center_rounded,
                      colores: const [Color(0xFF1457E8), Color(0xFF1531A6)],
                      destino: const FormularioCambioFisico(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('history'),
                      descripcion: IdiomaService.texto('history_desc'),
                      icono: Icons.history_rounded,
                      colores: const [Color(0xFF8051D4), Color(0xFF6047B7)],
                      destino: const PaginaHistorial(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: "Chat Live 4Life",
                      descripcion: IdiomaService.texto('chat_live_desc'),
                      icono: Icons.forum_rounded,
                      colores: const [Color(0xFF6A4DE8), Color(0xFF3C2AAE)],
                      destino: const PaginaChatbot(
                        titulo: "Chat Live 4Life",
                        modoLlamada: true,
                      ),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('ai_adviser'),
                      descripcion: IdiomaService.texto('ai_adviser_desc'),
                      icono: Icons.chat_rounded,
                      colores: const [Color(0xFF1487A8), Color(0xFF087394)],
                      destino: const PaginaChatbot(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('testimonials'),
                      descripcion: IdiomaService.texto('testimonials_desc'),
                      icono: Icons.ondemand_video_rounded,
                      colores: const [Color(0xFF3047CC), Color(0xFF172394)],
                      destino: const PaginaTestimonios4Life(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('dictionary'),
                      descripcion: IdiomaService.texto('dictionary_desc'),
                      icono: Icons.menu_book_rounded,
                      colores: const [Color(0xFF3047CC), Color(0xFF172394)],
                      destino: const PaginaDiccionario4Life(),
                    ),
                    _tarjetaMenu(
                      context,
                      titulo: IdiomaService.texto('profile'),
                      descripcion: IdiomaService.texto('profile_desc'),
                      icono: Icons.person_rounded,
                      colores: const [Color(0xFF455A64), Color(0xFF263238)],
                      destino: PaginaPerfil(onPerfilGuardado: _recargarPerfil),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 10),
                      child: Text(
                        IdiomaService.texto('quick_access'),
                        style: const TextStyle(
                          color: Color(0xFF0A1552),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _accesosRapidos(context),
                  ],
                ),
              ),
            ),
            _barraInferior(context),
          ],
        ),
      ),
    );
  }

  Widget _heroAsesor(BuildContext context, PerfilAsesor? perfil) {
    final nombre = perfil?.nombre.trim() ?? '';
    final saludo = nombre.isEmpty
        ? IdiomaService.texto('hello_adviser')
        : txtApp("¡Hola, $nombre!", "Hello, $nombre!");
    return Container(
      height: 158,
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
            right: 36,
            top: 22,
            child: Icon(
              Icons.science_rounded,
              size: 92,
              color: const Color(0xFF1B2A99).withValues(alpha: 0.88),
            ),
          ),
          Positioned(
            right: 18,
            top: 22,
            child: CustomPaint(
              size: const Size(116, 88),
              painter: _MoleculaPainter(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 120, 20),
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
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaImpacto4LifeNueva(),
                    ),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101A70),
                      borderRadius: BorderRadius.circular(18),
                    ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaMenu(
    BuildContext context, {
    required String titulo,
    required String descripcion,
    required IconData icono,
    required List<Color> colores,
    required Widget destino,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destino),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colores,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icono, color: Colors.white, size: 34),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          color: Color(0xFF111B59),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        descripcion,
                        style: const TextStyle(
                          color: Color(0xFF465074),
                          fontSize: 12,
                          height: 1.22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF071451),
                  size: 31,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _accesosRapidos(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1A5F).withValues(alpha: 0.06),
            blurRadius: 13,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _accesoRapido(
            context,
            IdiomaService.texto('catalog'),
            Icons.article_outlined,
            const ConsultaProductoPagina(),
          ),
          _accesoRapido(
            context,
            IdiomaService.texto('prices'),
            Icons.calculate_outlined,
            const PaginaCalculadoraPrecios(),
          ),
          _accesoRapido(
            context,
            IdiomaService.texto('diagnoses'),
            Icons.assignment_turned_in_outlined,
            const PaginaHistorial(),
          ),
          _accesoRapido(
            context,
            IdiomaService.texto('chats'),
            Icons.school_outlined,
            const PaginaHistorialChatbot(),
          ),
        ],
      ),
    );
  }

  Widget _accesoRapido(
      BuildContext context, String texto, IconData icono, Widget destino) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destino),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: const Color(0xFF1B2A99), size: 20),
            const SizedBox(height: 4),
            Text(
              texto,
              style: const TextStyle(
                color: Color(0xFF18215E),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barraInferior(BuildContext context) {
    return Container(
      height: 58,
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
            const ConsultaProductoPagina(),
          ),
          _itemBarra(
            context,
            IdiomaService.texto('clients'),
            Icons.groups_2_outlined,
            const PaginaHistorial(),
          ),
          _itemBarra(
            context,
            IdiomaService.texto('profile'),
            Icons.person_outline_rounded,
            PaginaPerfil(onPerfilGuardado: _recargarPerfil),
          ),
        ],
      ),
    );
  }

  Widget _itemBarra(
    BuildContext context,
    String texto,
    IconData icono,
    Widget? destino, {
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
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
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
                onTap: destino == null
                    ? null
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => destino),
                        ),
                child: contenido,
              ),
      ),
    );
  }
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
