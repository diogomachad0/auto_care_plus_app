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
    try {
      final model = lembrete.toModel();
      await _service.saveOrUpdate(model);

      if (lembrete.notificar) {
        await _scheduleNotification(model);
      }

      _resetLembrete();

      await load();
    } catch (e) {
      print('Erro ao salvar lembrete: $e');
      rethrow;
    }
  }

  @action
  void _resetLembrete() {
    lembrete = LembreteStoreFactory.novo();
  }

  Future<void> _scheduleNotification(dynamic lembreteModel) async {
    try {
      final int notificationId = _generateNotificationId(lembreteModel);

      await _notificationService.showLembreteNotification(
        id: notificationId,
        titulo: lembreteModel.titulo,
        data: lembreteModel.data,
      );

      print('Lembrete agendado: ${lembreteModel.titulo} para ${lembreteModel.data} às 12:00:00');
    } catch (e) {
      print('Erro ao agendar notificação: $e');
    }
  }

  int _generateNotificationId(dynamic lembreteModel) {
    return '${lembreteModel.titulo}${lembreteModel.data.millisecondsSinceEpoch}'.hashCode;
  }

  Future<void> delete(LembreteStore lembrete) async {
    try {
      if (lembrete.notificar) {
        final int notificationId = _generateNotificationId(lembrete.toModel());
        await _notificationService.cancelNotification(notificationId);
        print('Notificação cancelada para: ${lembrete.titulo}');
      }

      await _service.delete(lembrete.toModel());
      lembretes.remove(lembrete);
    } catch (e) {
      print('Erro ao deletar lembrete: $e');
      rethrow;
    }
  }

  @action
  void updateLembrete(String titulo, DateTime data, bool notificar) {
    if (lembrete.id.isEmpty) {
      lembrete = LembreteStoreFactory.novo();
    }

    lembrete.titulo = titulo;
    lembrete.data = data;
    lembrete.notificar = notificar;
  }

  Future<void> rescheduleAllNotifications() async {
    for (var lembreteItem in lembretes) {
      if (lembreteItem.notificar && lembreteItem.data.isAfter(DateTime.now())) {
        await _scheduleNotification(lembreteItem.toModel());
      }
    }
  }

  Future<void> debugPendingNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    print('Notificações pendentes: ${pending.length}');
    for (var notification in pending) {
      print('ID: ${notification.id}, Título: ${notification.title}, Body: ${notification.body}');
    }
  }
}
