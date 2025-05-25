import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdicionarVeiculoScreen extends StatefulWidget {
  const AdicionarVeiculoScreen({Key? key}) : super(key: key);

  @override
  State<AdicionarVeiculoScreen> createState() => _AdicionarVeiculoScreenState();
}

class _AdicionarVeiculoScreenState extends State<AdicionarVeiculoScreen>
    with ThemeMixin {
  String selectedFuelType = 'FLEX';
  final List<String> fuelTypes = [
    'FLEX',
    'GASOLINA',
    'ETANOL',
    'DIESEL',
    'ELÉTRICO'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.secondary,
        ),
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
            icon: Icon(
              Icons.arrow_back_ios,
              color: colorScheme.onPrimary,
            ),
            onPressed: () {
              Modular.to.navigate(veiculoRoute);
              //todo: arrumar depois
            },
          ),
          Text(
            'Adicionar veículo',
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_forever_rounded,
              color: colorScheme.onPrimary,
              size: 36,
            ),
            onPressed: () {},
          ),
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
            height: 180,
          ),
          const SizedBox(height: 12),
          Text(
            'Cadastre aqui os seus veículos!',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        const TextFieldCustom(label: 'Nome do veículo'),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: TextFieldCustom(label: 'Marca'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextFieldCustom(label: 'Ano'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: TextFieldCustom(label: 'Placa'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextFieldCustom(label: 'Quilometragem'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFuelTypeDropdown(),
        const SizedBox(height: 12),
        _buildObservationsField(context),
        const SizedBox(height: 24),
      ],
    );
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
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
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
        items: fuelTypes.map((String fuelType) {
          return DropdownMenuItem<String>(
            value: fuelType,
            child: Text(fuelType),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedFuelType = newValue!;
          });
        },
        dropdownColor: Colors.white,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildObservationsField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'Observações',
          labelStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey),
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
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class TextFieldCustom extends StatefulWidget {
  final String label;

  const TextFieldCustom({
    super.key,
    required this.label,
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> with ThemeMixin {
  @override
  Widget build(BuildContext context) {
    return TextField(
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
