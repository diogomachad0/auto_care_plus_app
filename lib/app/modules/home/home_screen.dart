import 'dart:ui';

import 'package:auto_care_plus_app/app/modules/home/home_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/services/notification_service/notification_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../lembrete/lembrete_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ThemeMixin {
  late final HomeController _controller;
  late final LembreteController _lembreteController;
  late PageController _chartPageController;
  int _currentChartIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<HomeController>();
    _lembreteController = Modular.get<LembreteController>();
    _chartPageController = PageController();
    _loadData();
  }

  @override
  void dispose() {
    _chartPageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _controller.load();
    await _lembreteController.load();
    NotificationService.verificarLembretesVencidos(_lembreteController.lembretes);
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
                      bottom: MediaQuery.of(context).padding.bottom + 50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildExpensesSection(),
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
                          color: _controller.veiculoSelecionadoId == null ? colorScheme.primary : colorScheme.secondary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Todos os veículos',
                          style: textTheme.bodyMedium?.copyWith(
                            color: _controller.veiculoSelecionadoId == null ? colorScheme.primary : colorScheme.secondary,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, top: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                _showNotificacoesDialog().then((_) {
                  setState(() {});
                });
              },
              child: Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.notifications_on_rounded,
                        size: 24,
                        color: colorScheme.secondary,
                      ),
                      if (NotificationService.notificacoes.isNotEmpty && NotificationService.notificacoes.any((lembrete) => !NotificationService.isLida(lembrete.id)))
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'GASTOS',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Observer(
              builder: (_) {
                final gastos = _controller.gastosCategorizados;
                final totalGastos = _controller.totalGastos;
                final expenses = gastos.entries.map((entry) => ExpenseCategory(entry.key, entry.value, _getColorForCategory(entry.key))).toList();
                final monthlyExpenses = _controller.gastosMensaisLista;

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
                      child: PageView(
                        controller: _chartPageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentChartIndex = index;
                          });
                        },
                        children: [
                          Center(child: _buildExpenseChart(expenses, totalGastos)),
                          Center(child: _buildMonthlyChart(monthlyExpenses)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPageIndicator(0),
                        const SizedBox(width: 8),
                        _buildPageIndicator(1),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentChartIndex == index ? colorScheme.primary : Colors.grey[300],
      ),
    );
  }

  Widget _buildMonthlyChart(List<MonthlyExpense> monthlyExpenses) {
    if (monthlyExpenses.isEmpty || monthlyExpenses.every((e) => e.value == 0)) {
      return Center(
        child: Text(
          'Nenhum gasto registrado',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final maxValue = monthlyExpenses.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Text(
          'Últimos 3 meses',
          style: textTheme.titleMedium?.copyWith(),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxValue * 1.2,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      'R\$ ${rod.toY.toStringAsFixed(2).replaceAll('.', ',')}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (value.toInt() < monthlyExpenses.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            monthlyExpenses[value.toInt()].month,
                            style: textTheme.bodySmall,
                          ),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: monthlyExpenses.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.value,
                      color: entry.value.color,
                      width: 40,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showNotificacoesDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return _NotificacoesDialog();
      },
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
              centerSpaceRadius: 50,
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
      case 'Financiamento':
        return Colors.purple;
      case 'Compras':
        return Colors.teal;
      case 'Impostos':
        return Colors.indigo;
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

class _NotificacoesDialog extends StatefulWidget {
  @override
  State<_NotificacoesDialog> createState() => _NotificacoesDialogState();
}

class _NotificacoesDialogState extends State<_NotificacoesDialog> with ThemeMixin {
  @override
  void initState() {
    super.initState();
    NotificationService.marcarTodasComoLidas();
  }

  @override
  Widget build(BuildContext context) {
    final notificacoes = NotificationService.notificacoes;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notificações',
                    style: textTheme.titleMedium?.copyWith(),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: notificacoes.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        itemCount: notificacoes.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final lembrete = notificacoes[index];
                          return _buildNotificacaoItem(lembrete);
                        },
                      ),
              ),
              if (notificacoes.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        NotificationService.limparNotificacoes();
                      });
                    },
                    child: Text(
                      'Limpar todas',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma notificação',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Você não possui notificações no momento',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificacaoItem(dynamic lembrete) {
    final dataNotificacao = DateTime(
      lembrete.data.year,
      lembrete.data.month,
      lembrete.data.day,
      12,
      0,
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.notifications,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lembrete - AutoCare+',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lembrete.titulo,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatarDataHora(dataNotificacao),
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatarDataHora(DateTime dateTime) {
    final agora = DateTime.now();
    final diferenca = agora.difference(dateTime);
    if (diferenca.inMinutes < 1) {
      return 'Agora mesmo';
    } else if (diferenca.inMinutes < 60) {
      return 'há ${diferenca.inMinutes} min';
    } else if (diferenca.inHours < 24) {
      return 'há ${diferenca.inHours}h';
    } else if (diferenca.inDays < 7) {
      return 'há ${diferenca.inDays} dias';
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    }
  }
}

class CurrencyParser {
  static double parseToDouble(String? value) {
    if (value == null || value.isEmpty) return 0.0;

    try {
      String cleanValue = value.replaceAll(RegExp(r'[^\d,.]'), '');

      if (cleanValue.isEmpty) return 0.0;

      if (cleanValue.contains(',') && cleanValue.contains('.')) {
        cleanValue = cleanValue.replaceAll('.', '').replaceAll(',', '.');
      } else if (cleanValue.contains(',') && !cleanValue.contains('.')) {
        cleanValue = cleanValue.replaceAll(',', '.');
      } else if (cleanValue.contains('.') && !cleanValue.contains(',')) {
        List<String> parts = cleanValue.split('.');
        if (parts.length > 2 || (parts.length == 2 && parts[1].length != 2)) {
          cleanValue = cleanValue.replaceAll('.', '');
        }
      }

      return double.parse(cleanValue);
    } catch (e) {
      print('Erro ao fazer parse do valor: $value - $e');
      return 0.0;
    }
  }

  static String formatToCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
