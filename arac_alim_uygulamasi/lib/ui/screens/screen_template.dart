// lib/ui/screens/screen_template.dart

import 'package:flutter/material.dart';

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
    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: BottomNavigationBar(
        // → Bu üç satırı ekleyin:
        backgroundColor: const Color(0xFF0D47A1), // Koyu mavi arkaplan
        selectedItemColor: Colors.white,          // Seçili ikon/etiket beyaz
        unselectedItemColor: Colors.white70,      // Seçilmeyenler yarı şeffaf beyaz

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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'İlanlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Aktivite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
