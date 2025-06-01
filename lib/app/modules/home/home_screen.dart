import 'dart:math' as math;

import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ThemeMixin {
  int _selectedIndex = 1;
  final PageController _pageController = PageController();

  final List<ExpenseCategory> _expenses = [
    ExpenseCategory('Reabastecimento', 350.0, Colors.blue),
    ExpenseCategory('Troca de Óleo', 0.0, Colors.red),
    ExpenseCategory('Lavagem', 0.0, Colors.orange),
    ExpenseCategory('Seguro', 0.0, Colors.yellow),
    ExpenseCategory('Serviço Mecânico', 900.0, Colors.green),
    ExpenseCategory('Outros', 70.0, Colors.cyan),
  ];

  double get _totalExpense {
    return _expenses.fold(0, (sum, expense) => sum + expense.value);
  }

  @override
  void dispose() {
    _pageController.dispose();
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
            'Inicio',
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildExpensesSection(),
                    _buildNotificationsSection(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildExpensesSection() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GASTOS',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Este mês',
                style: textTheme.bodyLarge,
              ),
              Row(
                children: [
                  Text(
                    'R\$ ${_totalExpense.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Filtros',
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.filter_list, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Relatórios',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          ..._expenses.map((expense) => _buildExpenseItem(expense)),
          const SizedBox(height: 16),
          Text(
            'Este mês',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: Center(child: _buildExpenseChart()),
          ),
          const SizedBox(height: 8),
        ],
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

  Widget _buildExpenseChart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 60,
              sections: _getChartSections(),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'R\$ ${_totalExpense.toStringAsFixed(2).replaceAll('.', ',')}',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _getChartSections() {
    final nonZeroExpenses = _expenses.where((e) => e.value > 0).toList();

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
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(0, Icons.menu, 'Menu'),
        _buildNavItem(1, Icons.home, 'Inicio'),
        const SizedBox(width: 48),
        _buildNavItem(2, Icons.show_chart, 'Atividade'),
        _buildNavItem(3, Icons.map, 'Mapa'),
      ],
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? colorScheme.primary : Colors.grey,
                size: 24,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? colorScheme.primary : Colors.grey,
                ),
              ),
            ],
          ),
        ),
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

class CircularNotch extends NotchedShape {
  const CircularNotch();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()..addRect(host);
    }

    final double notchRadius = guest.width / 2;

    const double s1 = 15.0;
    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - guest.center.dy;

    final double n2 = math.sqrt(b * b * r * r * (1.0 - b * b / (r * r)));
    final double p2xA = ((a * r * r - n2) / (a * a + b * b));
    final double p2xB = ((a * r * r + n2) / (a * a + b * b));
    final double p2yA = -b * p2xA / a;
    final double p2yB = -b * p2xB / a;

    final List<Offset> p = List<Offset>.filled(6, Offset.zero);

    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final double cAx = p2xA;
    final double cAy = p2yA;
    final double cBx = p2xB;
    final double cBy = p2yB;
    p[2] = Offset(cAx, cAy);
    p[3] = Offset(cBx, cBy);
    p[4] = Offset(-a, b);
    p[5] = Offset(-a + s1, b);

    final Path path = Path()
      ..moveTo(host.left, host.top)
      ..lineTo(host.left, host.bottom)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.right, host.top)
      ..lineTo(p[0].dx + guest.center.dx, p[0].dy + guest.center.dy)
      ..lineTo(p[1].dx + guest.center.dx, p[1].dy + guest.center.dy);

    for (int i = 1; i < p.length - 2; i += 1) {
      final double x2 = p[i + 1].dx + guest.center.dx;
      final double y2 = p[i + 1].dy + guest.center.dy;
      path.quadraticBezierTo(guest.center.dx, guest.center.dy, x2, y2);
    }

    return path
      ..lineTo(p[4].dx + guest.center.dx, p[4].dy + guest.center.dy)
      ..lineTo(p[5].dx + guest.center.dx, p[5].dy + guest.center.dy)
      ..lineTo(host.left, host.top)
      ..close();
  }
}
