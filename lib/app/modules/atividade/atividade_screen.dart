import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';

class AtividadeScreen extends StatefulWidget {
  const AtividadeScreen({super.key});

  @override
  State<AtividadeScreen> createState() => _AtividadeScreenState();
}

class _AtividadeScreenState extends State<AtividadeScreen> with ThemeMixin {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _kmAtualController = TextEditingController();
  final TextEditingController _totalPagoController = TextEditingController();
  final TextEditingController _litrosController = TextEditingController();
  final TextEditingController _precoLitroController = TextEditingController();
  final TextEditingController _estabelecimentoController =
      TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();

  String selectedActivityType = 'Abastecimento';
  String selectedFuelType = 'Gasolina';

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
  void dispose() {
    _dataController.dispose();
    _kmAtualController.dispose();
    _totalPagoController.dispose();
    _litrosController.dispose();
    _precoLitroController.dispose();
    _estabelecimentoController.dispose();
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
        automaticallyImplyLeading: false,
        title: Text(
          'Nova atividade',
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
                      color: value == selectedActivityType
                          ? Colors.white
                          : colorScheme.secondary,
                    ),
                    const SizedBox(width: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        textAlign: TextAlign.center,
                        value,
                        style: textTheme.bodyMedium?.copyWith(
                          color: value == selectedActivityType
                              ? colorScheme.onPrimary
                              : colorScheme.secondary,
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
        // Data
        TextFieldCustom(
          label: 'Data',
          controller: _dataController,
          onTap: () => _selectDate(context),
        ),
        const SizedBox(height: 16),

        // Km atual e Total pago
        Row(
          children: [
            Expanded(
              child: TextFieldCustom(
                label: 'Km atual',
                controller: _kmAtualController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFieldCustom(
                label: 'Total pago',
                controller: _totalPagoController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextFieldCustom(
                label: 'Litros',
                controller: _litrosController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFieldCustom(
                label: 'Preço do Litro',
                controller: _precoLitroController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildFuelTypeDropdown(),
        const SizedBox(height: 16),

        TextFieldCustom(
          label: 'Estabelecimento',
          controller: _estabelecimentoController,
        ),
        const SizedBox(height: 16),

        _buildObservationsField(),
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
        decoration: InputDecoration(
          labelText: 'Observações',
          labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _buildCadastrarButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 46),
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        child: Text(
          'Cadastrar',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
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
