import 'package:auto_care_plus_app/app/modules/atividade/services/atividade_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/atividade/store/atividade_store.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/store/veiculo_store.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final IVeiculoService _veiculoService;
  final IAtividadeService _atividadeService;

  @observable
  ObservableList<VeiculoStore> veiculos = ObservableList<VeiculoStore>();

  @observable
  ObservableList<AtividadeStore> atividades = ObservableList<AtividadeStore>();

  @observable
  String? veiculoSelecionadoId;

  @observable
  bool isLoading = false;

  _HomeControllerBase(this._veiculoService, this._atividadeService);

  @computed
  String get nomeVeiculoSelecionado {
    if (veiculoSelecionadoId == null) return 'Todos os veículos';

    final veiculo = veiculos.firstWhere(
          (v) => v.base.id == veiculoSelecionadoId,
      orElse: () => VeiculoStoreFactory.novo(),
    );

    return '${veiculo.modelo} - ${veiculo.placa}';
  }

  @computed
  List<AtividadeStore> get atividadesFiltradas {
    if (veiculoSelecionadoId == null) {
      return atividades;
    }

    return atividades.where((atividade) =>
    atividade.veiculoId == veiculoSelecionadoId
    ).toList();
  }

  @computed
  Map<String, double> get gastosCategorizados {
    final gastos = <String, double>{
      'Reabastecimento': 0.0,
      'Troca de Óleo': 0.0,
      'Lavagem': 0.0,
      'Seguro': 0.0,
      'Serviço Mecânico': 0.0,
      'Outros': 0.0,
    };

    for (var atividade in atividadesFiltradas) {
      final valor = _parseValor(atividade.totalPago);
      final categoria = _mapearCategoria(atividade.tipoAtividade ?? '');

      if (gastos.containsKey(categoria)) {
        gastos[categoria] = gastos[categoria]! + valor;
      } else {
        gastos['Outros'] = gastos['Outros']! + valor;
      }
    }

    return gastos;
  }

  @computed
  double get totalGastos {
    return gastosCategorizados.values.fold(0.0, (sum, valor) => sum + valor);
  }

  Future<void> loadVeiculos() async {
    try {
      isLoading = true;
      final list = await _veiculoService.getAll();

      veiculos.clear();
      for (var veiculo in list) {
        veiculos.add(VeiculoStoreFactory.fromModel(veiculo));
      }
    } catch (e) {
      print('Erro ao carregar veículos: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> loadAtividades() async {
    try {
      isLoading = true;
      final list = await _atividadeService.getAll();

      atividades.clear();
      for (var atividade in list) {
        atividades.add(AtividadeStoreFactory.fromModel(atividade));
      }
    } catch (e) {
      print('Erro ao carregar atividades: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> load() async {
    await Future.wait([
      loadVeiculos(),
      loadAtividades(),
    ]);
  }

  @action
  void setVeiculoSelecionado(String? veiculoId) {
    veiculoSelecionadoId = veiculoId;
  }

  double _parseValor(String? valor) {
    if (valor == null || valor.isEmpty) return 0.0;

    try {
      String valorLimpo = valor.replaceAll(RegExp(r'[^\d,.]'), '');
      valorLimpo = valorLimpo.replaceAll(',', '.');
      return double.parse(valorLimpo);
    } catch (e) {
      return 0.0;
    }
  }

  String _mapearCategoria(String tipoAtividade) {
    switch (tipoAtividade.toLowerCase()) {
      case 'abastecimento':
        return 'Reabastecimento';
      case 'troca de óleo':
        return 'Troca de Óleo';
      case 'lavagem':
        return 'Lavagem';
      case 'seguro':
        return 'Seguro';
      case 'serviço mecânico':
        return 'Serviço Mecânico';
      case 'financiamento':
      case 'compras':
      case 'impostos':
      case 'outros':
      default:
        return 'Outros';
    }
  }
}