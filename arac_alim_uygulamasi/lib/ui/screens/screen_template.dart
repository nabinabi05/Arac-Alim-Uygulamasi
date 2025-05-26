// File: lib/ui/screens/screen_template.dart
import 'package:flutter/material.dart';

typedef NavigateCallback = void Function(String);

/// Ortak Scaffold: SEPET sayfası kaldırıldı (listeden çıkarıldı)
class AppScaffold extends StatelessWidget {
  final String title;
  final NavigateCallback onNavigate;
  final Widget body;
  final bool isLoggedIn;

  const AppScaffold({
    Key? key,
    required this.title,
    required this.onNavigate,
    required this.body,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sepet kaldırıldı
    const pages = ['Anasayfa', 'Araçlar', 'Profil'];
    final accountItems = isLoggedIn
      ? ['Profil', 'AddSale', 'Logout']
      : ['Login', 'SignUp'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: onNavigate,
            itemBuilder: (_) => pages.map(
              (p) => PopupMenuItem(value: p, child: Text(p))
            ).toList(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: onNavigate,
            itemBuilder: (_) => accountItems.map(
              (label) => PopupMenuItem(value: label, child: Text(_labelText(label)))
            ).toList(),
          ),
        ],
      ),
      body: body,
      floatingActionButton: isLoggedIn && title == 'Anasayfa'
          ? FloatingActionButton(
              onPressed: () => onNavigate('AddSale'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  String _labelText(String key) {
    switch (key) {
      case 'AddSale': return 'Satışa Ekle';
      case 'Logout': return 'Çıkış Yap';
      default: return key;
    }
  }
}
