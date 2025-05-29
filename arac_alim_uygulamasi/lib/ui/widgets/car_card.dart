// File: lib/ui/widgets/car_card.dart
import 'package:flutter/material.dart';
import '/models/car.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onTap;
  const CarCard({Key? key, required this.car, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${car.brand} ${car.model}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('${car.price.toStringAsFixed(0)} ₺',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
