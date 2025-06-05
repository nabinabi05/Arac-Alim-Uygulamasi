import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showPriceChangeNotification(
    String carName, double oldPrice, double newPrice) async {
  await flutterLocalNotificationsPlugin.show(
    0,
    'Favori İlan Fiyatı Değişti',
    '$carName: $oldPrice₺ → $newPrice₺',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'price_change_channel',
        'Fiyat Bildirimi',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      ),
    ),
  );
}
