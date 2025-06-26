import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';

class ConfirmarBottomSheet extends StatefulWidget {
  final String titulo;
  final String mensagem;
  final String textoCancelar;
  final String textoConfirmar;
  final VoidCallback? onConfirmar;

  const ConfirmarBottomSheet({
    super.key,
    required this.titulo,
    required this.mensagem,
    this.textoCancelar = 'Cancelar',
    required this.textoConfirmar,
    this.onConfirmar,
  });

  static Future<bool> show({
    required BuildContext context,
    required String titulo,
    required String mensagem,
    String textoCancelar = 'Cancelar',
    required String textoConfirmar,
    VoidCallback? onConfirmar,
  }) async {
    return (await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return ConfirmarBottomSheet(
          titulo: titulo,
          mensagem: mensagem,
          textoCancelar: textoCancelar,
          textoConfirmar: textoConfirmar,
          onConfirmar: onConfirmar,
        );
      },
    )) ??
        false;
  }

  @override
  State<ConfirmarBottomSheet> createState() => _ConfirmarBottomSheetState();
}

class _ConfirmarBottomSheetState extends State<ConfirmarBottomSheet>
    with ThemeMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: colorScheme.secondary,
                size: 42,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.titulo,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.mensagem,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: BorderSide(
                      color: colorScheme.secondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    widget.textoCancelar,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32.0),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (widget.onConfirmar != null) {
                      widget.onConfirmar!();
                    }
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Confirmar',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
