import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bu provider, onConnectivityChanged akışından (liste / tekil değer / Object olarak gelebilecek)
/// gelen her durumu tek bir ConnectivityResult’a map’ler.
/// Eğer gerçekten liste geliyorsa ilk elemanı alır, tekil geliyorsa direkt döner,
/// aksi hâlde `ConnectivityResult.none` kullanır.
final connectivityStatusProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity()
      .onConnectivityChanged
      .map<ConnectivityResult>((dynamic event) {
        // 1) event, eğer List<ConnectivityResult> ise
        if (event is List<ConnectivityResult> && event.isNotEmpty) {
          return event.first;
        }
        // 2) event, tekil ConnectivityResult ise
        if (event is ConnectivityResult) {
          return event;
        }
        // 3) Yukarıdakilerin hiçbiri değilse (beklenmeyen tip), fallback:
        return ConnectivityResult.none;
      });
});
