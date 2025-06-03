// lib/ui/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'screen_template.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      title: 'Anasayfa',
      currentIndex: 0,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Hoş geldiniz!', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/list'),
            icon: const Icon(Icons.directions_car),
            label: const Text('Araçları Görüntüle'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/addSale'),
            icon: const Icon(Icons.add),
            label: const Text('İlan Ver'),
          ),
        ],
      ),
    );
  }
}
