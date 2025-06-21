import 'package:auto_care_plus_app/app/shared/models/base_model.dart';
import 'package:auto_care_plus_app/app/shared/models/base_model_interface.dart';

class UsuarioModel implements IBaseModel {
  @override
  BaseModel base;

  String nome;

  String email;

  String telefone;

  String senha;

  UsuarioModel({
    required this.base,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
  });
}
