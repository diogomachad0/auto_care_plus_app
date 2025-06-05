import 'package:auto_care_plus_app/app/modules/atividade/services/atividade_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/atividade/store/atividade_store.dart';
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

  _AtividadeControllerBase(this._service);

  @computed
  List<AtividadeStore> get atividadesFiltradas {
    if (searchText.isEmpty) return atividades;

    final query = searchText.toLowerCase();
    return atividades.where((a) =>
    a.tipoAtividade.toLowerCase().contains(query) ||
        a.estabelecimento.toLowerCase().contains(query) ||
        a.data.toLowerCase().contains(query)
    ).toList();
  }

  @computed
  bool get isFormValid {
    final a = atividade;

    // Validação básica - data e tipo sempre obrigatórios
    if (a.data.isEmpty || a.tipoAtividade.isEmpty) return false;

    // Validações específicas por tipo de atividade
    switch (a.tipoAtividade) {
      case 'Abastecimento':
        return a.km.isNotEmpty &&
            a.totalPago.isNotEmpty &&
            a.litros.isNotEmpty &&
            a.estabelecimento.isNotEmpty;

      case 'Troca de óleo':
        return a.km.isNotEmpty &&
            a.totalPago.isNotEmpty &&
            a.estabelecimento.isNotEmpty;

      case 'Lavagem':
        return a.totalPago.isNotEmpty &&
            a.estabelecimento.isNotEmpty;

      case 'Seguro':
        return a.totalPago.isNotEmpty;

      case 'Serviço mecânico':
        return a.totalPago.isNotEmpty &&
            a.estabelecimento.isNotEmpty;

      case 'Financiamento':
        return a.totalPago.isNotEmpty &&
            a.numeroParcela.isNotEmpty;

      case 'Compras':
        return a.totalPago.isNotEmpty;

      case 'Impostos':
        return a.totalPago.isNotEmpty;

      case 'Outros':
        return a.totalPago.isNotEmpty &&
            a.estabelecimento.isNotEmpty;

      default:
        return false;
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

  // Métodos para filtrar atividades por tipo
  @computed
  List<AtividadeStore> get abastecimentos =>
      atividades.where((a) => a.tipoAtividade == 'Abastecimento').toList();

  @computed
  List<AtividadeStore> get trocasOleo =>
      atividades.where((a) => a.tipoAtividade == 'Troca de óleo').toList();

  @computed
  List<AtividadeStore> get lavagens =>
      atividades.where((a) => a.tipoAtividade == 'Lavagem').toList();

  @computed
  List<AtividadeStore> get seguros =>
      atividades.where((a) => a.tipoAtividade == 'Seguro').toList();

  @computed
  List<AtividadeStore> get servicosMecanicos =>
      atividades.where((a) => a.tipoAtividade == 'Serviço mecânico').toList();

  @computed
  List<AtividadeStore> get financiamentos =>
      atividades.where((a) => a.tipoAtividade == 'Financiamento').toList();

  @computed
  List<AtividadeStore> get compras =>
      atividades.where((a) => a.tipoAtividade == 'Compras').toList();

  @computed
  List<AtividadeStore> get impostos =>
      atividades.where((a) => a.tipoAtividade == 'Impostos').toList();

  @computed
  List<AtividadeStore> get outros =>
      atividades.where((a) => a.tipoAtividade == 'Outros').toList();
}