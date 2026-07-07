part of '../main.dart';

class CatalogoPdf4Life {
  final String id;
  final String titulo;
  final String descripcion;
  final String url;
  final String pais;

  const CatalogoPdf4Life({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.url,
    required this.pais,
  });

  factory CatalogoPdf4Life.desdeJson(Map<String, dynamic> json) {
    return CatalogoPdf4Life(
      id: (json['id'] ?? '').toString(),
      titulo: (json['titulo'] ?? '').toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      url: (json['url'] ?? '').toString(),
      pais: (json['pais'] ?? '').toString(),
    );
  }
}

class PaginaCatalogosPdf4Life extends StatefulWidget {
  const PaginaCatalogosPdf4Life({super.key});

  @override
  State<PaginaCatalogosPdf4Life> createState() =>
      _PaginaCatalogosPdf4LifeState();
}

class _PaginaCatalogosPdf4LifeState extends State<PaginaCatalogosPdf4Life> {
  List<CatalogoPdf4Life> _catalogos = [];
  bool _cargando = true;
  String? _compartiendoId;

  @override
  void initState() {
    super.initState();
    _cargarCatalogos();
  }

  Future<void> _cargarCatalogos() async {
    try {
      final contenido =
          await rootBundle.loadString('assets/enlaces/catalogos.json');
      final data = jsonDecode(contenido) as List<dynamic>;
      final catalogos = data
          .map((item) =>
              CatalogoPdf4Life.desdeJson(Map<String, dynamic>.from(item)))
          .where((item) => item.url.trim().isNotEmpty)
          .toList();
      if (!mounted) return;
      setState(() {
        _catalogos = catalogos;
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _cargando = false);
    }
  }

  Future<void> _abrirCatalogo(CatalogoPdf4Life catalogo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _VisorCatalogoPdf4Life(catalogo: catalogo),
      ),
    );
  }

  Future<void> _compartirCatalogo(CatalogoPdf4Life catalogo) async {
    if (_compartiendoId != null) return;
    setState(() => _compartiendoId = catalogo.id);

    try {
      final carpetaTemporal = await getTemporaryDirectory();
      final nombreArchivo = '${_nombreArchivoSeguro(catalogo.titulo)}.pdf';
      final ruta =
          '${carpetaTemporal.path}${Platform.pathSeparator}$nombreArchivo';
      await Dio().download(catalogo.url, ruta);
      await Share.shareXFiles(
        [XFile(ruta, mimeType: 'application/pdf', name: nombreArchivo)],
        subject: catalogo.titulo,
        text: catalogo.descripcion,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              txtApp(
                'No se pudo compartir el PDF.',
                'The PDF could not be shared.',
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _compartiendoId = null);
    }
  }

  String _nombreArchivoSeguro(String texto) {
    final limpio = normalizarTexto(texto)
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    return limpio.isEmpty ? 'catalogo_4life' : limpio;
  }

  @override
  Widget build(BuildContext context) {
    final ingles = IdiomaService.actual.value == IdiomaApp.ingles;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
              child: Row(
                children: [
                  IconButton(
                    tooltip: txtApp('Cerrar', 'Close'),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: const Color(0xFF12248B),
                    iconSize: 34,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      txtApp('Catálogos PDF', 'PDF Catalogs'),
                      style: const TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 31,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : _catalogos.isEmpty
                      ? Center(
                          child: Text(
                            ingles
                                ? 'No catalogs available.'
                                : 'No hay catálogos disponibles.',
                            style: const TextStyle(
                              color: Color(0xFF465074),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                          itemCount: _catalogos.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) =>
                              _tarjetaCatalogo(_catalogos[index]),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaCatalogo(CatalogoPdf4Life catalogo) {
    final compartiendo = _compartiendoId == catalogo.id;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E3192), Color(0xFF151B7C)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF12248B).withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catalogo.titulo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        height: 1.12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      catalogo.pais,
                      style: const TextStyle(
                        color: Color(0xFFDDE3FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            catalogo.descripcion,
            style: const TextStyle(
              color: Color(0xFFE9EDFF),
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _abrirCatalogo(catalogo),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.70),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.visibility_rounded),
                  label: Text(txtApp('Ver PDF', 'View PDF')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      compartiendo ? null : () => _compartirCatalogo(catalogo),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF12248B),
                    disabledBackgroundColor:
                        Colors.white.withValues(alpha: 0.72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: compartiendo
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.ios_share_rounded),
                  label: Text(txtApp('Compartir', 'Share')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisorCatalogoPdf4Life extends StatelessWidget {
  final CatalogoPdf4Life catalogo;

  const _VisorCatalogoPdf4Life({required this.catalogo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12248B),
        foregroundColor: Colors.white,
        title: Text(
          catalogo.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SfPdfViewer.network(
        catalogo.url,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        onDocumentLoadFailed: (details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                txtApp(
                  'No se pudo cargar el PDF dentro de la app.',
                  'The PDF could not be loaded inside the app.',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
