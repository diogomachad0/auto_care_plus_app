import 'package:auto_care_plus_app/app/modules/atividade/atividade_controller.dart';
import 'package:auto_care_plus_app/app/modules/atividade/store/atividade_store.dart';
import 'package:auto_care_plus_app/app/modules/home/home_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';

part 'mapa_controller.g.dart';

class MapaController = _MapaControllerBase with _$MapaController;

class AtividadeAgrupada {
  final String estabelecimento;
  final LatLng coordenadas;
  final List<AtividadeStore> atividades;
  final double valorTotal;

  AtividadeAgrupada({
    required this.estabelecimento,
    required this.coordenadas,
    required this.atividades,
    required this.valorTotal,
  });
}

abstract class _MapaControllerBase with Store {
  final AtividadeController _atividadeController = Modular.get<AtividadeController>();

  @observable
  LatLng? myPosition;

  @computed
  get atividadesComLocalizacao =>
      _atividadeController.atividadesFiltradas
          .where((atividade) => atividade.hasCoordinates)
          .toList();

  @computed
  List<AtividadeAgrupada> get atividadesAgrupadas {
    final Map<String, List<AtividadeStore>> grupos = {};

    // Agrupa atividades por coordenadas (com tolerância para coordenadas próximas)
    for (var atividade in atividadesComLocalizacao) {
      if (atividade.hasCoordinates) {
        final lat = atividade.latitudeAsDouble!;
        final lng = atividade.longitudeAsDouble!;

        // Cria uma chave baseada nas coordenadas arredondadas (tolerância de ~100m)
        final chave = '${lat.toStringAsFixed(3)}_${lng.toStringAsFixed(3)}';

        if (!grupos.containsKey(chave)) {
          grupos[chave] = [];
        }
        grupos[chave]!.add(atividade);
      }
    }

    // Converte grupos em AtividadeAgrupada
    return grupos.entries.map((entry) {
      final atividades = entry.value;
      final primeiraAtividade = atividades.first;

      // Calcula o valor total do grupo
      double valorTotal = 0.0;
      for (var atividade in atividades) {
        if (atividade.totalPago.isNotEmpty) {
          valorTotal += CurrencyParser.parseToDouble(atividade.totalPago);
        }
      }

      return AtividadeAgrupada(
        estabelecimento: primeiraAtividade.estabelecimento,
        coordenadas: LatLng(
          primeiraAtividade.latitudeAsDouble!,
          primeiraAtividade.longitudeAsDouble!,
        ),
        atividades: atividades,
        valorTotal: valorTotal,
      );
    }).toList();
  }

  @computed
  get veiculos => _atividadeController.veiculos;

  @computed
  String? get veiculoSelecionadoId => _atividadeController.veiculoSelecionadoId;

  @computed
  String get nomeVeiculoSelecionado => _atividadeController.nomeVeiculoSelecionado;

  @action
  void setVeiculoSelecionado(String? veiculoId) {
    _atividadeController.setVeiculoSelecionado(veiculoId);
  }

  @action
  Future<void> mapaController() async {
    try {
      Position position = await _determinePosition();
      myPosition = LatLng(position.latitude, position.longitude);

      await Future.wait([
        _atividadeController.loadVeiculos(),
        _atividadeController.load(),
      ]);
    } catch (e) {}
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
