import 'package:flutter/material.dart';
import '../../models/car.dart';
import '../../ui/widgets/car_card.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  // Placeholder mock data
  static final List<Car> mockCars = [
    Car(id: 1, brand: 'Toyota', model: 'Corolla', price: 15000),
    Car(id: 2, brand: 'Honda', model: 'Civic', price: 18000),
    Car(id: 3, brand: 'Ford', model: 'Focus', price: 17000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araç Listesi'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockCars.length,
        itemBuilder: (context, index) {
          final car = mockCars[index];
          return CarCard(
            car: car,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/details',
                arguments: car,
              );
            },
          );
        },
      ),
    );
  }
}
