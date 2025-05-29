import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const dailyReminderTask = "dailyReminderTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == dailyReminderTask) {
      final notifications = FlutterLocalNotificationsPlugin();

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);
      await notifications.initialize(initSettings);

      notifications.show(
        0,
        'Araç Alım Uygulaması',
        'Yeni ilanlara göz attınız mı?',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel',
            'Hatırlatıcı',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }

    return Future.value(true);
  });
}
