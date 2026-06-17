part of '../main.dart';

const List<String> productosPermitidos4Life = [
  'Agpro',
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
  'Riovida stix',
  'Suero',
  'TF Boost',
  'Tonico',
  'Transfer factor plus',
  'Transfer factor tri factor',
  'Vistari',
];

const double escalaTextoInterfaces = 0.90;

final String catalogoPermitido4Life = productosPermitidos4Life.join(', ');

const List<String> productosCambioFisico4Life = [
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
  'Transfer factor plus': ['plus'],
  'Transfer factor tri factor': ['tri factor', 'trifactor'],
  'Riovida burst': ['riovida burst', 'burst'],
  'Riovida stix': ['riovida stix', 'riovida'],
  'Energy go stix': ['energy go', 'energy', 'go stix'],
};

const Map<String, String> imagenesProducto4Life = {
  'Transfer factor plus': 'assets/productos/trasnfer_factor_plus.png',
  'Riovida stix': 'assets/productos/riovida_stix.png',
  'Energy go stix': 'assets/productos/energy_go_stix.png',
  'Renuvo': 'assets/productos/renuvo.png',
  'Glucoach': 'assets/productos/glucoach.png',
  'Bcv': 'assets/productos/bcv.png',
  'Malepro': 'assets/productos/malepro.png',
  'Colageno tipo i': 'assets/productos/colageno_tipo_i.png',
  'Transfer factor tri factor':
      'assets/productos/transfer_factor_tri_factor.png',
  'Nutrastart': 'assets/productos/nutrastart.png',
  'Riovida burst': 'assets/productos/riovida_burst.png',
  'Protf': 'assets/productos/protf.png',
  'Bioefa': 'assets/productos/bioefa.png',
  'Belle vie': 'assets/productos/belle_vie.png',
  'Glutamine prime': 'assets/productos/glutamine_prime.png',
  'Kbu': 'assets/productos/kbu.png',
  'Vistari': 'assets/productos/vistari.png',
  'Preo biotics': 'assets/productos/preo_biotics.png',
  'Fibre': 'assets/productos/fibre.png',
  'Agpro': 'assets/productos/agpro.png',
  'Suero': 'assets/productos/suero.png',
  'Crema para los ojos': 'assets/productos/crema_para_los_ojos.png',
  'Tonico': 'assets/productos/tonico.png',
  'Crema humectante': 'assets/productos/crema_humectante.png',
  'Pasta de dientes': 'assets/productos/pasta_de_dientes.png',
  'Crema cuerpo': 'assets/productos/crema_de_cuerpo.png',
  'Limpiador': 'assets/productos/limpiador.png',
  'Recall': 'assets/productos/recall.png',
  'TF Boost': 'assets/productos/tf_boost.png',
};

class ProductoPrecio {
  final String nombre;
  final double afiliado;
  final double publico;
  final int? lp;

  const ProductoPrecio({
    required this.nombre,
    required this.afiliado,
    required this.publico,
    required this.lp,
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
      nombre: 'Transfer factor plus', afiliado: 83.17, publico: 110.98, lp: 55),
  ProductoPrecio(
      nombre: 'Riovida stix', afiliado: 43.36, publico: 57.67, lp: 20),
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
  ProductoPrecio(nombre: 'Nutrastart', afiliado: 73.93, publico: 98.57, lp: 30),
  ProductoPrecio(
      nombre: 'Riovida burst', afiliado: 53.39, publico: 70.85, lp: 27),
  ProductoPrecio(nombre: 'Protf', afiliado: 90.36, publico: 120.13, lp: 26),
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
      nombre: 'Pasta de dientes', afiliado: 16.43, publico: 21.56, lp: 5),
  ProductoPrecio(
      nombre: 'Crema cuerpo', afiliado: 25.67, publico: 33.88, lp: 8),
  ProductoPrecio(nombre: 'Recall', afiliado: 72.90, publico: 96.52, lp: 42),
  ProductoPrecio(nombre: 'TF Boost', afiliado: 27.72, publico: 36.96, lp: 15),
];

final Map<String, PrecioProductoResultadoFicha> preciosResultado4Life = {
  for (final producto in productosConPrecio4Life)
    producto.nombre: PrecioProductoResultadoFicha(
      afiliado: producto.afiliado,
      publico: producto.publico,
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
