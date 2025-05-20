// lib/ui/screens/list_screen.dart
import 'package:flutter/material.dart';
import '../../models/car.dart';
import '../../data/car_repository.dart';

class ListScreen extends StatelessWidget {
  final CarRepository repo;
  const ListScreen({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Araç Listesi')),
      body: FutureBuilder<List<Car>>(
        future: repo.getAllCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          final cars = snapshot.data!;
          if (cars.isEmpty) {
            return const Center(child: Text('Kayıtlı araç yok'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cars.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final car = cars[i];
              return ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text('${car.brand} ${car.model}'),
                subtitle: Text('₺${car.price.toStringAsFixed(0)}'),
                onTap: () {
                  // TODO: detay ekranına yönlendir
                  // Navigator.pushNamed(context, '/details', arguments: car);
                },
              );
            },
          );
        },
      ),
    );
  }
}
