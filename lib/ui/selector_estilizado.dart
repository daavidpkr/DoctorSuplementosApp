part of '../main.dart';

class OpcionSelectorEstilizado<T> {
  final T valor;
  final String texto;
  final IconData? icono;
  final String? emoji;

  const OpcionSelectorEstilizado({
    required this.valor,
    required this.texto,
    this.icono,
    this.emoji,
  });
}

class SelectorEstilizado<T> extends StatelessWidget {
  final T? valor;
  final String placeholder;
  final IconData icono;
  final List<OpcionSelectorEstilizado<T>> opciones;
  final ValueChanged<T> onChanged;
  final double alto;
  final bool soloIcono;

  const SelectorEstilizado({
    super.key,
    required this.valor,
    required this.placeholder,
    required this.icono,
    required this.opciones,
    required this.onChanged,
    this.alto = 64,
    this.soloIcono = false,
  });

  @override
  Widget build(BuildContext context) {
    final seleccion = opciones.cast<OpcionSelectorEstilizado<T>?>().firstWhere(
          (opcion) => opcion?.valor == valor,
          orElse: () => null,
        );

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final elegido = await showModalBottomSheet<T>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => _PanelSelectorEstilizado<T>(
            opciones: opciones,
            valor: valor,
            placeholder: placeholder,
          ),
        );
        if (elegido != null) onChanged(elegido);
      },
      child: Container(
        height: alto,
        padding: EdgeInsets.symmetric(horizontal: soloIcono ? 10 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE1E4F0), width: 1.4),
        ),
        child: Row(
          mainAxisAlignment:
              soloIcono ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            _IconoSelectorEstilizado(
              icono: seleccion?.icono ?? icono,
              emoji: seleccion?.emoji,
            ),
            if (!soloIcono) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  seleccion?.texto ?? placeholder,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: seleccion == null
                        ? const Color(0xFF6B7192)
                        : const Color(0xFF18215E),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF2839C7),
                size: 28,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PanelSelectorEstilizado<T> extends StatelessWidget {
  final List<OpcionSelectorEstilizado<T>> opciones;
  final T? valor;
  final String placeholder;

  const _PanelSelectorEstilizado({
    required this.opciones,
    required this.valor,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF07125E).withValues(alpha: 0.18),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8DCEB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              placeholder,
              style: const TextStyle(
                color: Color(0xFF12248B),
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final opcion in opciones)
                      _OpcionSelectorEstilizado<T>(
                        opcion: opcion,
                        seleccionada: opcion.valor == valor,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcionSelectorEstilizado<T> extends StatelessWidget {
  final OpcionSelectorEstilizado<T> opcion;
  final bool seleccionada;

  const _OpcionSelectorEstilizado({
    required this.opcion,
    required this.seleccionada,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pop(context, opcion.valor),
        child: Container(
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: seleccionada ? const Color(0xFFEFF2FF) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: seleccionada
                  ? const Color(0xFF4059EA)
                  : const Color(0xFFE1E4F0),
              width: seleccionada ? 1.8 : 1.2,
            ),
          ),
          child: Row(
            children: [
              _IconoSelectorEstilizado(
                icono: opcion.icono ?? Icons.check_rounded,
                emoji: opcion.emoji,
                activo: seleccionada,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  opcion.texto,
                  style: const TextStyle(
                    color: Color(0xFF18215E),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (seleccionada)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF172394),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconoSelectorEstilizado extends StatelessWidget {
  final IconData icono;
  final String? emoji;
  final bool activo;

  const _IconoSelectorEstilizado({
    required this.icono,
    this.emoji,
    this.activo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: activo ? const Color(0xFFF0F2FF) : const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: emoji == null
          ? Icon(
              icono,
              color:
                  activo ? const Color(0xFF172394) : const Color(0xFF8F96B4),
              size: 22,
            )
          : Center(
              child: Text(
                emoji!,
                style: const TextStyle(fontSize: 22, height: 1),
              ),
            ),
    );
  }
}
