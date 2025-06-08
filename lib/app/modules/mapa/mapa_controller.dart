import 'package:auto_care_plus_app/app/modules/atividade/atividade_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';

part 'mapa_controller.g.dart';

class MapaController = _MapaControllerBase with _$MapaController;

abstract class _MapaControllerBase with Store {
  final AtividadeController _atividadeController = Modular.get<AtividadeController>();

  @observable
  LatLng? myPosition;

  @computed
  get atividadesComLocalizacao => _atividadeController.atividadesComCoordenadas;

  @action
  Future<void> mapaController() async {
    try {
      Position position = await _determinePosition();
      myPosition = LatLng(position.latitude, position.longitude);
      print('Localização atual: $myPosition');

      await _atividadeController.load();
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
