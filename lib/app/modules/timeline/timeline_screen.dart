import 'package:auto_care_plus_app/app/modules/atividade/atividade_controller.dart';
import 'package:auto_care_plus_app/app/modules/atividade/store/atividade_store.dart';
import 'package:auto_care_plus_app/app/modules/home/home_screen.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_error.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../veiculo/store/veiculo_store.dart';
import 'submodules/filtro_widget.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> with ThemeMixin {
  late final AtividadeController _controller;
  bool _isLoading = true;
  String? _error;
  FiltroData? _filtroAtivo;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<AtividadeController>();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      await Future.wait([
        _controller.loadVeiculos(),
        _controller.load(),
      ]);
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

  void _showFilter() {
    showFiltroWidget(
      context,
      filtroAtual: _filtroAtivo,
      onSave: (FiltroData filtro) {
        setState(() {
          _filtroAtivo = filtro.hasFilters ? filtro : null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(child: _buildBody()),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48),
              Text(
                'Atividade',
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: _showFilter,
                child: SizedBox(
                  width: 48,
                  height: 28,
                  child: Center(
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 28,
                        ),
                        if (_filtroAtivo?.hasFilters == true)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
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
                  padding: const EdgeInsets.only(left: 0, right: 12),
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
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  iconEnabledColor: Colors.black54,
                ),
                hint: const Row(
                  children: [
                    Icon(Icons.directions_car),
                    SizedBox(width: 10),
                  ],
                ),
                style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
                selectedItemBuilder: (context) {
                  return [
                    null,
                    ...veiculos.map((v) => v.base.id),
                  ].map<Widget>((String? id) {
                    final isAll = id == null;
                    final veiculo = isAll
                        ? null
                        : veiculos.firstWhere(
                            (v) => v.base.id == id,
                            orElse: () => VeiculoStoreFactory.novo(),
                          );
                    return Row(
                      children: [
                        Icon(isAll ? Icons.south_east_rounded : Icons.directions_car),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isAll ? 'Todos os veículos' : '${veiculo!.modelo} - ${veiculo.placa}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  }).toList();
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
                        const SizedBox(width: 8),
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
                  }),
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

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colorScheme.secondary,
        ),
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

          return RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).padding.bottom + 30,
              ),
              itemCount: timelineItems.length,
              itemBuilder: (context, index) {
                final item = timelineItems[index];

                if (item.isMonthHeader) {
                  return _buildMonthHeader(item.title);
                }

                final isFirst = index == 0 || (index > 0 && timelineItems[index - 1].isMonthHeader);
                final isLast = index == timelineItems.length - 1;

                int? activityIndex;
                if (!item.isSpecial && !item.isWelcome) {
                  final originalAtividades = _getFilteredActivities();
                  for (int i = 0; i < originalAtividades.length; i++) {
                    final atividade = originalAtividades[i];
                    if (atividade.tipoAtividade == item.title && _parseDate(atividade.data).day == item.date.day && _parseDate(atividade.data).month == item.date.month && _parseDate(atividade.data).year == item.date.year) {
                      activityIndex = i;
                      break;
                    }
                  }
                }

                return _buildTimelineTile(
                  item: item,
                  isFirst: isFirst,
                  isLast: isLast,
                  activityIndex: activityIndex,
                );
              },
            ),
          );
        } catch (e) {
          return _buildErrorState(error: e.toString());
        }
      },
    );
  }

  Widget _buildMonthHeader(String monthYear) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFE0E0E0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                monthYear.toUpperCase(),
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFE0E0E0),
              ),
            ),
          ],
        ),
      ),
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
            onPressed: _loadData,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Observer(
      builder: (_) {
        final isFiltered = _controller.veiculoSelecionadoId != null;
        final hasActiveFilters = _filtroAtivo?.hasFilters == true;
        final veiculoNome = _controller.nomeVeiculoSelecionado;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasActiveFilters ? Icons.filter_list_off : Icons.timeline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                hasActiveFilters ? 'Nenhuma atividade encontrada com os filtros aplicados' : 'Nenhuma atividade encontrada',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                hasActiveFilters
                    ? 'Tente ajustar os filtros para ver mais resultados'
                    : isFiltered
                        ? 'Não há atividades para o veículo $veiculoNome'
                        : 'Adicione sua primeira atividade para começar!',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (hasActiveFilters)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _filtroAtivo = null;
                    });
                  },
                  child: const Text('Limpar Filtros'),
                )
              else if (isFiltered)
                TextButton(
                  onPressed: () {
                    _controller.setVeiculoSelecionado(null);
                  },
                  child: const Text('Ver todas as atividades'),
                ),
            ],
          ),
        );
      },
    );
  }

  List<AtividadeStore> _getFilteredActivities() {
    var atividades = _controller.atividadesFiltradas;

    if (_filtroAtivo != null) {
      atividades = atividades.where((atividade) {
        if (_filtroAtivo!.tipoAtividade != null && atividade.tipoAtividade != _filtroAtivo!.tipoAtividade) {
          return false;
        }

        final atividadeDate = _parseDate(atividade.data);
        if (_filtroAtivo!.dataInicio != null && atividadeDate.isBefore(_filtroAtivo!.dataInicio!)) {
          return false;
        }
        if (_filtroAtivo!.dataFim != null && atividadeDate.isAfter(_filtroAtivo!.dataFim!.add(const Duration(days: 1)))) {
          return false;
        }

        return true;
      }).toList();
    }

    return atividades;
  }

  List<TimelineItem> _buildTimelineItems() {
    final atividades = _getFilteredActivities();
    var items = <TimelineItem>[];

    for (var atividade in atividades) {
      try {
        items.add(_createTimelineItemFromAtividade(atividade));
      } catch (e) {}
    }

    items = items.reversed.toList();

    if (_filtroAtivo == null || !_filtroAtivo!.hasFilters) {
      items.add(TimelineItem(
        title: 'Você iniciou o controle de despesas do seu veículo com Auto Care!',
        date: DateTime.now().subtract(Duration(days: items.length + 1)),
        icon: Icons.star,
        iconColor: Colors.white,
        iconBackgroundColor: colorScheme.secondary,
        isSpecial: true,
        emoji: '🎉',
      ));
    }

    final itemsWithHeaders = <TimelineItem>[];
    String? currentMonth;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final monthYear = _formatMonthYear(item.date);

      if (currentMonth != monthYear) {
        itemsWithHeaders.add(TimelineItem(
          title: monthYear,
          date: item.date,
          icon: Icons.calendar_today,
          iconColor: Colors.transparent,
          iconBackgroundColor: Colors.transparent,
          isMonthHeader: true,
        ));
        currentMonth = monthYear;
      }

      itemsWithHeaders.add(item);
    }

    return itemsWithHeaders;
  }

  String _formatMonthYear(DateTime date) {
    try {
      return DateFormat('MMMM yyyy', 'pt_BR').format(date);
    } catch (e) {
      const months = ['', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
      return '${months[date.month]} ${date.year}';
    }
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
    } catch (e) {}

    return DateTime.now();
  }

  List<TimelineDetail> _buildDetailsForAtividade(AtividadeStore atividade) {
    final details = <TimelineDetail>[];

    try {
      switch (atividade.tipoAtividade) {
        case 'Abastecimento':
          if (atividade.km.isNotEmpty) {
            details.add(TimelineDetail(
              icon: Icons.speed,
              text: '${atividade.km} Km',
            ));
          }
          if (atividade.litros.isNotEmpty) {
            details.add(TimelineDetail(
              icon: Icons.local_gas_station,
              text: '${atividade.litros}L',
            ));
          }
          if (atividade.precoLitro.isNotEmpty) {
            details.add(TimelineDetail(
              icon: Icons.attach_money,
              text: '${atividade.precoLitro.replaceAll(RegExp(r'[^\d,\.]'), '')}/L',
            ));
          }
          if (atividade.tipoCombustivel.isNotEmpty) {
            details.add(TimelineDetail(
              icon: Icons.local_gas_station,
              text: atividade.tipoCombustivel,
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
          break;
        case 'Seguro':
          break;
        case 'Serviço mecânico':
          if (atividade.km.isNotEmpty) {
            details.add(TimelineDetail(
              icon: Icons.speed,
              text: '${atividade.km} Km',
            ));
          }
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
          break;
        case 'Impostos':
          break;
        case 'Outros':
          break;
      }

      if (atividade.estabelecimento.isNotEmpty) {
        details.add(TimelineDetail(
          icon: Icons.location_on,
          text: atividade.estabelecimento,
        ));
      }

      if (atividade.observacoes.isNotEmpty) {
        details.add(TimelineDetail(
          icon: Icons.note_add,
          text: atividade.observacoes,
        ));
      }
    } catch (e) {}

    return details;
  }

  double? _getPriceFromAtividade(AtividadeStore atividade) {
    try {
      if (atividade.totalPago.isNotEmpty) {
        final valor = CurrencyParser.parseToDouble(atividade.totalPago);
        return valor > 0 ? valor : null;
      }
    } catch (e) {}
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
        return colorScheme.secondary;
      case 'Troca de óleo':
        return colorScheme.secondary;
      case 'Lavagem':
        return colorScheme.secondary;
      case 'Seguro':
        return colorScheme.secondary;
      case 'Serviço mecânico':
        return colorScheme.secondary;
      case 'Financiamento':
        return colorScheme.secondary;
      case 'Compras':
        return colorScheme.secondary;
      case 'Impostos':
        return colorScheme.secondary;
      case 'Outros':
        return colorScheme.secondary;
      default:
        return colorScheme.secondary;
    }
  }

  Widget _buildTimelineTile({
    required TimelineItem item,
    required bool isFirst,
    required bool isLast,
    int? activityIndex,
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
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: item.isWelcome
                            ? RichText(
                                text: TextSpan(
                                  text: '${item.title} ',
                                  style: textTheme.bodyMedium?.copyWith(),
                                  children: [
                                    TextSpan(text: item.subtitle, style: textTheme.bodyMedium?.copyWith()),
                                  ],
                                ),
                              )
                            : item.isSpecial
                                ? Text(
                                    item.title,
                                    style: textTheme.bodyMedium?.copyWith(),
                                  )
                                : Text(
                                    item.title,
                                    style: textTheme.bodyMedium,
                                  ),
                      ),
                      if (!item.isSpecial && !item.isWelcome) ...[
                        Text(
                          _formatDateShort(item.date),
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                        if (activityIndex != null)
                          PopupMenuButton<String>(
                            offset: const Offset(-2, 8),
                            color: colorScheme.onPrimary,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                            onSelected: (value) async {
                              if (value == 'delete') {
                                try {
                                  final atividades = _getFilteredActivities();
                                  if (activityIndex < atividades.length) {
                                    await _controller.delete(atividades[activityIndex]);
                                  }
                                } catch (e, s) {
                                  await DialogError.show(context, 'Erro ao deletar atividade \nErro: ${e.toString()}', s);
                                }
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_forever_rounded, color: colorScheme.error),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Excluir',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ],
                  ),
                  if (!item.isSpecial && !item.isWelcome) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: const Color(0xFF9E9E9E),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatDateFull(item.date),
                          style: textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (!item.isSpecial && !item.isWelcome && item.details.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    ...item.details.map((detail) => Row(
                          children: [
                            Icon(
                              detail.icon,
                              size: 14,
                              color: const Color(0xFF9E9E9E),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                detail.text,
                                style: textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF9E9E9E),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                  if (!item.isSpecial && !item.isWelcome && item.price != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'R\$ ${item.price!.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                  if (item.isSpecial) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: const Color(0xFF9E9E9E),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDateShort(item.date),
                          style: textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
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
  final bool isMonthHeader;
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
    this.isMonthHeader = false,
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
