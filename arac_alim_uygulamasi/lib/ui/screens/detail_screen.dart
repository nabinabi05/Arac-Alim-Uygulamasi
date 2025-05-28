// File: lib/ui/screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'screen_template.dart';

typedef NavigateCallback = void Function(String);

class DetailScreen extends StatelessWidget {
  final NavigateCallback onNavigate;
  final String id;
  final bool isLoggedIn;

  const DetailScreen({Key? key, required this.onNavigate, required this.id, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Detay: $id',
      onNavigate: onNavigate,
      isLoggedIn: isLoggedIn,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detaylar', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('ID: $id', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            Text('Satıcı İletişim Bilgileri', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.phone, size: 20),
                SizedBox(width: 8),
                Text('+90 555 123 4567')
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.email, size: 20),
                SizedBox(width: 8),
                Text('seller@example.com')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
