part of '../main.dart';

class FormularioPaciente extends StatefulWidget {
  final Map<String, dynamic>? infoPrevia;
  const FormularioPaciente({super.key, this.infoPrevia});

  @override
  State<FormularioPaciente> createState() => _FormularioPacienteState();
}

class _FormularioPacienteState extends State<FormularioPaciente> {
  late TextEditingController nombreController;
  late TextEditingController edadController;
  late TextEditingController historialController;
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _generoSeleccionado;
  ArchivoAdjuntoIA? _adjunto;
  bool cargando = false;
  bool _grabandoAudio = false;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(
        text: widget.infoPrevia?['datos']?['nombre'] ?? "");
    edadController =
        TextEditingController(text: widget.infoPrevia?['datos']?['edad'] ?? "");
    _generoSeleccionado = widget.infoPrevia?['datos']?['genero'];
    historialController = TextEditingController();
    nombreController.addListener(_actualizarProgresoFormulario);
    edadController.addListener(_actualizarProgresoFormulario);
    historialController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _actualizarProgresoFormulario() {
    if (mounted) setState(() {});
  }

  int get _camposCompletosFormulario {
    var completos = 0;
    if (nombreController.text.trim().isNotEmpty) completos++;
    if (edadController.text.trim().isNotEmpty) completos++;
    if ((_generoSeleccionado ?? '').trim().isNotEmpty) completos++;
    if (historialController.text.trim().isNotEmpty ||
        _adjunto?.esAudio == true) {
      completos++;
    }
    return completos;
  }

  double get _progresoFormulario => _camposCompletosFormulario / 4;

  Future<void> generarDiagnostico() async {
    if (historialController.text.isEmpty && _adjunto == null) return;
    if (_generoSeleccionado == null || _generoSeleccionado!.isEmpty) {
      _mostrarDialogoSimple("Falta género", "Por favor, selecciona el género.");
      return;
    }
    setState(() => cargando = true);

    final model = GenerativeModel(
      model: 'gemini-3.1-flash-lite',
      apiKey: geminiApiKey,
    );

    String contextoAnterior = widget.infoPrevia != null
        ? "HISTORIAL PREVIO: El paciente anteriormente reportó: ${widget.infoPrevia!['datos']['sintomas']}. El resultado anterior fue: ${widget.infoPrevia!['resultado']}. "
        : "";

    final perfilAsesor = await PerfilService.cargar();
    final instruccionIdioma = await IdiomaService.instruccionIa();
    final saludoAsesor = perfilAsesor.tieneNombre
        ? "Inicia el reporte con este saludo personalizado: Hola, como estas, mi nombre es ${perfilAsesor.nombre.trim()}. Luego continua con el diagnostico."
        : "Inicia con un saludo empatico breve y luego continua con el diagnostico.";

    final prompt = """
    IDIOMA OBLIGATORIO:
    $instruccionIdioma

    $contextoAnterior
    SÍNTOMAS ACTUALES: ${historialController.text}
    DATOS: Nombre: ${nombreController.text}, Edad: ${edadController.text}, Género: $_generoSeleccionado.
    $saludoAsesor
    
    Actúa como un experto en inmunología, bioenergética y asesor profesional de la línea de suplementos de bienestar de 4Life. Tu objetivo es generar un reporte de recomendación altamente profesional, ético y optimizado exclusivamente para ser compartido por WhatsApp.

    REGLA CRÍTICA DE NEGOCIO: 
    - Debes recomendar ÚNICAMENTE estos productos: $catalogoPermitido4Life.
    - Queda estrictamente prohibido inventar nombres de productos, sugerir medicamentos fármacos o marcas externas a 4Life.

    Instrucciones estrictas de formato y contenido:
    1. Usa el formato de WhatsApp: coloca asteriscos (*) al principio y al final de los títulos o frases clave para generar textos en **negrita**. Usa listas con viñetas limpias (-) o números.
    2. El mensaje debe ser directo, empático y estructurado en bloques separados por espacios para que sea scannable en el celular.
    3. RECOMENDACIÓN DE PRODUCTOS: Recomienda un máximo de 3 o 4 productos de 4Life específicos para el caso. No satures al cliente.
    4. DOSIFICACIÓN EXACTA Y DETALLADA: Para cada producto recomendado, debes dar la dosis exacta en una lista independiente, clara y legible. Queda estrictamente prohibido agrupar o mezclar las dosis en un solo párrafo de texto corrido.
    5. TONO Y SEGURIDAD: Mantén un tono científico pero accesible. No uses lenguaje de ventas exagerado ni prometas "curas milagrosas". Incluye siempre de forma sutil que los suplementos respaldan las funciones fisiológicas y el sistema inmunitario, y que no sustituyen ningún tratamiento médico.

    Estructura requerida para la respuesta:

    *SALUDO Y ANÁLISIS DEL CASO*
    [Breve introducción empática analizando los datos del paciente]

    *SUSTRATO Y RESPALDO RECOMENDADO (Máx. 3-4 productos)*

    *1. [Nombre del Producto 4Life]*
    - *Dosis mañana:* [Cantidad exacta]
    - *Dosis tarde:* [Cantidad exacta]
    - *Dosis noche:* [Cantidad exacta]
    - *Beneficio clave:* [Breve explicación técnica de cómo actúa en el organismo]

    *2. [Nombre del Producto 4Life]*
    - *Dosis mañana:* [Cantidad exacta]
    - *Dosis tarde:* [Cantidad exacta]
    - *Dosis noche:* [Cantidad exacta]
    - *Beneficio clave:* [Breve explicación técnica]

    [Repetir estructura si se requiere un 3er o 4to producto, máximo y si no requiere no incluir el texto "No se requiere" o "No aplica"] 
    [Si por ejemplo no se tiene que tomar en la tarde o noche no pongas esa sección y solo pon las secciones que sean]
      
    *RECOMENDACIONES DE BIENESTAR GENERAL*
    - [Dar 2 o 3 hábitos diarios o consejos funcionales de apoyo]

    *Nota de seguridad:* Los productos de 4Life están diseñados para respaldar y potenciar la inteligencia de tu sistema inmunitario y funciones metabólicas generales; no reemplazan las indicaciones de su médico de cabecera.""";

    try {
      final content = [
        if (_adjunto == null)
          Content.text(prompt)
        else
          Content.multi([
            TextPart(
              _adjunto!.esAudio
                  ? "$prompt\n\nAnaliza la nota de voz adjunta. Extrae los sintomas, contexto y datos relevantes mencionados por el paciente para orientar la recomendacion; no guardes ni menciones que el audio fue almacenado."
                  : "$prompt\n\nAnaliza tambien el archivo adjunto. Extrae solo la informacion relevante para orientar la recomendacion y usala como contexto complementario; no afirmes diagnosticos medicos definitivos.",
            ),
            DataPart(_adjunto!.mimeType, _adjunto!.bytes),
          ]),
      ];
      final response = await model.generateContent(content);
      String textoFinal = response.text ?? "Sin respuesta";

      await HistorialService.guardar(
          "Diagnóstico: ${nombreController.text}", textoFinal, {
        'nombre': nombreController.text,
        'edad': edadController.text,
        'genero': _generoSeleccionado!,
        'sintomas':
            historialController.text.trim().isEmpty && _adjunto?.esAudio == true
                ? 'Sintomas enviados por nota de voz (audio no guardado)'
                : historialController.text,
      });

      _mostrarResultado(textoFinal, perfilAsesor);
    } catch (e) {
      _mostrarDialogoSimple("Error", "No se pudo conectar con la IA.");
    } finally {
      setState(() => cargando = false);
    }
  }

  void _mostrarResultado(String mensaje, PerfilAsesor perfilAsesor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaResultadoFicha(
          titulo: "Resultado del Diagnóstico",
          tipoFicha: "Diagnóstico",
          paciente: nombreController.text,
          nombreAsesor: perfilAsesor.nombre,
          especialidad: "Especialista en inmunología y bioenergética",
          resultado: mensaje,
          fecha: DateTime.now(),
          imagenesProducto: imagenesProducto4Life,
          preciosProducto: preciosResultado4Life,
          ingles: IdiomaService.actual.value == IdiomaApp.ingles,
        ),
      ),
    );
  }

  void _mostrarDialogoSimple(String t, String m) {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(title: Text(t), content: Text(m)));
  }

  Future<void> _tomarFotoDiagnostico() async {
    final imagen = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 88,
    );
    if (imagen == null) return;

    final bytes = await imagen.readAsBytes();
    if (!mounted) return;
    setState(() {
      _adjunto = ArchivoAdjuntoIA(
        nombre: imagen.name,
        mimeType: imagen.mimeType ?? 'image/jpeg',
        bytes: bytes,
      );
    });
  }

  Future<void> _seleccionarArchivoDiagnostico() async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'webp'],
      withData: true,
    );
    final archivo = resultado?.files.single;
    final bytes = archivo?.bytes;
    if (archivo == null || bytes == null) return;

    final extension = (archivo.extension ?? '').toLowerCase();
    final mime = switch (extension) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };

    if (!mounted) return;
    setState(() {
      _adjunto = ArchivoAdjuntoIA(
        nombre: archivo.name,
        mimeType: mime,
        bytes: bytes,
      );
    });
  }

  Future<void> _alternarAudioDiagnostico() async {
    if (_grabandoAudio) {
      final path = await _audioRecorder.stop();
      if (!mounted) return;
      setState(() => _grabandoAudio = false);
      if (path == null) return;

      final archivo = File(path);
      final bytes = await archivo.readAsBytes();
      await archivo.delete().catchError((_) => archivo);
      if (bytes.isEmpty || !mounted) return;

      setState(() {
        _adjunto = ArchivoAdjuntoIA(
          nombre: 'Nota de voz para diagnostico.m4a',
          mimeType: 'audio/mp4',
          bytes: bytes,
        );
      });
      return;
    }

    if (!await _audioRecorder.hasPermission()) {
      _mostrarDialogoSimple(
        "Permiso de microfono",
        "Activa el permiso del microfono para grabar la nota de voz.",
      );
      return;
    }

    final carpetaTemporal = await getTemporaryDirectory();
    final path =
        '${carpetaTemporal.path}/diagnostico_${DateTime.now().microsecondsSinceEpoch}.m4a';
    await _audioRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        numChannels: 1,
        bitRate: 64000,
      ),
      path: path,
    );
    if (!mounted) return;
    setState(() => _grabandoAudio = true);
  }

  void _quitarAdjuntoDiagnostico() {
    setState(() => _adjunto = null);
  }

  @override
  void dispose() {
    if (_grabandoAudio) {
      unawaited(_audioRecorder.cancel());
    }
    _audioRecorder.dispose();
    nombreController.dispose();
    edadController.dispose();
    historialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFormularioDiagnosticoNuevo();
  }

  // ignore: unused_element
  Widget _buildFormularioDiagnosticoAnterior(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Formulario de Diagnóstico")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildCampo("Nombre", nombreController, "Nombre..."),
            _buildCampo("Edad", edadController, "Edad..."),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
                    initialValue: _generoSeleccionado,
                    isDense: true,
                    decoration: const InputDecoration(
                      labelText: 'Género',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.wc),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Hombre', child: Text('Hombre')),
                      DropdownMenuItem(value: 'Mujer', child: Text('Mujer')),
                    ],
                    onChanged: (String? nuevoValor) {
                      setState(() {
                        _generoSeleccionado = nuevoValor;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecciona el género';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            _buildCampo("Síntomas actuales", historialController,
                "Describa qué siente...",
                lineas: 4),
            const SizedBox(height: 20),
            cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: generarDiagnostico,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        minimumSize: const Size(double.infinity, 55)),
                    child: const Text("GENERAR DIAGNÓSTICO",
                        style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampo(
      String label, TextEditingController controller, String hint,
      {int lineas = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: lineas,
        decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _buildFormularioDiagnosticoNuevo() {
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
                  _encabezadoDiagnostico(),
                  const SizedBox(height: 48),
                  _tarjetaProgreso(),
                  const SizedBox(height: 22),
                  _tarjetaCampoDiagnostico(
                    titulo: "Nombre completo",
                    icono: Icons.person_outline_rounded,
                    child: _campoTextoDiagnostico(
                      controller: nombreController,
                      hint: "Ingresa tu nombre",
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampoDiagnostico(
                    titulo: "Edad",
                    icono: Icons.calendar_month_rounded,
                    child: _campoTextoDiagnostico(
                      controller: edadController,
                      hint: "Ingresa tu edad",
                      prefixIcon: Icons.calendar_month_outlined,
                      keyboardType: TextInputType.number,
                      suffixText: "Años",
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampoDiagnostico(
                    titulo: "Genero",
                    icono: Icons.transgender_rounded,
                    child: _selectorGeneroDiagnostico(),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaCampoDiagnostico(
                    titulo: "Sintomas actuales",
                    icono: Icons.medical_services_outlined,
                    child: _campoSintomasDiagnostico(),
                  ),
                  const SizedBox(height: 16),
                  _tarjetaAdjuntoDiagnostico(),
                  const SizedBox(height: 20),
                  _tarjetaConfidencialidad(),
                  const SizedBox(height: 26),
                  _botonGenerarDiagnostico(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _encabezadoDiagnostico() {
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
                "Formulario de Diagnostico",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Completa los datos para un diagnostico preciso",
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
        const SizedBox(width: 8),
        InkWell(
          borderRadius: BorderRadius.circular(38),
          onTap: _mostrarAyudaDiagnostico,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.help_outline_rounded, color: Colors.white, size: 34),
                SizedBox(height: 3),
                Text(
                  "Ayuda",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
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
                  Icons.fact_check_outlined,
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
                      "Completa el formulario",
                      style: TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      "Proporciona informacion precisa para mejores resultados.",
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
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF1FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$_camposCompletosFormulario de 4",
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
              value: _progresoFormulario,
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

  Widget _tarjetaCampoDiagnostico({
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

  Widget _campoTextoDiagnostico({
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
      decoration: _inputDecoracionDiagnostico(
        hint: hint,
        prefixIcon: prefixIcon,
        suffixText: suffixText,
      ),
    );
  }

  Widget _selectorGeneroDiagnostico() {
    return DropdownButtonFormField<String>(
      initialValue: _generoSeleccionado,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF12248B), size: 32),
      decoration: _inputDecoracionDiagnostico(hint: "Selecciona una opcion"),
      hint: const Text(
        "Selecciona una opcion",
        style: TextStyle(
          color: Color(0xFF6B7192),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'Hombre', child: Text('Hombre')),
        DropdownMenuItem(value: 'Mujer', child: Text('Mujer')),
      ],
      onChanged: (String? nuevoValor) {
        setState(() {
          _generoSeleccionado = nuevoValor;
        });
      },
    );
  }

  Widget _campoSintomasDiagnostico() {
    final conteo = historialController.text.characters.length;
    return Stack(
      children: [
        TextField(
          controller: historialController,
          minLines: 6,
          maxLines: 6,
          maxLength: 500,
          textInputAction: TextInputAction.newline,
          decoration: _inputDecoracionDiagnostico(
            hint: "Describe tus sintomas actuales...",
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

  Widget _tarjetaAdjuntoDiagnostico() {
    return _tarjetaCampoDiagnostico(
      titulo: "Archivo para analizar",
      icono: Icons.attach_file_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: 120,
                child: OutlinedButton.icon(
                  onPressed: _tomarFotoDiagnostico,
                  icon: const Icon(Icons.photo_camera_rounded),
                  label: const Text("Camara"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF12248B),
                    minimumSize: const Size(0, 48),
                    side: const BorderSide(color: Color(0xFFD1D5E3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 124,
                child: OutlinedButton.icon(
                  onPressed: _seleccionarArchivoDiagnostico,
                  icon: const Icon(Icons.attach_file_rounded),
                  label: const Text("Archivo"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF12248B),
                    minimumSize: const Size(0, 48),
                    side: const BorderSide(color: Color(0xFFD1D5E3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 128,
                child: OutlinedButton.icon(
                  onPressed: cargando ? null : _alternarAudioDiagnostico,
                  icon: Icon(_grabandoAudio
                      ? Icons.stop_circle_outlined
                      : Icons.mic_none_rounded),
                  label: Text(_grabandoAudio ? "Detener" : "Audio"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _grabandoAudio
                        ? const Color(0xFFD33B3B)
                        : const Color(0xFF12248B),
                    minimumSize: const Size(0, 48),
                    side: BorderSide(
                      color: _grabandoAudio
                          ? const Color(0xFFD33B3B)
                          : const Color(0xFFD1D5E3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_adjunto != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE1E4F0)),
              ),
              child: Row(
                children: [
                  Icon(
                    _adjunto!.esAudio
                        ? Icons.mic_none_rounded
                        : _adjunto!.esPdf
                            ? Icons.picture_as_pdf_rounded
                            : Icons.image_outlined,
                    color: const Color(0xFF4059EA),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _adjunto!.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF27315F),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: "Quitar archivo",
                    onPressed: _quitarAdjuntoDiagnostico,
                    icon: const Icon(Icons.close_rounded),
                    color: const Color(0xFF12248B),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          _burbujaPrivacidadAdjunto(),
        ],
      ),
    );
  }

  Widget _burbujaPrivacidadAdjunto() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCDEBE2)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline_rounded, color: Color(0xFF08735F), size: 20),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              "Este documento, foto o audio no se guarda dentro de la app.",
              style: TextStyle(
                color: Color(0xFF175B50),
                fontSize: 13,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoracionDiagnostico({
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
              width: 96,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD74A4A), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD74A4A), width: 1.8),
      ),
    );
  }

  Widget _tarjetaConfidencialidad() {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tu informacion es confidencial",
                  style: TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Todos los datos ingresados estan protegidos y se utilizan unicamente para generar tu diagnostico personalizado.",
                  style: TextStyle(
                    color: Color(0xFF17246B),
                    fontSize: 17,
                    height: 1.4,
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

  Widget _botonGenerarDiagnostico() {
    return InkWell(
      borderRadius: BorderRadius.circular(36),
      onTap: cargando ? null : generarDiagnostico,
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
                    Icon(Icons.fact_check_outlined,
                        color: Colors.white, size: 34),
                    SizedBox(width: 18),
                    Text(
                      "GENERAR DIAGNOSTICO",
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

  void _mostrarAyudaDiagnostico() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ayuda"),
        content: const Text(
          "Completa nombre, edad, genero y sintomas actuales. Mientras mas claro sea el contexto, mas util sera el diagnostico generado.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Entendido"),
          ),
        ],
      ),
    );
  }
}
