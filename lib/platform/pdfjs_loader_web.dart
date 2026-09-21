import 'dart:js_interop';

@JS('prepararPdfJs')
external JSPromise<JSAny?> _prepararPdfJsWeb();

Future<void> prepararPdfJs() async {
  await _prepararPdfJsWeb().toDart;
}
