import 'package:auto_care_plus_app/app/modules/home/home_screen.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_info.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';

import 'mapa_controller.dart';
import 'widgets/simple_map_marker.dart';

const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1IjoiZGlvZ29tYWNoYWRvIiwiYSI6ImNtYjc2dXkwaDA3NGUyam4wMnJ4cHJyc2MifQ.UCZ3qN_mb80hb82sa6jmog';

class MapaScreen extends StatefulWidget {
  MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> with ThemeMixin {
  final MapaController controller = Modular.get<MapaController>();

  @override
  void initState() {
    super.initState();
    controller.mapaController();
  }

  double _getResponsiveIconSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 360) {
      return 24.0;
    } else if (screenWidth < 600) {
      return 28.0 + (screenWidth - 360) * 0.017;
    } else {
      return 36.0;
    }
  }

  double _getResponsiveShadowOffset(BuildContext context) {
    final iconSize = _getResponsiveIconSize(context);
    return iconSize * 0.07;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(child: _buildMap()),
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
                'Mapa',
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
              final veiculos = controller.veiculos;

              return DropdownButtonFormField2<String?>(
                isExpanded: true,
                value: controller.veiculoSelecionadoId,
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
                      SizedBox(width: 10),
                      Expanded(
                      child: Text(
                      '${veiculo.modelo} - ${veiculo.placa}',
                      overflow: TextOverflow.ellipsis,
                      ),
                      ),
                      ]
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
                          color: controller.veiculoSelecionadoId == null ? colorScheme.primary : colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Todos os veículos',
                          style: textTheme.bodyMedium?.copyWith(
                            color: controller.veiculoSelecionadoId == null ? colorScheme.primary : colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...veiculos.map((veiculo) {
                    final isSelected = controller.veiculoSelecionadoId == veiculo.base.id;
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
                  controller.setVeiculoSelecionado(newValue);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Observer(
      builder: (_) {
        if (controller.myPosition == null) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.secondary,
            ),
          );
        }

        List<Marker> markers = [];

        // Usa atividades agrupadas ao invés de individuais
        for (var grupo in controller.atividadesAgrupadas) {
          final priceText = 'R\$ ${grupo.valorTotal.toStringAsFixed(2).replaceAll('.', ',')}';

          markers.add(
            Marker(
              width: 90,
              height: 65,
              point: grupo.coordenadas,
              builder: (context) {
                return SimpleMapMarker(
                  price: priceText,
                  activityCount: grupo.atividades.length,
                  onTap: () {
                    _showAtividadesInfo(context, grupo);
                  },
                );
              },
            ),
          );
        }

        return FlutterMap(
          options: MapOptions(
            center: controller.myPosition,
            minZoom: 5,
            zoom: 18,
            maxZoom: 20,
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
          nonRotatedChildren: [
            TileLayer(
              urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
              additionalOptions: const {
                'accessToken': MAPBOX_ACCESS_TOKEN,
                'id': 'mapbox/streets-v12',
              },
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }

  void _showAtividadesInfo(BuildContext context, AtividadeAgrupada grupo) {
    String message = 'Estabelecimento: ${grupo.estabelecimento}\n';
    message += 'Total de atividades: ${grupo.atividades.length}\n';
    message += 'Valor total: R\$ ${grupo.valorTotal.toStringAsFixed(2).replaceAll('.', ',')}\n\n';

    message += 'Detalhes das atividades:\n';

    for (int i = 0; i < grupo.atividades.length; i++) {
      final atividade = grupo.atividades[i];
      message += '${i + 1}. ${atividade.tipoAtividade}\n';
      message += '   Data: ${atividade.data}\n';

      if (atividade.totalPago.isNotEmpty) {
        final valor = CurrencyParser.parseToDouble(atividade.totalPago);
        message += '   Valor: R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}\n';
      }

      if (atividade.km.isNotEmpty) {
        message += '   Km: ${atividade.km}\n';
      }

      if (i < grupo.atividades.length - 1) {
        message += '\n';
      }
    }

    DialogInfo.show(
      context,
      'Atividades no local',
      message,
    );
  }
}
