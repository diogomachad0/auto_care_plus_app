import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';

part 'mapa_controller.g.dart';

class MapaController = _MapaController with _$MapaController;

abstract class _MapaController with Store {
  @observable
  double lat = 0.0;

  @observable
  double long = 0.0;

  @observable
  String erro = '';

  mapaController() {
    getPosicao();
  }

  @action
  getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      lat = posicao.latitude;
      long = posicao.longitude;
    } catch (e) {
      erro = e.toString();
    }
  }

  @action
  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;

    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error('Serviço de localização desativado.');
    }

    permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        return Future.error('Permissão de localização negada.');
      }
    }
    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Permissão de localização negada. Solicite novamente.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
