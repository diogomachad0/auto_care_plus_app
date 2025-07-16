import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_error.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

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

class EditarVeiculoScreen extends StatefulWidget {
  const EditarVeiculoScreen({super.key});

  @override
  State<EditarVeiculoScreen> createState() => _EditarVeiculoScreenState();
}

class _EditarVeiculoScreenState extends State<EditarVeiculoScreen> with ThemeMixin {
  final controller = Modular.get<VeiculoController>();
  final List<String> fuelTypes = ['Flex', 'Gasolina', 'Etanol', 'Diesel', 'Elétrico'];

  late TextEditingController _modeloController;
  late TextEditingController _marcaController;
  late TextEditingController _anoController;
  late TextEditingController _placaController;
  late TextEditingController _quilometragemController;
  late TextEditingController _observacoesController;

  bool _loading = true;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();

    _modeloController = TextEditingController();
    _marcaController = TextEditingController();
    _anoController = TextEditingController();
    _placaController = TextEditingController();
    _quilometragemController = TextEditingController();
    _observacoesController = TextEditingController();

    final id = Modular.args.data;
    _loadVeiculo(id);
  }

  @override
  void dispose() {
    _modeloController.dispose();
    _marcaController.dispose();
    _anoController.dispose();
    _placaController.dispose();
    _quilometragemController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _loadVeiculo(String id) async {
    try {
      await controller.loadById(id);

      await Future.delayed(Duration.zero);

      if (mounted) {
        _modeloController.text = controller.veiculo.modelo ?? '';
        _marcaController.text = controller.veiculo.marca ?? '';
        _anoController.text = controller.veiculo.ano.toString() ?? '';
        _placaController.text = controller.veiculo.placa ?? '';

        if (controller.veiculo.quilometragem > 0) {
          _quilometragemController.text = NumberFormat('#,###', 'pt_BR').format(controller.veiculo.quilometragem);
        }

        _observacoesController.text = controller.veiculo.observacoes ?? '';

        setState(() {
          _dataLoaded = true;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    if (!_dataLoaded) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Erro ao carregar dados do veículo'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Modular.to.navigate(veiculoRoute),
                child: Text('Voltar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: colorScheme.secondary,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildIllustration(),
                        _buildForm(),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: colorScheme.onPrimary),
            onPressed: () => Modular.to.navigate(veiculoRoute),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Editar veículo',
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Image.asset(
            'assets/img/banners/bro.png',
            width: 330,
          ),
          const SizedBox(height: 16),
          Text(
            'Edite as informações do seu veículo aqui!',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onPrimary),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        TextFieldCustom(
          controller: _modeloController,
          label: 'Nome do veículo',
          onChanged: (v) => controller.veiculo.modelo = v,
        ),
        Row(
          children: [
            Expanded(
              child: TextFieldCustom(
                controller: _marcaController,
                label: 'Marca',
                onChanged: (v) => controller.veiculo.marca = v,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFieldCustom(
                controller: _anoController,
                label: 'Ano',
                onlyNumbers: true,
                validator: (value) {
                  final ano = int.tryParse(value);
                  if (ano == null || ano < 1900 || ano > 2026) {
                    return 'Ano inválido (1900 – 2026)';
                  }
                  return null;
                },
                onChanged: (v) => controller.veiculo.ano = int.tryParse(v) ?? 0,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextFieldCustom(
                controller: _placaController,
                label: 'Placa',
                toUpperCase: true,
                onChanged: (v) => controller.veiculo.placa = v,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(7),
                ],
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (value.length != 7) {
                    return 'Deve conter 7 caracteres';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFieldCustom(
                controller: _quilometragemController,
                label: 'Quilometragem',
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  String numericString = v.replaceAll(RegExp(r'[^\d]'), '');
                  controller.veiculo.quilometragem = int.tryParse(numericString) ?? 0;
                },
                inputFormatters: [
                  KmInputFormatter(),
                ],
              ),
            ),
          ],
        ),
        Observer(
          builder: (_) => DropdownButtonFormField2<String>(
            value: controller.veiculo.tipoCombustivel,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: textTheme.bodyMedium,
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              offset: const Offset(0, -2),
              padding: const EdgeInsets.symmetric(vertical: 4),
              maxHeight: 200,
            ),
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: 40,
              width: double.infinity,
            ),
            items: fuelTypes
                .map(
                  (fuel) => DropdownMenuItem<String>(
                    value: fuel,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(fuel),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => controller.veiculo.tipoCombustivel = value!,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _observacoesController,
            maxLines: 4,
            onChanged: (v) => controller.veiculo.observacoes = v,
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
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFuelTypeDropdown() {
    String? currentValue = controller.veiculo.tipoCombustivel;

    final Map<String, String> valueMapping = {
      'FLEX': 'Flex',
      'GASOLINA': 'Gasolina',
      'ETANOL': 'Etanol',
      'DIESEL': 'Diesel',
      'ELÉTRICO': 'Elétrico',
    };

    if (currentValue != null && valueMapping.containsKey(currentValue)) {
      currentValue = valueMapping[currentValue];
      controller.veiculo.tipoCombustivel = currentValue!;
    }

    if (currentValue != null && !fuelTypes.contains(currentValue)) {
      currentValue = null;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        decoration: InputDecoration(
          labelText: 'Tipo de Combustível',
          labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        items: fuelTypes.map((fuel) => DropdownMenuItem(value: fuel, child: Text(fuel))).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.veiculo.tipoCombustivel = value;
          }
        },
        dropdownColor: Colors.white,
        style: textTheme.bodyMedium,
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
        onChanged: (v) => controller.veiculo.observacoes = v,
        decoration: InputDecoration(
          labelText: 'Observações',
          labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Observer(
      builder: (_) {
        final isValid = controller.isFormValid;

        return FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 46),
            backgroundColor: isValid ? colorScheme.primary : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: isValid
              ? () async {
                  try {
                    await controller.save();
                    Modular.to.navigate(veiculoRoute);
                  } catch (e, s) {
                    await DialogError.show(context, 'Erro ao salvar veículo: \nErro: ${e.toString()}', s);
                  }
                }
              : null,
          child: Text(
            'Salvar alterações',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onPrimary,
            ),
          ),
        );
      },
    );
  }
}
