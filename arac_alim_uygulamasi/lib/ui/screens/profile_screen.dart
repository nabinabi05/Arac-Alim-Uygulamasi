// File: lib/ui/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'screen_template.dart';

typedef NavigateCallback = void Function(String);

/// Profil ekranı: Favori araçlar ve parola değiştirme
class ProfileScreen extends StatelessWidget {
  final NavigateCallback onNavigate;
  final bool isLoggedIn;
  final List<String> favorites;

  const ProfileScreen({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
    required this.favorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Profil',
      onNavigate: onNavigate,
      isLoggedIn: isLoggedIn,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Favori Araçlar', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (favorites.isEmpty)
              const Text('Henüz favori eklemediniz.')
            else
              ...favorites.map((item) => ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: Text(item),
                    onTap: () => onNavigate('Detail:$item'),
                  )),
            const Divider(),
            const SizedBox(height: 16),
            Text('Parola Değiştir', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Mevcut Şifre',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Yeni Şifre',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Yeni Şifre (Tekrar)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Şifre güncelleme işlemi
                },
                child: const Text('Parolayı Güncelle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
