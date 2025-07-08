import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_error.dart';
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
        _quilometragemController.text = controller.veiculo.quilometragem.toString() ?? '';
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
        print('Erro ao carregar veículo: $e');
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
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: TextField(
            controller: _modeloController,
            onChanged: (v) => controller.veiculo.modelo = v,
            decoration: InputDecoration(
              labelText: 'Nome do veículo',
              labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.only(bottom: 16, right: 8),
                child: TextField(
                  controller: _marcaController,
                  onChanged: (v) => controller.veiculo.marca = v,
                  decoration: InputDecoration(
                    labelText: 'Marca',
                    labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.only(bottom: 16, left: 8),
                child: TextField(
                  controller: _anoController,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.veiculo.ano = int.tryParse(v) ?? 0,
                  decoration: InputDecoration(
                    labelText: 'Ano',
                    labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.only(bottom: 16, right: 8),
                child: TextField(
                  controller: _placaController,
                  onChanged: (v) => controller.veiculo.placa = v,
                  decoration: InputDecoration(
                    labelText: 'Placa',
                    labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.only(bottom: 16, left: 8),
                child: TextField(
                  controller: _quilometragemController,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.veiculo.quilometragem = int.tryParse(v) ?? 0,
                  decoration: InputDecoration(
                    labelText: 'Quilometragem',
                    labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                ),
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
        final isValid = _modeloController.text.isNotEmpty && _marcaController.text.isNotEmpty && _placaController.text.isNotEmpty && _quilometragemController.text.isNotEmpty && _anoController.text.isNotEmpty && controller.veiculo.tipoCombustivel.isNotEmpty;

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
