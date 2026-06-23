import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'cloudinary_service.dart';

class SeccionDocumento {
  final String titulo;
  final String contenido;

  const SeccionDocumento({
    required this.titulo,
    required this.contenido,
  });
}

class ProductoDocumento {
  final String nombre;
  final String? imagenAsset;
  final List<String> indicaciones;
  final String detalle;
  final double? precioAfiliado;
  final int cantidad;
  final int? puntosLP;

  const ProductoDocumento({
    required this.nombre,
    this.imagenAsset,
    this.indicaciones = const [],
    this.detalle = '',
    this.precioAfiliado,
    this.cantidad = 1,
    this.puntosLP,
  });
}

class ProductoOrdenCompra {
  final String nombre;
  final double precioAfiliado;
  final int cantidad;
  final int puntosLP;

  const ProductoOrdenCompra({
    required this.nombre,
    required this.precioAfiliado,
    required this.cantidad,
    required this.puntosLP,
  });
}

class DocumentoCompartible {
  final String titulo;
  final String nombreArchivo;
  final String texto;
  final String? paciente;
  final DateTime fecha;
  final List<SeccionDocumento> secciones;
  final List<ProductoDocumento> productos;
  final String nota;
  final bool adjuntarImagenEnTexto;
  final String? numeroWhatsAppCompra;

  const DocumentoCompartible({
    required this.titulo,
    required this.nombreArchivo,
    required this.texto,
    required this.fecha,
    this.paciente,
    this.secciones = const [],
    this.productos = const [],
    this.nota = '',
    this.adjuntarImagenEnTexto = false,
    this.numeroWhatsAppCompra,
  });
}

String generarLinkWhatsApp(
  List<ProductoOrdenCompra> productos, {
  required String numeroWhatsApp,
}) {
  final numero = _normalizarNumeroWhatsAppEcuador(numeroWhatsApp);
  if (numero.isEmpty || productos.isEmpty) return '';

  final buffer = StringBuffer()
    ..writeln('Hola! Quiero concluir con mi compra de estos productos:')
    ..writeln();
  var totalPagar = 0.0;
  var totalLp = 0;

  for (final producto in productos) {
    final cantidad = producto.cantidad <= 0 ? 1 : producto.cantidad;
    final subtotal = producto.precioAfiliado * cantidad;
    final lpProducto = producto.puntosLP * cantidad;
    totalPagar += subtotal;
    totalLp += lpProducto;

    buffer
      ..writeln('*${cantidad}x ${producto.nombre}*')
      ..writeln('- Precio Afiliado: \$${subtotal.toStringAsFixed(2)}')
      ..writeln('- Puntos LP: $lpProducto')
      ..writeln();
  }

  buffer
    ..writeln('-----------------------------')
    ..writeln('*TOTAL A PAGAR:* \$${totalPagar.toStringAsFixed(2)}')
    ..writeln('*TOTAL LP:* $totalLp')
    ..writeln()
    ..write('Quedo a la espera de las instrucciones.');

  final mensajeCodificado = Uri.encodeComponent(buffer.toString());
  return 'https://wa.me/$numero?text=$mensajeCodificado';
}

String _normalizarNumeroWhatsAppEcuador(String valor) {
  var numero = valor.replaceAll(RegExp(r'\D'), '');
  if (numero.startsWith('593')) {
    numero = numero.substring(3);
  }
  while (numero.startsWith('0')) {
    numero = numero.substring(1);
  }
  if (numero.length != 9) return '';
  return '593$numero';
}

class _OpcionCompartirDocumento {
  final String tipo;
  final DocumentoCompartible documento;

  const _OpcionCompartirDocumento({
    required this.tipo,
    required this.documento,
  });
}

class ServicioCompartir {
  static const _azul = PdfColor.fromInt(0xFF12248B);
  static const _azulOscuro = PdfColor.fromInt(0xFF0A175E);
  static const _violeta = PdfColor.fromInt(0xFF4B48D8);
  static const _verde = PdfColor.fromInt(0xFF118B48);
  static const _texto = PdfColor.fromInt(0xFF20294F);
  static const _gris = PdfColor.fromInt(0xFF66708F);
  static const _borde = PdfColor.fromInt(0xFFE2E5F0);
  static const _fondo = PdfColor.fromInt(0xFFF6F7FC);

  static Future<void> mostrarOpciones(
    BuildContext context,
    DocumentoCompartible documento, {
    DocumentoCompartible? documentoInformativo,
    bool ingles = false,
    bool permitirTexto = true,
    bool permitirQrPdf = false,
  }) async {
    final tieneInformativo = documentoInformativo != null;
    final opcion = await showModalBottomSheet<_OpcionCompartirDocumento>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8DCEB),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                ingles
                    ? 'How do you want to share?'
                    : '¿Cómo deseas compartir?',
                style: const TextStyle(
                  color: Color(0xFF12248B),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                tieneInformativo
                    ? (ingles
                        ? 'Choose with prices or informational only.'
                        : 'Elige con precios o solo informativo.')
                    : (ingles
                        ? (permitirQrPdf
                            ? 'Choose a PDF or QR code.'
                            : 'Choose a PDF or a text message.')
                        : (permitirQrPdf
                            ? 'Elige un PDF o comparte por QR.'
                            : 'Elige un PDF o un mensaje de texto.')),
                style: const TextStyle(
                  color: Color(0xFF596284),
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              _opcion(
                context: sheetContext,
                valor: _OpcionCompartirDocumento(
                  tipo: 'pdf',
                  documento: documento,
                ),
                icono: Icons.picture_as_pdf_rounded,
                titulo: tieneInformativo
                    ? (ingles ? 'PDF with prices' : 'PDF con precios')
                    : 'PDF',
                descripcion: ingles
                    ? 'Professional, organized document with images.'
                    : 'Documento profesional, ordenado y con imágenes.',
                color: const Color(0xFFC62828),
              ),
              const SizedBox(height: 10),
              if (tieneInformativo) ...[
                _opcion(
                  context: sheetContext,
                  valor: _OpcionCompartirDocumento(
                    tipo: 'pdf',
                    documento: documentoInformativo,
                  ),
                  icono: Icons.picture_as_pdf_rounded,
                  titulo: ingles ? 'Informational PDF' : 'PDF informativo',
                  descripcion: ingles
                      ? 'Document without prices or doses.'
                      : 'Documento sin precios ni dosis.',
                  color: const Color(0xFF4B48D8),
                ),
                const SizedBox(height: 10),
              ],
              if (permitirQrPdf) ...[
                _opcion(
                  context: sheetContext,
                  valor: _OpcionCompartirDocumento(
                    tipo: 'qr',
                    documento: documento,
                  ),
                  icono: Icons.qr_code_2_rounded,
                  titulo: tieneInformativo
                      ? (ingles ? 'Complete QR' : 'QR completo')
                      : (ingles ? 'Share by QR' : 'Compartir por QR'),
                  descripcion: ingles
                      ? 'Upload the PDF and show a scannable code.'
                      : 'Sube el PDF y muestra un codigo escaneable.',
                  color: const Color(0xFF118B48),
                ),
                const SizedBox(height: 10),
              ] else if (permitirTexto) ...[
                _opcion(
                  context: sheetContext,
                  valor: _OpcionCompartirDocumento(
                    tipo: 'texto',
                    documento: documento,
                  ),
                  icono: Icons.chat_bubble_outline_rounded,
                  titulo: tieneInformativo
                      ? (ingles ? 'Text with prices' : 'Texto con precios')
                      : (ingles ? 'Text' : 'Texto'),
                  descripcion: ingles
                      ? 'Content ready to send by WhatsApp.'
                      : 'Contenido listo para enviar por WhatsApp.',
                  color: const Color(0xFF118B48),
                ),
              ],
              if (tieneInformativo && permitirQrPdf) ...[
                _opcion(
                  context: sheetContext,
                  valor: _OpcionCompartirDocumento(
                    tipo: 'qr',
                    documento: documentoInformativo,
                  ),
                  icono: Icons.qr_code_2_rounded,
                  titulo: ingles ? 'Informational QR' : 'QR informativo',
                  descripcion: ingles
                      ? 'Upload the informational PDF and show its QR.'
                      : 'Sube el PDF informativo y muestra su QR.',
                  color: const Color(0xFF008C7E),
                ),
              ] else if (tieneInformativo && permitirTexto) ...[
                const SizedBox(height: 10),
                _opcion(
                  context: sheetContext,
                  valor: _OpcionCompartirDocumento(
                    tipo: 'texto',
                    documento: documentoInformativo,
                  ),
                  icono: Icons.chat_bubble_outline_rounded,
                  titulo: ingles ? 'Informational text' : 'Texto informativo',
                  descripcion: ingles
                      ? 'Message without prices or doses.'
                      : 'Mensaje sin precios ni dosis.',
                  color: const Color(0xFF008C7E),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (opcion == null || !context.mounted) return;
    final documentoElegido = opcion.documento;
    if (opcion.tipo == 'texto') {
      await _compartirTexto(documentoElegido);
      return;
    }

    _mostrarProcesando(
      context,
      ingles: ingles,
      mensaje: opcion.tipo == 'qr'
          ? (ingles ? 'Preparing QR...' : 'Preparando QR...')
          : null,
    );
    try {
      final bytes = await generarPdf(documentoElegido);
      if (!context.mounted) return;
      final nombre = '${_nombreArchivoPdf(documentoElegido.nombreArchivo)}.pdf';
      if (opcion.tipo == 'qr') {
        final archivoPdf = await _guardarPdfTemporal(bytes, nombre);
        final url = await CloudinaryService().uploadPdf(archivoPdf);
        try {
          await archivoPdf.delete();
        } catch (_) {}
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        if (url == null) {
          _mostrarErrorQr(context, ingles: ingles);
          return;
        }
        await _mostrarQrPdf(
          context,
          url: url,
          titulo: documentoElegido.titulo,
          ingles: ingles,
        );
        return;
      }

      Navigator.of(context, rootNavigator: true).pop();
      await Share.shareXFiles(
        [
          XFile.fromData(
            bytes,
            name: nombre,
            mimeType: 'application/pdf',
          ),
        ],
        subject: documentoElegido.titulo,
        text: documentoElegido.titulo,
      );
    } catch (error) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ingles
                ? 'The PDF could not be generated. Try again.'
                : 'No se pudo generar el PDF. Inténtalo nuevamente.',
          ),
        ),
      );
    }
  }

  static Widget _opcion({
    required BuildContext context,
    required _OpcionCompartirDocumento valor,
    required IconData icono,
    required String titulo,
    required String descripcion,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.pop(context, valor),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icono, color: color, size: 29),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: Color(0xFF17204B),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    descripcion,
                    style: const TextStyle(
                      color: Color(0xFF66708F),
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF66708F),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _compartirTexto(DocumentoCompartible documento) async {
    if (!documento.adjuntarImagenEnTexto) {
      await Share.share(documento.texto, subject: documento.titulo);
      return;
    }

    final imagenAsset = documento.productos
        .map((producto) => producto.imagenAsset)
        .whereType<String>()
        .where((ruta) => ruta.trim().isNotEmpty)
        .cast<String?>()
        .firstWhere((ruta) => ruta != null, orElse: () => null);

    if (imagenAsset == null) {
      await Share.share(documento.texto, subject: documento.titulo);
      return;
    }

    try {
      final data = await rootBundle.load(imagenAsset);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await Share.shareXFiles(
        [
          XFile.fromData(
            bytes,
            name:
                '${_nombreArchivoPdf(documento.nombreArchivo)}.${_extensionImagen(imagenAsset)}',
            mimeType: _mimeImagen(imagenAsset),
          ),
        ],
        subject: documento.titulo,
        text: documento.texto,
      );
    } catch (_) {
      await Share.share(documento.texto, subject: documento.titulo);
    }
  }

  static void _mostrarProcesando(
    BuildContext context, {
    required bool ingles,
    String? mensaje,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                const SizedBox(width: 16),
                Text(
                  mensaje ??
                      (ingles ? 'Preparing PDF...' : 'Preparando PDF...'),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<File> _guardarPdfTemporal(
    Uint8List bytes,
    String nombre,
  ) async {
    final directorio = await getTemporaryDirectory();
    final archivo = File('${directorio.path}/$nombre');
    return archivo.writeAsBytes(bytes, flush: true);
  }

  static Future<void> _mostrarQrPdf(
    BuildContext context, {
    required String url,
    required String titulo,
    required bool ingles,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          ingles ? 'PDF QR code' : 'QR del PDF',
          style: const TextStyle(
            color: Color(0xFF12248B),
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: url,
              version: QrVersions.auto,
              size: 230,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF17204B),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            SelectableText(
              url,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF66708F),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ingles ? 'Link copied.' : 'Link copiado.',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded),
            label: Text(ingles ? 'Copy link' : 'Copiar link'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(ingles ? 'Close' : 'Cerrar'),
          ),
        ],
      ),
    );
  }

  static void _mostrarErrorQr(BuildContext context, {required bool ingles}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ingles
              ? 'The QR could not be generated. Try again.'
              : 'No se pudo generar el QR. Intentalo nuevamente.',
        ),
      ),
    );
  }

  static Future<Uint8List> generarPdf(
    DocumentoCompartible documento,
  ) async {
    final fuenteData = await rootBundle.load('assets/fonts/NotoSans.ttf');
    final fuente = pw.Font.ttf(fuenteData);
    final pdf = pw.Document(
      title: documento.titulo,
      author: 'DoctorSuplementos',
      creator: 'DoctorSuplementos',
    );
    final logo = await _cargarImagen('assets/icon.webp');
    final imagenes = <String, pw.MemoryImage?>{};
    for (final producto in documento.productos) {
      final ruta = producto.imagenAsset;
      if (ruta != null && !imagenes.containsKey(ruta)) {
        imagenes[ruta] = await _cargarImagen(ruta);
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(34, 30, 34, 34),
        theme: pw.ThemeData.withFont(
          base: fuente,
          bold: fuente,
          italic: fuente,
        ),
        header: (context) => context.pageNumber == 1
            ? pw.SizedBox()
            : pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 10),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: _borde, width: 0.8),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      documento.titulo,
                      style: pw.TextStyle(
                        color: _azul,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'DoctorSuplementos',
                      style: const pw.TextStyle(color: _gris, fontSize: 8),
                    ),
                  ],
                ),
              ),
        footer: (context) => pw.Container(
          padding: const pw.EdgeInsets.only(top: 10),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: _borde, width: 0.8),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Documento informativo de bienestar',
                style: const pw.TextStyle(color: _gris, fontSize: 8),
              ),
              pw.Text(
                'Página ${context.pageNumber} de ${context.pagesCount}',
                style: const pw.TextStyle(color: _gris, fontSize: 8),
              ),
            ],
          ),
        ),
        build: (_) => [
          _encabezadoPdf(documento, logo),
          pw.SizedBox(height: 18),
          for (final seccion in documento.secciones) ...[
            _seccionPdf(seccion),
            pw.SizedBox(height: 12),
          ],
          if (documento.productos.isNotEmpty) ...[
            _tituloBloque('PRODUCTOS RECOMENDADOS', _violeta),
            pw.SizedBox(height: 10),
            for (var i = 0; i < documento.productos.length; i++) ...[
              _productoPdf(
                documento.productos[i],
                i + 1,
                documento.productos[i].imagenAsset == null
                    ? null
                    : imagenes[documento.productos[i].imagenAsset],
              ),
              pw.SizedBox(height: 10),
            ],
            if (_linkOrdenCompra(documento).isNotEmpty) ...[
              pw.SizedBox(height: 2),
              _enlaceOrdenCompraPdf(_linkOrdenCompra(documento)),
              pw.SizedBox(height: 10),
            ],
          ],
          if (documento.nota.trim().isNotEmpty) ...[
            pw.SizedBox(height: 4),
            _notaPdf(documento.nota),
          ],
        ],
      ),
    );
    return pdf.save();
  }

  static pw.Widget _encabezadoPdf(
    DocumentoCompartible documento,
    pw.MemoryImage? logo,
  ) {
    final paciente = documento.paciente?.trim() ?? '';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(18),
          decoration: pw.BoxDecoration(
            gradient: const pw.LinearGradient(
              colors: [_azul, _azulOscuro],
            ),
            borderRadius: pw.BorderRadius.circular(16),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (logo != null)
                pw.Container(
                  width: 66,
                  height: 66,
                  padding: const pw.EdgeInsets.all(5),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.white,
                    shape: pw.BoxShape.circle,
                  ),
                  child: pw.Image(logo, fit: pw.BoxFit.contain),
                ),
              if (logo != null) pw.SizedBox(width: 15),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      _textoPdf(documento.titulo).toUpperCase(),
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 19,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Informe profesional de bienestar',
                      style: const pw.TextStyle(
                        color: PdfColor.fromInt(0xFFDDE3FF),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: pw.BoxDecoration(
            color: _fondo,
            borderRadius: pw.BorderRadius.circular(12),
            border: pw.Border.all(color: _borde),
          ),
          child: pw.Row(
            children: [
              if (paciente.isNotEmpty) ...[
                pw.Expanded(
                  child: _datoCabecera('PACIENTE', _textoPdf(paciente)),
                ),
                pw.Container(width: 1, height: 30, color: _borde),
                pw.SizedBox(width: 16),
              ],
              pw.Expanded(
                child: _datoCabecera(
                  'FECHA',
                  '${documento.fecha.day.toString().padLeft(2, '0')}/'
                      '${documento.fecha.month.toString().padLeft(2, '0')}/'
                      '${documento.fecha.year}',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _datoCabecera(String etiqueta, String valor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          etiqueta,
          style: pw.TextStyle(
            color: _violeta,
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          valor,
          style: pw.TextStyle(
            color: _texto,
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _seccionPdf(SeccionDocumento seccion) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: _borde),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _tituloBloque(_textoPdf(seccion.titulo).toUpperCase(), _azul),
          pw.SizedBox(height: 8),
          pw.Text(
            _textoPdf(seccion.contenido),
            style: const pw.TextStyle(
              color: _texto,
              fontSize: 10.5,
              lineSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _tituloBloque(String titulo, PdfColor color) {
    return pw.Row(
      children: [
        pw.Container(
          width: 4,
          height: 18,
          decoration: pw.BoxDecoration(
            color: color,
            borderRadius: pw.BorderRadius.circular(2),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Text(
            titulo,
            style: pw.TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _productoPdf(
    ProductoDocumento producto,
    int indice,
    pw.MemoryImage? imagen,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: _borde),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 104,
            height: 112,
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: _fondo,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: imagen == null
                ? pw.Center(
                    child: pw.Text(
                      '$indice',
                      style: pw.TextStyle(
                        color: _violeta,
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  )
                : pw.Image(imagen, fit: pw.BoxFit.contain),
          ),
          pw.SizedBox(width: 14),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '$indice. ${_textoPdf(producto.nombre)}',
                  style: pw.TextStyle(
                    color: _azul,
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (producto.indicaciones.isNotEmpty) pw.SizedBox(height: 8),
                for (final indicacion in producto.indicaciones)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          margin: const pw.EdgeInsets.only(top: 4),
                          width: 5,
                          height: 5,
                          decoration: const pw.BoxDecoration(
                            color: _verde,
                            shape: pw.BoxShape.circle,
                          ),
                        ),
                        pw.SizedBox(width: 7),
                        pw.Expanded(
                          child: pw.Text(
                            _textoPdf(indicacion),
                            style: const pw.TextStyle(
                              color: _texto,
                              fontSize: 9.5,
                              lineSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (producto.detalle.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 5),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: const PdfColor.fromInt(0xFFF0F8F3),
                      borderRadius: pw.BorderRadius.circular(7),
                    ),
                    child: pw.Text(
                      _textoPdf(producto.detalle),
                      style: const pw.TextStyle(
                        color: _texto,
                        fontSize: 9,
                        lineSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _linkOrdenCompra(DocumentoCompartible documento) {
    final numero = documento.numeroWhatsAppCompra?.trim() ?? '';
    if (numero.isEmpty) return '';
    final productosOrden = documento.productos
        .where((producto) => producto.precioAfiliado != null)
        .map(
          (producto) => ProductoOrdenCompra(
            nombre: producto.nombre,
            precioAfiliado: producto.precioAfiliado!,
            cantidad: producto.cantidad,
            puntosLP: producto.puntosLP ?? 0,
          ),
        )
        .toList();
    return generarLinkWhatsApp(productosOrden, numeroWhatsApp: numero);
  }

  static pw.Widget _enlaceOrdenCompraPdf(String url) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF8F9FD),
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _borde, width: 0.9),
      ),
      child: pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.UrlLink(
          destination: url,
          child: pw.Text(
            'Concluye tu compra aquí',
            style: pw.TextStyle(
              color: _azulOscuro,
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              decoration: pw.TextDecoration.underline,
              decorationColor: _azulOscuro,
            ),
          ),
        ),
      ),
    );
  }

  static pw.Widget _notaPdf(String nota) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFFFF8E8),
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(
          color: const PdfColor.fromInt(0xFFF1D999),
        ),
      ),
      child: pw.Text(
        _textoPdf(nota),
        style: const pw.TextStyle(
          color: _texto,
          fontSize: 8.8,
          lineSpacing: 2,
        ),
      ),
    );
  }

  static Future<pw.MemoryImage?> _cargarImagen(String asset) async {
    try {
      final data = await rootBundle.load(asset);
      return pw.MemoryImage(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    } catch (_) {
      return null;
    }
  }

  static String _textoPdf(String texto) {
    return texto
        .replaceAll(RegExp(r'[*#_`]'), '')
        .replaceAll('•', '-')
        .replaceAll(RegExp(r'[^\x09\x0A\x0D\x20-\xFF]'), '')
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .trim();
  }

  static String _nombreArchivoPdf(String texto) {
    final respaldo = _archivoSeguro(texto);
    final limpio = _textoPdf(texto)
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return limpio.isEmpty ? respaldo.toUpperCase() : limpio;
  }

  static String _extensionImagen(String ruta) {
    final extension = ruta.split('.').last.toLowerCase();
    if (extension == 'jpg' || extension == 'jpeg' || extension == 'webp') {
      return extension;
    }
    return 'png';
  }

  static String _mimeImagen(String ruta) {
    switch (_extensionImagen(ruta)) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/png';
    }
  }

  static String _archivoSeguro(String texto) {
    final limpio = _textoPdf(texto)
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9áéíóúüñ ]'), '')
        .replaceAll(RegExp(r'\s+'), '_');
    return limpio.isEmpty ? 'documento_doctorsuplementos' : limpio;
  }
}
