// lib/ui/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screen_template.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return ScreenTemplate(
      title: loc.homeTitle,
      currentIndex: 0,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(loc.welcomeMessage, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/list'),
            icon: const Icon(Icons.directions_car),
            label: Text(loc.viewCarsButton),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/addSale'),
            icon: const Icon(Icons.add),
            label: Text(loc.createListingButton),
          ),
        ],
      ),
    );
  }
}
