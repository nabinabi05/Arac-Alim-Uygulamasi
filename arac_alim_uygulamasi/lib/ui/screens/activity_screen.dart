// lib/ui/screens/activity_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <- Lokalizasyon sınıfı
import '../../models/activity.dart';
import '../../providers/repositories.dart';
import 'screen_template.dart';

IconData getActivityIcon(String? type) {
  switch (type) {
    case 'price_update':
      return Icons.price_change;
    case 'favorite':
      return Icons.star;
    case 'new_car':
      return Icons.directions_car;
    default:
      return Icons.info;
  }
}

Color getActivityColor(String? type) {
  switch (type) {
    case 'price_update':
      return Colors.amber;
    case 'favorite':
      return Colors.blue;
    case 'new_car':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lokalize edilmiş metinleri almak için:
    final loc = AppLocalizations.of(context)!;

    final activityFuture = ref.watch(activityRepoProvider).fetchAll();

    return ScreenTemplate(
      title: loc.activityHistory, // artık AppLocalizations içinden geliyor
      currentIndex: 2,
      body: FutureBuilder<List<Activity>>(
        future: activityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // "Hata:" metni de arb’den alınıyor
            return Center(child: Text('${loc.error} ${snapshot.error}'));
          }

          final activities = snapshot.data;
          if (activities == null || activities.isEmpty) {
            return Center(child: Text(loc.noActivity));
          }

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final act = activities[index];
              final type = act.activityType;

              return ListTile(
                leading: Icon(
                  getActivityIcon(type),
                  color: getActivityColor(type),
                ),
                title: Text(act.message),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(
                    act.timestamp.toLocal(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
