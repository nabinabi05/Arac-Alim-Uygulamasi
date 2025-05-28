import 'package:flutter/material.dart';
import '../../models/car.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback? onTap;

  const CarCard({Key? key, required this.car, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: ListTile(
        leading: const Icon(
          Icons.directions_car,
          size: 40,
        ),
        title: Text(
          '${car.brand} ${car.model}',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Text(
          '₺${car.price.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        onTap: onTap,
      ),
    );
  }
}
