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
    // Simülasyon: Fiyat değiştiğinde bildirim gönder
    _notificationsPlugin.show(
      0,
      'Fiyat Değişikliği!',
      'Favori ilandaki aracın fiyatı değişti.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'price_change_channel',
          'Fiyat Değişikliği',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
