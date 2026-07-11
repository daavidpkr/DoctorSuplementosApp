part of '../main.dart';

class _EnfermedadAnatomica {
  final String nombre;
  final String descripcion;
  const _EnfermedadAnatomica(this.nombre, this.descripcion);
}

class _OrganoAnatomico {
  final String nombre;
  final String nombreEn;
  final Rect zona;
  final List<_EnfermedadAnatomica> enfermedades;
  final List<String> productos;
  const _OrganoAnatomico(
      {required this.nombre,
      required this.nombreEn,
      required this.zona,
      required this.enfermedades,
      required this.productos});
}

const List<_OrganoAnatomico> _organosAnatomicos = [
  _OrganoAnatomico(
      nombre: 'Cerebro',
      nombreEn: 'Brain',
      zona: Rect.fromLTWH(.37, .025, .25, .105),
      productos: [
        'Recall',
        'Transfer factor plus',
        'Bioefa'
      ],
      enfermedades: [
        _EnfermedadAnatomica('Accidente cerebrovascular (ACV)',
            'Interrupción del flujo sanguíneo cerebral.'),
        _EnfermedadAnatomica(
            'Alzheimer', 'Enfermedad neurodegenerativa que afecta la memoria.'),
        _EnfermedadAnatomica(
            'Epilepsia', 'Trastorno que provoca convulsiones recurrentes.'),
        _EnfermedadAnatomica(
            'Tumor cerebral', 'Crecimiento anormal de células en el cerebro.'),
        _EnfermedadAnatomica('Meningitis',
            'Inflamación de las membranas que rodean el cerebro y la médula espinal.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Cerebelo',
      nombreEn: 'Cerebellum',
      zona: Rect.fromLTWH(.52, .095, .105, .065),
      productos: [
        'Recall',
        'Transfer factor plus',
        'Bioefa'
      ],
      enfermedades: [
        _EnfermedadAnatomica('Ataxia cerebelosa',
            'Trastorno que afecta el equilibrio y la coordinación.'),
        _EnfermedadAnatomica('Accidente cerebrovascular cerebeloso',
            'Interrupción del flujo sanguíneo en el cerebelo.'),
        _EnfermedadAnatomica('Tumor cerebeloso',
            'Crecimiento anormal de células en el cerebelo.'),
        _EnfermedadAnatomica('Degeneración cerebelosa',
            'Pérdida progresiva de las neuronas cerebelosas.'),
        _EnfermedadAnatomica('Cerebelitis',
            'Inflamación del cerebelo, generalmente por infecciones.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Pulmones',
      nombreEn: 'Lungs',
      zona: Rect.fromLTWH(.32, .215, .37, .17),
      productos: [
        'Transfer factor plus',
        'Transfer factor MAX',
        'Riovida Jugo'
      ],
      enfermedades: [
        _EnfermedadAnatomica(
            'Neumonía', 'Infección que inflama los alvéolos pulmonares.'),
        _EnfermedadAnatomica('Asma',
            'Inflamación crónica de las vías respiratorias que dificulta respirar.'),
        _EnfermedadAnatomica('EPOC',
            'Enfermedad pulmonar obstructiva crónica que reduce el flujo de aire.'),
        _EnfermedadAnatomica(
            'Cáncer de pulmón', 'Crecimiento maligno de células en el pulmón.'),
        _EnfermedadAnatomica('Tuberculosis',
            'Infección bacteriana que afecta principalmente los pulmones.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Corazón',
      nombreEn: 'Heart',
      zona: Rect.fromLTWH(.445, .285, .14, .105),
      productos: [
        'Bcv',
        'Bioefa',
        'Transfer factor plus'
      ],
      enfermedades: [
        _EnfermedadAnatomica('Infarto agudo de miocardio',
            'Muerte de una parte del músculo cardíaco por falta de riego sanguíneo.'),
        _EnfermedadAnatomica('Insuficiencia cardíaca',
            'El corazón no puede bombear suficiente sangre al cuerpo.'),
        _EnfermedadAnatomica(
            'Arritmias', 'Alteraciones en el ritmo normal de los latidos.'),
        _EnfermedadAnatomica('Cardiopatía coronaria',
            'Estrechamiento de las arterias que irrigan el corazón.'),
        _EnfermedadAnatomica('Miocarditis',
            'Inflamación del músculo cardíaco, generalmente causada por infecciones.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Hígado',
      nombreEn: 'Liver',
      zona: Rect.fromLTWH(.34, .365, .25, .105),
      productos: [
        'Transfer factor plus',
        'Riovida Jugo',
        'Aloe Vera Stix Tropical'
      ],
      enfermedades: [
        _EnfermedadAnatomica('Hepatitis',
            'Inflamación del hígado causada por virus, alcohol o medicamentos.'),
        _EnfermedadAnatomica('Cirrosis',
            'Cicatrización permanente que deteriora el funcionamiento del hígado.'),
        _EnfermedadAnatomica('Hígado graso',
            'Acumulación excesiva de grasa en las células hepáticas.'),
        _EnfermedadAnatomica('Cáncer de hígado',
            'Tumor maligno originado en el tejido hepático.'),
        _EnfermedadAnatomica('Insuficiencia hepática',
            'Pérdida grave de la función del hígado.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Vesícula biliar',
      nombreEn: 'Gallbladder',
      zona: Rect.fromLTWH(.37, .425, .12, .055),
      productos: [
        'Aloe Vera Stix Tropical',
        'Fibre',
        'Preo biotics'
      ],
      enfermedades: [
        _EnfermedadAnatomica(
            'Colelitiasis', 'Formación de cálculos o piedras en la vesícula.'),
        _EnfermedadAnatomica('Colecistitis',
            'Inflamación de la vesícula, generalmente por cálculos.'),
        _EnfermedadAnatomica(
            'Cáncer de vesícula biliar', 'Tumor maligno de la vesícula.'),
        _EnfermedadAnatomica('Pólipos de la vesícula',
            'Crecimientos en la pared interna de la vesícula.'),
        _EnfermedadAnatomica('Coledocolitiasis',
            'Presencia de cálculos en el conducto biliar principal.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Estómago',
      nombreEn: 'Stomach',
      zona: Rect.fromLTWH(.51, .375, .15, .105),
      productos: [
        'Aloe Vera Stix Tropical',
        'Preo biotics',
        'Transfer factor plus'
      ],
      enfermedades: [
        _EnfermedadAnatomica(
            'Gastritis', 'Inflamación del revestimiento del estómago.'),
        _EnfermedadAnatomica(
            'Úlcera gástrica', 'Herida en la mucosa del estómago.'),
        _EnfermedadAnatomica('Cáncer gástrico', 'Tumor maligno del estómago.'),
        _EnfermedadAnatomica('Gastroenteritis',
            'Inflamación del estómago e intestinos por infecciones.'),
        _EnfermedadAnatomica('Reflujo gastroesofágico (ERGE)',
            'El ácido del estómago regresa al esófago.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Páncreas',
      nombreEn: 'Pancreas',
      zona: Rect.fromLTWH(.44, .435, .20, .055),
      productos: [
        'Glucoach',
        'Aloe Vera Stix Tropical',
        'Transfer factor plus'
      ],
      enfermedades: [
        _EnfermedadAnatomica(
            'Pancreatitis aguda', 'Inflamación repentina del páncreas.'),
        _EnfermedadAnatomica('Pancreatitis crónica',
            'Inflamación prolongada que deteriora el órgano.'),
        _EnfermedadAnatomica(
            'Cáncer de páncreas', 'Tumor maligno pancreático.'),
        _EnfermedadAnatomica(
            'Diabetes tipo 1', 'El páncreas deja de producir insulina.'),
        _EnfermedadAnatomica('Insuficiencia pancreática',
            'Producción insuficiente de enzimas digestivas.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Bazo',
      nombreEn: 'Spleen',
      zona: Rect.fromLTWH(.61, .395, .09, .08),
      productos: [
        'Transfer factor MAX',
        'Transfer factor plus',
        'Riovida Jugo'
      ],
      enfermedades: [
        _EnfermedadAnatomica(
            'Esplenomegalia', 'Agrandamiento anormal del bazo.'),
        _EnfermedadAnatomica('Rotura del bazo',
            'Lesión grave generalmente causada por traumatismos.'),
        _EnfermedadAnatomica(
            'Absceso esplénico', 'Acumulación de pus en el bazo.'),
        _EnfermedadAnatomica('Infarto esplénico',
            'Muerte de tejido por falta de irrigación sanguínea.'),
        _EnfermedadAnatomica('Linfoma con afectación esplénica',
            'Cáncer del sistema linfático que compromete el bazo.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Intestino grueso',
      nombreEn: 'Large intestine',
      zona: Rect.fromLTWH(.34, .47, .33, .15),
      productos: [
        'Fibre',
        'Preo biotics',
        'Aloe Vera Stix Tropical'
      ],
      enfermedades: [
        _EnfermedadAnatomica(
            'Colitis ulcerosa', 'Inflamación crónica del colon y recto.'),
        _EnfermedadAnatomica(
            'Diverticulitis', 'Inflamación de pequeñas bolsas del colon.'),
        _EnfermedadAnatomica(
            'Cáncer colorrectal', 'Tumor maligno del colon o recto.'),
        _EnfermedadAnatomica('Síndrome del intestino irritable',
            'Trastorno funcional con dolor abdominal y cambios en las evacuaciones.'),
        _EnfermedadAnatomica(
            'Estreñimiento crónico', 'Dificultad persistente para evacuar.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Colon',
      nombreEn: 'Colon',
      zona: Rect.fromLTWH(.34, .475, .08, .14),
      productos: [
        'Fibre',
        'Preo biotics',
        'Aloe Vera Stix Tropical'
      ],
      enfermedades: [
        _EnfermedadAnatomica('Pólipos de colon',
            'Crecimientos anormales que pueden convertirse en cáncer.'),
        _EnfermedadAnatomica(
            'Cáncer de colon', 'Tumor maligno que se desarrolla en el colon.'),
        _EnfermedadAnatomica('Colitis isquémica',
            'Inflamación por disminución del flujo sanguíneo.'),
        _EnfermedadAnatomica('Diverticulosis',
            'Formación de pequeñas bolsas en la pared del colon.'),
        _EnfermedadAnatomica('Colitis infecciosa',
            'Inflamación causada por bacterias, virus o parásitos.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Intestino delgado',
      nombreEn: 'Small intestine',
      zona: Rect.fromLTWH(.41, .505, .20, .10),
      productos: [
        'Preo biotics',
        'Glutamine prime',
        'Aloe Vera Stix Tropical'
      ],
      enfermedades: [
        _EnfermedadAnatomica('Enfermedad celíaca',
            'Reacción inmunitaria al gluten que daña el intestino.'),
        _EnfermedadAnatomica(
            'Enfermedad de Crohn', 'Inflamación crónica del tubo digestivo.'),
        _EnfermedadAnatomica('Obstrucción intestinal',
            'Bloqueo que impide el paso de alimentos.'),
        _EnfermedadAnatomica(
            'Síndrome de malabsorción', 'Dificultad para absorber nutrientes.'),
        _EnfermedadAnatomica('Enteritis',
            'Inflamación del intestino delgado por infecciones u otras causas.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Riñones',
      nombreEn: 'Kidneys',
      zona: Rect.fromLTWH(.35, .605, .30, .075),
      productos: [
        'Transfer factor plus',
        'Riovida Jugo',
        'Aloe Vera Stix Tropical'
      ],
      enfermedades: [
        _EnfermedadAnatomica('Insuficiencia renal crónica',
            'Pérdida progresiva de la función renal.'),
        _EnfermedadAnatomica('Cálculos renales',
            'Formación de piedras minerales dentro del riñón.'),
        _EnfermedadAnatomica(
            'Pielonefritis', 'Infección bacteriana del riñón.'),
        _EnfermedadAnatomica(
            'Glomerulonefritis', 'Inflamación de los filtros renales.'),
        _EnfermedadAnatomica('Enfermedad renal poliquística',
            'Trastorno hereditario que produce múltiples quistes.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Uréter',
      nombreEn: 'Ureter',
      zona: Rect.fromLTWH(.39, .66, .23, .075),
      productos: [
        'Aloe Vera Stix Tropical',
        'Transfer factor plus',
        'Riovida Jugo'
      ],
      enfermedades: [
        _EnfermedadAnatomica(
            'Cálculos ureterales', 'Piedras que obstruyen el uréter.'),
        _EnfermedadAnatomica(
            'Estenosis ureteral', 'Estrechamiento del uréter.'),
        _EnfermedadAnatomica('Reflujo vesicoureteral',
            'La orina regresa desde la vejiga hacia el uréter.'),
        _EnfermedadAnatomica('Ureteritis', 'Inflamación del uréter.'),
        _EnfermedadAnatomica(
            'Cáncer de uréter', 'Tumor maligno que afecta este conducto.'),
      ]),
  _OrganoAnatomico(
      nombre: 'Vejiga',
      nombreEn: 'Bladder',
      zona: Rect.fromLTWH(.43, .695, .16, .075),
      productos: [
        'Transfer factor plus',
        'Aloe Vera Stix Tropical',
        'Riovida Jugo'
      ],
      enfermedades: [
        _EnfermedadAnatomica(
            'Cistitis', 'Infección o inflamación de la vejiga.'),
        _EnfermedadAnatomica(
            'Cáncer de vejiga', 'Tumor maligno de la vejiga urinaria.'),
        _EnfermedadAnatomica('Vejiga hiperactiva',
            'Contracciones involuntarias que producen urgencia urinaria.'),
        _EnfermedadAnatomica(
            'Cálculos vesicales', 'Piedras que se forman dentro de la vejiga.'),
        _EnfermedadAnatomica(
            'Incontinencia urinaria', 'Pérdida involuntaria de orina.'),
      ]),
];

class PaginaMapaAnatomico extends StatefulWidget {
  const PaginaMapaAnatomico({super.key});

  @override
  State<PaginaMapaAnatomico> createState() => _PaginaMapaAnatomicoState();
}

class _PaginaMapaAnatomicoState extends State<PaginaMapaAnatomico> {
  final TransformationController _zoomController = TransformationController();

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  void _cambiarZoom(double diferencia) {
    final escalaActual = _zoomController.value.getMaxScaleOnAxis();
    final nuevaEscala = (escalaActual + diferencia).clamp(1.0, 4.0);
    _zoomController.value = Matrix4.diagonal3Values(
      nuevaEscala,
      nuevaEscala,
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF172394),
        foregroundColor: Colors.white,
        title: Text(
            txtApp('Mapa Anatómico Interactivo', 'Interactive Anatomy Map'),
            style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFFE8ECFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBFCBFF))),
            child: Row(children: [
              const Icon(Icons.touch_app_rounded, color: Color(0xFF3047CC)),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                      txtApp(
                          'Amplía con dos dedos y toca un órgano para conocer sus enfermedades y productos de apoyo.',
                          'Pinch to zoom, then tap an organ to view its conditions and support products.'),
                      style: const TextStyle(
                          color: Color(0xFF25315F),
                          fontWeight: FontWeight.w700)))
            ]),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: InteractiveViewer(
                    transformationController: _zoomController,
                    minScale: 1,
                    maxScale: 4,
                    boundaryMargin: const EdgeInsets.all(100),
                    child: LayoutBuilder(builder: (context, c) {
                      return Stack(fit: StackFit.expand, children: [
                        Image.asset('assets/anatomia/mapa_anatomico.webp',
                            fit: BoxFit.contain),
                        for (final organo in _organosAnatomicos)
                          Positioned(
                              left: organo.zona.left * c.maxWidth,
                              top: organo.zona.top * c.maxHeight,
                              width: organo.zona.width * c.maxWidth,
                              height: organo.zona.height * c.maxHeight,
                              child: Semantics(
                                  button: true,
                                  label: organo.nombre,
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          onTap: () =>
                                              _mostrarOrgano(context, organo),
                                          splashColor: const Color(0xFF3047CC)
                                              .withValues(alpha: .25))))),
                      ]);
                    }),
                  ),
                ),
              ),
              Positioned(
                right: 14,
                bottom: 18,
                child: Column(
                  children: [
                    _botonZoom(Icons.add_rounded, () => _cambiarZoom(.75)),
                    const SizedBox(height: 8),
                    _botonZoom(Icons.remove_rounded, () => _cambiarZoom(-.75)),
                    const SizedBox(height: 8),
                    _botonZoom(Icons.center_focus_strong_rounded,
                        () => _zoomController.value = Matrix4.identity()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _botonZoom(IconData icono, VoidCallback onPressed) {
    return Material(
      color: const Color(0xFF172394),
      elevation: 4,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: icono == Icons.add_rounded
            ? txtApp('Acercar', 'Zoom in')
            : icono == Icons.remove_rounded
                ? txtApp('Alejar', 'Zoom out')
                : txtApp('Restablecer zoom', 'Reset zoom'),
        onPressed: onPressed,
        color: Colors.white,
        icon: Icon(icono),
      ),
    );
  }

  void _mostrarOrgano(BuildContext context, _OrganoAnatomico organo) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return DraggableScrollableSheet(
              initialChildSize: .72,
              minChildSize: .48,
              maxChildSize: .94,
              expand: false,
              builder: (context, controller) {
                return Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFF7F7FB),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(26))),
                  child: Column(children: [
                    const SizedBox(height: 10),
                    Container(
                        width: 46,
                        height: 5,
                        decoration: BoxDecoration(
                            color: const Color(0xFFC6CAE0),
                            borderRadius: BorderRadius.circular(10))),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                        child: Row(children: [
                          Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFE8ECFF),
                                  borderRadius: BorderRadius.circular(14)),
                              child: const Icon(Icons.favorite_rounded,
                                  color: Color(0xFF3047CC))),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(
                                    IdiomaService.actual.value ==
                                            IdiomaApp.ingles
                                        ? organo.nombreEn
                                        : organo.nombre,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF101A5B))),
                                Text(
                                    txtApp(
                                        '${organo.enfermedades.length} enfermedades',
                                        '${organo.enfermedades.length} conditions'),
                                    style: const TextStyle(
                                        color: Color(0xFF606A91),
                                        fontWeight: FontWeight.w600))
                              ])),
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close_rounded)),
                        ])),
                    Expanded(
                        child: ListView.builder(
                            controller: controller,
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                            itemCount: organo.enfermedades.length,
                            itemBuilder: (context, index) => _tarjetaEnfermedad(
                                organo, organo.enfermedades[index]))),
                  ]),
                );
              });
        });
  }

  Widget _tarjetaEnfermedad(
      _OrganoAnatomico organo, _EnfermedadAnatomica enfermedad) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFDDE2F8))),
      child: ExpansionTile(
        iconColor: const Color(0xFF3047CC),
        collapsedIconColor: const Color(0xFF3047CC),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(enfermedad.nombre,
            style: const TextStyle(
                fontWeight: FontWeight.w800, color: Color(0xFF101A5B))),
        subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(enfermedad.descripcion,
                style: const TextStyle(color: Color(0xFF59617F), height: 1.3))),
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(txtApp('Productos de apoyo', 'Support products'),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF172394)))),
          const SizedBox(height: 10),
          SizedBox(
              height: 112,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: organo.productos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final nombre = organo.productos[i];
                    final imagen = imagenesProducto4Life[nombre];
                    return Container(
                        width: 104,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF2F4FF),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFD6DCF8))),
                        child: Column(children: [
                          Expanded(
                              child: imagen == null
                                  ? const Icon(Icons.medication_rounded,
                                      color: Color(0xFF3047CC), size: 42)
                                  : Image.asset(imagen,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(
                                          Icons.medication_rounded,
                                          color: Color(0xFF3047CC),
                                          size: 42))),
                          const SizedBox(height: 5),
                          Text(nombre,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF101A5B)))
                        ]));
                  }))
        ],
      ),
    );
  }
}
