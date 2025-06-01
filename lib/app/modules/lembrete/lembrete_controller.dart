import 'package:auto_care_plus_app/app/modules/lembrete/services/lembrete_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/store/lembrete_store.dart';
import 'package:mobx/mobx.dart';

part 'lembrete_controller.g.dart';

class LembreteController = _LembreteControllerBase with _$LembreteController;

abstract class _LembreteControllerBase with Store {
  final ILembreteService _service;

  @observable
  String searchText = '';

  @observable
  LembreteStore lembrete = LembreteStoreFactory.novo();

  @observable
  ObservableList<LembreteStore> lembretes = ObservableList<LembreteStore>();

  _LembreteControllerBase(this._service);

  Future<void> load() async {
    final list = await _service.getAll();
    lembretes.clear();
    for (var lemb in list) {
      lembretes.add(LembreteStoreFactory.fromModel(lemb));
    }
  }

  @action
  Future<void> save() async {
    await _service.saveOrUpdate(lembrete.toModel());
    lembrete = LembreteStoreFactory.novo();
    await load();
  }

  Future<void> delete(LembreteStore lembrete) async {
    await _service.delete(lembrete.toModel());
    lembretes.remove(lembrete);
  }

  @action
  void updateLembrete(String titulo, DateTime data, bool notificar) {
    lembrete.titulo = titulo;
    lembrete.data = data;
    lembrete.notificar = notificar;
  }
}
