import 'package:auto_care_plus_app/app/modules/veiculo/models/veiculo_model.dart';
import 'package:auto_care_plus_app/app/shared/stores/base_store.dart';
import 'package:mobx/mobx.dart';

part 'veiculo_store.g.dart';

class VeiculoStore = _VeiculoStoreBase with _$VeiculoStore;

abstract class VeiculoStoreFactory {
  static VeiculoStore fromModel(VeiculoModel model) => VeiculoStore(
    base: BaseStoreFactory.fromEntity(model.base),
    modelo: model.modelo,
    marca: model.marca,
    placa: model.placa,
    ano: int.tryParse(model.ano) ?? 0,
    quilometragem: int.tryParse(model.quilometragem) ?? 0,
    tipoCombustivel: model.tipoCombustivel,
    observacoes: model.observacoes,
  );

  static VeiculoStore novo() => VeiculoStore(
    base: BaseStoreFactory.novo(),
    modelo: '',
    marca: '',
    placa: '',
    ano: 0,
    quilometragem: 0,
    tipoCombustivel: 'Flex',
    observacoes: '',
  );
}

abstract class _VeiculoStoreBase with Store {
  @observable
  BaseStore base;

  @observable
  String modelo;

  @observable
  String marca;

  @observable
  String placa;

  @observable
  int ano;

  @observable
  int quilometragem;

  @observable
  String tipoCombustivel;

  @observable
  String observacoes;

  _VeiculoStoreBase({
    required this.base,
    required this.modelo,
    required this.marca,
    required this.placa,
    required this.ano,
    required this.quilometragem,
    required this.tipoCombustivel,
    required this.observacoes,
  });

  VeiculoModel toModel() {
    return VeiculoModel(
      base: base.toModel(),
      modelo: modelo,
      marca: marca,
      placa: placa,
      ano: ano.toString(),
      quilometragem: quilometragem.toString(),
      tipoCombustivel: tipoCombustivel,
      observacoes: observacoes,
    );
  }
}
