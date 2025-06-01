import 'package:auto_care_plus_app/app/shared/models/base_model.dart';
import 'package:auto_care_plus_app/app/shared/models/base_model_interface.dart';
import 'package:uuid/uuid.dart';

class LembreteModel implements IBaseModel {
  @override
  BaseModel base;

  final String id;

  final String titulo;

  final DateTime data;

  final bool notificar;

  LembreteModel({
    required this.base,
    String? id,
    required this.titulo,
    required this.data,
    required this.notificar,
  }) : id = id ?? const Uuid().v4();
}
