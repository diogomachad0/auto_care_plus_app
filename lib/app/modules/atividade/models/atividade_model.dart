import 'package:auto_care_plus_app/app/shared/models/base_model.dart';
import 'package:auto_care_plus_app/app/shared/models/base_model_interface.dart';

class AtividadeModel implements IBaseModel {
  @override
  BaseModel base;

  String tipoAtividade;

  String data;

  String km;

  String totalPago;

  String valorPago;

  String litros;

  String precoLitro;

  String tipoCombustivel;

  String estabelecimento;

  String numeroParcela;

  String observacoes;

  AtividadeModel({
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
}
