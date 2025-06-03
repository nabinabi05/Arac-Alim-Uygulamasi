// lib/ui/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';       // authRepoProvider
import '../../providers/database_provider.dart';  // favoritesDaoProvider
import '../../data/database.dart';                // Favorite, Car modelleri
import '../../providers/theme_notifier.dart';     // Tema değişimi
import '../../models/car.dart';
import 'screen_template.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepoProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final isDarkMode = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    final favoritesDao = ref.watch(favoritesDaoProvider);
    final carRepo = ref.watch(carRepoProvider);

    return ScreenTemplate(
      title: 'Profil',
      currentIndex: 3,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 48),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text('Hoş geldiniz!', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16),

            // Tema geçişi
            SwitchListTile(
              title: const Text('Karanlık Tema'),
              value: isDarkMode,
              onChanged: (value) {
                themeNotifier.toggleTheme();
              },
            ),
            const Divider(thickness: 1, height: 32),

            // Çıkış yap düğmesi
            ElevatedButton.icon(
              onPressed: () async {
                await authRepo.logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Çıkış Yap'),
            ),
            const SizedBox(height: 32),

            const Text(
              'Favori İlanlar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // ---------------------- Favori Listeleme Bölümü ----------------------

            FutureBuilder<int?>(
              // 1) Önce “currentUserId” çekelim
              future: authRepo.getCurrentUserId(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final currentUserId = userSnapshot.data;
                if (currentUserId == null) {
                  return const Center(child: Text('Favori ilanlarınızı görmek için giriş yapın.'));
                }

                // 2) Bu userId ile favori listesini çek
                return FutureBuilder<List<Favorite>>(
                  future: favoritesDao.getAllFavoritesByUser(currentUserId),
                  builder: (context, favSnapshot) {
                    if (favSnapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (favSnapshot.hasError) {
                      return Center(child: Text('Hata: ${favSnapshot.error}'));
                    }

                    final favList = favSnapshot.data ?? [];
                    if (favList.isEmpty) {
                      return const Center(child: Text('Henüz favori ilanınız yok.'));
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: favList.length,
                        itemBuilder: (context, index) {
                          final fav = favList[index];
                          final carId = fav.carId;

                          return FutureBuilder<Car>(
                            future: carRepo.fetchById(carId.toString()),
                            builder: (context, carSnapshot) {
                              if (carSnapshot.connectionState != ConnectionState.done) {
                                return const ListTile(
                                  title: Text('Yükleniyor...'),
                                );
                              }
                              if (carSnapshot.hasError) {
                                final errStr = carSnapshot.error.toString();
                                if (errStr.contains('404')) {
                                  return ListTile(
                                    title: const Text(
                                      'Bu ilan silinmiş veya artık mevcut değil.',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        await favoritesDao.removeFavoriteByUserAndCar(
                                          currentUserId, carId);
                                        (context as Element).markNeedsBuild();
                                      },
                                    ),
                                  );
                                }
                                return ListTile(
                                  title: Text(
                                    'Hata: ${carSnapshot.error}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                              }

                              final car = carSnapshot.data!;
                              return ListTile(
                                leading: const Icon(Icons.directions_car),
                                title: Text('${car.brand} ${car.modelName}'),
                                subtitle: Text('Fiyat: ${car.price.toStringAsFixed(2)} ₺'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await favoritesDao.removeFavoriteByUserAndCar(
                                        currentUserId, carId);
                                    (context as Element).markNeedsBuild();
                                  },
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/detail',
                                    arguments: car.id.toString(),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
