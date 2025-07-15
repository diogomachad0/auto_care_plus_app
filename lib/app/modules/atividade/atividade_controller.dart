import 'package:auto_care_plus_app/app/modules/atividade/services/atividade_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/atividade/store/atividade_store.dart';
import 'package:auto_care_plus_app/app/modules/home/home_screen.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/store/veiculo_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'atividade_controller.g.dart';

class AtividadeController = _AtividadeControllerBase with _$AtividadeController;

abstract class _AtividadeControllerBase with Store {
  final IAtividadeService _service;

  @observable
  String searchText = '';

  @observable
  AtividadeStore atividade = AtividadeStoreFactory.novo();

  @observable
  ObservableList<AtividadeStore> atividades = ObservableList<AtividadeStore>();

  @observable
  ObservableList<VeiculoStore> veiculos = ObservableList<VeiculoStore>();

  @observable
  String? veiculoSelecionadoId;

  _AtividadeControllerBase(this._service);

  @action
  void setEstabelecimentoComCoordenadas(String estabelecimento, double lat, double lng) {
    atividade.estabelecimento = estabelecimento;
    atividade.latitude = lat.toString();
    atividade.longitude = lng.toString();
  }

  @action
  void setVeiculoSelecionado(String? veiculoId) {
    veiculoSelecionadoId = veiculoId;
  }

  @computed
  List<AtividadeStore> get atividadesComCoordenadas {
    return atividades.where((a) => a.hasCoordinates && a.estabelecimento.isNotEmpty).toList();
  }

  @computed
  List<AtividadeStore> get atividadesFiltradas {
    var atividadesList = atividades.toList();

    if (veiculoSelecionadoId != null && veiculoSelecionadoId!.isNotEmpty) {
      atividadesList = atividadesList.where((a) => a.veiculoId == veiculoSelecionadoId).toList();
    }

    if (searchText.isEmpty) return atividadesList;

    final query = searchText.toLowerCase();
    return atividadesList.where((a) => a.tipoAtividade.toLowerCase().contains(query) || a.estabelecimento.toLowerCase().contains(query) || a.data.toLowerCase().contains(query)).toList();
  }

  @computed
  String get nomeVeiculoSelecionado {
    if (veiculoSelecionadoId == null || veiculoSelecionadoId!.isEmpty) {
      return 'Todos os veículos';
    }

    final veiculo = veiculos.firstWhere(
      (v) => v.base.id == veiculoSelecionadoId,
      orElse: () => VeiculoStoreFactory.novo(),
    );

    return veiculo.modelo.isNotEmpty ? '${veiculo.marca} ${veiculo.modelo}' : 'Veículo não encontrado';
  }

  @computed
  bool get isFormValid {
    final a = atividade;

    if (a.data.isEmpty || a.tipoAtividade.isEmpty || a.veiculoId.isEmpty) return false;

    switch (a.tipoAtividade) {
      case 'Abastecimento':
        return a.km.isNotEmpty && a.totalPago.isNotEmpty && a.litros.isNotEmpty && a.estabelecimento.isNotEmpty;

      case 'Troca de óleo':
        return a.km.isNotEmpty && a.totalPago.isNotEmpty && a.estabelecimento.isNotEmpty;

      case 'Lavagem':
        return a.totalPago.isNotEmpty && a.estabelecimento.isNotEmpty;

      case 'Seguro':
        return a.totalPago.isNotEmpty;

      case 'Serviço mecânico':
        return a.totalPago.isNotEmpty && a.estabelecimento.isNotEmpty;

      case 'Financiamento':
        return a.totalPago.isNotEmpty && a.numeroParcela.isNotEmpty;

      case 'Compras':
        return a.totalPago.isNotEmpty;

      case 'Impostos':
        return a.totalPago.isNotEmpty;

      case 'Outros':
        return a.totalPago.isNotEmpty && a.estabelecimento.isNotEmpty;

      default:
        return false;
    }
  }

  @action
  Future<void> loadVeiculos() async {
    try {
      final veiculoService = Modular.get<IVeiculoService>();
      final list = await veiculoService.getAll();

      veiculos.clear();
      for (var veiculo in list) {
        veiculos.add(VeiculoStoreFactory.fromModel(veiculo));
      }
    } catch (e) {
      veiculos.clear();
    }
  }

  Future<void> load() async {
    final list = await _service.getAll();

    atividades.clear();

    for (var atividade in list) {
      atividades.add(AtividadeStoreFactory.fromModel(atividade));
    }
  }

  @action
  Future<void> loadById(String id) async {
    final model = await _service.getById(id);
    if (model != null) {
      atividade = AtividadeStoreFactory.fromModel(model);
    }
  }

  @action
  Future<void> save() async {
    await _service.saveOrUpdate(atividade.toModel());
    await load();
  }

  Future<void> delete(AtividadeStore atividade) async {
    await _service.delete(atividade.toModel());
    atividades.remove(atividade);
  }

  @action
  void resetForm() {
    atividade = AtividadeStoreFactory.novo();
  }

  @computed
  String get veiculoSelecionadoNome {
    if (atividade.veiculoId.isEmpty) return '';
    final veiculo = veiculos.firstWhere(
      (v) => v.base.id == atividade.veiculoId,
      orElse: () => VeiculoStoreFactory.novo(),
    );
    return veiculo.modelo.isNotEmpty ? '${veiculo.marca} ${veiculo.modelo}' : '';
  }

  @computed
  List<AtividadeStore> get abastecimentos => atividadesFiltradas.where((a) => a.tipoAtividade == 'Abastecimento').toList();

  @computed
  List<AtividadeStore> get trocasOleo => atividadesFiltradas.where((a) => a.tipoAtividade == 'Troca de óleo').toList();

  @computed
  List<AtividadeStore> get lavagens => atividadesFiltradas.where((a) => a.tipoAtividade == 'Lavagem').toList();

  @computed
  List<AtividadeStore> get seguros => atividadesFiltradas.where((a) => a.tipoAtividade == 'Seguro').toList();

  @computed
  List<AtividadeStore> get servicosMecanicos => atividadesFiltradas.where((a) => a.tipoAtividade == 'Serviço mecânico').toList();

  @computed
  List<AtividadeStore> get financiamentos => atividadesFiltradas.where((a) => a.tipoAtividade == 'Financiamento').toList();

  @computed
  List<AtividadeStore> get compras => atividadesFiltradas.where((a) => a.tipoAtividade == 'Compras').toList();

  @computed
  List<AtividadeStore> get impostos => atividadesFiltradas.where((a) => a.tipoAtividade == 'Impostos').toList();

  @computed
  List<AtividadeStore> get outros => atividadesFiltradas.where((a) => a.tipoAtividade == 'Outros').toList();

  @computed
  double get totalGastoGeral {
    return atividadesFiltradas.fold(0.0, (total, atividade) {
      if (atividade.totalPago.isNotEmpty) {
        return total + CurrencyParser.parseToDouble(atividade.totalPago);
      }
      return total;
    });
  }

  @computed
  double get totalGastoAbastecimento {
    return abastecimentos.fold(0.0, (total, atividade) {
      if (atividade.totalPago.isNotEmpty) {
        return total + CurrencyParser.parseToDouble(atividade.totalPago);
      }
      return total;
    });
  }

  @computed
  double get totalGastoManutencao {
    final manutencoes = [...trocasOleo, ...servicosMecanicos];
    return manutencoes.fold(0.0, (total, atividade) {
      if (atividade.totalPago.isNotEmpty) {
        return total + CurrencyParser.parseToDouble(atividade.totalPago);
      }
      return total;
    });
  }

  @computed
  int get totalAtividadesDoVeiculo {
    return atividadesFiltradas.length;
  }

  List<AtividadeStore> getAtividadesPorPeriodo(DateTime inicio, DateTime fim) {
    return atividadesFiltradas.where((atividade) {
      try {
        final dataAtividade = _parseDate(atividade.data);
        return dataAtividade.isAfter(inicio.subtract(const Duration(days: 1))) && dataAtividade.isBefore(fim.add(const Duration(days: 1)));
      } catch (e) {
        return false;
      }
    }).toList();
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
    }
    return DateTime.now();
  }

  AtividadeStore? getUltimaAtividadePorTipo(String tipo) {
    final atividadesTipo = atividadesFiltradas.where((a) => a.tipoAtividade == tipo).toList();
    if (atividadesTipo.isEmpty) return null;

    atividadesTipo.sort((a, b) {
      final dataA = _parseDate(a.data);
      final dataB = _parseDate(b.data);
      return dataB.compareTo(dataA);
    });

    return atividadesTipo.first;
  }

  @action
  void limparFiltros() {
    veiculoSelecionadoId = null;
    searchText = '';
  }
}
