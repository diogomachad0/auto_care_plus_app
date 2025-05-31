import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/store/veiculo_store.dart';
import 'package:mobx/mobx.dart';

part 'veiculo_controller.g.dart';

class VeiculoController = _VeiculoControllerBase with _$VeiculoController;

abstract class _VeiculoControllerBase with Store {
  final IVeiculoService _service;

  @observable
  VeiculoStore veiculo = VeiculoStoreFactory.novo();

  final veiculos = ObservableList<VeiculoStore>();

  _VeiculoControllerBase(this._service);

  Future<void> load() async {
    final list = await _service.getAll();

    for (var veiculo in list) {
      veiculos.add(VeiculoStoreFactory.fromModel(veiculo));
    }
  }

  Future<void> loadById(String id) async {
    final model = await _service.getById(id);
    if (model != null) {
      veiculo = VeiculoStoreFactory.fromModel(model);
    }
  }

  Future<void> save() async {
    await _service.saveOrUpdate(veiculo.toModel());
  }

  Future<void> delete(VeiculoStore veiculo) async {
    await _service.delete(veiculo.toModel());

    veiculos.remove(veiculo);
  }
}
