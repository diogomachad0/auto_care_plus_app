import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FiltroWidget extends StatefulWidget {
  final Function(String titulo, String data)? onSave;

  const FiltroWidget({super.key, this.onSave});

  @override
  State<FiltroWidget> createState() => _FiltroWidgetState();
}

class _FiltroWidgetState extends State<FiltroWidget> with ThemeMixin {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtrar',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            TextFieldCustom(
              label: 'Tipo da despesa',
              controller: _tituloController,
            ),
            const SizedBox(height: 16),
            TextFieldCustom(
              label: 'Data',
              controller: _dataController,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 24),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[400]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Cancelar',
              style: textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (widget.onSave != null) {
                widget.onSave!(
                  _tituloController.text,
                  _dataController.text,
                );
              }
              Modular.to.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Salvar',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dataController.text = "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }
}

void showFiltroWidget(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FiltroWidget(
        onSave: (titulo, data) {
          print('Título: $titulo, Data: $data');
        },
      );
    },
  );
}
