import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_provider.dart';
import 'screen_template.dart';

class ProfileScreen extends ConsumerWidget {
  final void Function(String) onNavigate;
  final bool isLoggedIn;
  final List<String> favorites;

  const ProfileScreen({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
    required this.favorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: 'Profil',
      onNavigate: onNavigate,
      isLoggedIn: isLoggedIn,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hoş geldiniz!'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                onNavigate('Login');
              },
              child: const Text('Çıkış Yap'),
            ),
            const SizedBox(height: 24),
            const Text('Favoriler'),
            const SizedBox(height: 8),
            ...favorites.map(
              (f) => ListTile(
                leading: const Icon(Icons.favorite),
                title: Text(f),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
