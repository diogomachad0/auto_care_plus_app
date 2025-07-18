import 'package:auto_care_plus_app/app/modules/lembrete/lembrete_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_error.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdicionarLembreteWidget extends StatefulWidget {
  const AdicionarLembreteWidget({super.key});

  @override
  State<AdicionarLembreteWidget> createState() => _AdicionarLembreteWidgetState();
}

class _AdicionarLembreteWidgetState extends State<AdicionarLembreteWidget> with ThemeMixin {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  bool _notificar = false;
  bool _isLoading = false;

  final controller = Modular.get<LembreteController>();

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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adicionar um novo lembrete',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFieldCustom(
              label: 'Título do lembrete',
              controller: _tituloController,
            ),
            TextFieldCustom(
              label: 'Data',
              controller: _dataController,
              onTap: () => _selectDate(context),
            ),
            _buildNotificationToggle(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notificar lembrete?',
                  style: textTheme.bodyMedium,
                ),
                Text(
                  'Você receberá uma notificação às 12:00 da data agendada',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
              ],
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
            activeTrackColor: colorScheme.primary,
            inactiveThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () {
              Modular.to.pop();
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
            onPressed: _isLoading ? null : _salvarLembrete,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Text(
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

  Future<void> _salvarLembrete() async {
    if (_tituloController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, informe o título do lembrete')),
      );
      return;
    }

    if (_dataController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma data')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final parts = _dataController.text.split('/');
      if (parts.length != 3) {
        throw Exception('Formato de data inválido');
      }

      final data = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );

      final hoje = DateTime.now();
      final dataHoje = DateTime(hoje.year, hoje.month, hoje.day);

      if (data.isBefore(dataHoje)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A data do lembrete não pode ser no passado')),
        );
        return;
      }

      controller.updateLembrete(
        _tituloController.text.trim(),
        data,
        _notificar,
      );

      await controller.save();

      if (mounted) {
        Modular.to.pop(true);
      }
    } catch (e, s) {
      if (mounted) {
        await DialogError.show(
            context,
            'Erro ao salvar o lembrete: \nErro: ${e.toString()}',
            s
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

Future<bool?> showAdicionarLembreteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return const AdicionarLembreteWidget();
    },
  );
}
