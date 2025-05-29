import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FavoriteSummaryNotifier {
  final FlutterLocalNotificationsPlugin _notifPlugin =
      FlutterLocalNotificationsPlugin();

  FavoriteSummaryNotifier() {
    _initialize();
  }

  void _initialize() {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    _notifPlugin.initialize(initSettings);
  }

  Future<void> scheduleDailySummary(int favoriteCount) async {
    final istanbul = tz.getLocation('Europe/Istanbul');
    final now = tz.TZDateTime.now(istanbul);
    final scheduleTime =
        tz.TZDateTime(istanbul, now.year, now.month, now.day, 9);

    final firstTrigger =
        scheduleTime.isBefore(now) ? scheduleTime.add(const Duration(days: 1)) : scheduleTime;

    await _notifPlugin.zonedSchedule(
      1,
      'Favori Ýlan Özetiniz',
      'Toplam $favoriteCount favori ilan takip ediyorsunuz.',
      firstTrigger,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_summary_channel',
          'Günlük Özet',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // her gün ayný saatte
    );
  }
}
