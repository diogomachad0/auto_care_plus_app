import 'package:auto_care_plus_app/app/shared/models/base_model.dart';
import 'package:auto_care_plus_app/app/shared/models/base_model_interface.dart';

class UsuarioModel implements IBaseModel {
  @override
  BaseModel base;

  String nomeCompleto;

  String email;

  String telefone;

  UsuarioModel({
    required this.base,
    required this.nomeCompleto,
    required this.email,
    required this.telefone,
  });
}
