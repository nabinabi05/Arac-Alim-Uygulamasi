import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/activity.dart';
import '../../providers/repositories.dart';
import 'package:intl/intl.dart';
import 'screen_template.dart'; // <-- Burayı ekliyoruz

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
    // activityRepoProvider zaten bir repository döndürecek; fetchAll() da Future<List<Activity>>
    final activityFuture = ref.watch(activityRepoProvider).fetchAll();

    return ScreenTemplate(
      title: 'Aktivite Geçmişi',
      currentIndex: 2,
      body: FutureBuilder<List<Activity>>(
        future: activityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final activities = snapshot.data;
          if (activities == null || activities.isEmpty) {
            return const Center(child: Text('Gösterilecek aktivite yok.'));
          }

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final act = activities[index];
              final type = act.activityType; // nullable olabilir
              return ListTile(
                leading: Icon(
                  getActivityIcon(type),
                  color: getActivityColor(type),
                ),
                title: Text(act.message),
                subtitle: Text(
                  // Tarihi kullanıcı yerel saatine çevirip basit gösterim:
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
