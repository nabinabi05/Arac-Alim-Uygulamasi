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
    // Simülasyon: Fiyat deðiþtiðinde bildirim gönder
    _notificationsPlugin.show(
      0,
      'Fiyat Deðiþikliði!',
      'Favori ilandaki aracýn fiyatý deðiþti.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'price_change_channel',
          'Fiyat Deðiþikliði',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
