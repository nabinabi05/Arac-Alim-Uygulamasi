import 'package:flutter/material.dart';
import '../../models/car.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Navigator üzerinden gönderilen Car objesini al
    final Car car = ModalRoute.of(context)!.settings.arguments as Car;

    return Scaffold(
      appBar: AppBar(
        title: Text('${car.brand} ${car.model}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Araç resmi placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.directions_car,
                size: 100,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Model: ${car.model}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 8),
            Text(
              'Marka: ${car.brand}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 8),
            Text(
              'Fiyat: ₺${car.price.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.headline6,
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Satın al veya favorilere ekle işlemi
                },
                child: const Text('Satın Al'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
