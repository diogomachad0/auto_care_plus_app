import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';
import 'package:geolocator/geolocator.dart';

part 'mapa_controller.g.dart';

class MapaController = _MapaControllerBase with _$MapaController;

abstract class _MapaControllerBase with Store {
  @observable
  LatLng? myPosition;

  @action
  Future<void> mapaController() async {
    try {
      Position position = await _determinePosition();
      myPosition = LatLng(position.latitude, position.longitude);
      print('Localização atual: $myPosition');
    } catch (e) {
      print('Erro ao obter localização: $e');
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão negada');
      }
    }
    return await Geolocator.getCurrentPosition();
  }
}
