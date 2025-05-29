import 'package:flutter/material.dart';
import '../../models/car.dart';
import '../../services/car_repository.dart';
import 'screen_template.dart';

class ListScreen extends StatelessWidget {
  final NavigateCallback onNavigate;
  final bool isLoggedIn;

  const ListScreen({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      onNavigate: onNavigate,
      isLoggedIn: isLoggedIn,
      child: FutureBuilder<List<Car>>(
        future: CarRepository().getCars(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Hata: ${snap.error}'));
          }
          final cars = snap.data ?? [];
          if (cars.isEmpty) {
            return const Center(child: Text('Henüz araç yok.'));
          }
          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (_, i) {
              final c = cars[i];
              return ListTile(
                title: Text('${c.brand} ${c.modelName}'),
                subtitle: Text('${c.year} — ${c.price} TL'),
                onTap: () => onNavigate('Detail', c.id.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
