import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Cihazın ağ bağlantısı ve gerçek internet erişimini kontrol eder.
class ConnectivityService {
  // Stream ile uygulama boyunca dinleyebilirsiniz:
  Stream<bool> get onConnectionChange async* {
    await for (final status in Connectivity().onConnectivityChanged) {
      if (status == ConnectivityResult.none) {
        yield false;
      } else {
        // Wi-Fi / Mobil ağ bağlı olabilir ama gerçek internet olmayabilir
        yield await InternetConnectionChecker().hasConnection;
      }
    }
  }

  /// Anlık olarak internet erişimi var mı?
  Future<bool> get hasConnection async {
    final status = await Connectivity().checkConnectivity();
    if (status == ConnectivityResult.none) return false;
    return await InternetConnectionChecker().hasConnection;
  }
}
