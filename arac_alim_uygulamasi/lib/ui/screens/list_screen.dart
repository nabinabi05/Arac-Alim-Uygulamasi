// lib/ui/screens/list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/car.dart';
import '../../providers/repositories.dart';
import 'screen_template.dart';
import 'detail_screen.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final repo = ref.watch(carRepoProvider);

    return ScreenTemplate(
      title: loc.listingsTitle,
      currentIndex: 1,
      body: FutureBuilder<List<Car>>(
        future: repo.fetchAll(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('${loc.error} ${snap.error}'));
          }

          final cars = snap.data ?? [];
          if (cars.isEmpty) {
            return Center(child: Text(loc.noListings));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: cars.length,
            itemBuilder: (context, i) {
              final car = cars[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text('${car.brand} ${car.modelName}'),
                  subtitle: Text(
                    '${car.year} • ₺${car.price.toStringAsFixed(0)}',
                  ),
                  onTap: () async {
                    // 1. Burada pushNamed yerine MaterialPageRoute kullanıyoruz:
                    final deleted = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => DetailScreen(
                          carId: car.id.toString(),
                        ),
                      ),
                    );

                    // 2. Eğer DetailScreen içinden pop(context, true) geldiyse listenin güncellenmesi için setState çağrıyoruz.
                    if (deleted == true) {
                      setState(() {});
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
