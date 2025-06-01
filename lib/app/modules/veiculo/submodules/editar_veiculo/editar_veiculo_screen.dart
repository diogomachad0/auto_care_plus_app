import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EditarVeiculoScreen extends StatefulWidget {
  const EditarVeiculoScreen({super.key});

  @override
  State<EditarVeiculoScreen> createState() => _EditarVeiculoScreenState();
}

class _EditarVeiculoScreenState extends State<EditarVeiculoScreen> with ThemeMixin {
  final controller = Modular.get<VeiculoController>();

  final List<String> fuelTypes = ['FLEX', 'GASOLINA', 'ETANOL', 'DIESEL', 'ELÉTRICO'];

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    final id = Modular.args.data;
    _loadVeiculo(id);
  }

  Future<void> _loadVeiculo(String id) async {
    await controller.loadById(id);
    setState(() {
      _loading = false;
    });
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
                            Modular.to.pop(true);
                          },
                          child: Text(
                            'Salvar alterações',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        )
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
    return Observer(
      builder: (_) => Column(
        children: [
          TextFieldCustom(
            label: 'Nome do veículo',
            initialValue: controller.veiculo.modelo,
            onChanged: (v) => controller.veiculo.modelo = v,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFieldCustom(
                  label: 'Marca',
                  initialValue: controller.veiculo.marca,
                  onChanged: (v) => controller.veiculo.marca = v,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldCustom(
                  label: 'Ano',
                  initialValue: controller.veiculo.ano.toString(),
                  onChanged: (v) => controller.veiculo.ano = int.tryParse(v) ?? 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFieldCustom(
                  label: 'Placa',
                  initialValue: controller.veiculo.placa,
                  onChanged: (v) => controller.veiculo.placa = v,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldCustom(
                  label: 'Quilometragem',
                  initialValue: controller.veiculo.quilometragem.toString(),
                  onChanged: (v) => controller.veiculo.quilometragem = int.tryParse(v) ?? 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFuelTypeDropdown(),
          const SizedBox(height: 16),
          _buildObservationsField(),
          const SizedBox(height: 16),
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
            labelStyle: textTheme.bodySmall,
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
          style: textTheme.bodySmall,
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
