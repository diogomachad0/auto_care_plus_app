import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

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
      print('Data do lembrete é no passado, não será agendado: $scheduledDate');
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

    print('Notificação agendada para: $scheduledDate (ID: $id)');
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    print('Notificação cancelada (ID: $id)');
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
