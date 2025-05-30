import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
              MarkerLayer(
                markers: [
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
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
