// lib/ui/screens/screen_template.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenTemplate extends StatelessWidget {
  final String title;
  final int currentIndex;
  final Widget body;

  const ScreenTemplate({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D47A1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/list');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/activity');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: loc.homeTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_car),
            label: loc.listingsTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: loc.activityHistory,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: loc.screenProfile,
          ),
        ],
      ),
    );
  }
}
