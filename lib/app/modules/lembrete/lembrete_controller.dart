import 'package:auto_care_plus_app/app/modules/lembrete/services/lembrete_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/store/lembrete_store.dart';
import 'package:auto_care_plus_app/app/shared/services/notification_service/notification_service.dart';
import 'package:mobx/mobx.dart';

part 'lembrete_controller.g.dart';

class LembreteController = _LembreteControllerBase with _$LembreteController;

abstract class _LembreteControllerBase with Store {
  final ILembreteService _service;
  final NotificationService _notificationService = NotificationService();

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
    final model = lembrete.toModel();
    await _service.saveOrUpdate(model);

    // Se o lembrete deve notificar, criar a notificação
    if (lembrete.notificar) {
      await _showLembreteNotification(model);
    }

    await load();
  }

  Future<void> _showLembreteNotification(dynamic lembreteModel) async {
    final int notificationId = '${lembreteModel.titulo}${lembreteModel.data.millisecondsSinceEpoch}'.hashCode;

    await _notificationService.showLembreteNotification(
      id: notificationId,
      titulo: lembreteModel.titulo,
      data: lembreteModel.data,
    );
  }

  Future<void> delete(LembreteStore lembrete) async {
    if (lembrete.notificar) {
      final int notificationId = '${lembrete.titulo}${lembrete.data.millisecondsSinceEpoch}'.hashCode;
      await _notificationService.cancelNotification(notificationId);
    }

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
