part of '../main.dart';

Future<void> _compartirRespuestaChat(
  BuildContext context,
  String texto,
) {
  final contenido = ContenidoResultadoFicha.desdeTexto(
    texto,
    imagenesProducto4Life,
  );
  final productos = contenido.productos
      .map(
        (producto) => ProductoDocumento(
          nombre: producto.nombre,
          imagenAsset: producto.imagen,
          indicaciones: producto.dosis,
          detalle: producto.beneficio,
        ),
      )
      .toList();
  final secciones = <SeccionDocumento>[
    SeccionDocumento(
      titulo: productos.isEmpty ? 'Respuesta del asesor' : 'Análisis',
      contenido: contenido.analisis.isEmpty ? texto : contenido.analisis,
    ),
    if (contenido.objetivo.isNotEmpty)
      SeccionDocumento(
        titulo: 'Objetivo',
        contenido: contenido.objetivo,
      ),
    if (contenido.recomendaciones.isNotEmpty)
      SeccionDocumento(
        titulo: 'Recomendaciones',
        contenido: contenido.recomendaciones,
      ),
  ];
  return ServicioCompartir.mostrarOpciones(
    context,
    DocumentoCompartible(
      titulo: 'RESPUESTA DEL ASESOR IA 4LIFE',
      nombreArchivo: 'respuesta_asesor_ia_4life',
      texto: texto,
      fecha: DateTime.now(),
      secciones: secciones,
      productos: productos,
      nota: contenido.nota,
    ),
  );
}

class PaginaChatbot extends StatefulWidget {
  final String titulo;
  final bool modoLlamada;
  final String? consultaInicial;
  final String? conversacionId;
  final List<Map<String, String>>? mensajesIniciales;

  const PaginaChatbot({
    super.key,
    this.titulo = "Asesor IA 4Life",
    this.modoLlamada = false,
    this.consultaInicial,
    this.conversacionId,
    this.mensajesIniciales,
  });

  @override
  State<PaginaChatbot> createState() => _PaginaChatbotState();
}

class _PaginaChatbotState extends State<PaginaChatbot> {
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final List<Map<String, String>> mensajes = [];
  ArchivoAdjuntoIA? _adjunto;
  bool enviando = false;
  bool _grabandoAudio = false;
  bool _iniciandoGrabacionVoz = false;
  bool _presionandoMicrofono = false;
  String _estadoLlamada = "Conectando...";
  late String _conversacionId;

  @override
  void initState() {
    super.initState();
    _conversacionId = widget.conversacionId ??
        DateTime.now().microsecondsSinceEpoch.toString();
    if (widget.mensajesIniciales != null) {
      mensajes.addAll(widget.mensajesIniciales!);
    }
    _controller.text = widget.consultaInicial ?? "";
    if (widget.modoLlamada) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _iniciarLlamada();
      });
    }
  }

  Future<void> _iniciarLlamada() async {
    if (!mounted) return;
    setState(
      () => _estadoLlamada = "Mantén pulsado el micrófono para hablar",
    );
  }

  Future<void> enviarMensaje() async {
    final textoUsuario = _controller.text.trim();
    if ((textoUsuario.isEmpty && _adjunto == null) || enviando) return;
    final textoVisible = textoUsuario.isEmpty
        ? (_adjunto?.esAudio == true
            ? "Analiza esta nota de voz."
            : "Analiza el archivo adjunto.")
        : textoUsuario;

    setState(() {
      mensajes.add({"rol": "usuario", "texto": textoVisible});
      enviando = true;
    });
    _controller.clear();

    final model = GenerativeModel(
      model: 'gemini-3.1-flash-lite',
      apiKey: geminiApiKey,
    );

    final historialPrevio = mensajes
        .take(mensajes.length - 1)
        .map((mensaje) =>
            "${mensaje['rol'] == 'ia' ? 'Asesor IA' : 'Socio'}: ${mensaje['texto']}")
        .join("\n");
    final productoCoincidente = buscarProductoPermitido(textoVisible);
    final instruccionProducto = productoCoincidente == null
        ? ""
        : "Si la consulta menciona un producto mal escrito, responde directamente sobre $productoCoincidente. No digas que fue una coincidencia ni que estaba mal escrito.";
    final instruccionVoz = widget.modoLlamada
        ? "Esta es una llamada de voz. Responde de forma natural, breve y directa, sin listas extensas ni formatos visuales. No saludes de nuevo en cada respuesta."
        : "";

    final promptLimpioParaChatbot = """
    Eres un asesor IA para socios de 4Life.
    Responde de manera clara, conversacional, sumamente ordenada y amigable.
    IMPORTANTE: No uses asteriscos (*), no uses almohadillas (#), ni guiones extraños para dar formato.
    Usa saltos de línea normales y texto limpio.
    Responde preguntas libres sobre suplementos, productos 4Life, hábitos saludables, ventas y seguimiento de clientes.
    REGLA OBLIGATORIA DE PRODUCTOS: Cuando recomiendes, compares, armes rutinas o sugieras productos,
    usa UNICAMENTE estos nombres del catalogo autorizado: $catalogoPermitido4Life.
    Si el socio pide algo que requiera un producto fuera de esa lista, explica que solo puedes recomendar
    productos del catalogo autorizado y ofrece alternativas dentro de esa lista.
    No inventes nombres, presentaciones ni productos adicionales.
    $instruccionProducto
    $instruccionVoz
    Mantén un tono claro, práctico y responsable. Si la pregunta parece médica, recomienda consultar a un profesional de salud.

    Conversación actual:
    $historialPrevio

    Consulta actual:
    $textoVisible
    """;

    try {
      final response = await model.generateContent([
        if (_adjunto == null)
          Content.text(promptLimpioParaChatbot)
        else
          Content.multi([
            TextPart(
              _adjunto!.esAudio
                  ? "$promptLimpioParaChatbot\n\nAnaliza la nota de voz adjunta como contexto temporal. Extrae la consulta y responde con base en el audio. No menciones que fue guardado, porque no se guarda en la app."
                  : "$promptLimpioParaChatbot\n\nAnaliza el archivo adjunto como contexto temporal. No menciones que fue guardado, porque no se guarda en la app.",
            ),
            DataPart(_adjunto!.mimeType, _adjunto!.bytes),
          ]),
      ]);
      final respuestaIA = response.text ?? "No pude generar una respuesta.";

      if (!mounted) return;
      setState(() {
        mensajes.add({"rol": "ia", "texto": respuestaIA});
        _adjunto = null;
        if (widget.modoLlamada) {
          _estadoLlamada = "DoctorSuplementos esta respondiendo...";
        }
      });
      await ChatHistoryService.guardarConversacion(_conversacionId, mensajes);
      if (widget.modoLlamada) {
        await ServicioTextoVoz.reproducir(respuestaIA);
        if (mounted) {
          setState(
            () => _estadoLlamada = "Mantén pulsado el micrófono para hablar",
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        mensajes.add({
          "rol": "ia",
          "texto": "No se pudo conectar con la IA. Intenta nuevamente."
        });
        if (widget.modoLlamada) {
          _estadoLlamada = "No pude responder. Intenta nuevamente";
        }
      });
      await ChatHistoryService.guardarConversacion(_conversacionId, mensajes);
    } finally {
      if (mounted) {
        setState(() => enviando = false);
      }
    }
  }

  @override
  void dispose() {
    if (_grabandoAudio) {
      unawaited(_audioRecorder.cancel());
    }
    if (widget.modoLlamada) {
      unawaited(ServicioTextoVoz.detener());
    }
    _audioRecorder.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> tomarFotoChat() async {
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

  Future<void> seleccionarArchivoChat() async {
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

  Future<void> alternarAudioChat() async {
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
          nombre: 'Nota de voz para el asesor.m4a',
          mimeType: 'audio/mp4',
          bytes: bytes,
        );
      });
      return;
    }

    if (!await _audioRecorder.hasPermission()) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Permiso de microfono"),
          content: Text(
            "Activa el permiso del microfono para grabar la nota de voz.",
          ),
        ),
      );
      return;
    }

    final carpetaTemporal = await getTemporaryDirectory();
    final path =
        '${carpetaTemporal.path}/chat_${DateTime.now().microsecondsSinceEpoch}.m4a';
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

  Future<void> iniciarLlamadaVoz() async {
    if (enviando || _grabandoAudio || _iniciandoGrabacionVoz) return;
    _iniciandoGrabacionVoz = true;
    await ServicioTextoVoz.detener();
    try {
      if (!await _audioRecorder.hasPermission()) {
        if (!mounted) return;
        _presionandoMicrofono = false;
        setState(() => _estadoLlamada = "Se necesita acceso al micrófono");
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Permiso de micrófono"),
            content: Text(
              "Activa el permiso del micrófono para conversar con DoctorSuplementos.",
            ),
          ),
        );
        return;
      }

      final carpetaTemporal = await getTemporaryDirectory();
      final path =
          '${carpetaTemporal.path}/chat_live_${DateTime.now().microsecondsSinceEpoch}.m4a';
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          numChannels: 1,
          bitRate: 64000,
        ),
        path: path,
      );
      if (!mounted) return;
      setState(() {
        _grabandoAudio = true;
        _estadoLlamada = "Te estoy escuchando...";
      });
    } finally {
      _iniciandoGrabacionVoz = false;
    }

    if (!_presionandoMicrofono && _grabandoAudio) {
      await finalizarLlamadaVoz();
    }
  }

  Future<void> finalizarLlamadaVoz() async {
    if (enviando || !_grabandoAudio) return;

    final path = await _audioRecorder.stop();
    if (!mounted) return;
    setState(() {
      _grabandoAudio = false;
      _estadoLlamada = "Procesando tu pregunta...";
    });
    if (path == null) {
      setState(
        () => _estadoLlamada = "Mantén pulsado el micrófono para hablar",
      );
      return;
    }

    final archivo = File(path);
    final bytes = await archivo.readAsBytes();
    await archivo.delete().catchError((_) => archivo);
    if (bytes.isEmpty || !mounted) {
      if (mounted) {
        setState(
          () => _estadoLlamada = "Mantén pulsado el micrófono para hablar",
        );
      }
      return;
    }

    setState(() {
      _adjunto = ArchivoAdjuntoIA(
        nombre: 'Pregunta de voz.m4a',
        mimeType: 'audio/mp4',
        bytes: bytes,
      );
    });
    await enviarMensaje();
  }

  void quitarAdjuntoChat() {
    setState(() => _adjunto = null);
  }

  @override
  Widget build(BuildContext context) {
    return widget.modoLlamada ? _buildChatLiveVoz() : _buildChatbotNuevo();
  }

  // ignore: unused_element
  Widget _buildChatbotAnterior(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: "Historial de chats",
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaginaHistorialChatbot(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: mensajes.isEmpty
                ? const Center(
                    child: Text(
                      "Haz una pregunta para iniciar la conversación.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: mensajes.length,
                    itemBuilder: (context, i) {
                      final esIA = mensajes[i]["rol"] == "ia";
                      final texto = mensajes[i]["texto"] ?? "";
                      return ListTile(
                        leading: Icon(esIA ? Icons.smart_toy : Icons.person),
                        title: Text(esIA ? "Gemini 4Life" : "Tú"),
                        subtitle: Text(texto),
                        trailing: esIA
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: texto));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Copiado al portapapeles")),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () =>
                                        _compartirRespuestaChat(context, texto),
                                  ),
                                ],
                              )
                            : null,
                      );
                    },
                  ),
          ),
          if (enviando)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Pregunta lo que sea...",
                      border: OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 4,
                    onSubmitted: (_) => enviarMensaje(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: enviando ? null : enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension _PaginaChatbotUi on _PaginaChatbotState {
  Widget _buildChatLiveVoz() {
    final escuchando = _grabandoAudio;
    final ocupado = enviando;

    return PopScope(
      onPopInvokedWithResult: (_, __) {
        unawaited(ServicioTextoVoz.detener());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF07125E),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF172B98),
                Color(0xFF101B79),
                Color(0xFF071044),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: "Finalizar llamada",
                        onPressed: () {
                          ServicioTextoVoz.detener();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        iconSize: 32,
                      ),
                      const Expanded(
                        child: Text(
                          "Chat Live 4Life",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: 174,
                  height: 174,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.24),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6578FF).withValues(alpha: 0.28),
                        blurRadius: escuchando ? 52 : 28,
                        spreadRadius: escuchando ? 18 : 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 132,
                      height: 132,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.health_and_safety_rounded,
                        color: Color(0xFF172394),
                        size: 72,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                const Text(
                  "DoctorSuplementos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    _estadoLlamada,
                    key: ValueKey(_estadoLlamada),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFD9DFFF),
                      fontSize: 17,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (ocupado) ...[
                  const SizedBox(height: 22),
                  const SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ],
                const Spacer(),
                Semantics(
                  button: true,
                  label: "Mantén pulsado para hablar y suelta para enviar",
                  child: GestureDetector(
                    onLongPressStart: ocupado
                        ? null
                        : (_) {
                            _presionandoMicrofono = true;
                            unawaited(iniciarLlamadaVoz());
                          },
                    onLongPressEnd: ocupado
                        ? null
                        : (_) {
                            _presionandoMicrofono = false;
                            if (_grabandoAudio) {
                              unawaited(finalizarLlamadaVoz());
                            }
                          },
                    onLongPressCancel: ocupado
                        ? null
                        : () {
                            _presionandoMicrofono = false;
                            if (_grabandoAudio) {
                              unawaited(finalizarLlamadaVoz());
                            }
                          },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: escuchando
                            ? const Color(0xFFE94352)
                            : ocupado
                                ? const Color(0xFF6670A8)
                                : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.22),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.mic_rounded,
                        color:
                            escuchando ? Colors.white : const Color(0xFF172394),
                        size: 56,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  escuchando
                      ? "Toca para enviar tu pregunta"
                      : "Toca para hablar",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 42),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatbotNuevo() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: Stack(
        children: [
          Container(
            height: 206,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF172B98), Color(0xFF07125E)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _encabezadoChatbot(),
                Expanded(
                  child: mensajes.isEmpty
                      ? _estadoInicialChat()
                      : _listaMensajesChat(),
                ),
                if (enviando)
                  const LinearProgressIndicator(
                    minHeight: 3,
                    color: Color(0xFF4059EA),
                    backgroundColor: Color(0xFFE5E8FF),
                  ),
                _barraEntradaChat(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _encabezadoChatbot() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      child: Row(
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
                  widget.titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    height: 1.1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Tu asistente inteligente de suplementos",
                  style: TextStyle(
                    color: Color(0xFFD9DFFF),
                    fontSize: 18,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: "Historial de chats",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaginaHistorialChatbot(),
              ),
            ),
            icon: const Icon(Icons.history_rounded, color: Colors.white),
            iconSize: 38,
          ),
        ],
      ),
    );
  }

  Widget _estadoInicialChat() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          _tarjetaBienvenidaChat(),
          const SizedBox(height: 82),
          _ilustracionConversacion(),
          const SizedBox(height: 30),
          const Text(
            "En que puedo ayudarte hoy?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF12248B),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "Haz una pregunta para iniciar la conversacion.\nEstoy aqui para ayudarte.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF4D5689),
              fontSize: 17,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaBienvenidaChat() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF1FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: Color(0xFF4D66F2),
                  size: 76,
                ),
              ),
              const SizedBox(width: 26),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hola, soy tu Asesor IA 4Life",
                      style: TextStyle(
                        color: Color(0xFF12248B),
                        fontSize: 22,
                        height: 1.18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      "Estoy aqui para ayudarte con informacion sobre productos, beneficios, dosis y recomendaciones personalizadas.",
                      style: TextStyle(
                        color: Color(0xFF4D5689),
                        fontSize: 17,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _preguntaRapida(
                  icono: Icons.medication_liquid_outlined,
                  texto: "Recomiendame un suplemento para tener mas energia",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _preguntaRapida(
                  icono: Icons.shield_outlined,
                  texto: "Cual es la funcion del Transfer Factor 4Life?",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _preguntaRapida(
                  icono: Icons.favorite_border_rounded,
                  texto: "Que productos apoyan el sistema inmunologico?",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _preguntaRapida({
    required IconData icono,
    required String texto,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        _controller.text = texto;
        enviarMensaje();
      },
      child: Container(
        height: 112,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF1FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icono, color: const Color(0xFF4D66F2), size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF12248B),
                  fontSize: 14.5,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ilustracionConversacion() {
    return SizedBox(
      width: 230,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 18,
            child: Container(
              width: 150,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF0B176B).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 10,
            child: Container(
              width: 126,
              height: 92,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF526BFA), Color(0xFF263BCB)],
                ),
                borderRadius: BorderRadius.circular(34),
              ),
              child: const Center(
                child: Text(
                  "...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    height: 0.72,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 18,
            child: Container(
              width: 98,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE3FF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.notes_rounded,
                color: Color(0xFF7E8FD4),
                size: 48,
              ),
            ),
          ),
          const Positioned(
            left: 0,
            top: 24,
            child: Icon(Icons.auto_awesome, color: Color(0xFFC4CCFA), size: 26),
          ),
          const Positioned(
            right: 16,
            top: 0,
            child: Icon(Icons.auto_awesome, color: Color(0xFFC4CCFA), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _listaMensajesChat() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      itemCount: mensajes.length,
      itemBuilder: (context, i) {
        final esIA = mensajes[i]["rol"] == "ia";
        final texto = mensajes[i]["texto"] ?? "";
        return _burbujaMensaje(esIA: esIA, texto: texto);
      },
    );
  }

  Widget _burbujaMensaje({
    required bool esIA,
    required String texto,
  }) {
    return Align(
      alignment: esIA ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 620),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        decoration: BoxDecoration(
          color: esIA ? Colors.white : const Color(0xFF172394),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: esIA ? const Radius.circular(4) : null,
            bottomRight: esIA ? null : const Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              esIA ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              esIA ? "Asesor IA" : "Tu",
              style: TextStyle(
                color: esIA ? const Color(0xFF12248B) : Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              texto,
              style: TextStyle(
                color: esIA ? const Color(0xFF27315F) : Colors.white,
                fontSize: 15.5,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (esIA) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: "Escuchar respuesta",
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.volume_up_rounded, size: 21),
                    color: const Color(0xFF4059EA),
                    onPressed: () => ServicioTextoVoz.reproducir(texto),
                  ),
                  IconButton(
                    tooltip: "Detener audio",
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.stop_circle_outlined, size: 21),
                    color: const Color(0xFF4059EA),
                    onPressed: ServicioTextoVoz.detener,
                  ),
                  IconButton(
                    tooltip: "Copiar",
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    color: const Color(0xFF4059EA),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: texto));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Copiado al portapapeles")),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: "Compartir",
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.share_rounded, size: 20),
                    color: const Color(0xFF4059EA),
                    onPressed: () => _compartirRespuestaChat(context, texto),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _barraEntradaChat() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_adjunto != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FF),
                borderRadius: BorderRadius.circular(12),
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
                    visualDensity: VisualDensity.compact,
                    onPressed: quitarAdjuntoChat,
                    icon: const Icon(Icons.close_rounded),
                    color: const Color(0xFF12248B),
                  ),
                ],
              ),
            ),
          ],
          Container(
            padding: const EdgeInsets.fromLTRB(18, 6, 8, 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD6D9E6), width: 1.5),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: "Tomar foto",
                  visualDensity: VisualDensity.compact,
                  onPressed: enviando ? null : tomarFotoChat,
                  icon: const Icon(Icons.photo_camera_rounded),
                  color: const Color(0xFF535B86),
                ),
                IconButton(
                  tooltip: "Adjuntar archivo",
                  visualDensity: VisualDensity.compact,
                  onPressed: enviando ? null : seleccionarArchivoChat,
                  icon: const Icon(Icons.attach_file_rounded),
                  color: const Color(0xFF535B86),
                ),
                IconButton(
                  tooltip: _grabandoAudio ? "Detener audio" : "Grabar audio",
                  visualDensity: VisualDensity.compact,
                  onPressed: enviando ? null : alternarAudioChat,
                  icon: Icon(_grabandoAudio
                      ? Icons.stop_circle_outlined
                      : Icons.mic_none_rounded),
                  color: _grabandoAudio
                      ? const Color(0xFFD33B3B)
                      : const Color(0xFF535B86),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => enviarMensaje(),
                    decoration: const InputDecoration(
                      hintText: "Pregunta lo que sea...",
                      hintStyle: TextStyle(
                        color: Color(0xFF8C91A8),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(32),
                  onTap: enviando ? null : enviarMensaje,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF172394), Color(0xFF0B176B)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.health_and_safety_outlined,
                  color: Color(0xFF5C6592), size: 22),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  "La informacion proporcionada por la IA no sustituye el consejo de un profesional de la salud.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF5C6592),
                    fontSize: 13.5,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded,
                  color: Color(0xFF08735F), size: 18),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Este documento, foto o audio no se guarda dentro de la app.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF175B50),
                    fontSize: 12.5,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
