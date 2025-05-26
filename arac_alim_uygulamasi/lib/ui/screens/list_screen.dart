// File: lib/ui/screens/list_screen.dart
import 'package:flutter/material.dart';

typedef NavigateCallback = void Function(String);

/// Araçlar sayfası: Drawer içinden filtreler, ana alanda liste
class ListScreen extends StatelessWidget {
  final NavigateCallback onNavigate;
  final List<String> items;
  final bool isLoggedIn;

  const ListScreen({
    Key? key,
    required this.onNavigate,
    required this.items,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const pages = ['Anasayfa', 'Araçlar', 'Profil'];
    final accountItems = isLoggedIn
      ? ['Profil', 'AddSale', 'Logout']
      : ['Login', 'SignUp'];

    // Filtre paneli içerikleri
    final filterPanel = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Filtreler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            hintText: 'Araç adı ara...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['Sedan', 'SUV', 'Hatchback']
              .map((cat) => FilterChip(label: Text(cat), onSelected: (_) {}))
              .toList(),
        ),
        const SizedBox(height: 16),
        const Text('Renk', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['Kırmızı', 'Mavi', 'Siyah']
              .map((color) => FilterChip(label: Text(color), onSelected: (_) {}))
              .toList(),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Araçlar'),
        // Filtre drawer için özel buton
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          // Sayfa navigasyonu
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: onNavigate,
            itemBuilder: (_) => pages
                .map((p) => PopupMenuItem(value: p, child: Text(p)))
                .toList(),
          ),
          // Hesap işlemleri
          PopupMenuButton<String>(
            icon: const Icon(Icons.person),
            onSelected: onNavigate,
            itemBuilder: (_) => accountItems
                .map((label) => PopupMenuItem(value: label, child: Text(label)))
                .toList(),
          ),
        ],
      ),
      drawer: Drawer(child: filterPanel),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text(item),
            subtitle: const Text('Placeholder açıklama'),
            onTap: () => onNavigate('Detail:$item'),
          );
        },
      ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: () => onNavigate('AddSale'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
