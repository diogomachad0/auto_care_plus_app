import 'package:auto_care_plus_app/app/shared/models/base_model.dart';
import 'package:auto_care_plus_app/app/shared/models/base_model_interface.dart';

class VeiculoModel implements IBaseModel {
  @override
  BaseModel base;

  String modelo;

  String marca;

  String placa;

  String ano;

  String quilometragem;

  String tipoCombustivel;

  String observacoes;

  VeiculoModel({
    required this.base,
    required this.modelo,
    required this.marca,
    required this.placa,
    required this.ano,
    required this.quilometragem,
    required this.tipoCombustivel,
    required this.observacoes,
  });
}
