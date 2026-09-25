part of '../main.dart';

class PaginaSeleccionPais extends StatefulWidget {
  final VoidCallback onContinuar;

  const PaginaSeleccionPais({super.key, required this.onContinuar});

  @override
  State<PaginaSeleccionPais> createState() => _PaginaSeleccionPaisState();
}

class _PaginaSeleccionPaisState extends State<PaginaSeleccionPais> {
  static const _azul = Color(0xFF172394);
  static const _oscuro = Color(0xFF07125E);
  PaisApp? _pais;
  late IdiomaApp _idioma;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    // El país siempre exige una elección nueva. El idioma sí se conserva.
    _idioma = IdiomaService.actual.value;
  }

  String _texto(String espanol, String ingles) =>
      _idioma == IdiomaApp.ingles ? ingles : espanol;

  Future<void> _continuar() async {
    final pais = _pais;
    if (pais == null || _guardando) return;
    setState(() => _guardando = true);
    try {
      await PaisService.guardar(pais);
      if (_idioma != IdiomaService.actual.value) {
        await IdiomaService.guardar(_idioma);
      }
      if (!mounted) return;
      widget.onContinuar();
    } catch (error) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_texto(
          'No se pudo guardar la selección. Inténtalo nuevamente.',
          'Could not save your selection. Please try again.',
        ))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_guardando,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7FB),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: _CurvaEncabezadoPais(),
                child: Container(
                  height: 150 + MediaQuery.paddingOf(context).top,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_azul, _oscuro],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/icon.webp',
                              width: 124,
                              height: 124,
                              semanticLabel: 'DoctorSuplementos',
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _texto('Elige tu país', 'Select your country'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: _oscuro),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _texto('Select your country', 'Elige tu país'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20, color: Color(0xFF77769D)),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                _texto(
                                  'Selecciona el país desde el cual vas a utilizar la aplicación.',
                                  'Select the country from which you will use the application.',
                                ),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, height: 1.5, color: _oscuro),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                  child: Container(
                                width: 42,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFB4A3DD),
                                    borderRadius: BorderRadius.circular(99)),
                              )),
                              const SizedBox(height: 28),
                              LayoutBuilder(builder: (context, constraints) {
                                final tarjetas = [
                                  _tarjeta(PaisApp.ecuador),
                                  _tarjeta(PaisApp.estadosUnidos),
                                ];
                                final escala =
                                    MediaQuery.textScalerOf(context).scale(16) /
                                        16;
                                if (constraints.maxWidth < 300 * escala) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      tarjetas[0],
                                      const SizedBox(height: 16),
                                      tarjetas[1]
                                    ],
                                  );
                                }
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: tarjetas[0]),
                                    const SizedBox(width: 16),
                                    Expanded(child: tarjetas[1])
                                  ],
                                );
                              }),
                              const SizedBox(height: 28),
                              Text(
                                _texto('Selecciona tu idioma',
                                    'Select your language'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: _oscuro),
                              ),
                              const SizedBox(height: 12),
                              IgnorePointer(
                                ignoring: _guardando,
                                child: SelectorEstilizado<IdiomaApp>(
                                  valor: _idioma,
                                  placeholder: _texto('Selecciona tu idioma',
                                      'Select your language'),
                                  icono: Icons.language_rounded,
                                  alto: math.max(
                                      64,
                                      MediaQuery.textScalerOf(context)
                                              .scale(16) +
                                          40),
                                  opciones: [
                                    OpcionSelectorEstilizado(
                                        valor: IdiomaApp.espanol,
                                        texto: _texto('Español', 'Spanish'),
                                        emoji: '🇪🇸'),
                                    const OpcionSelectorEstilizado(
                                        valor: IdiomaApp.ingles,
                                        texto: 'English',
                                        emoji: '🇺🇸'),
                                  ],
                                  onChanged: (idioma) {
                                    if (!_guardando) {
                                      setState(() => _idioma = idioma);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 28),
                              FilledButton(
                                key: const ValueKey('continuar-seleccion'),
                                onPressed: _pais == null || _guardando
                                    ? null
                                    : _continuar,
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF3734A5),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                                child: _guardando
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white))
                                    : Text(_texto('Continuar', 'Continue'),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjeta(PaisApp pais) {
    final seleccionada = _pais == pais;
    return Semantics(
      selected: seleccionada,
      button: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: seleccionada ? const Color(0xFFEEF1FF) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: seleccionada ? _azul : const Color(0xFFEEEBFA), width: 2),
          boxShadow: [
            BoxShadow(
              color: _oscuro.withValues(alpha: seleccionada ? 0.14 : 0.05),
              blurRadius: seleccionada ? 22 : 18,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: ValueKey('pais-${pais.codigo}'),
            borderRadius: BorderRadius.circular(24),
            onTap: _guardando ? null : () => setState(() => _pais = pais),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(children: [
                ExcludeSemantics(
                  child: _InsigniaPais(pais: pais, grande: true),
                ),
                const SizedBox(height: 12),
                Text(_texto(pais.etiqueta, pais.etiquetaIngles),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _oscuro)),
                const SizedBox(height: 12),
                Icon(
                    seleccionada
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: seleccionada ? _azul : const Color(0xFFB4BAD1)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _InsigniaPais extends StatelessWidget {
  final PaisApp pais;
  final bool grande;

  const _InsigniaPais({required this.pais, this.grande = false});

  @override
  Widget build(BuildContext context) {
    final altura = grande ? 52.0 : 30.0;
    final proporcion = pais == PaisApp.ecuador ? 1.5 : 1.9;
    return Container(
      width: altura * proporcion,
      height: altura,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(grande ? 12 : 8),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF07125E).withValues(alpha: 0.14),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SvgPicture.asset(
        pais == PaisApp.ecuador
            ? 'assets/banderas/ecuador.svg'
            : 'assets/banderas/estados_unidos.svg',
        fit: BoxFit.cover,
        excludeFromSemantics: true,
      ),
    );
  }
}

class _CurvaEncabezadoPais extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..lineTo(size.width, 0)
    ..lineTo(size.width, size.height)
    ..quadraticBezierTo(size.width / 2, 0, 0, size.height)
    ..close();

  @override
  bool shouldReclip(_CurvaEncabezadoPais oldClipper) => false;
}
