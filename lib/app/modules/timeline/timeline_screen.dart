import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> with ThemeMixin {
  final List<TimelineItem> _timelineItems = [
    TimelineItem(
      title: 'Abastecimento',
      date: DateTime(2025, 5, 1),
      icon: Icons.shopping_cart,
      iconColor: const Color(0xFF1A237E),
      iconBackgroundColor: const Color(0xFF90CAF9),
      details: [
        TimelineDetail(icon: Icons.calendar_today, text: '01/05/2025'),
        TimelineDetail(icon: Icons.shopping_bag, text: 'Compras de itens'),
        TimelineDetail(
            icon: Icons.location_on,
            text: 'Posto buffon BR 101 KM 5 - Torres, RS'),
      ],
      price: 479.90,
    ),
    TimelineItem(
      title: 'Troca de óleo',
      date: DateTime(2025, 5, 1),
      icon: Icons.build,
      iconColor: Colors.white,
      iconBackgroundColor: const Color(0xFF26A69A),
      details: [
        TimelineDetail(icon: Icons.speed, text: '63.000 Km'),
        TimelineDetail(icon: Icons.attach_money, text: '35,90 R\$/L'),
        TimelineDetail(
            icon: Icons.location_on, text: 'Mecânica garagem 01 - Torres, RS'),
      ],
      price: 143.60,
    ),
    TimelineItem(
      title: 'Abastecimento',
      date: DateTime(2025, 5, 1),
      icon: Icons.local_gas_station,
      iconColor: Colors.white,
      iconBackgroundColor: const Color(0xFF42A5F5),
      details: [
        TimelineDetail(icon: Icons.speed, text: '62.500 Km'),
        TimelineDetail(icon: Icons.attach_money, text: '6,20 R\$/L'),
        TimelineDetail(
            icon: Icons.location_on,
            text: 'Posto buffon BR 101 KM 5 - Torres, RS'),
      ],
      price: 100.00,
    ),
    TimelineItem(
      title:
      'Você iniciou o controle de despesas do seu veículo com Auto Care!',
      date: DateTime(2025, 5, 1),
      icon: Icons.star,
      iconColor: Colors.white,
      iconBackgroundColor: const Color(0xFF26A69A),
      isSpecial: true,
      emoji: '🎉',
    ),
    TimelineItem(
      title: 'Bem vindo ao',
      subtitle: 'AUTO CARE+',
      date: DateTime(2025, 5, 1),
      icon: Icons.chat,
      iconColor: Colors.white,
      iconBackgroundColor: const Color(0xFF2196F3),
      isWelcome: true,
    ),
  ];

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
          'Atividade',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildMonthHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8.0),
              itemCount: _timelineItems.length,
              itemBuilder: (context, index) {
                final item = _timelineItems[index];
                final isFirst = index == 0;
                final isLast = index == _timelineItems.length - 1;

                return _buildTimelineTile(
                  item: item,
                  isFirst: isFirst,
                  isLast: isLast,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'MAIO 2025',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTimelineTile({
    required TimelineItem item,
    required bool isFirst,
    required bool isLast,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.15,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 40,
        height: 40,
        indicator: Container(
          decoration: BoxDecoration(
            color: item.iconBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: item.emoji != null
                ? Text(
              item.emoji!,
              style: const TextStyle(fontSize: 20),
            )
                : Icon(
              item.icon,
              color: item.iconColor,
              size: 20,
            ),
          ),
        ),
        drawGap: true,
      ),
      beforeLineStyle: LineStyle(
        color: Colors.grey.shade300,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: Colors.grey.shade300,
        thickness: 2,
      ),
      endChild: Container(
        constraints: const BoxConstraints(
          minHeight: 120,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: item.isWelcome
                      ? RichText(
                    text: TextSpan(
                      text: '${item.title} ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: item.subtitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Text(
                    item.title,
                    style: TextStyle(
                      fontSize: item.isSpecial ? 16 : 18,
                      fontWeight: FontWeight.w500,
                      color: item.isSpecial
                          ? Colors.grey[700]
                          : Colors.black,
                    ),
                  ),
                ),
                if (!item.isSpecial && !item.isWelcome)
                  Text(
                    '01 mai.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
            if (!item.isSpecial && !item.isWelcome) ...[
              const SizedBox(height: 8),
              ...item.details.map((detail) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Icon(
                      detail.icon,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      detail.text,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 4),
              if (item.price != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'R\$ ${item.price!.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
            if (item.isSpecial) ...[
              const SizedBox(height: 8),
              Text(
                '01 mai.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TimelineItem {
  final String title;
  final String? subtitle;
  final DateTime date;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final List<TimelineDetail> details;
  final double? price;
  final bool isSpecial;
  final bool isWelcome;
  final String? emoji;

  TimelineItem({
    required this.title,
    this.subtitle,
    required this.date,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.details = const [],
    this.price,
    this.isSpecial = false,
    this.isWelcome = false,
    this.emoji,
  });
}

class TimelineDetail {
  final IconData icon;
  final String text;

  TimelineDetail({
    required this.icon,
    required this.text,
  });
}