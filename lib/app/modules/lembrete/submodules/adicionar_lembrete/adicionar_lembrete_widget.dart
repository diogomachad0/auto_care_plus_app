import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';

class AdicionarLembreteWidget extends StatefulWidget {
  final Function(String titulo, String data, bool notificar)? onSave;

  const AdicionarLembreteWidget({
    Key? key,
    this.onSave,
  }) : super(key: key);

  @override
  State<AdicionarLembreteWidget> createState() => _AdicionarLembreteWidgetState();
}

class _AdicionarLembreteWidgetState extends State<AdicionarLembreteWidget> with ThemeMixin {
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
            const Text(
              'Adicionar um novo lembrete',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextFieldCustom(
              label: 'Título da tarefa',
              controller: _tituloController,
            ),
            const SizedBox(height: 16),
            TextFieldCustom(
              label: 'Data',
              controller: _dataController,
              readOnly: true,
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
        const Text(
          'Notificar lembretes?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Switch(
          value: _notificar,
          onChanged: (value) {
            setState(() {
              _notificar = value;
            });
          },
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFF0288D1), // Blue color for the track
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey[300],
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
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
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
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0288D1), // Blue color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Salvar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
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
              primary: const Color(0xFF0288D1), // Blue color
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

// Enhanced TextFieldCustom to support controller and onTap
class TextFieldCustom extends StatefulWidget{
  final String label;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;

  const TextFieldCustom({
    super.key,
    required this.label,
    this.controller,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> with ThemeMixin{
  @override
  Widget build(BuildContext context){
    return TextField(
      controller: widget.controller,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
      ),
    );
  }
}

// Example of how to show the dialog
void showAdicionarLembreteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AdicionarLembreteWidget(
        onSave: (titulo, data, notificar) {
          // Handle saving the reminder
          print('Título: $titulo, Data: $data, Notificar: $notificar');
        },
      );
    },
  );
}