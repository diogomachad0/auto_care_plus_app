import 'package:auto_care_plus_app/app/modules/atividade/atividade_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/widgets/mapbox/mapbox_place_search.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AtividadeScreen extends StatefulWidget {
  final String? atividadeId;

  const AtividadeScreen({super.key, this.atividadeId});

  @override
  State<AtividadeScreen> createState() => _AtividadeScreenState();
}

class _AtividadeScreenState extends State<AtividadeScreen> with ThemeMixin {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _kmAtualController = TextEditingController();
  final TextEditingController _totalPagoController = TextEditingController();
  final TextEditingController _litrosController = TextEditingController();
  final TextEditingController _estabelecimentoController = TextEditingController();
  final TextEditingController _numeroParcelaController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();

  final AtividadeController _controller = Modular.get<AtividadeController>();

  String selectedActivityType = 'Abastecimento';
  String selectedFuelType = 'Gasolina';
  String? selectedVeiculoId;

  final List<String> activityTypes = [
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

  final List<String> fuelTypes = [
    'Gasolina',
    'Etanol',
    'Diesel',
    'Flex',
    'Elétrico',
  ];

  @override
  void initState() {
    super.initState();

    _controller.loadVeiculos();

    if (widget.atividadeId != null) {
      _loadAtividade();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resetFormCompletely();
      });
    }
  }

  void _resetFormCompletely() {
    _dataController.clear();
    _kmAtualController.clear();
    _totalPagoController.clear();
    _litrosController.clear();
    _estabelecimentoController.clear();
    _numeroParcelaController.clear();
    _observacoesController.clear();

    setState(() {
      selectedActivityType = 'Abastecimento';
      selectedFuelType = 'Gasolina';
      selectedVeiculoId = null;
    });

    _controller.resetForm();
  }

  Future<void> _loadAtividade() async {
    await _controller.loadById(widget.atividadeId!);
    _updateControllers();
  }

  void _updateControllers() {
    final atividade = _controller.atividade;

    setState(() {
      selectedActivityType = atividade.tipoAtividade;
      selectedVeiculoId = atividade.veiculoId.isNotEmpty ? atividade.veiculoId : null;
      _dataController.text = atividade.data;
      _kmAtualController.text = atividade.km;
      _totalPagoController.text = atividade.totalPago;
      _litrosController.text = atividade.litros;
      selectedFuelType = atividade.tipoCombustivel.isNotEmpty ? atividade.tipoCombustivel : 'Gasolina';
      _estabelecimentoController.text = atividade.estabelecimento;
      _numeroParcelaController.text = atividade.numeroParcela;
      _observacoesController.text = atividade.observacoes;
    });
  }

  void _updateAtividadeStore() {
    _controller.atividade.tipoAtividade = selectedActivityType;
    _controller.atividade.veiculoId = selectedVeiculoId ?? '';
    _controller.atividade.data = _dataController.text;
    _controller.atividade.km = _kmAtualController.text;
    _controller.atividade.totalPago = _totalPagoController.text;
    _controller.atividade.litros = _litrosController.text;
    _controller.atividade.tipoCombustivel = selectedFuelType;
    _controller.atividade.estabelecimento = _estabelecimentoController.text;
    _controller.atividade.numeroParcela = _numeroParcelaController.text;
    _controller.atividade.observacoes = _observacoesController.text;
  }

  @override
  void dispose() {
    _dataController.dispose();
    _kmAtualController.dispose();
    _totalPagoController.dispose();
    _litrosController.dispose();
    _estabelecimentoController.dispose();
    _numeroParcelaController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          widget.atividadeId != null ? 'Editar atividade' : 'Nova atividade',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewPadding.bottom + 100,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 16),
                      _buildActivityTypeDropdown(),
                      const SizedBox(height: 16),
                      _buildForm(),
                      const SizedBox(height: 16),
                      _buildCadastrarButton(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Preencha os campos abaixo',
            style: textTheme.titleMedium?.copyWith(),
            textAlign: TextAlign.center,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Cadastre com base na sua informação',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTypeDropdown() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        width: 200,
        height: 46,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: Colors.grey.shade200,
            value: selectedActivityType,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
            ),
            style: textTheme.bodyMedium?.copyWith(),
            onChanged: (String? newValue) {
              setState(() {
                selectedActivityType = newValue!;
                _clearFieldsOnTypeChange();
              });
            },
            items: activityTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Icon(
                      _getActivityIcon(value),
                      color: value == selectedActivityType ? Colors.white : colorScheme.secondary,
                    ),
                    const SizedBox(width: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        textAlign: TextAlign.center,
                        value,
                        style: textTheme.bodyMedium?.copyWith(
                          color: value == selectedActivityType ? colorScheme.onPrimary : colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _clearFieldsOnTypeChange() {
    _kmAtualController.clear();
    _totalPagoController.clear();
    _litrosController.clear();
    _estabelecimentoController.clear();
    _numeroParcelaController.clear();

    _controller.atividade.km = '';
    _controller.atividade.totalPago = '';
    _controller.atividade.litros = '';
    _controller.atividade.estabelecimento = '';
    _controller.atividade.numeroParcela = '';
    _controller.atividade.latitude = '';
    _controller.atividade.longitude = '';

    _controller.atividade.tipoAtividade = selectedActivityType;

    setState(() {
      selectedFuelType = 'Gasolina';
    });
    _controller.atividade.tipoCombustivel = 'Gasolina';
  }

  IconData _getActivityIcon(String activityType) {
    switch (activityType) {
      case 'Abastecimento':
        return Icons.local_gas_station_rounded;
      case 'Troca de óleo':
        return Icons.build_circle_rounded;
      case 'Lavagem':
        return Icons.local_car_wash_rounded;
      case 'Seguro':
        return Icons.security_rounded;
      case 'Serviço mecânico':
        return Icons.build_circle_rounded;
      case 'Financiamento':
        return Icons.attach_money_rounded;
      case 'Compras':
        return Icons.shopping_cart_rounded;
      case 'Impostos':
        return Icons.receipt_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }

  Widget _buildForm() {
    return Column(
      children: [
        TextFieldCustom(
          label: 'Data',
          controller: _dataController,
          onTap: () => _selectDate(context),
          onChanged: (value) {
            _controller.atividade.data = value;
          },
        ),
        _buildVeiculoDropdown(),
        const SizedBox(height: 16),
        ..._buildSpecificFields(),
        _buildObservationsField(),
      ],
    );
  }

  Widget _buildVeiculoDropdown() {
    return Observer(
      builder: (_) {
        final veiculos = _controller.veiculos;

        if (veiculos.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange[800]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Nenhum veículo cadastrado. Cadastre um veículo primeiro.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.orange[800],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedVeiculoId,
            decoration: InputDecoration(
              labelText: 'Selecione o veículo',
              labelStyle: textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            items: veiculos.map((veiculo) {
              return DropdownMenuItem<String>(
                value: veiculo.base.id,
                child: Text('${veiculo.marca} ${veiculo.modelo} (${veiculo.placa})'),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedVeiculoId = newValue;
                _controller.atividade.veiculoId = newValue ?? '';
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildEstabelecimentoField() {
    return MapboxPlaceSearch(
      controller: _estabelecimentoController,
      label: 'Estabelecimento',
      onPlaceSelected: (address, lat, lng) {
        _controller.setEstabelecimentoComCoordenadas(address, lat, lng);
        print('Endereço selecionado: $address');
        print('Coordenadas: $lat, $lng');
      },
      onChanged: (value) {
        _controller.atividade.estabelecimento = value;
      },
    );
  }

  List<Widget> _buildSpecificFields() {
    List<Widget> fields = [];

    switch (selectedActivityType) {
      case 'Abastecimento':
        fields.addAll([
          Row(
            children: [
              Expanded(
                child: TextFieldCustom(
                  label: 'Km',
                  controller: _kmAtualController,
                  onChanged: (value) {
                    _controller.atividade.km = value;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldCustom(
                  label: 'Total pago',
                  controller: _totalPagoController,
                  onChanged: (value) {
                    _controller.atividade.totalPago = value;
                  },
                ),
              ),
            ],
          ),
          TextFieldCustom(
            label: 'Litros',
            controller: _litrosController,
            onChanged: (value) {
              _controller.atividade.litros = value;
            },
          ),
          _buildFuelTypeDropdown(),
          const SizedBox(height: 16),
          _buildEstabelecimentoField(),
          const SizedBox(height: 16),
        ]);
        break;

      case 'Troca de óleo':
        fields.addAll([
          Row(
            children: [
              Expanded(
                child: TextFieldCustom(
                  label: 'Km',
                  controller: _kmAtualController,
                  onChanged: (value) {
                    _controller.atividade.km = value;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldCustom(
                  label: 'Total pago',
                  controller: _totalPagoController,
                  onChanged: (value) {
                    _controller.atividade.totalPago = value;
                  },
                ),
              ),
            ],
          ),
          _buildEstabelecimentoField(),
        ]);
        break;

      case 'Lavagem':
        fields.addAll([
          TextFieldCustom(
            label: 'Total pago',
            controller: _totalPagoController,
            onChanged: (value) {
              _controller.atividade.totalPago = value;
            },
          ),
          _buildEstabelecimentoField(),
        ]);
        break;

      case 'Seguro':
        fields.addAll([
          TextFieldCustom(
            label: 'Total pago',
            controller: _totalPagoController,
            onChanged: (value) {
              _controller.atividade.totalPago = value;
            },
          ),
        ]);
        break;

      case 'Serviço mecânico':
        fields.addAll([
          TextFieldCustom(
            label: 'Total pago',
            controller: _totalPagoController,
            onChanged: (value) {
              _controller.atividade.totalPago = value;
            },
          ),
          _buildEstabelecimentoField(),
        ]);
        break;

      case 'Financiamento':
        fields.addAll([
          Row(
            children: [
              Expanded(
                child: TextFieldCustom(
                  label: 'Total pago',
                  controller: _totalPagoController,
                  onChanged: (value) {
                    _controller.atividade.totalPago = value;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldCustom(
                  label: 'Número da parcela',
                  controller: _numeroParcelaController,
                  onChanged: (value) {
                    _controller.atividade.numeroParcela = value;
                  },
                ),
              ),
            ],
          ),
        ]);
        break;

      case 'Compras':
        fields.addAll([
          TextFieldCustom(
            label: 'Total pago',
            controller: _totalPagoController,
            onChanged: (value) {
              _controller.atividade.totalPago = value;
            },
          ),
        ]);
        break;

      case 'Impostos':
        fields.addAll([
          TextFieldCustom(
            label: 'Total pago',
            controller: _totalPagoController,
            onChanged: (value) {
              _controller.atividade.totalPago = value;
            },
          ),
        ]);
        break;

      case 'Outros':
        fields.addAll([
          TextFieldCustom(
            label: 'Total pago',
            controller: _totalPagoController,
            onChanged: (value) {
              _controller.atividade.totalPago = value;
            },
          ),
          _buildEstabelecimentoField(),
        ]);
        break;
    }

    return fields;
  }

  Widget _buildFuelTypeDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedFuelType,
        decoration: InputDecoration(
          labelText: 'Tipo de combustível',
          labelStyle: textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        items: fuelTypes.map((String fuelType) {
          return DropdownMenuItem<String>(
            value: fuelType,
            child: Text(fuelType),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedFuelType = newValue!;
            _controller.atividade.tipoCombustivel = newValue;
          });
        },
      ),
    );
  }

  Widget _buildObservationsField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _observacoesController,
        maxLines: 4,
        onChanged: (value) {
          _controller.atividade.observacoes = value;
        },
        decoration: InputDecoration(
          labelText: 'Observações',
          labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _buildCadastrarButton() {
    return Observer(builder: (_) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 46),
            backgroundColor: _controller.isFormValid ? colorScheme.primary : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _controller.isFormValid ? () => _saveAtividade(context) : null,
          child: Text(
            'Cadastrar',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      );
    });
  }

  Future<void> _saveAtividade(BuildContext context) async {
    try {
      _updateAtividadeStore();
      await _controller.save();
      _resetFormCompletely();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Atividade salva com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
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
        _controller.atividade.data = _dataController.text;
      });
    }
  }
}
