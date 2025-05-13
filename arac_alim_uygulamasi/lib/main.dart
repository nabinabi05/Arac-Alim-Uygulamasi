import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SystemEventWatcher {
  final Connectivity _connectivity = Connectivity();
  final Battery _battery = Battery();

  void listenToEvents(BuildContext context) {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      final isConnected = result != ConnectivityResult.none;
      _showSnackbar(context, isConnected ? "Bağlantı geldi" : "Bağlantı koptu");
    });

    _battery.batteryLevel.then((level) {
      if (level < 20) {
        _showSnackbar(context, "Batarya seviyesi düşük: %$level");
      }
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

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
