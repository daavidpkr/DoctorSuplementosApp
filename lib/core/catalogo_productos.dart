part of '../main.dart';

const List<String> productosPermitidos4Life = [
  'Agpro',
  'Aloe Vera Stix Tropical',
  'Bcv',
  'Belle vie',
  'Bioefa',
  'Colageno tipo i',
  'Crema cuerpo',
  'Crema humectante',
  'Crema para los ojos',
  'Energy go stix',
  'Fibre',
  'Glucoach',
  'Glutamine prime',
  'Kbu',
  'Limpiador',
  'Malepro',
  'Nutrastart',
  'Pasta de dientes',
  'Preo biotics',
  'Protf',
  'Recall',
  'Renuvo',
  'Riovida burst',
  'Riovida Jugo',
  'Riovida stix',
  'Suero',
  'TF Boost',
  'Transfer factor MAX',
  'Tonico',
  'Transfer factor plus',
  'Transfer factor tri factor',
  'Vistari',
];

const double escalaTextoInterfaces = 0.90;

final String catalogoPermitido4Life = productosPermitidos4Life.join(', ');

const List<String> productosCambioFisico4Life = [
  'Aloe Vera Stix Tropical',
  '4Life Transfer Factor GluCoach',
  'Energy Go Stix Berry',
  '4Life TF-Boost',
  'RioVida Stix',
  'RioVida Burst',
  '4Life Transfer Factor Colageno',
  'Pro-TF',
  'NutraStart',
  'BioEFA con CLA',
  '4Life Transfer Factor BCV',
  'Glutamine Prime',
  'Renuvo',
];

final String catalogoCambioFisico4Life = productosCambioFisico4Life.join(', ');

const Map<String, List<String>> _diferenciadoresProducto4Life = {
  'Transfer factor MAX': [
    'transfer factor max',
    'tf max',
    'max',
    '1 max',
    'factor max',
  ],
  'Transfer factor plus': ['plus'],
  'Transfer factor tri factor': ['tri factor', 'trifactor'],
  'Riovida burst': ['riovida burst', 'burst'],
  'Riovida Jugo': ['riovida jugo', 'rio vida jugo', 'jugo'],
  'Riovida stix': ['riovida stix', 'riovida'],
  'Energy go stix': ['energy go', 'energy', 'go stix'],
  'Aloe Vera Stix Tropical': ['aloe', 'aloe vera', 'aloe stix'],
};

const Map<String, String> imagenesProducto4Life = {
  'Aloe Vera Stix Tropical':
      'assets/productos/productos-ec/aloe_vera_stix_tropical.webp',
  'Transfer factor plus':
      'assets/productos/productos-ec/trasnfer_factor_plus.webp',
  'Transfer factor MAX':
      'assets/productos/productos-ec/transfer_factor_max.webp',
  'Riovida Jugo': 'assets/productos/productos-ec/riovida_jugo.webp',
  'Riovida stix': 'assets/productos/productos-ec/riovida_stix.webp',
  'Energy go stix': 'assets/productos/productos-ec/energy_go_stix.webp',
  'Renuvo': 'assets/productos/productos-ec/renuvo.webp',
  'Glucoach': 'assets/productos/productos-ec/glucoach.webp',
  'Bcv': 'assets/productos/productos-ec/bcv.webp',
  'Malepro': 'assets/productos/productos-ec/malepro.webp',
  'Colageno tipo i': 'assets/productos/productos-ec/colageno_tipo_i.webp',
  'Transfer factor tri factor':
      'assets/productos/productos-ec/transfer_factor_tri_factor.webp',
  'Nutrastart': 'assets/productos/productos-ec/nutrastart.webp',
  'Riovida burst': 'assets/productos/productos-ec/riovida_burst.webp',
  'Protf': 'assets/productos/productos-ec/protf.webp',
  'Bioefa': 'assets/productos/productos-ec/bioefa.webp',
  'Belle vie': 'assets/productos/productos-ec/belle_vie.webp',
  'Glutamine prime': 'assets/productos/productos-ec/glutamine_prime.webp',
  'Kbu': 'assets/productos/productos-ec/kbu.webp',
  'Vistari': 'assets/productos/productos-ec/vistari.webp',
  'Preo biotics': 'assets/productos/productos-ec/preo_biotics.webp',
  'Fibre': 'assets/productos/productos-ec/fibre.webp',
  'Agpro': 'assets/productos/productos-ec/agpro.webp',
  'Suero': 'assets/productos/productos-ec/suero.webp',
  'Crema para los ojos':
      'assets/productos/productos-ec/crema_para_los_ojos.webp',
  'Tonico': 'assets/productos/productos-ec/tonico.webp',
  'Crema humectante': 'assets/productos/productos-ec/crema_humectante.webp',
  'Pasta de dientes': 'assets/productos/productos-ec/pasta_de_dientes.webp',
  'Crema cuerpo': 'assets/productos/productos-ec/crema_de_cuerpo.webp',
  'Limpiador': 'assets/productos/productos-ec/limpiador.webp',
  'Recall': 'assets/productos/productos-ec/recall.webp',
  'TF Boost': 'assets/productos/productos-ec/tf_boost.webp',
};

class ProductoPrecio {
  final String nombre;
  final double afiliado;
  final double publico;
  final int? lp;
  final int? lpCanje;

  const ProductoPrecio({
    required this.nombre,
    required this.afiliado,
    required this.publico,
    required this.lp,
    this.lpCanje,
  });
}

class InformacionProductoCatalogo {
  final String descripcion;
  final String componentes;
  final String uso;
  final String precauciones;
  final String dosis;

  const InformacionProductoCatalogo({
    required this.descripcion,
    required this.componentes,
    required this.uso,
    required this.precauciones,
    required this.dosis,
  });
}

class LineaProductoPrecio {
  final ProductoPrecio producto;
  final int cantidad;

  const LineaProductoPrecio({
    required this.producto,
    required this.cantidad,
  });

  LineaProductoPrecio copyWith({int? cantidad}) {
    return LineaProductoPrecio(
      producto: producto,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}

class ConsultaProductoCantidad {
  final String texto;
  final int cantidad;

  const ConsultaProductoCantidad({
    required this.texto,
    required this.cantidad,
  });
}

const List<ProductoPrecio> productosConPrecio4Life = [
  ProductoPrecio(
      nombre: 'Aloe Vera Stix Tropical',
      afiliado: 40.04,
      publico: 53.39,
      lp: 22),
  ProductoPrecio(
      nombre: 'Transfer factor plus', afiliado: 83.17, publico: 110.98, lp: 55),
  ProductoPrecio(
      nombre: 'Transfer factor MAX', afiliado: 109.25, publico: 145.30, lp: 75),
  ProductoPrecio(
      nombre: 'Riovida Jugo', afiliado: 54.68, publico: 72.73, lp: 57),
  ProductoPrecio(
      nombre: 'Riovida stix', afiliado: 43.36, publico: 57.67, lp: 44),
  ProductoPrecio(
      nombre: 'Energy go stix', afiliado: 69.82, publico: 92.41, lp: 36),
  ProductoPrecio(nombre: 'Renuvo', afiliado: 69.82, publico: 92.41, lp: 42),
  ProductoPrecio(nombre: 'Glucoach', afiliado: 79.06, publico: 104.73, lp: 53),
  ProductoPrecio(nombre: 'Bcv', afiliado: 79.06, publico: 104.73, lp: 52),
  ProductoPrecio(nombre: 'Malepro', afiliado: 77.01, publico: 102.68, lp: 44),
  ProductoPrecio(
      nombre: 'Colageno tipo i', afiliado: 43.12, publico: 57.35, lp: 23),
  ProductoPrecio(
      nombre: 'Transfer factor tri factor',
      afiliado: 66.74,
      publico: 88.30,
      lp: 40),
  ProductoPrecio(nombre: 'Nutrastart', afiliado: 73.93, publico: 98.57, lp: 80),
  ProductoPrecio(
      nombre: 'Riovida burst', afiliado: 53.39, publico: 70.85, lp: 52),
  ProductoPrecio(nombre: 'Protf', afiliado: 90.36, publico: 120.13, lp: 100),
  ProductoPrecio(nombre: 'Bioefa', afiliado: 33.11, publico: 44.04, lp: 18),
  ProductoPrecio(nombre: 'Belle vie', afiliado: 67.77, publico: 90.36, lp: 43),
  ProductoPrecio(
      nombre: 'Glutamine prime', afiliado: 46.21, publico: 61.61, lp: 27),
  ProductoPrecio(nombre: 'Kbu', afiliado: 67.77, publico: 90.36, lp: 42),
  ProductoPrecio(nombre: 'Vistari', afiliado: 68.79, publico: 91.38, lp: 40),
  ProductoPrecio(
      nombre: 'Preo biotics', afiliado: 60.95, publico: 81.06, lp: 35),
  ProductoPrecio(nombre: 'Fibre', afiliado: 54.47, publico: 72.45, lp: 24),
  ProductoPrecio(nombre: 'Agpro', afiliado: 73.00, publico: 97.00, lp: 45),
  ProductoPrecio(nombre: 'Suero', afiliado: 50.31, publico: 66.74, lp: 29),
  ProductoPrecio(
      nombre: 'Crema para los ojos', afiliado: 45.00, publico: 60.00, lp: 27),
  ProductoPrecio(nombre: 'Tonico', afiliado: 36.00, publico: 48.00, lp: 19),
  ProductoPrecio(
      nombre: 'Crema humectante', afiliado: 36.96, publico: 49.29, lp: 19),
  ProductoPrecio(
      nombre: 'Pasta de dientes', afiliado: 16.43, publico: 21.56, lp: 15),
  ProductoPrecio(
      nombre: 'Crema cuerpo', afiliado: 25.67, publico: 33.88, lp: 18),
  ProductoPrecio(nombre: 'Recall', afiliado: 72.90, publico: 96.52, lp: 42),
  ProductoPrecio(nombre: 'TF Boost', afiliado: 27.72, publico: 36.96, lp: 15),
];

const Map<String, double> preciosPromocionalesMiTienda4Life = {
  'Agpro': 77.60,
  'Bcv': 83.78,
  'Belle vie': 72.28,
  'Bioefa': 35.23,
  'Colageno tipo i': 45.88,
  'Crema cuerpo': 27.10,
  'Energy go stix': 73.93,
  'Fibre': 57.96,
  'Glucoach': 83.78,
  'Glutamine prime': 49.28,
  'Kbu': 72.28,
  'Malepro': 82.15,
  'Nutrastart': 78.85,
  'Pasta de dientes': 17.25,
  'Preo biotics': 64.85,
  'Protf': 96.10,
  'Recall': 77.22,
  'Renuvo': 73.93,
  'Riovida burst': 56.68,
  'Riovida Jugo': 58.18,
  'Riovida stix': 46.14,
  'TF Boost': 29.57,
  'Transfer factor MAX': 116.24,
  'Transfer factor plus': 88.72,
  'Transfer factor tri factor': 70.65,
  'Vistari': 73.10,
  'Aloe Vera Stix Tropical': 42.72,
};

final List<ProductoPrecio> productosMiTienda4Life = productosConPrecio4Life
    .where(
      (producto) => preciosPromocionalesMiTienda4Life.containsKey(
        producto.nombre,
      ),
    )
    .toList();

double? precioPromocionalMiTienda(String nombre) {
  return preciosPromocionalesMiTienda4Life[nombre];
}

const Map<String, InformacionProductoCatalogo> informacionProductos4Life = {
  'Transfer factor tri factor': InformacionProductoCatalogo(
    descripcion:
        'Este producto es un suplemento disenado para respaldar el sistema inmunitario. Su formula combina la tecnologia de los factores de transferencia provenientes del calostro bovino y la yema de huevo, ayudando al cuerpo a reconocer, responder y recordar amenazas potenciales a la salud, promoviendo un equilibrio en el sistema de defensa natural.',
    componentes:
        '- Tri-Factor Formula, mezcla de calostro bovino y yema de huevo.\n- Otros ingredientes varian segun la presentacion en capsulas.',
    uso:
        'Se usa como apoyo diario para el bienestar inmunologico. Revisar la etiqueta oficial para la porcion exacta.',
    precauciones:
        'No usar como sustituto de una evaluacion medica. Consultar a un profesional de salud si existe embarazo, lactancia, alergias, medicacion o una condicion de salud.',
    dosis: 'Seguir la dosis indicada en la etiqueta oficial del producto.',
  ),
  'Transfer factor plus': InformacionProductoCatalogo(
    descripcion:
        'Suplemento orientado al apoyo inmunologico avanzado. Combina factores de transferencia con ingredientes vegetales y hongos funcionales para acompanar las defensas naturales del cuerpo.',
    componentes:
        '- Factores de transferencia de calostro bovino y yema de huevo.\n- Mezcla de hongos y botanicos segun etiqueta oficial.',
    uso:
        'Ideal para personas que buscan respaldo diario de bienestar inmunitario.',
    precauciones:
        'Consultar con un profesional si hay condiciones medicas, alergias, embarazo, lactancia o uso de medicamentos.',
    dosis: 'Seguir la indicacion de la etiqueta oficial vigente.',
  ),
  'Transfer factor MAX': InformacionProductoCatalogo(
    descripcion:
        'Suplemento de apoyo inmunologico avanzado con una formula mas concentrada dentro de la familia Transfer Factor. Esta orientado a personas que buscan un respaldo diario mas potente para la educacion, reconocimiento y memoria del sistema inmune.',
    componentes:
        '- Factores de transferencia de calostro bovino y yema de huevo.\n- Formula MAX con componentes de apoyo inmunologico segun etiqueta oficial vigente.',
    uso:
        'Puede usarse como apoyo de bienestar inmunitario avanzado dentro de una rutina responsable de descanso, nutricion e hidratacion.',
    precauciones:
        'Consultar con un profesional de salud si hay embarazo, lactancia, alergias al huevo o lacteos, medicacion inmunologica o una condicion medica diagnosticada.',
    dosis: 'Seguir la dosis indicada en la etiqueta oficial vigente.',
  ),
  'Aloe Vera Stix Tropical': InformacionProductoCatalogo(
    descripcion:
        'Bebida en polvo con gel de aloe vera para diluir, pensada para apoyar la hidratacion y el bienestar digestivo diario con sabor tropical.',
    componentes:
        '- Gel de aloe vera en polvo.\n- Edulcorante no calorico y componentes propios de la presentacion en sobres.',
    uso:
        'Diluir el sobre segun la etiqueta y consumir como bebida de bienestar.',
    precauciones:
        'Verificar tolerancia individual. Consultar a un profesional si existe embarazo, lactancia, medicacion o condicion digestiva.',
    dosis:
        'Seguir la preparacion y frecuencia indicadas en la etiqueta oficial.',
  ),
  'Agpro': InformacionProductoCatalogo(
    descripcion:
        'Suplemento de bienestar enfocado en hombres, usado como apoyo nutricional para la vitalidad, energia diaria y equilibrio general.',
    componentes:
        '- Formula especializada AG-Pro.\n- Componentes nutricionales segun etiqueta oficial.',
    uso:
        'Puede acompanarse con una rutina saludable de descanso, hidratacion y actividad fisica.',
    precauciones:
        'Consultar a un profesional si existen condiciones hormonales, uso de medicamentos o enfermedades previas.',
    dosis: 'Seguir la etiqueta oficial del producto.',
  ),
  'Bcv': InformacionProductoCatalogo(
    descripcion:
        'Suplemento orientado al bienestar cardiovascular y circulatorio, pensado para apoyar una rutina saludable del corazon.',
    componentes:
        '- Formula BCV de 4Life.\n- Factores de transferencia y componentes de soporte cardiovascular segun etiqueta.',
    uso:
        'Usar como complemento de bienestar junto con alimentacion equilibrada y seguimiento profesional cuando aplique.',
    precauciones:
        'Consultar si el cliente toma medicacion cardiovascular, anticoagulantes o tiene diagnosticos previos.',
    dosis: 'Seguir la dosis indicada en la etiqueta vigente.',
  ),
  'Belle vie': InformacionProductoCatalogo(
    descripcion:
        'Suplemento de bienestar femenino disenado para apoyar equilibrio, vitalidad y cuidado integral de la mujer.',
    componentes:
        '- Formula Belle Vie de 4Life.\n- Ingredientes especificos de bienestar femenino segun etiqueta.',
    uso: 'Acompanarlo con habitos saludables, hidratacion y descanso adecuado.',
    precauciones:
        'Consultar en embarazo, lactancia, condiciones hormonales o uso de medicamentos.',
    dosis: 'Seguir la etiqueta oficial.',
  ),
  'Bioefa': InformacionProductoCatalogo(
    descripcion:
        'Suplemento de acidos grasos esenciales que apoya nutricion celular, bienestar general y equilibrio de grasas saludables en la dieta.',
    componentes:
        '- Acidos grasos esenciales.\n- CLA y componentes grasos segun presentacion oficial.',
    uso: 'Usar como apoyo nutricional dentro de una alimentacion balanceada.',
    precauciones:
        'Consultar si hay alergias, uso de anticoagulantes o indicaciones medicas especiales.',
    dosis: 'Seguir la etiqueta oficial del producto.',
  ),
  'Colageno tipo i': InformacionProductoCatalogo(
    descripcion:
        'Suplemento enfocado en belleza y estructura corporal, usado para apoyar piel, cabello, unas, articulaciones y tejido conectivo.',
    componentes:
        '- Colageno tipo I.\n- Componentes de soporte segun etiqueta oficial.',
    uso:
        'Puede integrarse en rutinas de belleza, bienestar articular y cuidado diario.',
    precauciones:
        'Verificar alergias y consultar si existe condicion medica o embarazo.',
    dosis: 'Seguir la forma de preparacion indicada en la etiqueta.',
  ),
  'Crema cuerpo': InformacionProductoCatalogo(
    descripcion:
        'Producto de cuidado corporal para hidratar y suavizar la piel, ayudando a mantener una sensacion de humectacion diaria.',
    componentes:
        '- Ingredientes humectantes y emolientes segun etiqueta.\n- Formula cosmetica de uso externo.',
    uso: 'Aplicar sobre piel limpia con masaje suave.',
    precauciones:
        'Uso externo. Evitar contacto con ojos e interrumpir si aparece irritacion.',
    dosis: 'Aplicar segun necesidad y etiqueta del producto.',
  ),
  'Crema humectante': InformacionProductoCatalogo(
    descripcion:
        'Crema facial o corporal de hidratacion diaria para apoyar la suavidad, apariencia y confort de la piel.',
    componentes:
        '- Agentes humectantes.\n- Formula cosmetica segun presentacion oficial.',
    uso: 'Aplicar sobre la piel limpia como parte de la rutina de cuidado.',
    precauciones: 'Uso externo. Probar tolerancia y evitar zonas irritadas.',
    dosis: 'Aplicar segun la etiqueta y necesidad de la piel.',
  ),
  'Crema para los ojos': InformacionProductoCatalogo(
    descripcion:
        'Producto cosmetico para el contorno de ojos, orientado a hidratar y mejorar la apariencia de esta zona delicada.',
    componentes:
        '- Formula cosmetica para contorno de ojos.\n- Ingredientes especificos segun etiqueta.',
    uso:
        'Aplicar pequena cantidad alrededor del contorno de ojos evitando contacto directo con el ojo.',
    precauciones: 'Uso externo. Suspender si hay irritacion.',
    dosis: 'Usar segun indicacion del envase.',
  ),
  'Energy go stix': InformacionProductoCatalogo(
    descripcion:
        'Bebida en sobres para apoyar energia y enfoque durante el dia, practica para personas activas o con jornadas exigentes.',
    componentes:
        '- Formula Energy Go Stix.\n- Componentes energeticos y saborizantes segun etiqueta.',
    uso: 'Diluir segun la etiqueta y consumir como bebida de apoyo energetico.',
    precauciones:
        'Revisar tolerancia a estimulantes o componentes energeticos. Consultar si hay hipertension, embarazo o medicacion.',
    dosis: 'Seguir la preparacion del sobre indicada en la etiqueta.',
  ),
  'Fibre': InformacionProductoCatalogo(
    descripcion:
        'Suplemento de fibra orientado a apoyar digestion, regularidad y bienestar intestinal dentro de una alimentacion equilibrada.',
    componentes:
        '- Mezcla de fibra dietaria.\n- Presentacion en sobres segun etiqueta.',
    uso:
        'Consumir con suficiente agua y acompanado de buenos habitos alimenticios.',
    precauciones:
        'Aumentar fibra gradualmente si el cliente es sensible. Consultar ante condiciones digestivas.',
    dosis: 'Seguir la etiqueta oficial.',
  ),
  'Glucoach': InformacionProductoCatalogo(
    descripcion:
        'Suplemento dirigido al bienestar metabolico, usado como apoyo nutricional para personas que cuidan su equilibrio de glucosa dentro de habitos saludables.',
    componentes:
        '- Formula Glucoach.\n- Componentes de soporte metabolico segun etiqueta.',
    uso:
        'Acompanarlo con alimentacion balanceada, actividad fisica y seguimiento profesional cuando corresponda.',
    precauciones:
        'Consultar si el cliente usa medicamentos para glucosa o tiene diagnostico metabolico.',
    dosis: 'Seguir la etiqueta oficial vigente.',
  ),
  'Glutamine prime': InformacionProductoCatalogo(
    descripcion:
        'Suplemento de glutamina usado para apoyar recuperacion, bienestar digestivo y nutricion en personas activas.',
    componentes:
        '- L-glutamina o formula de glutamina segun etiqueta.\n- Componentes adicionales de la presentacion oficial.',
    uso:
        'Puede usarse como parte de una rutina de actividad fisica o bienestar digestivo.',
    precauciones:
        'Consultar si hay enfermedad renal, embarazo, lactancia o medicacion.',
    dosis: 'Seguir la etiqueta oficial.',
  ),
  'Kbu': InformacionProductoCatalogo(
    descripcion:
        'Producto de bienestar enfocado en belleza, hidratacion y cuidado corporal desde una rutina nutricional.',
    componentes:
        '- Formula KBU de 4Life.\n- Componentes de soporte de belleza segun etiqueta.',
    uso: 'Integrar como apoyo diario para cuidado de belleza y bienestar.',
    precauciones:
        'Verificar ingredientes y consultar si hay alergias, embarazo o condicion medica.',
    dosis: 'Seguir las instrucciones de la etiqueta oficial.',
  ),
  'Limpiador': InformacionProductoCatalogo(
    descripcion:
        'Producto cosmetico de limpieza para retirar impurezas y preparar la piel dentro de la rutina diaria.',
    componentes:
        '- Agentes limpiadores cosmeticos.\n- Formula segun presentacion oficial.',
    uso:
        'Aplicar sobre la piel segun indicacion del envase y enjuagar si corresponde.',
    precauciones:
        'Uso externo. Evitar contacto con ojos y suspender si irrita.',
    dosis: 'Usar segun etiqueta.',
  ),
  'Malepro': InformacionProductoCatalogo(
    descripcion:
        'Suplemento orientado al bienestar masculino, usado como apoyo nutricional para vitalidad, energia y equilibrio general.',
    componentes:
        '- Formula MalePro.\n- Ingredientes de soporte masculino segun etiqueta.',
    uso:
        'Puede acompanarse con ejercicio, descanso y alimentacion equilibrada.',
    precauciones:
        'Consultar ante condiciones prostaticas, hormonales, cardiovasculares o uso de medicamentos.',
    dosis: 'Seguir la etiqueta oficial.',
  ),
  'Nutrastart': InformacionProductoCatalogo(
    descripcion:
        'Suplemento nutricional diario pensado para apoyar energia, micronutrientes y bienestar general en la rutina.',
    componentes:
        '- Formula NutraStart.\n- Vitaminas, minerales o componentes nutricionales segun etiqueta.',
    uso:
        'Usar como complemento nutricional dentro de un plan de alimentacion saludable.',
    precauciones:
        'Revisar etiqueta si hay alergias, embarazo, lactancia o condiciones medicas.',
    dosis: 'Seguir la etiqueta oficial.',
  ),
  'Pasta de dientes': InformacionProductoCatalogo(
    descripcion:
        'Producto de higiene oral para limpieza dental diaria y apoyo al cuidado de dientes y encias.',
    componentes:
        '- Formula de higiene oral segun etiqueta.\n- Ingredientes de limpieza y frescura bucal.',
    uso: 'Cepillar los dientes segun rutina habitual.',
    precauciones:
        'No ingerir. Supervisar en ninos y evitar uso si hay sensibilidad a algun componente.',
    dosis: 'Usar segun indicacion del envase.',
  ),
  'Preo biotics': InformacionProductoCatalogo(
    descripcion:
        'Suplemento orientado al bienestar digestivo, usado para apoyar el equilibrio de la microbiota y la salud intestinal.',
    componentes:
        '- Prebioticos y/o componentes digestivos segun etiqueta oficial.',
    uso:
        'Integrar con hidratacion y alimentacion rica en fibra cuando sea apropiado.',
    precauciones:
        'Consultar si hay condiciones digestivas, embarazo, lactancia o medicacion.',
    dosis: 'Seguir la etiqueta oficial vigente.',
  ),
  'Protf': InformacionProductoCatalogo(
    descripcion:
        'Suplemento de proteina usado como apoyo nutricional para masa muscular, recuperacion y aporte de proteina diaria.',
    componentes:
        '- Proteina segun presentacion oficial.\n- Componentes nutricionales indicados en etiqueta.',
    uso:
        'Puede usarse en rutinas de actividad fisica o cuando se busca aumentar aporte proteico.',
    precauciones:
        'Consultar si hay enfermedad renal, alergias alimentarias o restricciones nutricionales.',
    dosis: 'Preparar y consumir segun etiqueta.',
  ),
  'Recall': InformacionProductoCatalogo(
    descripcion:
        'Suplemento orientado al bienestar cognitivo, usado como apoyo para memoria, enfoque y claridad mental.',
    componentes:
        '- Formula Recall.\n- Componentes de soporte cognitivo segun etiqueta.',
    uso:
        'Usar como complemento de habitos de descanso, hidratacion y actividad mental.',
    precauciones:
        'Consultar si se usan medicamentos neurologicos, estimulantes o hay condicion medica.',
    dosis: 'Seguir la etiqueta oficial.',
  ),
  'Renuvo': InformacionProductoCatalogo(
    descripcion:
        'Suplemento de bienestar y envejecimiento saludable, orientado a apoyar vitalidad, energia celular y equilibrio diario.',
    componentes:
        '- Formula Renuvo.\n- Componentes de soporte celular segun etiqueta.',
    uso:
        'Puede acompanarse con alimentacion saludable, descanso y actividad fisica regular.',
    precauciones:
        'Consultar si hay embarazo, lactancia, medicacion o condiciones de salud.',
    dosis: 'Seguir la indicacion oficial del producto.',
  ),
  'Riovida burst': InformacionProductoCatalogo(
    descripcion:
        'Bebida o suplemento en presentacion practica con enfoque antioxidante y nutricional para apoyar bienestar diario.',
    componentes:
        '- Formula RioVida Burst.\n- Mezcla de frutas, antioxidantes o componentes segun etiqueta.',
    uso: 'Consumir como complemento nutricional segun presentacion oficial.',
    precauciones:
        'Revisar ingredientes si hay sensibilidad a frutas, edulcorantes o componentes especificos.',
    dosis: 'Seguir la etiqueta oficial.',
  ),
  'Riovida Jugo': InformacionProductoCatalogo(
    descripcion:
        'Bebida nutricional RioVida en presentacion de jugo, enfocada en antioxidantes y fitonutrientes para apoyar el bienestar diario, la hidratacion y una rutina de nutricion celular.',
    componentes:
        '- Mezcla RioVida de frutas, antioxidantes y fitonutrientes segun etiqueta oficial.\n- Componentes propios de la presentacion liquida o jugo.',
    uso:
        'Consumir como bebida de bienestar diario de acuerdo con la etiqueta, especialmente cuando se busca una opcion antioxidante distinta a los stix o burst.',
    precauciones:
        'Revisar ingredientes si hay sensibilidad a frutas, edulcorantes o restricciones de azucar. Consultar ante embarazo, lactancia, medicacion o condicion medica.',
    dosis: 'Seguir la porcion y frecuencia indicadas en la etiqueta oficial.',
  ),
  'Riovida stix': InformacionProductoCatalogo(
    descripcion:
        'Bebida en sobres con enfoque antioxidante, practica para apoyar bienestar diario e hidratacion con sabor.',
    componentes:
        '- Formula RioVida Stix.\n- Mezcla de frutas y antioxidantes segun etiqueta.',
    uso: 'Diluir el sobre y consumir segun la etiqueta.',
    precauciones:
        'Verificar ingredientes si hay alergias, sensibilidad digestiva o restricciones alimentarias.',
    dosis: 'Seguir la preparacion indicada en la etiqueta.',
  ),
  'Suero': InformacionProductoCatalogo(
    descripcion:
        'Producto orientado a hidratacion y reposicion dentro de una rutina de bienestar, util para apoyo diario segun necesidad.',
    componentes:
        '- Formula tipo suero segun presentacion oficial.\n- Componentes de hidratacion indicados en etiqueta.',
    uso: 'Preparar o consumir segun la indicacion del envase.',
    precauciones:
        'Consultar si hay restricciones de sodio, condicion renal o indicacion medica especial.',
    dosis: 'Seguir la etiqueta oficial.',
  ),
  'TF Boost': InformacionProductoCatalogo(
    descripcion:
        'Suplemento practico de apoyo inmunologico y bienestar diario, pensado como complemento de la tecnologia de factores de transferencia.',
    componentes:
        '- Formula TF Boost.\n- Factores de transferencia o componentes de soporte segun etiqueta.',
    uso:
        'Usar como apoyo diario segun necesidades de bienestar y etiqueta oficial.',
    precauciones:
        'Consultar en embarazo, lactancia, alergias o condiciones medicas.',
    dosis: 'Seguir la etiqueta vigente.',
  ),
  'Tonico': InformacionProductoCatalogo(
    descripcion:
        'Producto cosmetico tipo tonico para complementar la limpieza y preparacion de la piel.',
    componentes:
        '- Formula cosmetica tonificante segun etiqueta.\n- Ingredientes de cuidado de piel.',
    uso:
        'Aplicar despues de limpiar la piel, evitando contacto directo con ojos.',
    precauciones: 'Uso externo. Suspender si hay irritacion.',
    dosis: 'Usar segun indicacion del envase.',
  ),
  'Vistari': InformacionProductoCatalogo(
    descripcion:
        'Suplemento orientado al bienestar visual y soporte antioxidante para personas que cuidan su salud ocular.',
    componentes:
        '- Formula Vistari.\n- Componentes de soporte visual y antioxidante segun etiqueta.',
    uso:
        'Usar como complemento de habitos saludables para la vista, descanso visual e hidratacion.',
    precauciones:
        'Consultar si hay diagnosticos oculares, medicacion o tratamiento oftalmologico.',
    dosis: 'Seguir la etiqueta oficial.',
  ),
};

InformacionProductoCatalogo informacionProductoCatalogo(String nombre) {
  return informacionProductos4Life[nombre] ??
      InformacionProductoCatalogo(
        descripcion:
            'Producto 4Life de bienestar disenado para complementar una rutina saludable segun la necesidad del cliente y la linea a la que pertenece.',
        componentes:
            '- Componentes propios de la formula oficial del producto.\n- Revisar la etiqueta vigente para ingredientes, porciones y presentacion exacta.',
        uso:
            'Usar como suplemento de bienestar de acuerdo con la etiqueta oficial y las necesidades generales del cliente.',
        precauciones:
            'Recomendar orientacion profesional si el cliente esta embarazada, en lactancia, toma medicamentos, tiene alergias o presenta una condicion medica.',
        dosis:
            'Seguir la etiqueta oficial. Si existe alguna duda, verificar el envase o material vigente antes de indicar una dosis.',
      );
}

final Map<String, PrecioProductoResultadoFicha> preciosResultado4Life = {
  for (final producto in productosConPrecio4Life)
    producto.nombre: PrecioProductoResultadoFicha(
      afiliado: producto.afiliado,
      publico: producto.publico,
      promocional: precioPromocionalMiTienda(producto.nombre),
      lp: producto.lp,
    ),
};

String normalizarTexto(String texto) {
  return texto
      .toLowerCase()
      .replaceAll(RegExp(r'[áàäâ]'), 'a')
      .replaceAll(RegExp(r'[éèëê]'), 'e')
      .replaceAll(RegExp(r'[íìïî]'), 'i')
      .replaceAll(RegExp(r'[óòöô]'), 'o')
      .replaceAll(RegExp(r'[úùüû]'), 'u')
      .replaceAll('ñ', 'n')
      .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String normalizarClaveProducto(String texto) {
  return normalizarTexto(texto).replaceAll(RegExp(r'\s+'), '');
}

String? productoPorReglaDiferenciadora(String consulta) {
  final normalizado = normalizarTexto(consulta);
  final clave = normalizarClaveProducto(consulta);
  if (normalizado.isEmpty) return null;

  for (final entry in _diferenciadoresProducto4Life.entries) {
    final coincide = entry.value.any((diferenciador) {
      final normalizadoDiferenciador = normalizarTexto(diferenciador);
      final claveDiferenciador = normalizarClaveProducto(diferenciador);
      return normalizado.contains(normalizadoDiferenciador) ||
          clave.contains(claveDiferenciador);
    });
    if (coincide) return entry.key;
  }

  return null;
}

int distanciaLevenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  var anterior = List<int>.generate(b.length + 1, (i) => i);
  for (var i = 0; i < a.length; i++) {
    final actual = List<int>.filled(b.length + 1, 0);
    actual[0] = i + 1;
    for (var j = 0; j < b.length; j++) {
      final costo = a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1;
      actual[j + 1] = [
        actual[j] + 1,
        anterior[j + 1] + 1,
        anterior[j] + costo,
      ].reduce((min, value) => value < min ? value : min);
    }
    anterior = actual;
  }
  return anterior.last;
}

int puntajeCoincidencia(String consulta, String producto) {
  final q = normalizarTexto(consulta);
  final p = normalizarTexto(producto);
  final qClave = normalizarClaveProducto(consulta);
  final pClave = normalizarClaveProducto(producto);
  if (q.isEmpty) return 0;
  if (q == p || qClave == pClave) return 100;
  if (p.contains(q) ||
      q.contains(p) ||
      pClave.contains(qClave) ||
      qClave.contains(pClave)) {
    return 85;
  }

  final palabras = q.split(' ').where((e) => e.isNotEmpty).toSet();
  final palabrasProducto = p.split(' ').where((e) => e.isNotEmpty).toSet();
  if (palabras.isEmpty) return 0;
  final coincidencias = palabras.intersection(palabrasProducto).length;
  final puntajePalabras = ((coincidencias / palabras.length) * 70).round();

  final maxLen = qClave.length > pClave.length ? qClave.length : pClave.length;
  if (maxLen == 0) return puntajePalabras;
  final distancia = distanciaLevenshtein(qClave, pClave);
  final similitud = (((maxLen - distancia) / maxLen) * 100).round();

  var mejorToken = 0;
  for (final palabraConsulta in palabras) {
    for (final palabraProducto in palabrasProducto) {
      final largo = palabraConsulta.length > palabraProducto.length
          ? palabraConsulta.length
          : palabraProducto.length;
      if (largo < 3) continue;
      final distanciaToken =
          distanciaLevenshtein(palabraConsulta, palabraProducto);
      final similitudToken = (((largo - distanciaToken) / largo) * 100).round();
      if (similitudToken > mejorToken) mejorToken = similitudToken;
    }
  }

  return [puntajePalabras, similitud, mejorToken].reduce(
    (max, value) => value > max ? value : max,
  );
}

ProductoPrecio? buscarProductoConPrecio(String consulta) {
  final productoDiferenciado = productoPorReglaDiferenciadora(consulta);
  if (productoDiferenciado != null) {
    for (final producto in productosConPrecio4Life) {
      if (producto.nombre == productoDiferenciado) return producto;
    }
  }

  ProductoPrecio? mejor;
  var mejorPuntaje = 0;
  for (final producto in productosConPrecio4Life) {
    final puntaje = puntajeCoincidencia(consulta, producto.nombre);
    if (puntaje > mejorPuntaje) {
      mejorPuntaje = puntaje;
      mejor = producto;
    }
  }
  return mejorPuntaje >= 45 ? mejor : null;
}

String? buscarProductoPermitido(String consulta) {
  final productoDiferenciado = productoPorReglaDiferenciadora(consulta);
  if (productoDiferenciado != null) return productoDiferenciado;

  String? mejor;
  var mejorPuntaje = 0;
  for (final producto in productosPermitidos4Life) {
    final puntaje = puntajeCoincidencia(consulta, producto);
    if (puntaje > mejorPuntaje) {
      mejorPuntaje = puntaje;
      mejor = producto;
    }
  }
  return mejorPuntaje >= 45 ? mejor : null;
}

String? productoDesdeTexto(String texto) {
  final normalizado = normalizarTexto(texto);
  final normalizadoClave = normalizarClaveProducto(texto);
  for (final producto in productosPermitidos4Life) {
    if (normalizado.contains(normalizarTexto(producto)) ||
        normalizadoClave.contains(normalizarClaveProducto(producto))) {
      return producto;
    }
  }
  return null;
}

List<String> dividirConsultaProductos(String texto) {
  return texto
      .split(RegExp(r'[,;\n]+'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

ConsultaProductoCantidad extraerConsultaConCantidad(String texto) {
  final limpio = texto.trim();
  final match = RegExp(r'^(\d+)\s*[xX]?\s+(.+)$').firstMatch(limpio);
  if (match == null) {
    return ConsultaProductoCantidad(texto: limpio, cantidad: 1);
  }

  final cantidad = int.tryParse(match.group(1) ?? '') ?? 1;
  final producto = (match.group(2) ?? limpio).trim();
  return ConsultaProductoCantidad(
    texto: producto,
    cantidad: cantidad.clamp(1, 999).toInt(),
  );
}
