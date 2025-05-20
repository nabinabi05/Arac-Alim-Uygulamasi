// lib/main.dart
import 'package:flutter/material.dart';
import 'theme.dart';
import 'constants.dart';
import 'screens/home/home_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDark = await StorageService.getTheme();
  final lang   = await StorageService.getLanguage();
  runApp(MyApp(isDarkMode: isDark, languageCode: lang));
}

class AracAlimApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: AppTheme.lightTheme,
      home: HomeScreenWrapper(),
    );
  }
}

class HomeScreenWrapper extends StatefulWidget {
  @override
  _HomeScreenWrapperState createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper> {
  final SystemEventWatcher _systemEventWatcher = SystemEventWatcher();

  @override
  void initState() {
    super.initState();
    _systemEventWatcher.listenToEvents(context);
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}

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
        _showSnackbar(context, "Batarya seviyesi düşük: %\$level");
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
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  void checkForPriceChangeAndNotify() {
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