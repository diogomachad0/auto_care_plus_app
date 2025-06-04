import 'package:auto_care_plus_app/app/modules/atividade/models/atividade_model.dart';
import 'package:auto_care_plus_app/app/shared/stores/base_store.dart';
import 'package:mobx/mobx.dart';

part 'atividade_store.g.dart';

class AtividadeStore = _AtividadeStoreBase with _$AtividadeStore;

abstract class AtividadeStoreFactory {
  static AtividadeStore fromModel(AtividadeModel model) => AtividadeStore(
        base: BaseStoreFactory.fromEntity(model.base),
        tipoAtividade: model.tipoAtividade,
        data: model.data,
        km: model.km,
        totalPago: model.totalPago,
        valorPago: model.valorPago,
        litros: model.litros,
        precoLitro: model.precoLitro,
        tipoCombustivel: model.tipoCombustivel,
        estabelecimento: model.estabelecimento,
        numeroParcela: model.numeroParcela,
        observacoes: model.observacoes,
      );

  static AtividadeStore novo() => AtividadeStore(
        base: BaseStoreFactory.novo(),
        tipoAtividade: 'Abastecimento',
        data: '',
        km: '',
        totalPago: '',
        valorPago: '',
        litros: '',
        precoLitro: '',
        tipoCombustivel: 'Gasolina',
        estabelecimento: '',
        numeroParcela: '',
        observacoes: '',
      );
}

abstract class _AtividadeStoreBase with Store {
  @observable
  BaseStore base;

  @observable
  String tipoAtividade;

  @observable
  String data;

  @observable
  String km;

  @observable
  String totalPago;

  @observable
  String valorPago;

  @observable
  String litros;

  @observable
  String precoLitro;

  @observable
  String tipoCombustivel;

  @observable
  String estabelecimento;

  @observable
  String numeroParcela;

  @observable
  String observacoes;

  _AtividadeStoreBase({
    required this.base,
    required this.tipoAtividade,
    required this.data,
    required this.km,
    required this.totalPago,
    required this.valorPago,
    required this.litros,
    required this.precoLitro,
    required this.tipoCombustivel,
    required this.estabelecimento,
    required this.numeroParcela,
    required this.observacoes,
  });

  AtividadeModel toModel() {
    return AtividadeModel(
      base: base.toModel(),
      tipoAtividade: tipoAtividade,
      data: data,
      km: km,
      totalPago: totalPago,
      valorPago: valorPago,
      litros: litros,
      precoLitro: precoLitro,
      tipoCombustivel: tipoCombustivel,
      estabelecimento: estabelecimento,
      numeroParcela: numeroParcela,
      observacoes: observacoes,
    );
  }
}
