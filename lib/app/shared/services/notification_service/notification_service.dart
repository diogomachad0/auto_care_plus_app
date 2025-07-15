import 'package:auto_care_plus_app/app/modules/lembrete/store/lembrete_store.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static final List<LembreteStore> _notificacoesDispararadas = [];
  static final Set<String> _notificacoesLidas = <String>{};

  static List<LembreteStore> get notificacoes => List.unmodifiable(_notificacoesDispararadas);

  static int get notificacaoNaoLidasCount => _notificacoesDispararadas.where((lembrete) => !_notificacoesLidas.contains(lembrete.id)).length;

  static bool get hasNotificacoesNaoLidas {
    return notificacaoNaoLidasCount > 0;
  }

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await _notifications.initialize(initializationSettings);
  }

  Future<void> showLembreteNotification({
    required int id,
    required String titulo,
    required DateTime data,
  }) async {
    final scheduledDate = DateTime(
      data.year,
      data.month,
      data.day,
      12,
      0,
      0,
    );

    final tz.TZDateTime scheduledTZ = tz.TZDateTime.from(scheduledDate, tz.local);

    if (scheduledTZ.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'lembrete_channel',
      'Lembretes',
      channelDescription: 'Notificações de lembretes do AutoCare+',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notifications.zonedSchedule(
      id,
      'Lembrete - AutoCare+',
      titulo,
      scheduledTZ,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  static void verificarLembretesVencidos(List<LembreteStore> lembretes) {
    final agora = DateTime.now();
    for (var lembrete in lembretes) {
      if (lembrete.notificar) {
        final dataNotificacao = DateTime(
          lembrete.data.year,
          lembrete.data.month,
          lembrete.data.day,
          12,
          0,
        );

        if ((dataNotificacao.isBefore(agora) || dataNotificacao.isAtSameMomentAs(agora))) {
          final jaExiste = _notificacoesDispararadas.any((n) => n.id == lembrete.id);

          if (!jaExiste) {
            _notificacoesDispararadas.insert(0, lembrete);
          }
        }
      }
    }
  }

  static void marcarTodasComoLidas() {
    for (var lembrete in _notificacoesDispararadas) {
      _notificacoesLidas.add(lembrete.id);
    }
  }

  static bool isLida(String lembreteId) {
    return _notificacoesLidas.contains(lembreteId);
  }

  static void limparNotificacoes() {
    _notificacoesDispararadas.clear();
    _notificacoesLidas.clear();
  }
}
