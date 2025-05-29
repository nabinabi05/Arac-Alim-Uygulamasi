// File: lib/ui/screens/list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_provider.dart';
import 'screen_template.dart';

class ListScreen extends ConsumerWidget {
  final void Function(String) onNavigate;
  final List<String> items;

  const ListScreen({
    Key? key,
    required this.onNavigate,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.status == AuthStatus.authenticated;

    return AppScaffold(
      title: 'Araçlar',
      onNavigate: onNavigate,
      isLoggedIn: isLoggedIn,
      body: Column(
        children: [
          // ► Filtre alanınız buraya
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Araç Ara',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (q) {
                // filtre mantığı
              },
            ),
          ),

          // ► Liste
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.directions_car),
                    title: Text(items[i]),
                    onTap: () => onNavigate('Detail:$i'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
