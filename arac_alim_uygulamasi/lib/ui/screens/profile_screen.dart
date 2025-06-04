// lib/ui/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/repositories.dart';       // authRepoProvider
import '../../providers/database_provider.dart';  // favoritesDaoProvider
import '../../data/database.dart';                // Favorite modeli
import '../../providers/theme_notifier.dart';     // Tema değişimi
import '../../providers/language_notifier.dart';  // Dil değişimi
import '../../models/car.dart';
import 'screen_template.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final authRepo = ref.watch(authRepoProvider);

    // Tema kontrolü
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final isDarkMode = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    // Dil kontrolü
    final languageNotifier = ref.read(languageNotifierProvider.notifier);
    final currentLocale = ref.watch(languageNotifierProvider);
    final isEnglish = currentLocale.languageCode == 'en';

    final favoritesDao = ref.watch(favoritesDaoProvider);
    final carRepo = ref.watch(carRepoProvider);

    return ScreenTemplate(
      title: loc.screenProfile,
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
            Center(
              child: Text(
                loc.welcomeUser,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),

            // Tema geçişi
            SwitchListTile(
              title: Text(loc.switchDarkTheme),
              value: isDarkMode,
              onChanged: (value) {
                themeNotifier.toggleTheme();
              },
            ),
            const Divider(thickness: 1, height: 32),

            // Dil geçişi
            SwitchListTile(
              title: Text(loc.switchLanguage),
              subtitle: Text(isEnglish ? loc.english : loc.turkish),
              value: isEnglish,
              onChanged: (value) {
                languageNotifier.setLanguage(value ? 'en' : 'tr');
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
              label: Text(loc.logout),
            ),
            const SizedBox(height: 32),

            Text(
              loc.favoriteCars,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // ---------------------- Favori Listeleme Bölümü ----------------------
            FutureBuilder<int?>(
              future: authRepo.getCurrentUserId(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final currentUserId = userSnapshot.data;
                if (currentUserId == null) {
                  return Center(child: Text(loc.loginToViewFavorites));
                }

                return FutureBuilder<List<Favorite>>(
                  future: favoritesDao.getAllFavoritesByUser(currentUserId),
                  builder: (context, favSnapshot) {
                    if (favSnapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (favSnapshot.hasError) {
                      return Center(
                        child: Text('${loc.error} ${favSnapshot.error}'),
                      );
                    }

                    final favList = favSnapshot.data ?? [];
                    if (favList.isEmpty) {
                      return Center(child: Text(loc.noFavoritesYet));
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
                              if (carSnapshot.connectionState !=
                                  ConnectionState.done) {
                                return const ListTile(
                                  title: Text('...'),
                                );
                              }
                              if (carSnapshot.hasError) {
                                final errStr = carSnapshot.error.toString();
                                if (errStr.contains('404')) {
                                  return ListTile(
                                    title: Text(
                                      loc.listingNotFound,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        await favoritesDao
                                            .removeFavoriteByUserAndCar(
                                          currentUserId,
                                          carId,
                                        );
                                        (context as Element).markNeedsBuild();
                                      },
                                    ),
                                  );
                                }
                                return ListTile(
                                  title: Text(
                                    '${loc.error} ${carSnapshot.error}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                              }

                              final car = carSnapshot.data!;
                              return ListTile(
                                leading: const Icon(Icons.directions_car),
                                title: Text('${car.brand} ${car.modelName}'),
                                subtitle: Text(
                                  '${loc.pricePrefix} ${car.price.toStringAsFixed(2)} ₺',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await favoritesDao
                                        .removeFavoriteByUserAndCar(
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
