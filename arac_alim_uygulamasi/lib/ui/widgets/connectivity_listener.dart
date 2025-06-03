// lib/ui/widgets/connectivity_listener.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../providers/connectivity_provider.dart';

/// ConnectivityListener: Altındaki widget’ı sarar ve bağlantı durumu değiştiğinde
/// yalnızca gerçekten offline → online geçişlerinde “İnternet geri geldi”,
/// online → offline geçişlerinde “İnternet bağlantısı kesildi” SnackBar’ı gösterir.
class ConnectivityListener extends ConsumerWidget {
  final Widget child;
  const ConnectivityListener({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<ConnectivityResult>>(connectivityStatusProvider,
        (previous, next) {
      // Henüz veri gelmiyorsa veya hata varsa hiçbir şey yapmıyoruz.
      if (next.isLoading || next.hasError) return;

      final currentStatus = next.value!;             // Şu anki ConnectivityResult
      final previousStatus = previous?.value;        // Önceki ConnectivityResult (null olabilir)

      // Eğer önceki durum 'none' (bağlantı yok) ve yeni durum 'wifi' ya da 'mobile' ise:
      if (previousStatus == ConnectivityResult.none &&
          (currentStatus == ConnectivityResult.wifi ||
           currentStatus == ConnectivityResult.mobile)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('İnternet bağlantısı geri geldi'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
      // Eğer önceki durum wifi/mobile (yani internet vardı) ve yeni durum none ise:
      else if ((previousStatus == ConnectivityResult.wifi ||
                previousStatus == ConnectivityResult.mobile) &&
               currentStatus == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('İnternet bağlantısı kesildi'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Başlangıçta previousStatus null olduğu için ne bağlanma ne de kopma SnackBar’ı gösterilmez.
    });

    return child;
  }
}
