import 'package:auto_care_plus_app/app/modules/atividade/atividade_controller.dart';
import 'package:auto_care_plus_app/app/modules/atividade/store/atividade_store.dart';
import 'package:auto_care_plus_app/app/modules/timeline/submodules/filtro_widget.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> with ThemeMixin {
  late final AtividadeController _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<AtividadeController>();
    _loadAtividades();
  }

  Future<void> _loadAtividades() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      await _controller.load();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
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
          'Atividades',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              showFiltroWidget(context);
            },
            tooltip: 'Filtros',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    return Observer(
      builder: (_) {
        try {
          final timelineItems = _buildTimelineItems();

          if (timelineItems.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadAtividades,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: timelineItems.length,
                    itemBuilder: (context, index) {
                      final item = timelineItems[index];
                      final isFirst = index == 0;
                      final isLast = index == timelineItems.length - 1;

                      return _buildTimelineTile(
                        item: item,
                        isFirst: isFirst,
                        isLast: isLast,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } catch (e) {
          return _buildErrorState(error: e.toString());
        }
      },
    );
  }

  Widget _buildErrorState({String? error}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar timeline',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error ?? _error ?? 'Erro desconhecido',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadAtividades,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma atividade encontrada',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione sua primeira atividade para começar!',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  List<TimelineItem> _buildTimelineItems() {
    final atividades = _controller.atividades ?? [];
    var items = <TimelineItem>[];

    // Adicionar atividades reais
    for (var atividade in atividades) {
      try {
        items.add(_createTimelineItemFromAtividade(atividade));
      } catch (e) {
        print('Erro ao criar item da timeline para atividade: $e');
      }
    }

    // CORREÇÃO: Ordenar por ordem de criação (mais antiga primeiro, depois reverter para mostrar mais recente no topo)
    // Como não temos campo de criação, vamos manter a ordem original e reverter
    items = items.reversed.toList();

    // Adicionar itens especiais apenas se houver atividades
    if (items.isNotEmpty) {
      items.add(TimelineItem(
        title: 'Você iniciou o controle de despesas do seu veículo com Auto Care!',
        date: DateTime.now().subtract(Duration(days: items.length + 1)),
        icon: Icons.star,
        iconColor: Colors.white,
        iconBackgroundColor: const Color(0xFF4CAF50),
        isSpecial: true,
        emoji: '🎉',
      ));
    }

    // Item de boas-vindas sempre no final
    items.add(TimelineItem(
      title: 'Bem vindo ao',
      subtitle: 'AUTO CARE+',
      date: DateTime.now().subtract(Duration(days: items.length + 2)),
      icon: Icons.chat_bubble,
      iconColor: Colors.white,
      iconBackgroundColor: colorScheme.primary,
      isWelcome: true,
    ));

    return items;
  }

  TimelineItem _createTimelineItemFromAtividade(AtividadeStore atividade) {
    final date = _parseDate(atividade.data);
    final details = _buildDetailsForAtividade(atividade);
    final price = _getPriceFromAtividade(atividade);

    return TimelineItem(
      title: atividade.tipoAtividade ?? 'Atividade',
      date: date,
      icon: _getIconForAtividade(atividade.tipoAtividade ?? ''),
      iconColor: Colors.white,
      iconBackgroundColor: _getColorForAtividade(atividade.tipoAtividade ?? ''),
      details: details,
      price: price,
    );
  }

  DateTime _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now();
    }

    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      print('Erro ao fazer parse da data: $dateString - $e');
    }
    return DateTime.now();
  }

  List<TimelineDetail> _buildDetailsForAtividade(AtividadeStore atividade) {
    final details = <TimelineDetail>[];

    try {
      // CORREÇÃO: Implementar todos os tipos de atividade seguindo o padrão do abastecimento
      switch (atividade.tipoAtividade) {
        case 'Abastecimento':
          if (atividade.km.isNotEmpty) {
            details.add(TimelineDetail(
              icon: Icons.speed,
              text: '${atividade.km} Km',
            ));
          }
          break;

        case 'Troca de óleo':
          if (atividade.km.isNotEmpty) {
            details.add(TimelineDetail(
              icon: Icons.speed,
              text: '${atividade.km} Km',
            ));
          }
          break;

        case 'Lavagem':
        // Para lavagem, não há campos específicos além do estabelecimento
          break;

        case 'Seguro':
        // Para seguro, não há campos específicos além do valor
          break;

        case 'Serviço mecânico':
        // Para serviço mecânico, não há campos específicos além do estabelecimento
          break;

        case 'Financiamento':
          if (atividade.numeroParcela.isNotEmpty) {
            details.add(TimelineDetail(
              icon: Icons.payment,
              text: 'Parcela ${atividade.numeroParcela}',
            ));
          }
          break;

        case 'Compras':
        // Para compras, não há campos específicos além do estabelecimento
          break;

        case 'Impostos':
        // Para impostos, não há campos específicos
          break;

        case 'Outros':
        // Para outros, não há campos específicos além do estabelecimento
          break;
      }

      // CORREÇÃO: Estabelecimento sempre por último (quando presente)
      if (atividade.estabelecimento.isNotEmpty) {
        details.add(TimelineDetail(
          icon: Icons.location_on,
          text: atividade.estabelecimento,
        ));
      }
    } catch (e) {
      print('Erro ao construir detalhes da atividade: $e');
    }

    return details;
  }

  double? _getPriceFromAtividade(AtividadeStore atividade) {
    try {
      String priceString = '';

      // CORREÇÃO: Verificar totalPago primeiro, depois valorPago
      if (atividade.totalPago.isNotEmpty) {
        priceString = atividade.totalPago;
      }

      if (priceString.isNotEmpty) {
        // Remove caracteres não numéricos exceto vírgula e ponto
        priceString = priceString.replaceAll(RegExp(r'[^\d,.]'), '');
        // Substitui vírgula por ponto para conversão
        priceString = priceString.replaceAll(',', '.');
        return double.parse(priceString);
      }
    } catch (e) {
      print('Erro ao fazer parse do preço: $e');
    }

    return null;
  }

  IconData _getIconForAtividade(String tipoAtividade) {
    switch (tipoAtividade) {
      case 'Abastecimento':
        return Icons.local_gas_station;
      case 'Troca de óleo':
        return Icons.build_circle;
      case 'Lavagem':
        return Icons.local_car_wash;
      case 'Seguro':
        return Icons.security;
      case 'Serviço mecânico':
        return Icons.build;
      case 'Financiamento':
        return Icons.attach_money;
      case 'Compras':
        return Icons.shopping_cart;
      case 'Impostos':
        return Icons.receipt;
      case 'Outros':
        return Icons.more_horiz;
      default:
        return Icons.event;
    }
  }

  Color _getColorForAtividade(String tipoAtividade) {
    switch (tipoAtividade) {
      case 'Abastecimento':
        return const Color(0xFF2196F3); // Azul
      case 'Troca de óleo':
        return const Color(0xFF4CAF50); // Verde
      case 'Lavagem':
        return const Color(0xFF00BCD4); // Ciano
      case 'Seguro':
        return const Color(0xFF9C27B0); // Roxo
      case 'Serviço mecânico':
        return const Color(0xFFFF9800); // Laranja
      case 'Financiamento':
        return const Color(0xFFE91E63); // Rosa
      case 'Compras':
        return const Color(0xFF2196F3); // Azul
      case 'Impostos':
        return const Color(0xFFF44336); // Vermelho
      case 'Outros':
        return const Color(0xFF607D8B); // Azul acinzentado
      default:
        return const Color(0xFF9E9E9E); // Cinza
    }
  }

  Widget _buildTimelineTile({
    required TimelineItem item,
    required bool isFirst,
    required bool isLast,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: item.isWelcome ? 120 : 44,
        height: item.isWelcome ? 120 : 44,
        indicator: item.isWelcome
            ? Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/img/logo_black_app.png',
                ),
              )
            : Container(
          decoration: BoxDecoration(
            color: item.iconBackgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: item.emoji != null
                ? Text(
              item.emoji!,
              style: const TextStyle(fontSize: 24),
            )
                : Icon(
              item.icon,
              color: item.iconColor,
              size: 22,
            ),
          ),
        ),
        drawGap: true,
      ),
      beforeLineStyle: const LineStyle(
        color: Color(0xFFE0E0E0),
        thickness: 2,
      ),
      afterLineStyle: const LineStyle(
        color: Color(0xFFE0E0E0),
        thickness: 2,
      ),
      endChild: Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com título e data
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: item.isWelcome
                            ? RichText(
                          text: TextSpan(
                            text: '${item.title} ',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF424242),
                            ),
                            children: [
                              TextSpan(
                                text: item.subtitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1976D2),
                                ),
                              )
                            ],
                          ),
                        )
                            : item.isSpecial
                            ? Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF424242),
                          ),
                        )
                            : Text(
                          item.title,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      if (!item.isSpecial && !item.isWelcome)
                        Text(
                          _formatDateShort(item.date),
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                    ],
                  ),

                  // Data completa para atividades normais
                  if (!item.isSpecial && !item.isWelcome) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatDateFull(item.date),
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                  ],

                  // Detalhes da atividade
                  if (!item.isSpecial && !item.isWelcome && item.details.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...item.details.map((detail) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        children: [
                          Icon(
                            detail.icon,
                            size: 14,
                            color: const Color(0xFF9E9E9E),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              detail.text,
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF9E9E9E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],

                  // Preço
                  if (!item.isSpecial && !item.isWelcome && item.price != null) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'R\$ ${item.price!.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],

                  // Data para itens especiais
                  if (item.isSpecial) ...[
                    const SizedBox(height: 8),
                    Text(
                      _formatDateShort(item.date),
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Divider apenas se não for o último item
            if (!isLast)
              const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE0E0E0),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateShort(DateTime date) {
    try {
      return DateFormat('dd MMM', 'pt_BR').format(date).toLowerCase();
    } catch (e) {
      return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)}';
    }
  }

  String _formatDateFull(DateTime date) {
    try {
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = ['', 'jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
    return months[month] ?? 'jan';
  }
}

// Classes TimelineItem e TimelineDetail permanecem iguais
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