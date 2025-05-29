import 'package:flutter/material.dart';
import '../../models/car.dart';
import '../../services/car_repository.dart';
import 'screen_template.dart';

class DetailScreen extends StatelessWidget {
  final NavigateCallback onNavigate;
  final bool isLoggedIn;
  final String id;

  const DetailScreen({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
    required this.id,
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
          final car = cars.firstWhere(
            (c) => c.id.toString() == id,
            orElse: () => Car(
              id: int.tryParse(id) ?? 0,
              brand: '',
              modelName: '',
              year: 0,
              price: 0,
              description: '',
            ),
          );

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${car.brand} ${car.modelName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Yıl: ${car.year}'),
                Text('Fiyat: ${car.price} TL'),
                const SizedBox(height: 16),
                const Text(
                  'Açıklama:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(car.description),
              ],
            ),
          );
        },
      ),
    );
  }
}
