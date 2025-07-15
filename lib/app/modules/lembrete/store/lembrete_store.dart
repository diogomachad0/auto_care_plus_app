import 'package:auto_care_plus_app/app/modules/lembrete/models/lembrete_model.dart';
import 'package:auto_care_plus_app/app/shared/stores/base_store.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'lembrete_store.g.dart';

class LembreteStore = _LembreteStoreBase with _$LembreteStore;

abstract class LembreteStoreFactory {
  static LembreteStore fromModel(LembreteModel model) => LembreteStore(
    base: BaseStoreFactory.fromEntity(model.base),
    id: model.id,
    titulo: model.titulo,
    data: model.data,
    notificar: model.notificar,
  );

  static LembreteStore novo() => LembreteStore(
    base: BaseStoreFactory.novo(),
    id: const Uuid().v4(),
    titulo: '',
    data: DateTime.now(),
    notificar: false,
  );
}

abstract class _LembreteStoreBase with Store {
  @observable
  BaseStore base;

  @observable
  String id;

  @observable
  String titulo;

  @observable
  DateTime data;

  @observable
  bool notificar;

  _LembreteStoreBase({
    required this.base,
    required this.id,
    required this.titulo,
    required this.data,
    required this.notificar,
  });

  LembreteModel toModel() {
    return LembreteModel(
      base: base.toModel(),
      id: id.isNotEmpty ? id : null,
      titulo: titulo,
      data: data,
      notificar: notificar,
    );
  }
}
