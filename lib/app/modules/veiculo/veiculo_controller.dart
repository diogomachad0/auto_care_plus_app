import 'package:auto_care_plus_app/app/modules/veiculo/models/veiculo_model.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service_interface.dart';
import 'package:mobx/mobx.dart';

part 'veiculo_controller.g.dart';

class VeiculoController = _VeiculoControllerBase with _$VeiculoController;

abstract class _VeiculoControllerBase with Store {
  final IVeiculoService _service;

  @observable
  ObservableList<VeiculoModel> veiculos = ObservableList<VeiculoModel>();

  _VeiculoControllerBase(this._service);

  @action
  Future<void> load() async {
    final list = await _service.getAll();
    veiculos = list.asObservable();
  }

  @action
  Future<void> save(VeiculoModel model) async {
    await _service.saveOrUpdate(model);
    await load();
  }

  @action
  Future<void> delete(VeiculoModel model) async {
    await _service.delete(model);
    await load();
  }
}
