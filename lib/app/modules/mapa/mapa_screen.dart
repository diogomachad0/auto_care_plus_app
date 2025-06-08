import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';

import 'mapa_controller.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZGlvZ29tYWNoYWRvIiwiYSI6ImNtYjc2dXkwaDA3NGUyam4wMnJ4cHJyc2MifQ.UCZ3qN_mb80hb82sa6jmog';

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
          'Mapa',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: Observer(
        builder: (_) {
          if (controller.myPosition == null) {
            return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.secondary,
                ));
          }

          // Cria lista de markers
          List<Marker> markers = [
            // Marker da posição atual
            Marker(
              point: controller.myPosition!,
              builder: (context) {
                return const Icon(
                  Icons.person_pin,
                  color: Colors.blueAccent,
                  size: 40,
                );
              },
            ),
          ];

          // Adiciona markers das atividades
          for (var atividade in controller.atividadesComLocalizacao) {
            if (atividade.hasCoordinates) {
              markers.add(
                Marker(
                  point: LatLng(atividade.latitudeAsDouble!, atividade.longitudeAsDouble!),
                  builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        _showAtividadeInfo(context, atividade);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _getActivityColor(atividade.tipoAtividade),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          _getActivityIcon(atividade.tipoAtividade),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
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
                urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: const {
                  'accessToken': MAPBOX_ACCESS_TOKEN,
                  'id': 'mapbox/streets-v12',
                },
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }

  void _showAtividadeInfo(BuildContext context, atividade) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                _getActivityIcon(atividade.tipoAtividade),
                color: _getActivityColor(atividade.tipoAtividade),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  atividade.tipoAtividade,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Estabelecimento: ${atividade.estabelecimento}'),
              const SizedBox(height: 4),
              Text('Data: ${atividade.data}'),
              if (atividade.totalPago.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Total pago: R\$ ${atividade.totalPago}'),
              ],
              if (atividade.km.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Km: ${atividade.km}'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Color _getActivityColor(String activityType) {
    switch (activityType) {
      case 'Abastecimento':
        return Colors.green;
      case 'Troca de óleo':
        return Colors.orange;
      case 'Lavagem':
        return Colors.blue;
      case 'Seguro':
        return Colors.purple;
      case 'Serviço mecânico':
        return Colors.red;
      case 'Financiamento':
        return Colors.teal;
      case 'Compras':
        return Colors.pink;
      case 'Impostos':
        return Colors.brown;
      default:
        return Colors.grey;
    }
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
}
