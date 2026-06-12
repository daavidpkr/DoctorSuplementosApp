part of '../main.dart';

class PantallaPrincipalVieja extends StatelessWidget {
  const PantallaPrincipalVieja({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DoctorSuplementos"),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.biotech, size: 80, color: Color(0xFF1A237E)),
                const SizedBox(height: 40),
                _botonMenu(context, "Consultar producto(s)", Icons.search,
                    const ConsultaProductoPagina()),
                _botonMenu(context, "Consultora y calculadora", Icons.calculate,
                    const PaginaCalculadoraPrecios()),
                _botonMenu(context, "Diagnóstico", Icons.medication,
                    const FormularioPaciente()),
                _botonMenu(context, "Historial", Icons.history,
                    const PaginaHistorial()),
                _botonMenu(context, "Asesor IA 4Life", Icons.chat,
                    const PaginaChatbot()),
                _botonMenu(context, "Historial de chats", Icons.forum,
                    const PaginaHistorialChatbot()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonMenu(
      BuildContext context, String titulo, IconData icono, Widget destino) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => destino)),
        icon: Icon(icono, color: Colors.white),
        label: Text(titulo,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          minimumSize: const Size(double.infinity, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}

// --- GESTIÓN DE HISTORIAL LOCAL ---
