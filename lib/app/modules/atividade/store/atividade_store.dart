import 'package:auto_care_plus_app/app/modules/atividade/models/atividade_model.dart';
import 'package:auto_care_plus_app/app/shared/stores/base_store.dart';
import 'package:mobx/mobx.dart';

part 'atividade_store.g.dart';

class AtividadeStore = _AtividadeStoreBase with _$AtividadeStore;

abstract class AtividadeStoreFactory {
  static AtividadeStore fromModel(AtividadeModel model) => AtividadeStore(
        base: BaseStoreFactory.fromEntity(model.base),
        veiculoId: model.veiculoId,
        tipoAtividade: model.tipoAtividade,
        data: model.data,
        km: model.km,
        totalPago: model.totalPago,
        litros: model.litros,
        tipoCombustivel: model.tipoCombustivel,
        estabelecimento: model.estabelecimento,
        numeroParcela: model.numeroParcela,
        observacoes: model.observacoes,
        latitude: model.latitude?.toString() ?? '',
        longitude: model.longitude?.toString() ?? '',
      );

  static AtividadeStore novo() => AtividadeStore(
        base: BaseStoreFactory.novo(),
        veiculoId: '',
        tipoAtividade: 'Abastecimento',
        data: '',
        km: '',
        totalPago: '',
        litros: '',
        tipoCombustivel: 'Gasolina',
        estabelecimento: '',
        numeroParcela: '',
        observacoes: '',
        latitude: '',
        longitude: '',
      );
}

abstract class _AtividadeStoreBase with Store {
  @observable
  BaseStore base;

  @observable
  String veiculoId;

  @observable
  String tipoAtividade;

  @observable
  String data;

  @observable
  String km;

  @observable
  String totalPago;

  @observable
  String litros;

  @observable
  String tipoCombustivel;

  @observable
  String estabelecimento;

  @observable
  String numeroParcela;

  @observable
  String observacoes;

  @observable
  String latitude;

  @observable
  String longitude;

  _AtividadeStoreBase({
    required this.base,
    required this.veiculoId,
    required this.tipoAtividade,
    required this.data,
    required this.km,
    required this.totalPago,
    required this.litros,
    required this.tipoCombustivel,
    required this.estabelecimento,
    required this.numeroParcela,
    required this.observacoes,
    required this.latitude,
    required this.longitude,
  });

  AtividadeModel toModel() {
    return AtividadeModel(
      base: base.toModel(),
      veiculoId: veiculoId,
      tipoAtividade: tipoAtividade,
      data: data,
      km: km,
      totalPago: totalPago,
      litros: litros,
      tipoCombustivel: tipoCombustivel,
      estabelecimento: estabelecimento,
      numeroParcela: numeroParcela,
      observacoes: observacoes,
      latitude: latitude.isNotEmpty ? double.tryParse(latitude) : null,
      longitude: longitude.isNotEmpty ? double.tryParse(longitude) : null,
    );
  }

  double? get latitudeAsDouble => latitude.isNotEmpty ? double.tryParse(latitude) : null;

  double? get longitudeAsDouble => longitude.isNotEmpty ? double.tryParse(longitude) : null;

  bool get hasCoordinates => latitudeAsDouble != null && longitudeAsDouble != null;
}
