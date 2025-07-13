import 'dart:ui';

import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class FiltroData {
  final String? tipoAtividade;
  final DateTime? dataInicio;
  final DateTime? dataFim;

  FiltroData({
    this.tipoAtividade,
    this.dataInicio,
    this.dataFim,
  });

  bool get hasFilters => tipoAtividade != null || dataInicio != null || dataFim != null;
}

class FiltroWidget extends StatefulWidget {
  final Function(FiltroData filtro)? onSave;
  final FiltroData? filtroAtual;

  const FiltroWidget({
    super.key,
    this.onSave,
    this.filtroAtual,
  });

  @override
  State<FiltroWidget> createState() => _FiltroWidgetState();
}

class _FiltroWidgetState extends State<FiltroWidget> with ThemeMixin {
  final TextEditingController _dataInicioController = TextEditingController();
  final TextEditingController _dataFimController = TextEditingController();

  String? _tipoAtividadeSelecionado;
  DateTime? _dataInicio;
  DateTime? _dataFim;

  final List<String> _tiposAtividade = [
    'Abastecimento',
    'Troca de óleo',
    'Lavagem',
    'Seguro',
    'Serviço mecânico',
    'Financiamento',
    'Compras',
    'Impostos',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.filtroAtual != null) {
      _tipoAtividadeSelecionado = widget.filtroAtual!.tipoAtividade;
      _dataInicio = widget.filtroAtual!.dataInicio;
      _dataFim = widget.filtroAtual!.dataFim;

      if (_dataInicio != null) {
        _dataInicioController.text = _formatDate(_dataInicio!);
      }
      if (_dataFim != null) {
        _dataFimController.text = _formatDate(_dataFim!);
      }
    }
  }

  @override
  void dispose() {
    _dataInicioController.dispose();
    _dataFimController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Dialog(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtrar Atividades',
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTipoAtividadeDropdown(),
              const SizedBox(height: 16),
              Text(
                'Período',
                style: textTheme.bodyMedium?.copyWith(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: 'Data início',
                      controller: _dataInicioController,
                      onTap: () => _selectDate(context, true),
                      onClear: _dataInicio != null
                          ? () {
                              setState(() {
                                _dataInicio = null;
                                _dataInicioController.clear();
                              });
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateField(
                      label: 'Data fim',
                      controller: _dataFimController,
                      onTap: () => _selectDate(context, false),
                      onClear: _dataFim != null
                          ? () {
                              setState(() {
                                _dataFim = null;
                                _dataFimController.clear();
                              });
                            }
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.text.isEmpty ? 'Selecionar' : controller.text,
                    style: textTheme.bodyMedium?.copyWith(
                      color: controller.text.isEmpty ? Colors.grey[500] : Colors.black87,
                    ),
                  ),
                ),
                if (onClear != null)
                  GestureDetector(
                    onTap: onClear,
                    child: Icon(
                      Icons.clear,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  )
                else
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Colors.grey[600],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipoAtividadeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Atividade',
          style: textTheme.bodyMedium?.copyWith(),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField2<String?>(
            isExpanded: true,
            value: _tipoAtividadeSelecionado,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.only(right: 6),
            ),
            hint: Text(
              'Selecione o tipo de atividade',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
            buttonStyleData: const ButtonStyleData(
              height: 46,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              maxHeight: 300,
            ),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(
                  'Todos os tipos',
                  style: textTheme.bodyMedium?.copyWith(),
                ),
              ),
              ..._tiposAtividade.map((tipo) {
                return DropdownMenuItem<String?>(
                  value: tipo,
                  child: Row(
                    children: [
                      Icon(
                        _getIconForAtividade(tipo),
                        size: 20,
                        color: _tipoAtividadeSelecionado == tipo ? colorScheme.primary : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tipo,
                        style: textTheme.bodyMedium?.copyWith(
                          color: _tipoAtividadeSelecionado == tipo ? colorScheme.primary : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            onChanged: (String? newValue) {
              setState(() {
                _tipoAtividadeSelecionado = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  IconData _getIconForAtividade(String tipoAtividade) {
    switch (tipoAtividade) {
      case 'Abastecimento':
        return Icons.local_gas_station;
      case 'Troca de óleo':
        return Icons.build_circle;
      case 'Lavagem':
        return Icons.local_car_wash;
      case 'Seguro':
        return Icons.security;
      case 'Serviço mecânico':
        return Icons.build;
      case 'Financiamento':
        return Icons.attach_money;
      case 'Compras':
        return Icons.shopping_cart;
      case 'Impostos':
        return Icons.receipt;
      case 'Outros':
        return Icons.more_horiz;
      default:
        return Icons.event;
    }
  }

  bool _hasActiveFilters() {
    return _tipoAtividadeSelecionado != null || _dataInicio != null || _dataFim != null;
  }

  void _clearFilters() {
    setState(() {
      _tipoAtividadeSelecionado = null;
      _dataInicio = null;
      _dataFim = null;
      _dataInicioController.clear();
      _dataFimController.clear();
    });
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
                final filtro = FiltroData(
                  tipoAtividade: _tipoAtividadeSelecionado,
                  dataInicio: _dataInicio,
                  dataFim: _dataFim,
                );
                widget.onSave!(filtro);
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Aplicar Filtro',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_dataInicio ?? DateTime.now()) : (_dataFim ?? DateTime.now()),
      firstDate: DateTime(2020),
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
        if (isStartDate) {
          _dataInicio = picked;
          _dataInicioController.text = _formatDate(picked);
          if (_dataFim != null && _dataFim!.isBefore(picked)) {
            _dataFim = null;
            _dataFimController.clear();
          }
        } else {
          _dataFim = picked;
          _dataFimController.text = _formatDate(picked);
        }
      });
    }
  }
}

void showFiltroWidget(
  BuildContext context, {
  Function(FiltroData)? onSave,
  FiltroData? filtroAtual,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FiltroWidget(
        onSave: onSave,
        filtroAtual: filtroAtual,
      );
    },
  );
}
