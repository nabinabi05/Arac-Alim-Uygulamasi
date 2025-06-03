// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'providers/theme_notifier.dart';
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

/// Arka planda favori ilanların fiyatını kontrol eden task adı
const String fetchPricesTask = "fetchPricesTask";

/// WorkManager callback fonksiyonu (arka plan tetikleyici)
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

/// Arka planda favori ilanları kontrol eden fonksiyon
Future<void> _checkFavoritePrices() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  final favoritesDao = db.favoritesDao;
  final prefs = await SharedPreferences.getInstance();

  // Eski: final favList = await favoritesDao.getAllFavorites();
  // Yeni: Tüm favori satırlarını direkt tablo üzerinden çekiyoruz
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

/// Flutter Local Notifications plugin örneği
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Fiyat değiştiğinde bildirim göstermek için fonksiyon
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // WorkManager’ı başlatıyoruz
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
    // Riverpod ProviderScope başlatılıyor
    ProviderScope(
      child: const AppWithConnectivity(),
    ),
  );
}

/// Uygulamanın kök widget’ı.
/// ConnectivityOverlay, MaterialApp’in builder’ında konumlandırıldığı için
/// hangi sayfa açıksa o sayfanın üzerine internet durumu SnackBar’ı gösterir.
class AppWithConnectivity extends ConsumerWidget {
  const AppWithConnectivity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'AraçAlım',
      debugShowCheckedModeBanner: false,

      /// Burada önemli kısım: MaterialApp.builder
      builder: (context, child) {
        // child, routing ile seçilen herhangi bir ekran (Login, Home, vs)
        // Üzerine ConnectivityOverlay sarıyoruz:
        return ConnectivityOverlay(child: child!);
      },

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
      themeMode: ref.watch(themeNotifierProvider),

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
    );
  }
}

/// **Burada “ConnectivityOverlay” sınıfını tamamen yeniledik:**
class ConnectivityOverlay extends ConsumerWidget {
  final Widget child;
  const ConnectivityOverlay({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<ConnectivityResult>>(
      connectivityStatusProvider,
      (previous, next) {
        // Henüz veri gelmiyorsa veya hata varsa hiçbir şey yapma
        if (next.isLoading || next.hasError) return;

        final currentStatus = next.value!;       // Şimdiki bağlantı durumu
        final previousStatus = previous?.value;  // Önceki bağlantı durumu (null olabilir)

        // 1) Offline → Online geçişi
        if (previousStatus == ConnectivityResult.none &&
            (currentStatus == ConnectivityResult.wifi ||
             currentStatus == ConnectivityResult.mobile)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('İnternet bağlantısı geri geldi'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
        // 2) Online → Offline geçişi
        else if ((previousStatus == ConnectivityResult.wifi ||
                  previousStatus == ConnectivityResult.mobile) &&
                 currentStatus == ConnectivityResult.none) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('İnternet bağlantısı kesildi'),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 3),
            ),
          );
        }
        // 3) İlk açılışta previousStatus null olduğu için hiçbir snackbar gösterilmez.
      },
    );

    // Her zaman child (aktuel ekran) döndürülür.
    return child;
  }
}
