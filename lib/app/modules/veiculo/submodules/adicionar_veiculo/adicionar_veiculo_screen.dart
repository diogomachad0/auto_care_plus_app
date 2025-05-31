import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdicionarVeiculoScreen extends StatefulWidget {
  const AdicionarVeiculoScreen({super.key});

  @override
  State<AdicionarVeiculoScreen> createState() => _AdicionarVeiculoScreenState();
}

class _AdicionarVeiculoScreenState extends State<AdicionarVeiculoScreen> with ThemeMixin {
  final controller = Modular.get<VeiculoController>();

  final List<String> fuelTypes = ['FLEX', 'GASOLINA', 'ETANOL', 'DIESEL', 'ELÉTRICO'];

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
                        FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 46),
                            backgroundColor: colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await controller.save();
                            Modular.to.navigate(veiculoRoute);
                          },
                          child: Text(
                            'Salvar',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onPrimary,
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Observer(
      builder: (_) => Column(
        children: [
          TextFieldCustom(
            label: 'Nome do veículo',
            initialValue: controller.veiculo.modelo,
            onChanged: (v) => controller.veiculo.modelo = v,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFieldCustom(
                  label: 'Marca',
                  initialValue: controller.veiculo.marca,
                  onChanged: (v) => controller.veiculo.marca = v,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFieldCustom(
                  label: 'Ano',
                  initialValue: controller.veiculo.ano.toString(),
                  onChanged: (v) => controller.veiculo.ano = int.tryParse(v) ?? 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFieldCustom(
                  label: 'Placa',
                  initialValue: controller.veiculo.placa,
                  onChanged: (v) => controller.veiculo.placa = v,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFieldCustom(
                  label: 'Quilometragem',
                  initialValue: controller.veiculo.quilometragem.toString(),
                  onChanged: (v) => controller.veiculo.quilometragem = int.tryParse(v) ?? 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFuelTypeDropdown(),
          const SizedBox(height: 12),
          _buildObservationsField(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFuelTypeDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Observer(
        builder: (_) => DropdownButtonFormField<String>(
          value: controller.veiculo.tipoCombustivel,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          items: fuelTypes.map((fuel) => DropdownMenuItem(value: fuel, child: Text(fuel))).toList(),
          onChanged: (value) => controller.veiculo.tipoCombustivel = value!,
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildObservationsField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Observer(
        builder: (_) => TextField(
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
      ),
    );
  }
}

class TextFieldCustom extends StatelessWidget {
  final String label;
  final String? initialValue;
  final void Function(String)? onChanged;

  const TextFieldCustom({super.key, required this.label, this.initialValue, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }
}
