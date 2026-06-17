part of '../main.dart';

class FormularioCambioFisico extends StatefulWidget {
  const FormularioCambioFisico({super.key});

  @override
  State<FormularioCambioFisico> createState() => _FormularioCambioFisicoState();
}

class _FormularioCambioFisicoState extends State<FormularioCambioFisico> {
  final nombreController = TextEditingController();
  final edadController = TextEditingController();
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  final objetivoController = TextEditingController();
  String? _generoSeleccionado;
  String? _contexturaSeleccionada;
  bool cargando = false;

  static const Map<String, String> _contexturas = {
    'Ectomorfo':
        'Complexion delgada, extremidades largas y huesos finos. Metabolismo rapido; les cuesta subir de peso y ganar masa muscular.',
    'Mesomorfo':
        'Complexion atletica, naturalmente musculoso y fuerte. Metabolismo eficiente; ganan masa muscular con facilidad y mantienen un peso estable rapidamente.',
    'Endomorfo':
        'Estructura osea mas ancha, cuerpo suave y redondeado. Metabolismo lento; tienden a acumular grasa con mayor facilidad, pero tambien pueden desarrollar buena masa muscular.',
  };

  @override
  void initState() {
    super.initState();
    for (final controller in [
      nombreController,
      edadController,
      pesoController,
      alturaController,
      objetivoController,
    ]) {
      controller.addListener(_actualizar);
    }
  }

  void _actualizar() {
    if (mounted) setState(() {});
  }

  int get _camposCompletos {
    var completos = 0;
    if (nombreController.text.trim().isNotEmpty) completos++;
    if (edadController.text.trim().isNotEmpty) completos++;
    if ((_generoSeleccionado ?? '').trim().isNotEmpty) completos++;
    if (pesoController.text.trim().isNotEmpty) completos++;
    if (alturaController.text.trim().isNotEmpty) completos++;
    if ((_contexturaSeleccionada ?? '').trim().isNotEmpty) completos++;
    if (objetivoController.text.trim().isNotEmpty) completos++;
    return completos;
  }

  double get _progreso => _camposCompletos / 7;

  Future<void> generarCambioFisico() async {
    if (_camposCompletos < 7) {
      _mostrarDialogoSimple(
        "Datos incompletos",
        "Completa todos los campos para generar la recomendacion.",
      );
      return;
    }

    setState(() => cargando = true);

    final model = GenerativeModel(
      model: 'gemini-3.1-flash-lite',
      apiKey: geminiApiKey,
    );

    final perfilAsesor = await PerfilService.cargar();
    final instruccionIdioma = await IdiomaService.instruccionIa();
    final saludoAsesor = perfilAsesor.tieneNombre
        ? "Inicia el reporte con este saludo personalizado: Hola, como estas, mi nombre es ${perfilAsesor.nombre.trim()}. Luego continua con la guia."
        : "Inicia con un saludo empatico breve y luego continua con la guia.";

    final prompt = """
    IDIOMA OBLIGATORIO:
    $instruccionIdioma

    DATOS PARA CAMBIO FISICO:
    Nombre: ${nombreController.text}
    Edad: ${edadController.text}
    Genero: $_generoSeleccionado
    Peso: ${pesoController.text} kg
    Altura: ${alturaController.text} m
    Contextura: $_contexturaSeleccionada - ${_contexturas[_contexturaSeleccionada] ?? ''}
    Objetivo fisico: ${objetivoController.text}
    $saludoAsesor

    Actua como asesor profesional de bienestar, composicion corporal y suplementos 4Life. Genera una guia responsable, clara y lista para compartir por WhatsApp.

    REGLA CRITICA DE PRODUCTOS:
    - Debes recomendar UNICAMENTE productos de esta lista: $catalogoCambioFisico4Life.
    - Recomienda maximo 3 o 4 productos.
    - No inventes productos, no uses medicamentos, no recomiendes marcas externas y no menciones productos fuera de la lista.

    Instrucciones:
    1. Usa asteriscos para titulos en negrita de WhatsApp.
    2. Enfoca el analisis en peso, altura, genero, contextura y objetivo fisico.
    3. No prometas resultados exactos ni milagrosos.
    4. Para cada producto incluye dosis general por horario si corresponde.
    5. Agrega 3 recomendaciones de habitos: alimentacion, entrenamiento y descanso.

    Estructura obligatoria:

    *SALUDO Y ANALISIS FISICO*
    [Analisis breve del perfil y objetivo]

    *PLAN DE APOYO 4LIFE (Max. 3-4 productos)*

    *1. [Nombre exacto del producto]*
    - *Dosis manana:* [Cantidad]
    - *Dosis tarde:* [Cantidad, si aplica]
    - *Dosis noche:* [Cantidad, si aplica]
    - *Apoyo principal:* [Explicacion breve]

    [Repetir solo hasta 3 o 4 productos]

    *HABITOS PARA EL OBJETIVO*
    - [Consejo de alimentacion]
    - [Consejo de entrenamiento]
    - [Consejo de descanso/seguimiento]

    *Nota responsable:* Esta guia es de apoyo general para bienestar y composicion corporal; no sustituye una evaluacion medica, nutricional o deportiva profesional.""";

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final textoFinal = response.text ?? "Sin respuesta";

      await HistorialService.guardar(
        "Cambio fisico: ${nombreController.text}",
        textoFinal,
        {
          'nombre': nombreController.text,
          'edad': edadController.text,
          'genero': _generoSeleccionado!,
          'peso': pesoController.text,
          'altura': alturaController.text,
          'contextura': _contexturaSeleccionada!,
          'objetivoFisico': objetivoController.text,
        },
        tipo: 'cambio_fisico',
      );

      _mostrarResultado(textoFinal, perfilAsesor);
    } catch (e) {
      _mostrarDialogoSimple("Error", "No se pudo conectar con la IA.");
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  void _mostrarResultado(String mensaje, PerfilAsesor perfilAsesor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaResultadoFicha(
          titulo: "Resultado de Cambio Físico",
          tipoFicha: "Cambio físico",
          paciente: nombreController.text,
          nombreAsesor: perfilAsesor.nombre,
          especialidad: "Asesor de bienestar y composición corporal",
          resultado: mensaje,
          fecha: DateTime.now(),
          imagenesProducto: imagenesProducto4Life,
          preciosProducto: preciosResultado4Life,
        ),
      ),
    );
  }

  void _mostrarDialogoSimple(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(titulo), content: Text(mensaje)),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    edadController.dispose();
    pesoController.dispose();
    alturaController.dispose();
    objetivoController.dispose();
    super.dispose();
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
                colors: [Color(0xFF172B98), Color(0xFF07125E)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              child: Column(
                children: [
                  _encabezado(),
                  const SizedBox(height: 48),
                  _tarjetaProgreso(),
                  const SizedBox(height: 22),
                  _tarjetaCampo(
                    titulo: "Nombre completo",
                    icono: Icons.person_outline_rounded,
                    child: _campoTexto(
                      controller: nombreController,
                      hint: "Ingresa tu nombre",
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Edad",
                    icono: Icons.calendar_month_rounded,
                    child: _campoTexto(
                      controller: edadController,
                      hint: "Ingresa tu edad",
                      prefixIcon: Icons.calendar_month_outlined,
                      keyboardType: TextInputType.number,
                      suffixText: "Años",
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Genero",
                    icono: Icons.transgender_rounded,
                    child: _selectorGenero(),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Peso en kilogramos",
                    icono: Icons.monitor_weight_outlined,
                    child: _campoTexto(
                      controller: pesoController,
                      hint: "Ej. 72",
                      prefixIcon: Icons.monitor_weight_outlined,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      suffixText: "Kg",
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Altura en metros",
                    icono: Icons.height_rounded,
                    child: _campoTexto(
                      controller: alturaController,
                      hint: "Ej. 1.70",
                      prefixIcon: Icons.height_rounded,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      suffixText: "m",
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Contextura",
                    icono: Icons.accessibility_new_rounded,
                    child: _selectorContextura(),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampo(
                    titulo: "Objetivo fisico",
                    icono: Icons.flag_outlined,
                    child: _campoObjetivo(),
                  ),
                  const SizedBox(height: 20),
                  _tarjetaInfo(),
                  const SizedBox(height: 26),
                  _botonGenerar(),
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
                "Ficha de Cambio Fisico",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Completa los datos para una guia corporal personalizada",
                style: TextStyle(
                  color: Color(0xFFD9DFFF),
                  fontSize: 18,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tarjetaProgreso() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
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
        children: [
          Row(
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2E7FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: Color(0xFF4865F4),
                  size: 54,
                ),
              ),
              const SizedBox(width: 22),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Completa la ficha",
                      style: TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      "La guia se adapta al perfil fisico y objetivo.",
                      style: TextStyle(
                        color: Color(0xFF3F4A82),
                        fontSize: 18,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF1FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$_camposCompletos de 7",
                  style: const TextStyle(
                    color: Color(0xFF4565F0),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: _progreso,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E8FF),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF4865F4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaCampo({
    required String titulo,
    required IconData icono,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE3E7FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icono, color: const Color(0xFF4059EA), size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoTexto({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    String? suffixText,
    TextInputAction? textInputAction,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: _inputDecoracion(
        hint: hint,
        prefixIcon: prefixIcon,
        suffixText: suffixText,
      ),
    );
  }

  Widget _selectorGenero() {
    return DropdownButtonFormField<String>(
      initialValue: _generoSeleccionado,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF12248B), size: 32),
      decoration: _inputDecoracion(hint: "Selecciona una opcion"),
      items: const [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
      ],
      onChanged: (valor) => setState(() => _generoSeleccionado = valor),
    );
  }

  Widget _selectorContextura() {
    final descripcion = _contexturas[_contexturaSeleccionada];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _contexturaSeleccionada,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF12248B), size: 32),
          decoration: _inputDecoracion(hint: "Selecciona una contextura"),
          items: _contexturas.keys
              .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
              .toList(),
          onChanged: (valor) => setState(() => _contexturaSeleccionada = valor),
        ),
        if (descripcion != null) ...[
          const SizedBox(height: 12),
          Text(
            descripcion,
            style: const TextStyle(
              color: Color(0xFF4C5687),
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _campoObjetivo() {
    final conteo = objetivoController.text.characters.length;
    return Stack(
      children: [
        TextField(
          controller: objetivoController,
          minLines: 6,
          maxLines: 6,
          maxLength: 500,
          textInputAction: TextInputAction.newline,
          decoration: _inputDecoracion(
            hint: "Describe el objetivo fisico...",
            alignLabelWithHint: true,
          ).copyWith(counterText: ""),
        ),
        Positioned(
          right: 18,
          bottom: 16,
          child: Text(
            "$conteo/500",
            style: const TextStyle(
              color: Color(0xFF4C5687),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoracion({
    required String hint,
    IconData? prefixIcon,
    String? suffixText,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hint,
      alignLabelWithHint: alignLabelWithHint,
      hintStyle: const TextStyle(
        color: Color(0xFF6B7192),
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, color: const Color(0xFF535B86), size: 28),
      suffixIcon: suffixText == null
          ? null
          : Container(
              width: 76,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFFE5E7F0), width: 1.2),
                ),
              ),
              child: Text(
                suffixText,
                style: const TextStyle(
                  color: Color(0xFF12248B),
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC8CDE0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF4059EA), width: 1.8),
      ),
    );
  }

  Widget _tarjetaInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF0FF), Color(0xFFF5F7FF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFF5367F2),
            child: Icon(Icons.info_rounded, color: Colors.white, size: 30),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              "La recomendacion se genera solo con los datos corporales ingresados y productos permitidos para cambio fisico.",
              style: TextStyle(
                color: Color(0xFF17246B),
                fontSize: 17,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonGenerar() {
    return InkWell(
      borderRadius: BorderRadius.circular(36),
      onTap: cargando ? null : generarCambioFisico,
      child: Container(
        height: 76,
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
          child: cargando
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fitness_center_rounded,
                        color: Colors.white, size: 34),
                    SizedBox(width: 18),
                    Text(
                      "GENERAR GUIA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// --- PANTALLA: CONSULTA DE PRODUCTO ---
