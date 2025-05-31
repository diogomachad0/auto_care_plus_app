import 'package:uuid/uuid.dart';

class BaseModel {
  String id;
  DateTime? dataHoraCriado;
  DateTime? dataHoraDeletado;
  DateTime? dataHoraUltimaAlteracao;

  BaseModel({
    required this.id,
    this.dataHoraCriado,
    this.dataHoraDeletado,
    this.dataHoraUltimaAlteracao,
  });

  factory BaseModel.novo() => BaseModel(id: const Uuid().v1());

  bool get isDeleted => dataHoraDeletado != null;

  bool get isNew => dataHoraCriado == null;

  void setDataHoraCriado() {
    dataHoraCriado ??= DateTime.now();
  }

  BaseModel clone() => BaseModel(
    id: id,
    dataHoraCriado: dataHoraCriado,
    dataHoraUltimaAlteracao: dataHoraCriado,
    dataHoraDeletado: dataHoraDeletado,
  );
}
