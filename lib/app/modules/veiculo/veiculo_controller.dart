import 'package:auto_care_plus_app/app/modules/veiculo/models/veiculo_model.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/store/veiculo_store.dart';
import 'package:mobx/mobx.dart';

part 'veiculo_controller.g.dart';

class VeiculoController = _VeiculoControllerBase with _$VeiculoController;

abstract class _VeiculoControllerBase with Store {
  final IVeiculoService _service;

  @observable
  VeiculoStore veiculo = VeiculoStoreFactory.novo();

  final veiculos = ObservableList<VeiculoModel>();

  _VeiculoControllerBase(this._service);

  Future<void> load() async {
    final lista = await _service.getAll();

    veiculos
      ..clear()
      ..addAll(lista);

    final model = lista.isNotEmpty ? lista.first : null;
    if (model != null) {
      veiculo = VeiculoStoreFactory.fromModel(model);
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

  @action
  Future<void> delete(VeiculoModel model) async {
    await _service.delete(model);
    await load();
  }
}
