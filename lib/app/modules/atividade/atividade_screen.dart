import 'package:auto_care_plus_app/app/modules/atividade/atividade_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/widgets/mapbox/mapbox_place_search.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$ ',
    decimalDigits: 2,
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String numericString = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (numericString.isEmpty) {
      return newValue.copyWith(text: '');
    }

    double value = double.parse(numericString) / 100;

    if (value > 999999.99) {
      value = 999999.99;
    }

    String formattedValue = _formatter.format(value);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class KmInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String numericString = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (numericString.isEmpty) {
      return newValue.copyWith(text: '');
    }

    int value = int.tryParse(numericString) ?? 0;

    if (value > 999999) {
      value = 999999;
    }

    String formattedValue = NumberFormat('#,###', 'pt_BR').format(value);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class LitrosInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d,.]'), '');

    if (cleanText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String normalizedText = cleanText.replaceAll(',', '.');

    double? value = double.tryParse(normalizedText);

    if (value == null) {
      return oldValue;
    }

    if (value > 500) {
      value = 500;
    }

    String formattedValue;
    if (value == value.toInt()) {
      formattedValue = value.toInt().toString();
    } else {
      formattedValue = value.toStringAsFixed(2).replaceAll('.', ',');
      formattedValue = formattedValue.replaceAll(RegExp(r',?0+$'), '');
    }

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class PrecoLitroInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$ ',
    decimalDigits: 3,
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String numericString = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (numericString.isEmpty) {
      return newValue.copyWith(text: '');
    }

    double value = double.parse(numericString) / 1000;

    if (value > 99.999) {
      value = 99.999;
    }

    String formattedValue = _formatter.format(value);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class ParcelaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String numericString = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (numericString.isEmpty) {
      return newValue.copyWith(text: '');
    }

    int value = int.tryParse(numericString) ?? 0;

    if (value > 120) {
      value = 120;
    }

    return TextEditingValue(
      text: value.toString(),
      selection: TextSelection.collapsed(offset: value.toString().length),
    );
  }
}

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
  final TextEditingController _precoLitroController = TextEditingController();
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
    _precoLitroController.clear();
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
      _precoLitroController.text = atividade.precoLitro;
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
    _controller.atividade.precoLitro = _precoLitroController.text;
    _controller.atividade.tipoCombustivel = selectedFuelType;
    _controller.atividade.estabelecimento = _estabelecimentoController.text;
    _controller.atividade.numeroParcela = _numeroParcelaController.text;
    _controller.atividade.observacoes = _observacoesController.text;
  }

  void _calcularTotal() {
    try {
      String litrosText = _litrosController.text.replaceAll(',', '.');
      String precoText = _precoLitroController.text.replaceAll(RegExp(r'[^\d,.]'), '').replaceAll(',', '.');

      double litros = double.tryParse(litrosText) ?? 0;
      double preco = double.tryParse(precoText) ?? 0;

      if (litros > 0 && preco > 0) {
        double total = litros * preco;

        String totalFormatado = NumberFormat.currency(
          locale: 'pt_BR',
          symbol: 'R\$ ',
          decimalDigits: 2,
        ).format(total);

        _totalPagoController.text = totalFormatado;
        _controller.atividade.totalPago = totalFormatado;
      }
    } catch (e) {
      print('Erro ao calcular total: $e');
    }
  }

  @override
  void dispose() {
    _dataController.dispose();
    _kmAtualController.dispose();
    _totalPagoController.dispose();
    _litrosController.dispose();
    _precoLitroController.dispose();
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
                bottom: MediaQuery.of(context).viewPadding.bottom + 30,
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
            'Selecione abaixo o tipo de atividade que deseja cadastrar.',
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
    return Observer(
      builder: (_) => DropdownButtonFormField2<String>(
        value: selectedActivityType,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          offset: const Offset(0, -4),
          padding: const EdgeInsets.symmetric(vertical: 4),
          maxHeight: 200,
        ),
        buttonStyleData: ButtonStyleData(
          height: 46,
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
        ),
        style: textTheme.bodyMedium?.copyWith(color: Colors.white),
        selectedItemBuilder: (context) {
          return activityTypes.map((value) {
            return Row(
              children: [
                Icon(
                  _getActivityIcon(value),
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            );
          }).toList();
        },
        items: activityTypes.map((value) {
          final isSelected = value == selectedActivityType;
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Icon(
                  _getActivityIcon(value),
                  color: isSelected ? colorScheme.primary : colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: textTheme.bodyMedium?.copyWith(
                    color: isSelected ? colorScheme.primary : colorScheme.secondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedActivityType = newValue!;
            _clearFieldsOnTypeChange();
          });
        },
      ),
    );
  }

  void _clearFieldsOnTypeChange() {
    _kmAtualController.clear();
    _totalPagoController.clear();
    _litrosController.clear();
    _precoLitroController.clear();
    _estabelecimentoController.clear();
    _numeroParcelaController.clear();

    _controller.atividade.km = '';
    _controller.atividade.totalPago = '';
    _controller.atividade.litros = '';
    _controller.atividade.precoLitro = '';
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
        _buildVeiculoDropdown(),
        const SizedBox(height: 16),
        TextFieldCustom(
          label: 'Data',
          controller: _dataController,
          onTap: () => _selectDate(context),
          onChanged: (value) {
            _controller.atividade.data = value;
          },
        ),
        ..._buildSpecificFields(),
        const SizedBox(height: 16),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: Colors.amber,
                  size: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.secondary,
                      ),
                      children: [
                        const TextSpan(text: 'Nenhum veículo cadastrado! '),
                        WidgetSpan(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              Modular.to.pushNamed(veiculoRoute);
                            },
                            child: Text(
                              'Cadastre um veículo',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: ' para começar!'),
                      ],
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
          child: DropdownButtonFormField2<String>(
            value: selectedVeiculoId,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Selecione o veículo',
              labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.only(right: 8),
            ),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              offset: const Offset(0, -2),
              padding: const EdgeInsets.symmetric(vertical: 4),
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              iconEnabledColor: Colors.black54,
            ),
            style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
            items: veiculos.map((veiculo) {
              return DropdownMenuItem<String>(
                value: veiculo.base.id,
                child: Text(
                  '${veiculo.marca} ${veiculo.modelo} (${veiculo.placa})',
                  overflow: TextOverflow.ellipsis,
                ),
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
    return SizedBox(
      height: 46,
      child: MapboxPlaceSearch(
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
      ),
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [KmInputFormatter()],
                  onChanged: (value) {
                    _controller.atividade.km = value;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldCustom(
                  label: 'Litros',
                  controller: _litrosController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [LitrosInputFormatter()],
                  onChanged: (value) {
                    _controller.atividade.litros = value;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFieldCustom(
                  label: 'Preço por litro',
                  controller: _precoLitroController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [PrecoLitroInputFormatter()],
                  onChanged: (value) {
                    _controller.atividade.precoLitro = value;
                    _calcularTotal();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldCustom(
                  label: 'Total pago',
                  controller: _totalPagoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyInputFormatter()],
                  onChanged: (value) {
                    _controller.atividade.totalPago = value;
                  },
                ),
              ),
            ],
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [KmInputFormatter()],
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyInputFormatter()],
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
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyInputFormatter()],
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
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyInputFormatter()],
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
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyInputFormatter()],
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyInputFormatter()],
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [ParcelaInputFormatter()],
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
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyInputFormatter()],
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
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyInputFormatter()],
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
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyInputFormatter()],
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
    return DropdownButtonFormField2<String>(
      value: selectedFuelType,
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        offset: const Offset(0, -2),
        padding: const EdgeInsets.symmetric(vertical: 4),
        maxHeight: 200,
      ),
      buttonStyleData: ButtonStyleData(
        height: 46,
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
      ),
      style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
      selectedItemBuilder: (context) {
        return fuelTypes.map((value) {
          return Row(
            children: [
              const SizedBox(width: 10),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
              ),
            ],
          );
        }).toList();
      },
      items: fuelTypes.map((value) {
        final isSelected = value == selectedFuelType;
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: isSelected ? colorScheme.primary : colorScheme.secondary,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedFuelType = newValue!;
          _controller.atividade.tipoCombustivel = newValue;
        });
      },
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