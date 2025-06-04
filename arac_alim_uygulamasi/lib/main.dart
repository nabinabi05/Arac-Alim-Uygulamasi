// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'providers/theme_notifier.dart';
import 'providers/language_notifier.dart';
import 'providers/database_provider.dart';
import 'providers/connectivity_provider.dart';
import 'data/database.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/list_screen.dart';
import 'ui/screens/detail_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'ui/screens/add_sale_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/signup_screen.dart';
import 'ui/screens/activity_screen.dart';

const String fetchPricesTask = "fetchPricesTask";

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case fetchPricesTask:
        await _checkFavoritePrices();
        break;
    }
    return Future.value(true);
  });
}

Future<void> _checkFavoritePrices() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  final prefs = await SharedPreferences.getInstance();
  final favList = await db.select(db.favorites).get();
  if (favList.isEmpty) {
    await db.close();
    return;
  }

  final dio = Dio(BaseOptions(baseUrl: const String.fromEnvironment('API_BASE')));
  final token = await FlutterSecureStorage().read(key: 'jwt_token');
  if (token != null) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  for (final fav in favList) {
    final carId = fav.carId;
    try {
      final res = await dio.get('/cars/$carId/');
      final data = res.data as Map<String, dynamic>;
      final rawPrice = data['price'];
      double newPrice;
      if (rawPrice is num) {
        newPrice = rawPrice.toDouble();
      } else if (rawPrice is String) {
        newPrice = double.tryParse(rawPrice) ?? 0.0;
      } else {
        newPrice = 0.0;
      }

      final key = 'fav_price_$carId';
      final storedPriceString = prefs.getString(key);
      if (storedPriceString != null) {
        final oldPrice = double.tryParse(storedPriceString) ?? 0.0;
        if (newPrice != oldPrice) {
          await _showPriceChangeNotification(carId, oldPrice, newPrice);
          await prefs.setString(key, newPrice.toString());
        }
      } else {
        await prefs.setString(key, newPrice.toString());
      }
    } catch (e) {
      debugPrint('Arka plan fiyat kontrol hata (carId: $carId): $e');
    }
  }

  await db.close();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _showPriceChangeNotification(
    int carId, double oldPrice, double newPrice) async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(android: androidSettings, iOS: iosSettings),
  );

  const androidChannel = AndroidNotificationDetails(
    'price_changes_channel',
    'Fiyat Değişiklikleri',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );
  const iosChannel = DarwinNotificationDetails();
  const platformChannel =
      NotificationDetails(android: androidChannel, iOS: iosChannel);

  final title = 'Fiyat Güncellemesi!';
  final body =
      'Car #$carId’in yeni fiyatı: ${newPrice.toStringAsFixed(2)}₺ (Eski: ${oldPrice.toStringAsFixed(2)}₺)';

  await flutterLocalNotificationsPlugin.show(
    carId,
    title,
    body,
    platformChannel,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  Workmanager().registerPeriodicTask(
    "1",
    fetchPricesTask,
    frequency: const Duration(hours: 1),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    constraints: Constraints(networkType: NetworkType.connected),
  );

  runApp(
    ProviderScope(
      child: const AppWithConnectivityAndBattery(),
    ),
  );
}

class AppWithConnectivityAndBattery extends ConsumerWidget {
  const AppWithConnectivityAndBattery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(languageNotifierProvider);

    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0D47A1),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1F1F1F),
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.white54,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      themeMode: themeMode,

      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeScreen(),
        '/list': (_) => const ListScreen(),
        '/addSale': (_) => const AddSaleScreen(),
        '/detail': (ctx) {
          final id = ModalRoute.of(ctx)!.settings.arguments as String;
          return DetailScreen(carId: id);
        },
        '/activity': (_) => const ActivityScreen(),
        '/profile': (_) => const ProfileScreen(),
      },

      builder: (context, child) {
        return BatteryOverlay(
          child: ConnectivityOverlay(child: child!),
        );
      },
    );
  }
}

class BatteryOverlay extends StatefulWidget {
  final Widget child;
  const BatteryOverlay({required this.child, super.key});

  @override
  State<BatteryOverlay> createState() => _BatteryOverlayState();
}

class _BatteryOverlayState extends State<BatteryOverlay>
    with WidgetsBindingObserver {
  final _battery = Battery();
  bool _hasNotified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkBatteryLevel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkBatteryLevel();
    }
  }

  Future<void> _checkBatteryLevel() async {
    try {
      final level = await _battery.batteryLevel;
      if (level <= 20 && !_hasNotified) {
        _hasNotified = true;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.batteryLowMessage(level),
              ),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else if (level > 20) {
        _hasNotified = false;
      }
    } catch (_) {
      // Sessizce geç
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class ConnectivityOverlay extends ConsumerWidget {
  final Widget child;
  const ConnectivityOverlay({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<ConnectivityResult>>(
      connectivityStatusProvider,
      (previous, next) {
        if (next.isLoading || next.hasError) return;

        final currentStatus = next.value!;
        final previousStatus = previous?.value;

        if (previousStatus == ConnectivityResult.none &&
            (currentStatus == ConnectivityResult.wifi ||
                currentStatus == ConnectivityResult.mobile)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.backOnlineMessage),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if ((previousStatus == ConnectivityResult.wifi ||
                previousStatus == ConnectivityResult.mobile) &&
            currentStatus == ConnectivityResult.none) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.wentOfflineMessage),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
    );

    return child;
  }
}
