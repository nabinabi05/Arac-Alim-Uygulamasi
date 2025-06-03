// lib/ui/screens/list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/car.dart';
import '../../providers/repositories.dart';
import 'screen_template.dart';
import 'detail_screen.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(carRepoProvider);

    return ScreenTemplate(
      title: 'İlanlar',
      currentIndex: 1,
      body: FutureBuilder<List<Car>>(
        future: repo.fetchAll(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Hata: ${snap.error}'));
          }
          final cars = snap.data ?? [];
          if (cars.isEmpty) {
            return const Center(child: Text('Henüz ilan yok'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: cars.length,
            itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text('${cars[i].brand} ${cars[i].modelName}'),
                subtitle: Text(
                    '${cars[i].year} • ₺${cars[i].price.toStringAsFixed(0)}'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: cars[i].id.toString(),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
