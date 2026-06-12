part of '../main.dart';

class PaginaPerfil extends StatefulWidget {
  final VoidCallback? onPerfilGuardado;

  const PaginaPerfil({super.key, this.onPerfilGuardado});

  @override
  State<PaginaPerfil> createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> {
  final TextEditingController _nombreController = TextEditingController();
  String _fotoBase64 = '';
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    final perfil = await PerfilService.cargar();
    if (!mounted) return;
    setState(() {
      _nombreController.text = perfil.nombre;
      _fotoBase64 = perfil.fotoBase64;
      _cargando = false;
    });
  }

  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    final imagen = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 700,
      imageQuality: 70,
    );
    if (imagen == null) return;

    final bytes = await imagen.readAsBytes();
    setState(() {
      _fotoBase64 = base64Encode(bytes);
    });
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    final perfil = PerfilAsesor(
      nombre: _nombreController.text,
      fotoBase64: _fotoBase64,
    );
    await PerfilService.guardar(perfil);
    widget.onPerfilGuardado?.call();
    if (!mounted) return;
    setState(() => _guardando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil guardado")),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fotoBytes = _fotoBase64.isEmpty ? null : base64Decode(_fotoBase64);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Stack(
        children: [
          Container(
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF172B98), Color(0xFF07125E)],
              ),
            ),
          ),
          SafeArea(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF172394),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                    child: Column(
                      children: [
                        _encabezadoPerfil(),
                        const SizedBox(height: 44),
                        _tarjetaFotoPerfil(fotoBytes),
                        const SizedBox(height: 22),
                        _tarjetaInformacionAsesor(),
                        const SizedBox(height: 28),
                        _botonGuardarPerfil(),
                        const SizedBox(height: 28),
                        _tarjetaSeguridadPerfil(),
                        const SizedBox(height: 18),
                        _copyrightPerfil(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _encabezadoPerfil() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          iconSize: 34,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Perfil del asesor",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Gestiona tu informacion personal",
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
      ],
    );
  }

  Widget _tarjetaFotoPerfil(Uint8List? fotoBytes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 30, 28, 30),
      decoration: _decoracionTarjetaPerfil(),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 72,
                backgroundColor: const Color(0xFFE7EAFF),
                backgroundImage:
                    fotoBytes == null ? null : MemoryImage(fotoBytes),
                child: fotoBytes == null
                    ? ClipOval(
                        child: Image.asset(
                          'assets/icon.png',
                          width: 144,
                          height: 144,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person_rounded,
                            color: Color(0xFF172394),
                            size: 86,
                          ),
                        ),
                      )
                    : null,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(36),
                onTap: _seleccionarFoto,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4059EA), Color(0xFF172394)],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Icon(
                    Icons.photo_camera_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 34),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Foto de perfil",
                  style: TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Agrega una foto para personalizar tu perfil y que otros te reconozcan facilmente.",
                  style: TextStyle(
                    color: Color(0xFF3F4A82),
                    fontSize: 18,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 26),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _seleccionarFoto,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF1FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.photo_camera_rounded,
                            color: Color(0xFF4059EA), size: 28),
                        SizedBox(width: 14),
                        Text(
                          "Cambiar foto",
                          style: TextStyle(
                            color: Color(0xFF3150D9),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaInformacionAsesor() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
      decoration: _decoracionTarjetaPerfil(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informacion del asesor",
            style: TextStyle(
              color: Color(0xFF12248B),
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Nombre del asesor",
            style: TextStyle(
              color: Color(0xFF2F3A78),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nombreController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Ingresa tu nombre completo",
              hintStyle: const TextStyle(
                color: Color(0xFF6B7192),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF5B628C),
                size: 30,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFFC8CDE0), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF4059EA), width: 1.8),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Este nombre sera visible para tus clientes y en tus reportes.",
            style: TextStyle(
              color: Color(0xFF2F3A78),
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonGuardarPerfil() {
    return InkWell(
      borderRadius: BorderRadius.circular(36),
      onTap: _guardando ? null : _guardar,
      child: Container(
        height: 76,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF172394), Color(0xFF0B176B)],
          ),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B176B).withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: _guardando
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save_rounded, color: Colors.white, size: 30),
                    SizedBox(width: 18),
                    Text(
                      "Guardar perfil",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _tarjetaSeguridadPerfil() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF0FF), Color(0xFFF5F7FF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFE1E6FF),
            child: Icon(
              Icons.health_and_safety_outlined,
              color: Color(0xFF172394),
              size: 42,
            ),
          ),
          SizedBox(width: 26),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tu informacion esta segura",
                  style: TextStyle(
                    color: Color(0xFF12248B),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  "Tus datos personales estan protegidos y solo se utilizaran dentro de la aplicacion.",
                  style: TextStyle(
                    color: Color(0xFF17246B),
                    fontSize: 18,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _copyrightPerfil() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E4F0)),
      ),
      child: const Text(
        "Copyright © 2026 Josué David Girón Castro. All Rights Reserved.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF5B628C),
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  BoxDecoration _decoracionTarjetaPerfil() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF0B176B).withValues(alpha: 0.08),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}
