import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdicionarLembreteWidget extends StatefulWidget {
  final Function(String titulo, String data, bool notificar)? onSave;

  const AdicionarLembreteWidget({super.key, this.onSave});

  @override
  State<AdicionarLembreteWidget> createState() =>
      _AdicionarLembreteWidgetState();
}

class _AdicionarLembreteWidgetState extends State<AdicionarLembreteWidget>
    with ThemeMixin {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  bool _notificar = false;

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
              'Adicionar um novo lembrete',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            TextFieldCustom(
              label: 'Título do lembrete',
              controller: _tituloController,
            ),
            const SizedBox(height: 16),
            TextFieldCustom(
              label: 'Data',
              controller: _dataController,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 24),
            _buildNotificationToggle(),
            const SizedBox(height: 24),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Notificar lembretes?',
          style: textTheme.bodyMedium,
        ),
        Switch(
          value: _notificar,
          onChanged: (value) {
            setState(() {
              _notificar = value;
            });
          },
          activeColor: Colors.white,
          activeTrackColor: colorScheme.primary,
          inactiveThumbColor: Colors.white,
        ),
      ],
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
                  _notificar,
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

void showAdicionarLembreteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AdicionarLembreteWidget(
        onSave: (titulo, data, notificar) {
          print('Título: $titulo, Data: $data, Notificar: $notificar');
        },
      );
    },
  );
}
