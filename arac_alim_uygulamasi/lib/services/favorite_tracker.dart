import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FavoriteTracker {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  void checkForPriceChangeAndNotify() {
    // Sim�lasyon: Fiyat de�i�ti�inde bildirim g�nder
    _notificationsPlugin.show(
      0,
      'Fiyat De�i�ikli�i!',
      'Favori ilandaki arac�n fiyat� de�i�ti.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'price_change_channel',
          'Fiyat De�i�ikli�i',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
