import 'package:auto_care_plus_app/app/modules/home/home_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../veiculo/store/veiculo_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ThemeMixin {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<HomeController>();
    _loadData();
  }

  Future<void> _loadData() async {
    await _controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: Observer(
              builder: (_) {
                if (_controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildExpensesSection(),
                        _buildNotificationsSection(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 8,
      ),
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
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Início',
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          _buildVehicleDropdown(),
        ],
      ),
    );
  }

  Widget _buildVehicleDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: 46,
          decoration: BoxDecoration(
            color: colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Observer(
            builder: (_) {
              final veiculos = _controller.veiculos;

              return DropdownButtonFormField2<String?>(
                isExpanded: true,
                value: _controller.veiculoSelecionadoId,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                buttonStyleData: ButtonStyleData(
                  height: 46,
                  padding: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  offset: const Offset(0, -4),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  iconEnabledColor: Colors.black54,
                ),
                hint: const Row(
                  children: [
                    Icon(Icons.directions_car),
                  ],
                ),
                style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
                selectedItemBuilder: (context) {
                  return <Widget>[
                    const Row(
                      children: [
                        Icon(Icons.south_east_rounded),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Todos os veículos',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    ...veiculos.map((veiculo) {
                      return Row(
                        children: [
                          const Icon(Icons.directions_car),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${veiculo.modelo} - ${veiculo.placa}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ];
                },
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.south_east_rounded,
                          color: _controller.veiculoSelecionadoId == null
                              ? colorScheme.primary
                              : colorScheme.secondary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Todos os veículos',
                          style: textTheme.bodyMedium?.copyWith(
                            color: _controller.veiculoSelecionadoId == null
                                ? colorScheme.primary
                                : colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...veiculos.map((veiculo) {
                    final isSelected = _controller.veiculoSelecionadoId == veiculo.base.id;
                    return DropdownMenuItem<String?>(
                      value: veiculo.base.id,
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: isSelected ? colorScheme.primary : colorScheme.secondary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${veiculo.modelo} - ${veiculo.placa}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: isSelected ? colorScheme.primary : colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
                onChanged: (String? newValue) {
                  _controller.setVeiculoSelecionado(newValue);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExpensesSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 22, left: 16, right: 16),
        child: Observer(
          builder: (_) {
            final gastos = _controller.gastosCategorizados;
            final totalGastos = _controller.totalGastos;
            final expenses = gastos.entries.map((entry) => ExpenseCategory(entry.key, entry.value, _getColorForCategory(entry.key))).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'R\$ ${totalGastos.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: textTheme.titleMedium,
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(4),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list, size: 16, color: Colors.black87),
                      label: Text(
                        'Filtros',
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Relatórios',
                  style: textTheme.titleMedium,
                ),
                Text(
                  'Relatório de gastos registrados',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                ...expenses.map((expense) => _buildExpenseItem(expense)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: Center(child: _buildExpenseChart(expenses, totalGastos)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpenseItem(ExpenseCategory expense) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: expense.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              expense.name,
              style: textTheme.bodyMedium,
            ),
          ),
          Text(
            'R\$ ${expense.value.toStringAsFixed(2).replaceAll('.', ',')}',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseChart(List<ExpenseCategory> expenses, double totalExpense) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0.5,
              centerSpaceRadius: 60,
              sections: _getChartSections(expenses),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'R\$ ${totalExpense.toStringAsFixed(2).replaceAll('.', ',')}',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _getChartSections(List<ExpenseCategory> expenses) {
    final nonZeroExpenses = expenses.where((e) => e.value > 0).toList();

    if (nonZeroExpenses.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey[300],
          value: 1,
          radius: 50,
          showTitle: false,
        )
      ];
    }

    return nonZeroExpenses.map((expense) {
      return PieChartSectionData(
        color: expense.color,
        value: expense.value,
        radius: 50,
        showTitle: false,
      );
    }).toList();
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Reabastecimento':
        return Colors.blue;
      case 'Troca de Óleo':
        return Colors.red;
      case 'Lavagem':
        return Colors.orange;
      case 'Seguro':
        return Colors.yellow;
      case 'Serviço Mecânico':
        return Colors.green;
      case 'Outros':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  Widget _buildNotificationsSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOTIFICAÇÕES',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'No momento não há notificações para você! 😊',
                  style: textTheme.bodyMedium,
                ),
              ),
              Text(
                'há 5 dias',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.notifications,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Não ativou as notificações? ',
                style: textTheme.bodySmall,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Clique aqui',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                ' para permitir',
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpenseCategory {
  final String name;
  final double value;
  final Color color;

  ExpenseCategory(this.name, this.value, this.color);
}
