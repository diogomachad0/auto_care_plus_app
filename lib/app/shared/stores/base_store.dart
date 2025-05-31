import 'package:auto_care_plus_app/app/shared/models/base_model.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'base_store.g.dart';

class BaseStore = _BaseStoreBase with _$BaseStore;

abstract class BaseStoreFactory {
  static BaseStore fromEntity(BaseModel model) => BaseStore(
    id: model.id,
    dataHoraCriado: model.dataHoraCriado,
    dataHoraUltimaAlteracao: model.dataHoraUltimaAlteracao,
    dataHoraDeletado: model.dataHoraDeletado,
  );

  static BaseStore novo() => BaseStore(
    id: const Uuid().v1(),
    dataHoraCriado: null,
    dataHoraUltimaAlteracao: null,
    dataHoraDeletado: null,
  );
}

abstract class _BaseStoreBase with Store {
  @observable
  String id;

  @observable
  DateTime? dataHoraCriado;

  @observable
  DateTime? dataHoraUltimaAlteracao;

  @observable
  DateTime? dataHoraDeletado;

  bool get deletado => dataHoraDeletado != null;

  _BaseStoreBase({
    required this.id,
    this.dataHoraCriado,
    this.dataHoraUltimaAlteracao,
    this.dataHoraDeletado,
  });

  BaseModel toModel() => BaseModel(
    id: id,
    dataHoraCriado: dataHoraCriado,
    dataHoraUltimaAlteracao: dataHoraUltimaAlteracao,
    dataHoraDeletado: dataHoraDeletado,
  );

  BaseStore clone() => BaseStore(
    id: id,
    dataHoraCriado: dataHoraCriado,
    dataHoraUltimaAlteracao: dataHoraUltimaAlteracao,
    dataHoraDeletado: dataHoraDeletado,
  );
}
