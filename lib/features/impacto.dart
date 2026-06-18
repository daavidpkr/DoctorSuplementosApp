part of '../main.dart';

class PaginaImpacto4LifeNueva extends StatefulWidget {
  const PaginaImpacto4LifeNueva({super.key});

  @override
  State<PaginaImpacto4LifeNueva> createState() =>
      _PaginaImpacto4LifeNuevaState();
}

class _PaginaImpacto4LifeNuevaState extends State<PaginaImpacto4LifeNueva> {
  static const _azulVivo = Color(0xFF173BE5);
  static const _verde = Color(0xFF0FA64A);
  static const _naranja = Color(0xFFFF8500);
  static const _tinta = Color(0xFF07136E);
  static const _textoSuave = Color(0xFF56618F);

  List<Map<String, dynamic>> _eventos = [];
  bool _cargando = true;
  String? _mesSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final eventos = await ImpactoService.cargarEventos();
    final grupos = _agruparPorMes(eventos);
    final claves = grupos.keys.toList()..sort((a, b) => b.compareTo(a));
    if (!mounted) return;
    setState(() {
      _eventos = eventos;
      _mesSeleccionado =
          claves.isNotEmpty ? claves.first : _claveMes(DateTime.now());
      _cargando = false;
    });
  }

  DateTime? _fechaEvento(Map<String, dynamic> evento) {
    final raw = evento['fecha']?.toString();
    return raw == null ? null : DateTime.tryParse(raw);
  }

  String _claveMes(DateTime fecha) {
    return '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}';
  }

  DateTime _fechaDesdeClave(String clave) {
    final partes = clave.split('-');
    return DateTime(
      int.tryParse(partes.first) ?? DateTime.now().year,
      int.tryParse(partes.last) ?? DateTime.now().month,
    );
  }

  String _claveMesAnterior(String clave) {
    final fecha = _fechaDesdeClave(clave);
    return _claveMes(DateTime(fecha.year, fecha.month - 1));
  }

  String _nombreMes(DateTime fecha) {
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
    return '${meses[fecha.month - 1]} ${fecha.year}';
  }

  String _mesCorto(DateTime fecha) {
    const meses = [
      'ene.',
      'feb.',
      'mar.',
      'abr.',
      'may.',
      'jun.',
      'jul.',
      'ago.',
      'sep.',
      'oct.',
      'nov.',
      'dic.',
    ];
    return meses[fecha.month - 1];
  }

  String _rangoMes(DateTime fecha) {
    final ultimoDia = DateTime(fecha.year, fecha.month + 1, 0).day;
    return 'del 1 al $ultimoDia';
  }

  Map<String, List<Map<String, dynamic>>> _agruparPorMes(
    List<Map<String, dynamic>> eventos,
  ) {
    final grupos = <String, List<Map<String, dynamic>>>{};
    for (final evento in eventos) {
      final fecha = _fechaEvento(evento);
      if (fecha == null) continue;
      grupos.putIfAbsent(_claveMes(fecha), () => []).add(evento);
    }
    return grupos;
  }

  _ResumenImpactoNuevo _resumen(
    List<Map<String, dynamic>> eventos, {
    required String clave,
    required int totalAnterior,
  }) {
    final fecha = _fechaDesdeClave(clave);
    final totalDias = DateTime(fecha.year, fecha.month + 1, 0).day;
    final dias = List<int>.filled(totalDias, 0);
    final horas = List<int>.filled(24, 0);
    final productos = <String, int>{};
    final pacientes = <String>{};
    var diagnosticos = 0;
    var consultasProducto = 0;
    var calculadoras = 0;

    for (final evento in eventos) {
      switch (evento['tipo']) {
        case 'diagnostico':
          diagnosticos++;
          break;
        case 'consulta_producto':
          consultasProducto++;
          break;
        case 'calculadora_productos':
          calculadoras++;
          break;
      }

      final fechaEvento = _fechaEvento(evento);
      if (fechaEvento != null) {
        dias[(fechaEvento.day - 1).clamp(0, totalDias - 1)]++;
        horas[fechaEvento.hour]++;
      }

      final datos = evento['datos'];
      if (datos is! Map) continue;
      final nombrePaciente = datos['nombre']?.toString().trim();
      if (nombrePaciente != null && nombrePaciente.isNotEmpty) {
        pacientes.add(nombrePaciente.toLowerCase());
      }

      final producto = datos['producto']?.toString().trim();
      if (producto != null && producto.isNotEmpty) {
        productos.update(producto, (valor) => valor + 1, ifAbsent: () => 1);
      }

      final lista = datos['productos'];
      if (lista is List) {
        for (final item in lista) {
          String? nombre;
          var cantidad = 1;
          if (item is Map) {
            nombre = item['nombre']?.toString().trim();
            cantidad = int.tryParse('${item['cantidad'] ?? 1}') ?? 1;
          } else {
            nombre = item.toString().trim();
          }
          if (nombre != null && nombre.isNotEmpty) {
            productos.update(nombre, (valor) => valor + cantidad,
                ifAbsent: () => cantidad);
          }
        }
      }
    }

    final productosOrdenados = productos.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final mayorHora = horas.reduce((a, b) => a > b ? a : b);
    final horaActiva = mayorHora == 0 ? 19 : horas.indexOf(mayorHora);

    return _ResumenImpactoNuevo(
      diagnosticos: diagnosticos,
      consultasProducto: consultasProducto,
      calculadoras: calculadoras,
      productos: productosOrdenados,
      accionesPorDia: dias,
      accionesPorHora: horas,
      pacientes: pacientes.length,
      horaActiva: horaActiva,
      totalAnterior: totalAnterior,
    );
  }

  @override
  Widget build(BuildContext context) {
    final grupos = _agruparPorMes(_eventos);
    final claves = grupos.keys.toList()..sort((a, b) => b.compareTo(a));
    final clave = _mesSeleccionado ??
        (claves.isNotEmpty ? claves.first : _claveMes(DateTime.now()));
    final fecha = _fechaDesdeClave(clave);
    final eventosMes = grupos[clave] ?? const <Map<String, dynamic>>[];
    final resumen = _resumen(
      eventosMes,
      clave: clave,
      totalAnterior: (grupos[_claveMesAnterior(clave)] ?? const []).length,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: _azulVivo))
          : Column(
              children: [
                _HeaderImpactoNuevo(onBack: () => Navigator.pop(context)),
                Expanded(
                  child: RefreshIndicator(
                    color: _azulVivo,
                    onRefresh: _cargar,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
                      children: [
                        _SelectorMesImpactoNuevo(
                          mes: _nombreMes(fecha),
                          rango: _rangoMes(fecha),
                          claves: claves,
                          claveSeleccionada: clave,
                          nombreClave: (item) =>
                              _nombreMes(_fechaDesdeClave(item)),
                          onSeleccionar: (item) =>
                              setState(() => _mesSeleccionado = item),
                        ),
                        const SizedBox(height: 14),
                        _CardResumenImpactoNuevo(resumen: resumen),
                        const SizedBox(height: 14),
                        _CardEvolucionImpactoNuevo(
                          resumen: resumen,
                          mesCorto: _mesCorto(fecha),
                        ),
                        const SizedBox(height: 14),
                        _CardProductosImpactoNuevo(
                            productos: resumen.productos),
                        const SizedBox(height: 14),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 620) {
                              return Column(
                                children: [
                                  _CardPacientesImpactoNuevo(resumen: resumen),
                                  const SizedBox(height: 14),
                                  _CardHorasImpactoNuevo(resumen: resumen),
                                ],
                              );
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: _CardPacientesImpactoNuevo(
                                        resumen: resumen)),
                                const SizedBox(width: 14),
                                Expanded(
                                    child: _CardHorasImpactoNuevo(
                                        resumen: resumen)),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        _CardCompromisoImpactoNuevo(resumen: resumen),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ResumenImpactoNuevo {
  final int diagnosticos;
  final int consultasProducto;
  final int calculadoras;
  final List<MapEntry<String, int>> productos;
  final List<int> accionesPorDia;
  final List<int> accionesPorHora;
  final int pacientes;
  final int horaActiva;
  final int totalAnterior;

  const _ResumenImpactoNuevo({
    required this.diagnosticos,
    required this.consultasProducto,
    required this.calculadoras,
    required this.productos,
    required this.accionesPorDia,
    required this.accionesPorHora,
    required this.pacientes,
    required this.horaActiva,
    required this.totalAnterior,
  });

  int get total => diagnosticos + consultasProducto + calculadoras;
  int get variacion {
    if (totalAnterior == 0) return total == 0 ? 0 : 100;
    return (((total - totalAnterior) / totalAnterior) * 100).round();
  }

  double get compromiso => (total / 95).clamp(0.0, 1.0);
}

class _HeaderImpactoNuevo extends StatelessWidget {
  final VoidCallback onBack;

  const _HeaderImpactoNuevo({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF072393), Color(0xFF07146A)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.white,
                iconSize: 34,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints.tightFor(width: 46, height: 46),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Text(
                  'Tu impacto 4Life',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.calendar_month_outlined),
                color: Colors.white,
                iconSize: 34,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectorMesImpactoNuevo extends StatelessWidget {
  final String mes;
  final String rango;
  final List<String> claves;
  final String claveSeleccionada;
  final String Function(String clave) nombreClave;
  final ValueChanged<String> onSeleccionar;

  const _SelectorMesImpactoNuevo({
    required this.mes,
    required this.rango,
    required this.claves,
    required this.claveSeleccionada,
    required this.nombreClave,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return _CardImpactoNuevo(
      padding: const EdgeInsets.fromLTRB(20, 18, 18, 18),
      child: Row(
        children: [
          _IconoSuaveImpacto(
              icono: Icons.calendar_month_outlined,
              color: _PaginaImpacto4LifeNuevaState._azulVivo),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mes,
                  style: const TextStyle(
                    color: _PaginaImpacto4LifeNuevaState._tinta,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rango,
                  style: const TextStyle(
                    color: _PaginaImpacto4LifeNuevaState._textoSuave,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Cambiar mes',
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: _PaginaImpacto4LifeNuevaState._azulVivo, size: 36),
            onSelected: onSeleccionar,
            itemBuilder: (context) {
              final opciones = claves.isEmpty ? [claveSeleccionada] : claves;
              return [
                for (final clave in opciones)
                  PopupMenuItem(
                    value: clave,
                    child: Text(nombreClave(clave)),
                  ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

class _CardImpactoNuevo extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _CardImpactoNuevo({
    required this.child,
    this.padding = const EdgeInsets.all(22),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B176B).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardResumenImpactoNuevo extends StatelessWidget {
  final _ResumenImpactoNuevo resumen;

  const _CardResumenImpactoNuevo({required this.resumen});

  @override
  Widget build(BuildContext context) {
    final maximo = [
      resumen.diagnosticos,
      resumen.consultasProducto,
      resumen.calculadoras,
      1
    ].reduce((a, b) => a > b ? a : b);
    return _CardImpactoNuevo(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compacto = constraints.maxWidth < 520;
          final grafico = SizedBox(
            width: compacto ? 190 : 230,
            height: compacto ? 190 : 230,
            child: CustomPaint(
              painter: _AnilloImpactoNuevo(
                diagnosticos: resumen.diagnosticos,
                productos: resumen.consultasProducto,
                calculadora: resumen.calculadoras,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${resumen.total}',
                      style: const TextStyle(
                        color: _PaginaImpacto4LifeNuevaState._azulVivo,
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'acciones\ntotales',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _PaginaImpacto4LifeNuevaState._textoSuave,
                        fontSize: 18,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          final barras = Column(
            children: [
              _FilaMetricaImpacto(
                  icono: Icons.monitor_heart_outlined,
                  etiqueta: 'Diagnosticos',
                  valor: resumen.diagnosticos,
                  maximo: maximo,
                  color: _PaginaImpacto4LifeNuevaState._verde),
              const SizedBox(height: 24),
              _FilaMetricaImpacto(
                  icono: Icons.medication_liquid_outlined,
                  etiqueta: 'Productos',
                  valor: resumen.consultasProducto,
                  maximo: maximo,
                  color: _PaginaImpacto4LifeNuevaState._azulVivo),
              const SizedBox(height: 24),
              _FilaMetricaImpacto(
                  icono: Icons.calculate_outlined,
                  etiqueta: 'Calculadora',
                  valor: resumen.calculadoras,
                  maximo: maximo,
                  color: _PaginaImpacto4LifeNuevaState._naranja),
            ],
          );
          if (compacto) {
            return Column(
                children: [grafico, const SizedBox(height: 26), barras]);
          }
          return Row(
            children: [
              grafico,
              Container(
                  width: 1,
                  height: 250,
                  margin: const EdgeInsets.symmetric(horizontal: 26),
                  color: const Color(0xFFE1E5F2)),
              Expanded(child: barras),
            ],
          );
        },
      ),
    );
  }
}

class _FilaMetricaImpacto extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final int valor;
  final int maximo;
  final Color color;

  const _FilaMetricaImpacto({
    required this.icono,
    required this.etiqueta,
    required this.valor,
    required this.maximo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progreso = maximo == 0 ? 0.0 : (valor / maximo).clamp(0.0, 1.0);
    return Row(
      children: [
        _IconoSuaveImpacto(icono: icono, color: color),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      etiqueta,
                      style: const TextStyle(
                        color: _PaginaImpacto4LifeNuevaState._tinta,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    '$valor',
                    style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progreso,
                  minHeight: 13,
                  color: color,
                  backgroundColor: const Color(0xFFE4E8F5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconoSuaveImpacto extends StatelessWidget {
  final IconData icono;
  final Color color;

  const _IconoSuaveImpacto({required this.icono, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icono, color: color, size: 34),
    );
  }
}

class _CardEvolucionImpactoNuevo extends StatelessWidget {
  final _ResumenImpactoNuevo resumen;
  final String mesCorto;

  const _CardEvolucionImpactoNuevo({
    required this.resumen,
    required this.mesCorto,
  });

  @override
  Widget build(BuildContext context) {
    final variacion = resumen.variacion;
    return _CardImpactoNuevo(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Evolucion de acciones',
                  style: TextStyle(
                    color: _PaginaImpacto4LifeNuevaState._tinta,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${variacion >= 0 ? '+' : ''}$variacion%',
                    style: TextStyle(
                      color: variacion >= 0
                          ? _PaginaImpacto4LifeNuevaState._verde
                          : const Color(0xFFD33B3B),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'vs. mes anterior',
                    style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 165,
            child: CustomPaint(
              painter: _LineaImpactoNuevo(
                resumen.accionesPorDia,
                mesCorto,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

void _mostrarTodosProductosImpacto(
  BuildContext context,
  List<MapEntry<String, int>> productos,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.42,
      maxChildSize: 0.92,
      builder: (context, controller) => SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD8DCEB),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Todos los productos consultados',
                      style: TextStyle(
                        color: _PaginaImpacto4LifeNuevaState._tinta,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    color: _PaginaImpacto4LifeNuevaState._textoSuave,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
                itemCount: productos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FE),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE1E5F2)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              _PaginaImpacto4LifeNuevaState._azulVivo,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            producto.key,
                            style: const TextStyle(
                              color: _PaginaImpacto4LifeNuevaState._tinta,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          '${producto.value}',
                          style: const TextStyle(
                            color: _PaginaImpacto4LifeNuevaState._azulVivo,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _CardProductosImpactoNuevo extends StatelessWidget {
  final List<MapEntry<String, int>> productos;

  const _CardProductosImpactoNuevo({required this.productos});

  @override
  Widget build(BuildContext context) {
    final visibles = productos.take(5).toList();
    return _CardImpactoNuevo(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Productos mas consultados',
                  style: TextStyle(
                    color: _PaginaImpacto4LifeNuevaState._tinta,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (productos.length > visibles.length)
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () =>
                      _mostrarTodosProductosImpacto(context, productos),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ver todos',
                          style: TextStyle(
                            color: _PaginaImpacto4LifeNuevaState._azulVivo,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: _PaginaImpacto4LifeNuevaState._azulVivo,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 22),
          if (visibles.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Sin productos registrados este mes',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w700),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth < 520
                    ? 128.0
                    : constraints.maxWidth / 5;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < visibles.length; i++)
                        SizedBox(
                          width: itemWidth,
                          child: _ProductoImpactoNuevo(
                            posicion: i + 1,
                            nombre: visibles[i].key,
                            imagenAsset: _imagenProducto(visibles[i].key),
                            consultas: visibles[i].value,
                            color: [
                              _PaginaImpacto4LifeNuevaState._azulVivo,
                              const Color(0xFF2AA6B8),
                              const Color(0xFF6832DF),
                              _PaginaImpacto4LifeNuevaState._verde,
                              _PaginaImpacto4LifeNuevaState._naranja,
                            ][i],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String? _imagenProducto(String nombre) {
    final exacta = imagenesProducto4Life[nombre];
    if (exacta != null) return exacta;
    final producto = buscarProductoPermitido(nombre);
    return producto == null ? null : imagenesProducto4Life[producto];
  }
}

class _ProductoImpactoNuevo extends StatelessWidget {
  final int posicion;
  final String nombre;
  final String? imagenAsset;
  final int consultas;
  final Color color;

  const _ProductoImpactoNuevo({
    required this.posicion,
    required this.nombre,
    required this.imagenAsset,
    required this.consultas,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2FD),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: imagenAsset == null
                        ? Icon(
                            Icons.medication_liquid_outlined,
                            color: color,
                            size: 42,
                          )
                        : Image.asset(
                            imagenAsset!,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                  ),
                ),
              ),
              Positioned(
                left: -2,
                top: -2,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: _PaginaImpacto4LifeNuevaState._azulVivo,
                  child: Text(
                    '$posicion',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          nombre,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _PaginaImpacto4LifeNuevaState._tinta,
            fontSize: 15,
            height: 1.12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$consultas ${consultas == 1 ? 'consulta' : 'consultas'}',
          style: const TextStyle(
            color: _PaginaImpacto4LifeNuevaState._textoSuave,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CardPacientesImpactoNuevo extends StatelessWidget {
  final _ResumenImpactoNuevo resumen;

  const _CardPacientesImpactoNuevo({required this.resumen});

  @override
  Widget build(BuildContext context) {
    return _CardImpactoNuevo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pacientes atendidos',
            style: TextStyle(
                color: _PaginaImpacto4LifeNuevaState._tinta,
                fontSize: 21,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const _IconoSuaveImpacto(
                  icono: Icons.groups_2_outlined,
                  color: _PaginaImpacto4LifeNuevaState._azulVivo),
              const SizedBox(width: 26),
              Text(
                '${resumen.pacientes}',
                style: const TextStyle(
                    color: _PaginaImpacto4LifeNuevaState._tinta,
                    fontSize: 44,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'este mes',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            '${resumen.variacion >= 0 ? '+' : ''}${resumen.variacion}%\nvs. mes anterior',
            style: TextStyle(
              color: resumen.variacion >= 0
                  ? _PaginaImpacto4LifeNuevaState._verde
                  : const Color(0xFFD33B3B),
              fontSize: 19,
              height: 1.35,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardHorasImpactoNuevo extends StatelessWidget {
  final _ResumenImpactoNuevo resumen;

  const _CardHorasImpactoNuevo({required this.resumen});

  String _hora(int hora) {
    final periodo = hora >= 12 ? 'PM' : 'AM';
    final h = hora % 12 == 0 ? 12 : hora % 12;
    return '$h:00 $periodo';
  }

  @override
  Widget build(BuildContext context) {
    return _CardImpactoNuevo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Horas mas activas',
            style: TextStyle(
                color: _PaginaImpacto4LifeNuevaState._tinta,
                fontSize: 21,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _PaginaImpacto4LifeNuevaState._azulVivo
                      .withValues(alpha: 0.11),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.schedule_rounded,
                    color: _PaginaImpacto4LifeNuevaState._azulVivo, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  '${_hora(resumen.horaActiva)} - ${_hora((resumen.horaActiva + 2).clamp(0, 23))}',
                  style: const TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._tinta,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 50, top: 4),
            child: Text(
              'Pico de consultas',
              style: TextStyle(
                  color: _PaginaImpacto4LifeNuevaState._textoSuave,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 94,
            child: CustomPaint(
              painter: _BarrasHorasImpactoNuevo(
                  resumen.accionesPorHora, resumen.horaActiva),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardCompromisoImpactoNuevo extends StatelessWidget {
  final _ResumenImpactoNuevo resumen;

  const _CardCompromisoImpactoNuevo({required this.resumen});

  @override
  Widget build(BuildContext context) {
    final porcentaje = (resumen.compromiso * 100).round();
    return _CardImpactoNuevo(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      child: Column(
        children: [
          Row(
            children: [
              const _IconoSuaveImpacto(
                  icono: Icons.volunteer_activism_outlined,
                  color: _PaginaImpacto4LifeNuevaState._verde),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu compromiso en 4Life',
                      style: TextStyle(
                          color: _PaginaImpacto4LifeNuevaState._tinta,
                          fontSize: 19,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Estas generando habitos mas saludables y ayudando a transformar vidas.',
                      style: TextStyle(
                          color: _PaginaImpacto4LifeNuevaState._textoSuave,
                          fontSize: 15.5,
                          height: 1.35,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _PaginaImpacto4LifeNuevaState._verde,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  '$porcentaje%',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 17,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: Color(0xFFE7EAF4)),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: resumen.compromiso,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xFFFF2E2E),
                          Color(0xFFFFB000),
                          Color(0xFF45B846)
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w800)),
              Text('25%',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w800)),
              Text('50%',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w800)),
              Text('75%',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w800)),
              Text('100%',
                  style: TextStyle(
                      color: _PaginaImpacto4LifeNuevaState._textoSuave,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnilloImpactoNuevo extends CustomPainter {
  final int diagnosticos;
  final int productos;
  final int calculadora;

  const _AnilloImpactoNuevo({
    required this.diagnosticos,
    required this.productos,
    required this.calculadora,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = diagnosticos + productos + calculadora;
    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2 - 13);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFE6EAF5);
    canvas.drawArc(rect, -1.5708, 6.28318, false, base);
    if (total == 0) return;

    final segmentos = [
      MapEntry(diagnosticos, _PaginaImpacto4LifeNuevaState._verde),
      MapEntry(productos, _PaginaImpacto4LifeNuevaState._azulVivo),
      MapEntry(calculadora, _PaginaImpacto4LifeNuevaState._naranja),
    ];
    var inicio = -1.5708;
    for (final segmento in segmentos) {
      if (segmento.key <= 0) continue;
      final sweep = segmento.key / total * 6.28318;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 25
        ..strokeCap = StrokeCap.round
        ..color = segmento.value;
      canvas.drawArc(rect, inicio, sweep, false, paint);
      inicio += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _AnilloImpactoNuevo oldDelegate) {
    return oldDelegate.diagnosticos != diagnosticos ||
        oldDelegate.productos != productos ||
        oldDelegate.calculadora != calculadora;
  }
}

class _LineaImpactoNuevo extends CustomPainter {
  final List<int> dias;
  final String mesCorto;

  const _LineaImpactoNuevo(this.dias, this.mesCorto);

  @override
  void paint(Canvas canvas, Size size) {
    final grafico = Rect.fromLTWH(46, 6, size.width - 54, size.height - 34);
    final grid = Paint()
      ..color = const Color(0xFFDDE2F0)
      ..strokeWidth = 1;
    final texto = TextPainter(textDirection: TextDirection.ltr);
    const labelsY = [100, 75, 50, 25, 0];
    for (var i = 0; i < labelsY.length; i++) {
      final y = grafico.top + (grafico.height / 4) * i;
      canvas.drawLine(Offset(grafico.left, y), Offset(grafico.right, y), grid);
      texto.text = TextSpan(
        text: '${labelsY[i]}',
        style: const TextStyle(
            color: _PaginaImpacto4LifeNuevaState._textoSuave,
            fontSize: 13,
            fontWeight: FontWeight.w700),
      );
      texto.layout();
      texto.paint(canvas, Offset(4, y - 8));
    }

    final acumulados = <int>[];
    var acumulado = 0;
    for (final valor in dias) {
      acumulado += valor;
      acumulados.add(acumulado);
    }
    final maximo = [100, ...acumulados].reduce((a, b) => a > b ? a : b);
    final puntosDias =
        [1, 8, 15, 22, dias.length].where((d) => d <= dias.length).toList();
    final puntos = <Offset>[];
    for (final dia in puntosDias) {
      final x = grafico.left +
          ((dia - 1) / (dias.length - 1).clamp(1, 99)) * grafico.width;
      final valor = acumulados.isEmpty ? 0 : acumulados[dia - 1];
      final y = grafico.bottom - (valor / maximo) * grafico.height;
      puntos.add(Offset(x, y));
    }

    if (puntos.isNotEmpty) {
      final area = Path()..moveTo(puntos.first.dx, grafico.bottom);
      for (final punto in puntos) {
        area.lineTo(punto.dx, punto.dy);
      }
      area.lineTo(puntos.last.dx, grafico.bottom);
      area.close();
      canvas.drawPath(
        area,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x33213FE7), Color(0x00213FE7)],
          ).createShader(grafico),
      );

      final path = Path()..moveTo(puntos.first.dx, puntos.first.dy);
      for (final punto in puntos.skip(1)) {
        path.lineTo(punto.dx, punto.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = _PaginaImpacto4LifeNuevaState._azulVivo
          ..strokeWidth = 3.2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      for (final punto in puntos) {
        canvas.drawCircle(
            punto, 6, Paint()..color = _PaginaImpacto4LifeNuevaState._azulVivo);
      }
    }

    for (final dia in puntosDias) {
      final x = grafico.left +
          ((dia - 1) / (dias.length - 1).clamp(1, 99)) * grafico.width;
      texto.text = TextSpan(
        text: '$dia $mesCorto',
        style: const TextStyle(
            color: _PaginaImpacto4LifeNuevaState._textoSuave,
            fontSize: 13,
            fontWeight: FontWeight.w700),
      );
      texto.layout();
      texto.paint(canvas, Offset(x - texto.width / 2, grafico.bottom + 12));
    }
  }

  @override
  bool shouldRepaint(covariant _LineaImpactoNuevo oldDelegate) =>
      oldDelegate.dias != dias || oldDelegate.mesCorto != mesCorto;
}

class _BarrasHorasImpactoNuevo extends CustomPainter {
  final List<int> horas;
  final int activa;

  const _BarrasHorasImpactoNuevo(this.horas, this.activa);

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(0, 0, size.width, size.height - 18);
    final maximo = [1, ...horas].reduce((a, b) => a > b ? a : b);
    final ancho = chart.width / 30;
    for (var i = 0; i < horas.length; i++) {
      final alto = 10 + (horas[i] / maximo) * (chart.height - 12);
      final x = (i / 23) * (chart.width - ancho);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, chart.bottom - alto, ancho, alto),
        const Radius.circular(3),
      );
      canvas.drawRRect(
        rect,
        Paint()
          ..color = i == activa
              ? _PaginaImpacto4LifeNuevaState._azulVivo
              : const Color(0xFFDDE3FA),
      );
    }
    final texto = TextPainter(textDirection: TextDirection.ltr);
    final etiquetas = {6: '6 AM', 12: '12 PM', 18: '6 PM', 23: '12 AM'};
    etiquetas.forEach((hora, label) {
      final x = (hora / 23) * chart.width;
      texto.text = TextSpan(
        text: label,
        style: const TextStyle(
            color: _PaginaImpacto4LifeNuevaState._textoSuave,
            fontSize: 12,
            fontWeight: FontWeight.w800),
      );
      texto.layout();
      texto.paint(
          canvas,
          Offset((x - texto.width / 2).clamp(0, size.width - texto.width),
              chart.bottom + 5));
    });
  }

  @override
  bool shouldRepaint(covariant _BarrasHorasImpactoNuevo oldDelegate) {
    return oldDelegate.horas != horas || oldDelegate.activa != activa;
  }
}

class PaginaImpacto4Life extends StatefulWidget {
  const PaginaImpacto4Life({super.key});

  @override
  State<PaginaImpacto4Life> createState() => _PaginaImpacto4LifeState();
}

class _PaginaImpacto4LifeState extends State<PaginaImpacto4Life> {
  List<Map<String, dynamic>> _eventos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final eventos = await ImpactoService.cargarEventos();
    if (!mounted) return;
    setState(() {
      _eventos = eventos;
      _cargando = false;
    });
  }

  DateTime? _fechaEvento(Map<String, dynamic> evento) {
    final raw = evento['fecha']?.toString();
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  String _claveMes(DateTime fecha) {
    final mes = fecha.month.toString().padLeft(2, '0');
    return '${fecha.year}-$mes';
  }

  String _tituloMes(String clave) {
    final partes = clave.split('-');
    final anio = int.tryParse(partes.first) ?? DateTime.now().year;
    final mes = int.tryParse(partes.last) ?? DateTime.now().month;
    const nombres = [
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
    final ultimoDia = DateTime(anio, mes + 1, 0).day;
    return '${nombres[mes - 1]} $anio - del 1 al $ultimoDia';
  }

  Map<String, List<Map<String, dynamic>>> _eventosPorMes() {
    final grupos = <String, List<Map<String, dynamic>>>{};
    for (final evento in _eventos) {
      final fecha = _fechaEvento(evento);
      if (fecha == null) continue;
      grupos.putIfAbsent(_claveMes(fecha), () => []).add(evento);
    }
    return grupos;
  }

  _ResumenImpactoMes _resumenMes(List<Map<String, dynamic>> eventos) {
    final diagnosticos =
        eventos.where((e) => e['tipo'] == 'diagnostico').length;
    final consultasProducto =
        eventos.where((e) => e['tipo'] == 'consulta_producto').length;
    final calculadoras =
        eventos.where((e) => e['tipo'] == 'calculadora_productos').length;
    final productos = eventos
        .map((e) => e['datos'])
        .whereType<Map>()
        .expand((datos) {
          final lista = datos['productos'];
          if (lista is List) return lista.map((e) => '$e');
          final producto = datos['producto']?.toString();
          return producto == null || producto.isEmpty
              ? const Iterable<String>.empty()
              : [producto];
        })
        .toSet()
        .toList();

    return _ResumenImpactoMes(
      diagnosticos: diagnosticos,
      consultasProducto: consultasProducto,
      calculadoras: calculadoras,
      productos: productos,
    );
  }

  @override
  Widget build(BuildContext context) {
    final grupos = _eventosPorMes();
    final claves = grupos.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tu impacto 4Life"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : claves.isEmpty
              ? const Center(
                  child: Text(
                    "Aun no hay diagnósticos ni consultas registradas.",
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: claves.length,
                  itemBuilder: (context, index) {
                    final clave = claves[index];
                    final resumen = _resumenMes(grupos[clave] ?? []);
                    return _TarjetaImpactoGrafica(
                      titulo: _tituloMes(clave),
                      resumen: resumen,
                    );
                  },
                ),
    );
  }
}

class _ResumenImpactoMes {
  final int diagnosticos;
  final int consultasProducto;
  final int calculadoras;
  final List<String> productos;

  const _ResumenImpactoMes({
    required this.diagnosticos,
    required this.consultasProducto,
    required this.calculadoras,
    required this.productos,
  });

  int get total => diagnosticos + consultasProducto + calculadoras;
}

class _TarjetaImpactoGrafica extends StatelessWidget {
  final String titulo;
  final _ResumenImpactoMes resumen;

  const _TarjetaImpactoGrafica({
    required this.titulo,
    required this.resumen,
  });

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2839C7);
    final maximo = [
      resumen.diagnosticos,
      resumen.consultasProducto,
      resumen.calculadoras,
      1,
    ].reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Color(0xFF12248B),
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 112,
                height: 112,
                child: CustomPaint(
                  painter: _GraficoCircularImpacto(
                    diagnosticos: resumen.diagnosticos,
                    consultasProducto: resumen.consultasProducto,
                    calculadoras: resumen.calculadoras,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${resumen.total}',
                          style: const TextStyle(
                            color: azul,
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'acciones',
                          style: TextStyle(
                            color: Color(0xFF68708C),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    _BarraImpacto(
                      etiqueta: 'Diagnósticos',
                      valor: resumen.diagnosticos,
                      maximo: maximo,
                      color: const Color(0xFF14983E),
                    ),
                    const SizedBox(height: 12),
                    _BarraImpacto(
                      etiqueta: 'Productos',
                      valor: resumen.consultasProducto,
                      maximo: maximo,
                      color: azul,
                    ),
                    const SizedBox(height: 12),
                    _BarraImpacto(
                      etiqueta: 'Calculadora',
                      valor: resumen.calculadoras,
                      maximo: maximo,
                      color: const Color(0xFFF29A00),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (resumen.productos.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Productos consultados',
              style: TextStyle(
                color: Color(0xFF12248B),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final producto in resumen.productos.take(8))
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF1FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      producto,
                      style: const TextStyle(
                        color: azul,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BarraImpacto extends StatelessWidget {
  final String etiqueta;
  final int valor;
  final int maximo;
  final Color color;

  const _BarraImpacto({
    required this.etiqueta,
    required this.valor,
    required this.maximo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final porcentaje = maximo == 0 ? 0.0 : (valor / maximo).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
              '$valor',
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: porcentaje,
            minHeight: 10,
            color: color,
            backgroundColor: const Color(0xFFE8EBF6),
          ),
        ),
      ],
    );
  }
}

class _GraficoCircularImpacto extends CustomPainter {
  final int diagnosticos;
  final int consultasProducto;
  final int calculadoras;

  const _GraficoCircularImpacto({
    required this.diagnosticos,
    required this.consultasProducto,
    required this.calculadoras,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = diagnosticos + consultasProducto + calculadoras;
    final centro = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: centro, radius: (size.width / 2) - 7);
    final base = Paint()
      ..color = const Color(0xFFE8EBF6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 6.28318, false, base);
    if (total == 0) return;

    final segmentos = [
      (diagnosticos, const Color(0xFF14983E)),
      (consultasProducto, const Color(0xFF2839C7)),
      (calculadoras, const Color(0xFFF29A00)),
    ];
    var inicio = -1.5708;
    for (final segmento in segmentos) {
      if (segmento.$1 <= 0) continue;
      final sweep = (segmento.$1 / total) * 6.28318;
      final paint = Paint()
        ..color = segmento.$2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, inicio, sweep, false, paint);
      inicio += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _GraficoCircularImpacto oldDelegate) {
    return oldDelegate.diagnosticos != diagnosticos ||
        oldDelegate.consultasProducto != consultasProducto ||
        oldDelegate.calculadoras != calculadoras;
  }
}

// --- PANTALLA PRINCIPAL ANTERIOR ---
