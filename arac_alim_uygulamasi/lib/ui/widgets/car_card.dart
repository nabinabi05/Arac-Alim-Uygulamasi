import 'package:flutter/material.dart';
import '../../models/car.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onTap;

  const CarCard({super.key, required this.car, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${car.brand} ${car.modelName}'),
        subtitle:
            Text('${car.year} • ₺${car.price.toStringAsFixed(0)}'),
        onTap: onTap,
      ),
    );
  }
}
