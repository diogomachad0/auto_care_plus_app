import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/store/veiculo_store.dart';
import 'package:mobx/mobx.dart';

part 'veiculo_controller.g.dart';

class VeiculoController = _VeiculoControllerBase with _$VeiculoController;

abstract class _VeiculoControllerBase with Store {
  final IVeiculoService _service;

  @observable
  String searchText = '';

  @observable
  VeiculoStore veiculo = VeiculoStoreFactory.novo();

  @observable
  ObservableList<VeiculoStore> veiculos = ObservableList<VeiculoStore>();

  _VeiculoControllerBase(this._service);

  @computed
  List<VeiculoStore> get veiculosFiltrados {
    if (searchText.isEmpty) return veiculos;

    final query = searchText.toLowerCase();
    return veiculos.where((v) => v.modelo.toLowerCase().contains(query)).toList();
  }

  @computed
  bool get isFormValid {
    final v = veiculo;

    return v.modelo.isNotEmpty && v.marca.isNotEmpty && v.placa.isNotEmpty && v.quilometragem > 0 && v.ano >= 1950 && v.ano <= 2026 && (v.tipoCombustivel.isNotEmpty);
  }

  Future<void> load() async {
    final list = await _service.getAll();

    veiculos.clear();

    for (var veiculo in list) {
      veiculos.add(VeiculoStoreFactory.fromModel(veiculo));
    }
  }

  @action
  Future<void> loadById(String id) async {
    final model = await _service.getById(id);
    if (model != null) {
      veiculo = VeiculoStoreFactory.fromModel(model);
    }
  }

  @action
  Future<void> save() async {
    await _service.saveOrUpdate(veiculo.toModel());

    await load();
  }

  Future<void> delete(VeiculoStore veiculo) async {
    await _service.delete(veiculo.toModel());

    veiculos.remove(veiculo);
  }
}
