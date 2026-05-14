import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // <--- PARA COPIAR (Clipboard)
import 'package:share_plus/share_plus.dart'; // <--- PARA COMPARTIR

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DoctorSuplementos());
}

class DoctorSuplementos extends StatelessWidget {
  const DoctorSuplementos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor de Suplementos',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5EE),
        primaryColor: const Color(0xFF1A237E),
      ),
      home: const PantallaPrincipal(),
    );
  }
}

// --- PANTALLA PRINCIPAL CON LOS 3 BOTONES ---
class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("4Life Asesor Integral"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.biotech, size: 80, color: Color(0xFF1A237E)),
              const SizedBox(height: 40),
              _botonMenu(context, "Consultar producto(s)", Icons.search, const ConsultaProductoPagina()),
              _botonMenu(context, "Diagnóstico", Icons.medication, const FormularioPaciente()),
              _botonMenu(context, "Historial", Icons.history, const HistorialPagina()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonMenu(BuildContext context, String titulo, IconData icono, Widget destino) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destino)),
        icon: Icon(icono, color: Colors.white),
        label: Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}

// --- GESTIÓN DE HISTORIAL LOCAL ---
class HistorialService {
  static final List<Map<String, dynamic>> registros = [];
  
  static void guardar(String titulo, String resultado, Map<String, String> datos) {
    registros.insert(0, {
      'fecha': DateTime.now().toString().substring(0, 16),
      'titulo': titulo,
      'resultado': resultado,
      'datos': datos,
    });
  }
}

// --- PANTALLA DE DIAGNÓSTICO (FORMULARIO) ---
class FormularioPaciente extends StatefulWidget {
  final Map<String, dynamic>? infoPrevia;
  const FormularioPaciente({super.key, this.infoPrevia});

  @override
  State<FormularioPaciente> createState() => _FormularioPacienteState();
}

class _FormularioPacienteState extends State<FormularioPaciente> {
  late TextEditingController nombreController;
  late TextEditingController edadController;
  late TextEditingController generoController;
  late TextEditingController historialController;
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.infoPrevia?['datos']?['nombre'] ?? "");
    edadController = TextEditingController(text: widget.infoPrevia?['datos']?['edad'] ?? "");
    generoController = TextEditingController(text: widget.infoPrevia?['datos']?['genero'] ?? "");
    historialController = TextEditingController();
  }

  Future<void> generarDiagnostico() async {
    if (historialController.text.isEmpty) return;
    setState(() => cargando = true);

    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: 'AIzaSyB3ea3TYD72dtfGyP9kSrjyot7RzMk0ZXk',
    );

    String contextoAnterior = widget.infoPrevia != null 
        ? "HISTORIAL PREVIO: El paciente anteriormente reportó: ${widget.infoPrevia!['datos']['sintomas']}. El resultado anterior fue: ${widget.infoPrevia!['resultado']}. "
        : "";

    final prompt = """
    $contextoAnterior
    SÍNTOMAS ACTUALES: ${historialController.text}
    DATOS: Nombre: ${nombreController.text}, Edad: ${edadController.text}.
    
    Actúa como Especialista 4Life. Entrega:
    1. Título breve.
    2. Hallazgos/Diagnóstico con explicación.
    3. Nivel de confianza (Alto/Medio/Bajo).
    4. Recomendaciones accionables (Dosis exactas, dieta, ejercicio). Hazlo que sea legible y fácil de seguir, como por ejemplo en una lista o tabla.
    5. Productos relacionados (de la lista permitida).
    
    PRODUCTOS PERMITIDOS: [TRANSFER FACTOR PLUS, RIOVIDA, ENERGY, RENUVO, GLUCOACH, BCV, MALEPRO, COLAGENO, TRI FACTOR, NUTRASTART, BIOEFA, BELLE VIE, GLUTAMINE, KBU, VISTARI, PREO BIOTICS, FIBRE, RECALL, IMMUNE BOOST].
    """;

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      String textoFinal = response.text ?? "Sin respuesta";
      
      HistorialService.guardar("Diagnóstico: ${nombreController.text}", textoFinal, {
        'nombre': nombreController.text,
        'edad': edadController.text,
        'genero': generoController.text,
        'sintomas': historialController.text,
      });

      _mostrarResultado(textoFinal);
    } catch (e) {
      _mostrarDialogoSimple("Error", "No se pudo conectar con la IA.");
    } finally {
      setState(() => cargando = false);
    }
  }

  void _mostrarResultado(String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Resultado del Diagnóstico"),
        content: SingleChildScrollView(child: Text(mensaje)),
        actions: [
          IconButton(icon: const Icon(Icons.copy), onPressed: () {
            Clipboard.setData(ClipboardData(text: mensaje));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copiado al portapapeles")));
          }),
          IconButton(icon: const Icon(Icons.share), onPressed: () => Share.share(mensaje)),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
        ],
      ),
    );
  }

  void _mostrarDialogoSimple(String t, String m) {
    showDialog(context: context, builder: (c) => AlertDialog(title: Text(t), content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Formulario de Diagnóstico")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildCampo("Nombre", nombreController, "Nombre..."),
            _buildCampo("Edad", edadController, "Edad..."),
            _buildCampo("Género", generoController, "Género..."),
            _buildCampo("Síntomas actuales", historialController, "Describa qué siente...", lineas: 4),
            const SizedBox(height: 20),
            cargando 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: generarDiagnostico,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), minimumSize: const Size(double.infinity, 55)),
                  child: const Text("GENERAR DIAGNÓSTICO", style: TextStyle(color: Colors.white)),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampo(String label, TextEditingController controller, String hint, {int lineas = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: lineas,
        decoration: InputDecoration(labelText: label, hintText: hint, border: const OutlineInputBorder()),
      ),
    );
  }
}

// --- PANTALLA: CONSULTA DE PRODUCTO ---
class ConsultaProductoPagina extends StatefulWidget {
  const ConsultaProductoPagina({super.key});

  @override
  State<ConsultaProductoPagina> createState() => _ConsultaProductoPaginaState();
}

class _ConsultaProductoPaginaState extends State<ConsultaProductoPagina> {
  final controller = TextEditingController();
  
  Future<void> consultar() async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: 'AIzaSyB3ea3TYD72dtfGyP9kSrjyot7RzMk0ZXk');
    final prompt = "Proporciona información completa (Descripción, ingredientes, indicaciones, contraindicaciones y dosis) del producto: ${controller.text}";
    final response = await model.generateContent([Content.text(prompt)]);
    
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text("Info: ${controller.text}"),
        content: SingleChildScrollView(child: Text(response.text ?? "")),
        actions: [
          IconButton(icon: const Icon(Icons.copy), onPressed: () => Clipboard.setData(ClipboardData(text: response.text ?? ""))),
          IconButton(icon: const Icon(Icons.share), onPressed: () => Share.share(response.text ?? "")),
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("Cerrar")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consultar Productos")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: controller, decoration: const InputDecoration(labelText: "Nombre del producto")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: consultar, child: const Text("Consultar")),
          ],
        ),
      ),
    );
  }
}

// --- PANTALLA: HISTORIAL ---
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
                  Navigator.push(context, MaterialPageRoute(
                    builder: (c) => FormularioPaciente(infoPrevia: item)
                  ));
                },
              );
            },
          ),
    );
  }
}