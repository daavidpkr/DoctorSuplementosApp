part of '../main.dart';

class HistorialPagina extends StatelessWidget {
  const HistorialPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historial (Local)")),
      body: HistorialService.registros.isEmpty
          ? const Center(child: Text("No hay consultas previas"))
          : ListView.builder(
              itemCount: HistorialService.registros.length,
              itemBuilder: (context, index) {
                final item = HistorialService.registros[index];
                return ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(item['titulo']),
                  subtitle: Text("Fecha: ${item['fecha']}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) =>
                                FormularioPaciente(infoPrevia: item)));
                  },
                );
              },
            ),
    );
  }
}
// --- PANTALLAS DE NAVEGACIÓN ---

class PaginaConsulta extends StatelessWidget {
  const PaginaConsulta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consultar Producto"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Aquí podrás consultar información detallada de los productos 4Life.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class PaginaHistorial extends StatefulWidget {
  const PaginaHistorial({super.key});

  @override
  State<PaginaHistorial> createState() => _PaginaHistorialState();
}

class _PaginaHistorialState extends State<PaginaHistorial> {
  List<Map<String, dynamic>> _todoElHistorial = [];
  List<Map<String, dynamic>> _historialFiltrado = [];
  final TextEditingController _searchController = TextEditingController();
  String _tipoSeleccionado = 'diagnostico';

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(HistorialService.prefsKey) ?? [];
    final datos =
        raw.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    if (!mounted) return;
    setState(() {
      _todoElHistorial = datos;
      _aplicarFiltros();
    });
  }

  String _tipoRegistro(Map<String, dynamic> registro) {
    return registro['tipo']?.toString() ?? 'diagnostico';
  }

  bool _esCambioFisico(Map<String, dynamic> registro) {
    return _tipoRegistro(registro) == 'cambio_fisico';
  }

  void _aplicarFiltros() {
    final busqueda = _searchController.text.toLowerCase().trim();
    _historialFiltrado = _todoElHistorial.where((paciente) {
      if (_tipoRegistro(paciente) != _tipoSeleccionado) return false;
      final nombre = _nombrePaciente(paciente).toLowerCase();
      final fecha = paciente['fecha']?.toString().toLowerCase() ?? '';
      final resultado = paciente['resultado']?.toString().toLowerCase() ?? '';
      final titulo = paciente['titulo']?.toString().toLowerCase() ?? '';
      final datos = paciente['datos'];
      final objetivo = datos is Map
          ? (datos['objetivoFisico']?.toString().toLowerCase() ?? '')
          : '';
      return nombre.contains(busqueda) ||
          fecha.contains(busqueda) ||
          resultado.contains(busqueda) ||
          titulo.contains(busqueda) ||
          objetivo.contains(busqueda);
    }).toList();
  }

  String _nombrePaciente(Map<String, dynamic> registro) {
    final datos = registro['datos'];
    if (registro['nombre'] != null &&
        registro['nombre'].toString().trim().isNotEmpty) {
      return registro['nombre'].toString();
    }
    if (datos is Map &&
        datos['nombre'] != null &&
        datos['nombre'].toString().trim().isNotEmpty) {
      return datos['nombre'].toString();
    }
    return registro['titulo']?.toString() ?? "Sin nombre";
  }

  void _filtrarHistorial(String query) {
    setState(() {
      _aplicarFiltros();
    });
  }

  void _cambiarTipoHistorial(String tipo) {
    setState(() {
      _tipoSeleccionado = tipo;
      _aplicarFiltros();
    });
  }

  void _reDiagnosticar(Map<String, dynamic> pacienteViejo) {
    final nombre = _nombrePaciente(pacienteViejo);
    final resultado =
        pacienteViejo['resultado']?.toString() ?? "Sin resultado guardado";
    final esCambio = _esCambioFisico(pacienteViejo);
    final nuevaPreguntaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(esCambio ? "Ajustar cambio fisico" : "Re-evaluar a $nombre"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${esCambio ? 'Guia anterior' : 'Diagnostico anterior'}:\n$resultado",
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nuevaPreguntaController,
              decoration: const InputDecoration(
                labelText: "Que cambio o que nueva duda tienes?",
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              final nuevaConsultaIA =
                  "Tomando como base ${esCambio ? 'la guia de cambio fisico anterior' : 'el diagnostico anterior'} de este paciente: $resultado. "
                  "El paciente ahora presenta lo siguiente o se requiere ajustar esto: ${nuevaPreguntaController.text}";

              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PaginaChatbot(consultaInicial: nuevaConsultaIA),
                ),
              );
            },
            child: const Text("Consultar Ajuste"),
          ),
        ],
      ),
    ).then((_) => nuevaPreguntaController.dispose());
  }

  Future<void> _verReporteAnterior(
    Map<String, dynamic> pacienteViejo,
  ) async {
    final nombre = _nombrePaciente(pacienteViejo);
    final resultado =
        pacienteViejo['resultado']?.toString() ?? "Sin resultado guardado";
    final esCambio = _esCambioFisico(pacienteViejo);
    final fecha = DateTime.tryParse(
          pacienteViejo['fecha']?.toString() ?? '',
        ) ??
        DateTime.now();
    final perfilAsesor = await PerfilService.cargar();
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaResultadoFicha(
          titulo: esCambio
              ? 'Resultado de Cambio Físico'
              : 'Resultado del Diagnóstico',
          tipoFicha: esCambio ? 'Cambio físico' : 'Diagnóstico',
          paciente: nombre,
          nombreAsesor: perfilAsesor.nombre,
          especialidad: esCambio
              ? 'Asesor de bienestar y composición corporal'
              : 'Especialista en inmunología y bioenergética',
          resultado: resultado,
          fecha: fecha,
          imagenesProducto: imagenesProducto4Life,
          preciosProducto: preciosResultado4Life,
        ),
      ),
    );
  }

  String _fechaPaciente(dynamic valor) {
    final texto = valor?.toString() ?? '';
    final fecha = DateTime.tryParse(texto);
    if (fecha == null) return texto.isEmpty ? 'Sin fecha' : texto;
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
  }

  String _horaPaciente(dynamic valor) {
    final texto = valor?.toString() ?? '';
    final fecha = DateTime.tryParse(texto);
    if (fecha == null) return '--:--';
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  _EstadoPaciente _estadoPaciente(Map<String, dynamic> registro) {
    final resultado = registro['resultado']?.toString().trim() ?? '';
    if (resultado.isEmpty) {
      return const _EstadoPaciente(
        texto: 'Pendiente',
        icono: Icons.schedule_rounded,
        color: Color(0xFFF29A00),
      );
    }
    if (_esCambioFisico(registro)) {
      return const _EstadoPaciente(
        texto: 'Cambio fisico completo',
        icono: Icons.fitness_center_rounded,
        color: Color(0xFF14983E),
      );
    }
    return const _EstadoPaciente(
      texto: 'Diagnóstico completo',
      icono: Icons.check_circle_outline,
      color: Color(0xFF14983E),
    );
  }

  Color _colorAvatar(String nombre) {
    final colores = [
      const Color(0xFFDDE8FF),
      const Color(0xFFD8F4DA),
      const Color(0xFFE8DBFF),
      const Color(0xFFD8F3F8),
    ];
    if (nombre.isEmpty) return colores.first;
    return colores[nombre.codeUnitAt(0) % colores.length];
  }

  Color _colorInicial(String nombre) {
    final colores = [
      const Color(0xFF1D65C1),
      const Color(0xFF128E32),
      const Color(0xFF5A34C9),
      const Color(0xFF11899A),
    ];
    if (nombre.isEmpty) return colores.first;
    return colores[nombre.codeUnitAt(0) % colores.length];
  }

  void _nuevoDiagnostico() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _tipoSeleccionado == 'cambio_fisico'
            ? const FormularioCambioFisico()
            : const FormularioPaciente(),
      ),
    ).then((_) => _cargarDatos());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _selectorTipoHistorial() {
    return Container(
      height: 58,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _opcionTipoHistorial(
              texto: 'Diagnosticos',
              icono: Icons.medical_services_outlined,
              tipo: 'diagnostico',
            ),
          ),
          Expanded(
            child: _opcionTipoHistorial(
              texto: 'Cambios fisicos',
              icono: Icons.fitness_center_rounded,
              tipo: 'cambio_fisico',
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcionTipoHistorial({
    required String texto,
    required IconData icono,
    required String tipo,
  }) {
    final activo = _tipoSeleccionado == tipo;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _cambiarTipoHistorial(tipo),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: activo ? const Color(0xFFEDEEFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icono,
              color: activo ? const Color(0xFF2839C7) : const Color(0xFF68708C),
              size: 22,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                texto,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: activo
                      ? const Color(0xFF2839C7)
                      : const Color(0xFF68708C),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);
    const azulOscuro = Color(0xFF111B7D);
    final cantidad = _historialFiltrado.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              height: 112,
              padding: EdgeInsets.only(
                left: 22,
                right: 22,
                top: MediaQuery.of(context).padding.top + 12,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [azul, azulOscuro],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 32),
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      txtApp('Historial de Pacientes', 'Patient History'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: txtApp('Filtros', 'Filters'),
                    icon: const Icon(Icons.filter_list_rounded, size: 34),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 126),
                    children: [
                      Container(
                        height: 72,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filtrarHistorial,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                            color: Color(0xFF0D1430),
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: txtApp(
                              'Buscar paciente, fecha o registro...',
                              'Search patient, date, or record...',
                            ),
                            hintStyle: const TextStyle(
                              color: Color(0xFF747A9E),
                              fontSize: 16,
                            ),
                            icon: const Icon(
                              Icons.search,
                              color: Color(0xFF68709D),
                              size: 34,
                            ),
                            suffixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              color: azul,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _selectorTipoHistorial(),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _tipoSeleccionado == 'cambio_fisico'
                                  ? txtApp('Cambios fisicos', 'Body changes')
                                  : txtApp('Diagnosticos', 'Diagnoses'),
                              style: const TextStyle(
                                color: Color(0xFF646B88),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            txtApp(
                              '$cantidad ${cantidad == 1 ? 'resultado' : 'resultados'}',
                              '$cantidad ${cantidad == 1 ? 'result' : 'results'}',
                            ),
                            style: const TextStyle(
                              color: azul,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      if (_historialFiltrado.isEmpty)
                        _EstadoHistorialVacio(
                          texto: txtApp(
                            'No se encontraron registros',
                            'No records found',
                          ),
                        )
                      else
                        ..._historialFiltrado.map((item) {
                          final nombre = _nombrePaciente(item);
                          return _TarjetaPacienteHistorial(
                            nombre: nombre,
                            inicial:
                                nombre.isEmpty ? '?' : nombre[0].toUpperCase(),
                            fecha: _fechaPaciente(item['fecha']),
                            hora: _horaPaciente(item['fecha']),
                            estado: _estadoPaciente(item),
                            colorAvatar: _colorAvatar(nombre),
                            colorInicial: _colorInicial(nombre),
                            onVer: () => _verReporteAnterior(item),
                            onRepetir: () => _reDiagnosticar(item),
                            onAbrir: () => _verReporteAnterior(item),
                          );
                        }),
                    ],
                  ),
                  Positioned(
                    right: 24,
                    bottom: 74,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: FloatingActionButton(
                            heroTag: 'nuevo-diagnostico-historial',
                            backgroundColor: azul,
                            foregroundColor: Colors.white,
                            elevation: 9,
                            shape: const CircleBorder(),
                            onPressed: _nuevoDiagnostico,
                            child: const Icon(Icons.add, size: 32),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _tipoSeleccionado == 'cambio_fisico'
                              ? txtApp('Nuevo cambio', 'New change')
                              : txtApp('Nuevo diagnostico', 'New diagnosis'),
                          style: TextStyle(
                            color: azul,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
        child: Container(
          height: 82,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.history,
                  texto: txtApp('Historial', 'History'),
                  activo: true,
                ),
              ),
              Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.people_outline,
                  texto: txtApp('Pacientes', 'Patients'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaDatosPaciente(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.bar_chart,
                  texto: txtApp('Estadisticas', 'Statistics'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaImpacto4LifeNueva(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoPaciente {
  final String texto;
  final IconData icono;
  final Color color;

  const _EstadoPaciente({
    required this.texto,
    required this.icono,
    required this.color,
  });
}

class _TarjetaPacienteHistorial extends StatelessWidget {
  final String nombre;
  final String inicial;
  final String fecha;
  final String hora;
  final _EstadoPaciente estado;
  final Color colorAvatar;
  final Color colorInicial;
  final VoidCallback onVer;
  final VoidCallback onRepetir;
  final VoidCallback onAbrir;

  const _TarjetaPacienteHistorial({
    required this.nombre,
    required this.inicial,
    required this.fecha,
    required this.hora,
    required this.estado,
    required this.colorAvatar,
    required this.colorInicial,
    required this.onVer,
    required this.onRepetir,
    required this.onAbrir,
  });

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);

    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        elevation: 1.5,
        shadowColor: Colors.black.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onAbrir,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 14),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: colorAvatar,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    inicial,
                    style: TextStyle(
                      color: colorInicial,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              nombre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF10162F),
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                height: 1.08,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: azul,
                            size: 32,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xFF68708C),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              fecha,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF68708C),
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.access_time,
                            color: Color(0xFF68708C),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            hora,
                            style: const TextStyle(
                              color: Color(0xFF68708C),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  estado.icono,
                                  color: estado.color,
                                  size: 20,
                                ),
                                const SizedBox(width: 7),
                                Flexible(
                                  child: Text(
                                    estado.texto,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: estado.color,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _BotonAccionPaciente(
                            icono: Icons.visibility_outlined,
                            tooltip: 'Ver reporte',
                            onTap: onVer,
                            relleno: false,
                          ),
                          const SizedBox(width: 8),
                          _BotonAccionPaciente(
                            icono: Icons.refresh,
                            tooltip: 'Repetir',
                            onTap: onRepetir,
                            relleno: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BotonAccionPaciente extends StatelessWidget {
  final IconData icono;
  final String tooltip;
  final VoidCallback onTap;
  final bool relleno;

  const _BotonAccionPaciente({
    required this.icono,
    required this.tooltip,
    required this.onTap,
    required this.relleno,
  });

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 44,
        height: 40,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: relleno ? const Color(0xFFEDEEFF) : Colors.white,
            foregroundColor: azul,
            side: BorderSide(
              color:
                  relleno ? const Color(0xFFEDEEFF) : const Color(0xFFD6D9F1),
              width: 1.4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Icon(icono, size: 22),
        ),
      ),
    );
  }
}

class PaginaDatosPaciente extends StatelessWidget {
  const PaginaDatosPaciente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datos del Paciente"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "No tienes datos guardados localmente.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para agregar nuevo paciente (no implementada)
        },
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PaginaHistorialChatbot extends StatefulWidget {
  const PaginaHistorialChatbot({super.key});

  @override
  State<PaginaHistorialChatbot> createState() => _PaginaHistorialChatbotState();
}

class _PaginaHistorialChatbotState extends State<PaginaHistorialChatbot> {
  List<Map<String, dynamic>> _conversaciones = [];
  List<Map<String, dynamic>> _conversacionesFiltradas = [];
  final TextEditingController _busquedaController = TextEditingController();
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final datos = await ChatHistoryService.cargarConversaciones();
    if (!mounted) return;
    setState(() {
      _conversaciones = datos;
      _conversacionesFiltradas = _filtrar(datos, _busquedaController.text);
      _cargando = false;
    });
  }

  List<Map<String, dynamic>> _filtrar(
    List<Map<String, dynamic>> conversaciones,
    String query,
  ) {
    final texto = query.trim().toLowerCase();
    if (texto.isEmpty) return conversaciones;
    return conversaciones.where((chat) {
      final titulo = chat['titulo']?.toString().toLowerCase() ?? '';
      final fecha = chat['fecha']?.toString().toLowerCase() ?? '';
      final mensajes =
          _mensajes(chat).map((m) => m['texto'] ?? '').join(' ').toLowerCase();
      return titulo.contains(texto) ||
          fecha.contains(texto) ||
          mensajes.contains(texto);
    }).toList();
  }

  void _buscar(String query) {
    setState(() {
      _conversacionesFiltradas = _filtrar(_conversaciones, query);
    });
  }

  List<Map<String, String>> _mensajes(Map<String, dynamic> chat) {
    final raw = chat['mensajes'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((m) => {
              'rol': m['rol']?.toString() ?? 'usuario',
              'texto': m['texto']?.toString() ?? '',
            })
        .toList();
  }

  Future<void> _eliminar(String id) async {
    await ChatHistoryService.eliminarConversacion(id);
    await _cargar();
  }

  void _abrirChat(Map<String, dynamic> chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaChatbot(
          conversacionId: chat['id']?.toString(),
          mensajesIniciales: _mensajes(chat),
        ),
      ),
    ).then((_) => _cargar());
  }

  String _fechaLegible(dynamic valor) {
    final texto = valor?.toString() ?? '';
    final fecha = DateTime.tryParse(texto);
    if (fecha == null) return texto.isEmpty ? 'Sin fecha' : texto;
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year} · $hora:$minuto';
  }

  _CategoriaChat _categoriaPara(String titulo) {
    final t = titulo.toLowerCase();
    if (t.contains('sueño') ||
        t.contains('sueno') ||
        t.contains('insomnio') ||
        t.contains('descanso')) {
      return const _CategoriaChat(
        texto: 'Sueño y descanso',
        icono: Icons.nightlight_round,
        color: Color(0xFF5E46D8),
        fondo: Color(0xFFEAE6FF),
      );
    }
    if (t.contains('dolor') ||
        t.contains('lesion') ||
        t.contains('lesión') ||
        t.contains('espalda') ||
        t.contains('migraña')) {
      return const _CategoriaChat(
        texto: 'Dolor y lesiones',
        icono: Icons.accessibility_new_rounded,
        color: Color(0xFF2876DF),
        fondo: Color(0xFFE7F1FF),
      );
    }
    if (t.contains('gastritis') ||
        t.contains('digest') ||
        t.contains('estomago') ||
        t.contains('estómago')) {
      return const _CategoriaChat(
        texto: 'Salud digestiva',
        icono: Icons.local_fire_department_outlined,
        color: Color(0xFFC45B20),
        fondo: Color(0xFFFFE8D8),
      );
    }
    if (t.contains('prote') ||
        t.contains('creatina') ||
        t.contains('vitamina') ||
        t.contains('suplement')) {
      return const _CategoriaChat(
        texto: 'Suplementos',
        icono: Icons.spa_outlined,
        color: Color(0xFF3F9A4B),
        fondo: Color(0xFFE1F4E2),
      );
    }
    return const _CategoriaChat(
      texto: 'Salud general',
      icono: Icons.health_and_safety_outlined,
      color: Color(0xFF3047CC),
      fondo: Color(0xFFE8ECFF),
    );
  }

  void _nuevoChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaginaChatbot()),
    ).then((_) => _cargar());
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);
    const azulOscuro = Color(0xFF111B7D);
    final cantidad = _conversacionesFiltradas.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              height: 112,
              padding: EdgeInsets.only(
                left: 22,
                right: 22,
                top: MediaQuery.of(context).padding.top + 12,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [azul, azulOscuro],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 32),
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 22),
                  const Expanded(
                    child: Text(
                      'Historial de chats',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Filtros',
                    icon: const Icon(Icons.filter_list_rounded, size: 34),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  _cargando
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 126),
                          children: [
                            Container(
                              height: 72,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _busquedaController,
                                onChanged: _buscar,
                                textAlign: TextAlign.start,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                  color: Color(0xFF0D1430),
                                  fontSize: 16,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Buscar en el historial...',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF747A9E),
                                    fontSize: 16,
                                  ),
                                  icon: Icon(
                                    Icons.search,
                                    color: Color(0xFF68709D),
                                    size: 34,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: azul,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 26),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Conversaciones recientes',
                                    style: TextStyle(
                                      color: Color(0xFF646B88),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$cantidad ${cantidad == 1 ? 'conversación' : 'conversaciones'}',
                                  style: const TextStyle(
                                    color: azul,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            if (_conversaciones.isEmpty)
                              const _EstadoHistorialVacio(
                                texto: 'No hay conversaciones guardadas',
                              )
                            else if (_conversacionesFiltradas.isEmpty)
                              const _EstadoHistorialVacio(
                                texto: 'No se encontraron conversaciones',
                              )
                            else
                              ..._conversacionesFiltradas.map((chat) {
                                final id = chat['id']?.toString() ?? '';
                                final titulo =
                                    chat['titulo']?.toString() ?? 'Chat 4Life';
                                return _TarjetaConversacion(
                                  titulo: titulo,
                                  fecha: _fechaLegible(chat['fecha']),
                                  categoria: _categoriaPara(titulo),
                                  onAbrir: () => _abrirChat(chat),
                                  onEliminar:
                                      id.isEmpty ? null : () => _eliminar(id),
                                );
                              }),
                          ],
                        ),
                  Positioned(
                    right: 24,
                    bottom: 74,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: FloatingActionButton(
                            heroTag: 'nuevo-chat-historial',
                            backgroundColor: azul,
                            foregroundColor: Colors.white,
                            elevation: 9,
                            shape: const CircleBorder(),
                            onPressed: _nuevoChat,
                            child: const Icon(Icons.add, size: 32),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Nuevo chat',
                          style: TextStyle(
                            color: azul,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
        child: Container(
          height: 82,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.history,
                  texto: 'Historial',
                  activo: true,
                ),
              ),
              Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.people_outline,
                  texto: txtApp('Pacientes', 'Patients'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaDatosPaciente(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _ItemNavegacionHistorial(
                  icono: Icons.bar_chart,
                  texto: txtApp('Estadisticas', 'Statistics'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaImpacto4LifeNueva(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriaChat {
  final String texto;
  final IconData icono;
  final Color color;
  final Color fondo;

  const _CategoriaChat({
    required this.texto,
    required this.icono,
    required this.color,
    required this.fondo,
  });
}

class _TarjetaConversacion extends StatelessWidget {
  final String titulo;
  final String fecha;
  final _CategoriaChat categoria;
  final VoidCallback onAbrir;
  final VoidCallback? onEliminar;

  const _TarjetaConversacion({
    required this.titulo,
    required this.fecha,
    required this.categoria,
    required this.onAbrir,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);

    return Container(
      constraints: const BoxConstraints(minHeight: 128),
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        elevation: 1.5,
        shadowColor: Colors.black.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onAbrir,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 14),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDEEFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: azul,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF10162F),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          height: 1.08,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xFF68708C),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              fecha,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF68708C),
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: categoria.fondo,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                categoria.icono,
                                color: categoria.color,
                                size: 17,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                categoria.texto,
                                style: TextStyle(
                                  color: categoria.color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  tooltip: 'Eliminar',
                  onPressed: onEliminar,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F1F8),
                    fixedSize: const Size(46, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFF5E637C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: azul,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EstadoHistorialVacio extends StatelessWidget {
  final String texto;

  const _EstadoHistorialVacio({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      alignment: Alignment.center,
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF646B88),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ItemNavegacionHistorial extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool activo;
  final VoidCallback? onTap;

  const _ItemNavegacionHistorial({
    required this.icono,
    required this.texto,
    this.activo = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = activo ? const Color(0xFF2839C7) : const Color(0xFF737892);

    return Material(
      color: activo ? const Color(0xFFEDEEFF) : Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: activo ? null : onTap,
        child: SizedBox(
          height: 62,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: color, size: 24),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  texto,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: activo ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
