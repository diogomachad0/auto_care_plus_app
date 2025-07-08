import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
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

class AdicionarVeiculoScreen extends StatefulWidget {
  const AdicionarVeiculoScreen({super.key});

  @override
  State<AdicionarVeiculoScreen> createState() => _AdicionarVeiculoScreenState();
}

class _AdicionarVeiculoScreenState extends State<AdicionarVeiculoScreen> with ThemeMixin {
  final controller = Modular.get<VeiculoController>();

  final List<String> fuelTypes = ['Flex', 'Gasolina', 'Etanol', 'Diesel', 'Elétrico'];

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildIllustration(),
                        _buildForm(),
                        Observer(
                          builder: (_) => FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(double.infinity, 46),
                              backgroundColor: controller.isFormValid ? colorScheme.primary : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: controller.isFormValid
                                ? () async {
                                    await controller.save();
                                    Modular.to.navigate(veiculoRoute);
                                  }
                                : null,
                            child: Text(
                              'Salvar',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
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
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: colorScheme.onPrimary),
            onPressed: () => Modular.to.navigate(veiculoRoute),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Adicionar veículo',
                style: textTheme.titleLarge?.copyWith(color: Colors.white),
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
          Image.asset('assets/img/banners/bro.png', height: 180),
          const SizedBox(height: 12),
          Text(
            'Cadastre aqui os seus veículos!',
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
          label: 'Nome do veículo',
          onChanged: (v) => controller.veiculo.modelo = v,
        ),
        Row(
          children: [
            Expanded(
              child: TextFieldCustom(
                label: 'Marca',
                onChanged: (v) => controller.veiculo.marca = v,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFieldCustom(
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
                  }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFieldCustom(
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
        _buildFuelTypeDropdown(),
        const SizedBox(height: 16),
        _buildObservationsField(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFuelTypeDropdown() {
    return Observer(
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
    );
  }

  Widget _buildObservationsField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        maxLines: 4,
        onChanged: (v) => controller.veiculo.observacoes = v,
        decoration: InputDecoration(
          labelText: 'Observações',
          labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
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
}
