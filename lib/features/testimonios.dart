part of '../main.dart';

class Testimonio4Life {
  final String id;
  final String titulo;
  final String descripcion;
  final String videoUrl;
  final String duracion;
  final String categoriaEnfermedad;
  final List<String> descripcionParrafos;

  const Testimonio4Life({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.videoUrl,
    required this.duracion,
    required this.categoriaEnfermedad,
    required this.descripcionParrafos,
  });

  factory Testimonio4Life.desdeJson(Map<String, dynamic> json) {
    return Testimonio4Life(
      id: (json['id'] ?? '').toString(),
      titulo: (json['titulo'] ?? '').toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      videoUrl: (json['videoUrl'] ?? '').toString(),
      duracion: (json['duracion'] ?? '').toString(),
      categoriaEnfermedad: (json['categoriaEnfermedad'] ?? '').toString(),
      descripcionParrafos: (json['descripcionParrafos'] as List? ?? const [])
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(),
    );
  }
}

extension _FormatoDuracionTestimonio on Duration {
  String get formatoVideo {
    if (this <= Duration.zero) return '';
    final horas = inHours;
    final minutos = inMinutes.remainder(60).toString().padLeft(2, '0');
    final segundos = inSeconds.remainder(60).toString().padLeft(2, '0');
    if (horas > 0) return '$horas:$minutos:$segundos';
    return '${inMinutes.remainder(60)}:$segundos';
  }
}

class PaginaTestimonios4Life extends StatefulWidget {
  const PaginaTestimonios4Life({super.key});

  @override
  State<PaginaTestimonios4Life> createState() => _PaginaTestimonios4LifeState();
}

class _PaginaTestimonios4LifeState extends State<PaginaTestimonios4Life> {
  final TextEditingController _busquedaController = TextEditingController();
  final Map<String, String> _calidades = const {
    'Auto': '',
    '720p': 'q_auto:good,c_limit,w_1280',
    '480p': 'q_auto:eco,c_limit,w_854',
    '360p': 'q_auto:eco,c_limit,w_640',
  };

  String _busqueda = '';
  String _calidadActual = 'Auto';
  double _volumen = 1.0;
  final Map<String, String> _duracionesDetectadas = {};
  List<Testimonio4Life> _testimonios = [];
  Testimonio4Life? _seleccionado;
  VideoPlayerController? _videoController;
  bool _cargandoLista = true;
  bool _cargandoVideo = false;
  bool _compartiendoVideo = false;
  bool _miniPlayer = false;

  @override
  void initState() {
    super.initState();
    _cargarTestimonios();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _cargarTestimonios() async {
    try {
      final contenido =
          await rootBundle.loadString('assets/testimonios/testimonios.json');
      final datos = jsonDecode(contenido) as List;
      final testimonios = datos
          .whereType<Map>()
          .map((item) => Testimonio4Life.desdeJson(
                item.cast<String, dynamic>(),
              ))
          .where((item) => item.titulo.isNotEmpty && item.videoUrl.isNotEmpty)
          .toList();
      if (!mounted) return;
      setState(() {
        _testimonios = testimonios;
        _cargandoLista = false;
      });
      unawaited(_cargarDuracionesVideos(testimonios));
    } catch (_) {
      if (!mounted) return;
      setState(() => _cargandoLista = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cargar testimonios.')),
      );
    }
  }

  List<Testimonio4Life> get _resultados {
    final consulta = normalizarTexto(_busqueda);
    if (consulta.isEmpty) return _testimonios;

    final palabras = consulta
        .split(RegExp(r'\s+'))
        .where((palabra) => palabra.trim().length > 1)
        .toList();
    final puntuados = <MapEntry<Testimonio4Life, int>>[];

    for (final testimonio in _testimonios) {
      final texto = normalizarTexto(
        '${testimonio.titulo} ${testimonio.descripcion} '
        '${testimonio.categoriaEnfermedad} '
        '${testimonio.descripcionParrafos.join(' ')}',
      );
      var puntaje = texto.contains(consulta) ? 8 : 0;
      for (final palabra in palabras) {
        if (texto.contains(palabra)) puntaje += 2;
      }
      if (puntaje > 0) puntuados.add(MapEntry(testimonio, puntaje));
    }

    puntuados.sort((a, b) => b.value.compareTo(a.value));
    return puntuados.map((entry) => entry.key).toList();
  }

  Future<void> _abrirReproductor(Testimonio4Life testimonio) async {
    setState(() => _miniPlayer = false);
    await _prepararVideo(testimonio);
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, actualizarModal) => _reproductorGrande(
          testimonio,
          actualizarModal,
        ),
      ),
    );
  }

  Future<void> _prepararVideo(Testimonio4Life testimonio) async {
    setState(() {
      _seleccionado = testimonio;
      _cargandoVideo = true;
    });

    final posicionAnterior = _videoController?.value.position ?? Duration.zero;
    final anterior = _videoController;
    _videoController = null;
    await anterior?.dispose();

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(_urlPorCalidad(testimonio.videoUrl, _calidadActual)),
    );
    _videoController = controller;

    try {
      await controller.initialize();
      _guardarDuracionDetectada(testimonio, controller.value.duration);
      await controller.setVolume(_volumen);
      if (posicionAnterior > Duration.zero &&
          posicionAnterior < controller.value.duration) {
        await controller.seekTo(posicionAnterior);
      }
      await controller.play();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo reproducir el video.')),
        );
      }
    }

    if (!mounted) return;
    setState(() => _cargandoVideo = false);
  }

  Future<void> _cargarDuracionesVideos(
      List<Testimonio4Life> testimonios) async {
    for (final testimonio in testimonios) {
      if (_duracionesDetectadas.containsKey(testimonio.id)) continue;
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(testimonio.videoUrl),
      );
      try {
        await controller.initialize();
        _guardarDuracionDetectada(testimonio, controller.value.duration);
      } catch (_) {
        // La duracion manual queda como respaldo si la metadata no responde.
      } finally {
        await controller.dispose();
      }
    }
  }

  void _guardarDuracionDetectada(
    Testimonio4Life testimonio,
    Duration duracion,
  ) {
    final texto = duracion.formatoVideo;
    if (texto.isEmpty || _duracionesDetectadas[testimonio.id] == texto) return;
    if (!mounted) return;
    setState(() => _duracionesDetectadas[testimonio.id] = texto);
  }

  String _duracionVisible(Testimonio4Life testimonio) {
    return _duracionesDetectadas[testimonio.id] ?? testimonio.duracion;
  }

  String _urlPorCalidad(String url, String calidad) {
    final transformacion = _calidades[calidad] ?? '';
    if (transformacion.isEmpty || !url.contains('/upload/')) return url;
    return url.replaceFirst('/upload/', '/upload/$transformacion/');
  }

  Future<void> _cambiarCalidad(String calidad) async {
    if (_seleccionado == null || calidad == _calidadActual) return;
    setState(() => _calidadActual = calidad);
    await _prepararVideo(_seleccionado!);
  }

  Future<void> _compartirMp4(Testimonio4Life testimonio) async {
    if (_compartiendoVideo) return;
    setState(() => _compartiendoVideo = true);

    try {
      final carpetaTemporal = await getTemporaryDirectory();
      final nombreArchivo = '${_nombreArchivoSeguro(testimonio.titulo)}.mp4';
      final ruta =
          '${carpetaTemporal.path}${Platform.pathSeparator}$nombreArchivo';
      await Dio().download(testimonio.videoUrl, ruta);
      await Share.shareXFiles(
        [XFile(ruta, mimeType: 'video/mp4', name: nombreArchivo)],
        subject: testimonio.titulo,
        text: testimonio.descripcion,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo compartir el MP4.')),
        );
      }
    } finally {
      if (mounted) setState(() => _compartiendoVideo = false);
    }
  }

  String _nombreArchivoSeguro(String texto) {
    final limpio = normalizarTexto(texto)
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    return limpio.isEmpty ? 'testimonio_4life' : limpio;
  }

  Future<void> _abrirPantallaCompleta() async {
    final testimonio = _seleccionado;
    if (testimonio == null) return;
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (context) => StatefulBuilder(
        builder: (context, actualizarModal) => Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: SafeArea(
            child: Stack(
              children: [
                Center(child: _videoGrande()),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: _controlesVideo(testimonio, actualizarModal),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.close_fullscreen_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _abrirSugerenciaWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/593959848545?text=Hola!%20puedes%20a%C3%B1adir%20este%20testimonio',
    );
    final abierto = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!abierto && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            IdiomaService.actual.value == IdiomaApp.ingles
                ? 'Could not open WhatsApp.'
                : 'No se pudo abrir WhatsApp.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingles = IdiomaService.actual.value == IdiomaApp.ingles;
    final resultados = _resultados;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF172B98), Color(0xFF06105A)],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      _encabezado(context, ingles),
                      const SizedBox(height: 18),
                      _buscador(ingles),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 24),
                  children: [
                    _tituloBiblioteca(ingles),
                    const SizedBox(height: 14),
                    if (_cargandoLista)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 34),
                          child: CircularProgressIndicator(
                            color: Color(0xFF172394),
                          ),
                        ),
                      )
                    else if (resultados.isEmpty)
                      _estadoVacio(ingles)
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: resultados.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.62,
                        ),
                        itemBuilder: (context, index) {
                          return _tarjetaVideo(resultados[index], ingles);
                        },
                      ),
                    SizedBox(
                      height: resultados.length <= 3
                          ? math.max(
                              24,
                              MediaQuery.of(context).size.height * 0.26,
                            )
                          : 24,
                    ),
                    _ayudaTestimonios(ingles),
                    if (_miniPlayer) const SizedBox(height: 126),
                  ],
                ),
              ),
            ],
          ),
          if (_miniPlayer && _seleccionado != null) _miniReproductor(ingles),
        ],
      ),
    );
  }

  Widget _encabezado(BuildContext context, bool ingles) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          iconSize: 32,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 42, height: 42),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            ingles ? 'Testimonials' : 'Testimonios',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              height: 1.05,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buscador(bool ingles) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _busquedaController,
        onChanged: (valor) => setState(() => _busqueda = valor),
        decoration: InputDecoration(
          hintText: ingles ? 'Search' : 'Buscar',
          hintStyle: const TextStyle(
            color: Color(0xFF7A819F),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF172394),
            size: 28,
          ),
          suffixIcon: _busqueda.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _busquedaController.clear();
                    setState(() => _busqueda = '');
                  },
                  icon: const Icon(Icons.close_rounded),
                  color: const Color(0xFF66708F),
                ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
      ),
    );
  }

  Widget _tituloBiblioteca(bool ingles) {
    return Row(
      children: [
        const Icon(
          Icons.video_library_rounded,
          color: Color(0xFF2839C7),
          size: 25,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            ingles ? 'Video library' : 'Caja de testimonios',
            style: const TextStyle(
              color: Color(0xFF07136E),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tarjetaVideo(Testimonio4Life testimonio, bool ingles) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _abrirReproductor(testimonio),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF172B98), Color(0xFF06105A)],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.18,
                    child: GridPaper(
                      color: Colors.white,
                      divisions: 2,
                      subdivisions: 1,
                      interval: 34,
                    ),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.66),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _duracionVisible(testimonio),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            testimonio.titulo,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF111B4F),
              fontSize: 11.5,
              height: 1.12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            ingles ? 'Testimonial video' : 'Video testimonial',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF687092),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reproductorGrande(
    Testimonio4Life testimonio,
    void Function(void Function()) actualizarModal,
  ) {
    final alto = MediaQuery.of(context).size.height * 0.92;
    return Container(
      height: alto,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: Colors.black,
              child: Stack(
                children: [
                  _videoGrande(),
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: _controlesVideo(testimonio, actualizarModal),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                testimonio.titulo,
                style: const TextStyle(
                  color: Color(0xFF07136E),
                  fontSize: 20,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _descripcionVideo(testimonio),
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoGrande() {
    final controller = _videoController;
    final listo = controller != null && controller.value.isInitialized;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final maxHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : double.infinity;
        final ancho = math.min(maxWidth, maxHeight * 9 / 16);
        return Center(
          child: SizedBox(
            width: ancho,
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: _cargandoVideo || !listo
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : VideoPlayer(controller),
            ),
          ),
        );
      },
    );
  }

  Widget _videoMiniatura() {
    final controller = _videoController;
    final listo = controller != null && controller.value.isInitialized;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _cargandoVideo || !listo
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : VideoPlayer(controller),
    );
  }

  Widget _controlesVideo(
    Testimonio4Life testimonio,
    void Function(void Function()) actualizarModal,
  ) {
    final controller = _videoController;
    final listo = controller != null && controller.value.isInitialized;
    final reproduciendo = listo && controller.value.isPlaying;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (listo)
            VideoProgressIndicator(
              controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Color(0xFF4C63FF),
                bufferedColor: Color(0xFF9EA8E8),
                backgroundColor: Color(0xFF283172),
              ),
            ),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton(
                color: Colors.white,
                onPressed: listo
                    ? () {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                        actualizarModal(() {});
                        setState(() {});
                      }
                    : null,
                icon: Icon(
                  reproduciendo
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
              ),
              IconButton(
                tooltip: 'Pantalla completa',
                color: Colors.white,
                onPressed: listo ? _abrirPantallaCompleta : null,
                icon: const Icon(Icons.fullscreen_rounded),
              ),
              IconButton(
                tooltip: 'Picture in picture',
                color: Colors.white,
                onPressed: listo
                    ? () {
                        Navigator.pop(context);
                        setState(() => _miniPlayer = true);
                      }
                    : null,
                icon: const Icon(Icons.picture_in_picture_alt_rounded),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6),
                  ),
                  child: Slider(
                    value: _volumen,
                    min: 0,
                    max: 1,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white38,
                    onChanged: listo
                        ? (valor) {
                            _volumen = valor;
                            controller.setVolume(valor);
                            actualizarModal(() {});
                            setState(() {});
                          }
                        : null,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Calidad',
                initialValue: _calidadActual,
                color: Colors.white,
                onSelected: (valor) {
                  actualizarModal(() {});
                  unawaited(_cambiarCalidad(valor));
                },
                itemBuilder: (context) => [
                  for (final calidad in _calidades.keys)
                    PopupMenuItem(value: calidad, child: Text(calidad)),
                ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    _calidadActual,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Compartir MP4',
                color: Colors.white,
                onPressed:
                    _compartiendoVideo ? null : () => _compartirMp4(testimonio),
                icon: _compartiendoVideo
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.2,
                        ),
                      )
                    : const Icon(Icons.ios_share_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _descripcionVideo(Testimonio4Life testimonio) {
    final parrafos = testimonio.descripcionParrafos.isEmpty
        ? [testimonio.descripcion]
        : testimonio.descripcionParrafos;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descripción',
            style: TextStyle(
              color: Color(0xFF07136E),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          for (final parrafo in parrafos) ...[
            Text(
              parrafo,
              style: const TextStyle(
                color: Color(0xFF2F3A78),
                fontSize: 14,
                height: 1.38,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _miniReproductor(bool ingles) {
    final testimonio = _seleccionado!;
    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: Material(
        elevation: 14,
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF07105A),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(width: 126, child: _videoMiniatura()),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  testimonio.titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.open_in_full_rounded),
                onPressed: () {
                  setState(() => _miniPlayer = false);
                  _abrirReproductor(testimonio);
                },
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  _videoController?.pause();
                  setState(() => _miniPlayer = false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _estadoVacio(bool ingles) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 16),
      alignment: Alignment.center,
      child: Text(
        ingles
            ? 'No testimonial videos found.'
            : 'No se encontraron testimonios relacionados.',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF56618F),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _ayudaTestimonios(bool ingles) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFFE2E7FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_comment_outlined,
              color: Color(0xFF2839C7),
              size: 31,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingles ? 'Suggest a testimonial' : 'Sugerir un testimonio',
                  style: const TextStyle(
                    color: Color(0xFF07136E),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ingles
                      ? 'Send a new video candidate through WhatsApp.'
                      : 'Envia un nuevo video candidato por WhatsApp.',
                  style: const TextStyle(
                    color: Color(0xFF2F3A78),
                    fontSize: 14,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: _abrirSugerenciaWhatsApp,
                  child: Text(
                    ingles ? 'click here' : 'click aqui',
                    style: const TextStyle(
                      color: Color(0xFF1457E8),
                      fontSize: 14,
                      height: 1.25,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF1457E8),
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
}
