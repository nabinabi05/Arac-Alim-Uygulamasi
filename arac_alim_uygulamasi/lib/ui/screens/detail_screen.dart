// lib/ui/screens/detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/car.dart';
import '../../providers/repositories.dart';       // authRepoProvider, carRepoProvider
import '../../providers/database_provider.dart';  // favoritesDaoProvider
import '../../data/database.dart';                // Favorite modeli
import 'screen_template.dart';
import '../../utils/location_utils.dart';         // getCityAndDistrict

class DetailScreen extends ConsumerStatefulWidget {
  final String carId;
  const DetailScreen({Key? key, required this.carId}) : super(key: key);

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  String? _cityAndDistrict;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final carRepo = ref.watch(carRepoProvider);
    final favoritesDao = ref.watch(favoritesDaoProvider);
    final authRepo = ref.watch(authRepoProvider);

    return FutureBuilder<Car>(
      future: carRepo.fetchById(widget.carId),
      builder: (context, carSnapshot) {
        if (carSnapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (carSnapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('${loc.error} ${carSnapshot.error}')),
          );
        }

        final car = carSnapshot.data!;

        // Şehir/ilçe label’ı
        if (_cityAndDistrict == null) {
          getCityAndDistrict(car.latitude, car.longitude).then((value) {
            if (mounted) {
              setState(() {
                _cityAndDistrict = value;
              });
            }
          });
        }

        return ScreenTemplate(
          title: loc.detailScreenTitle,
          currentIndex: 1,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${car.brand} ${car.modelName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${loc.yearPrefix} ${car.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${loc.pricePrefix} ${car.price.toStringAsFixed(2)} ₺',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        loc.descriptionHeading,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        car.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 20,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _cityAndDistrict ?? loc.loadingLocation,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Favori Buton Bölümü
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FutureBuilder<int?>(
                  future: authRepo.getCurrentUserId(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState !=
                        ConnectionState.done) {
                      return const SizedBox(
                        height: 48,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final currentUserId = userSnapshot.data;
                    if (currentUserId == null) {
                      return Center(
                          child:
                              Text(loc.pleaseLoginToFavorite));
                    }

                    return FutureBuilder<bool>(
                      future: favoritesDao.isFavorite(
                          currentUserId, car.id),
                      builder: (context, favSnapshot) {
                        if (favSnapshot.connectionState !=
                            ConnectionState.done) {
                          return const SizedBox(
                            height: 48,
                            child:
                                Center(child: CircularProgressIndicator()),
                          );
                        }
                        final isFav = favSnapshot.data ?? false;

                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(isFav
                                    ? Icons.star
                                    : Icons.star_border),
                                label: Text(isFav
                                    ? loc.removeFavorite
                                    : loc.addFavorite),
                                onPressed: () async {
                                  if (isFav) {
                                    await favoritesDao
                                        .removeFavoriteByUserAndCar(
                                            currentUserId, car.id);
                                  } else {
                                    await favoritesDao.addFavorite(
                                        currentUserId, car.id);
                                  }
                                  if (mounted) (context as Element)
                                      .markNeedsBuild();
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                child: Text(loc.goToFavorites),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/profile');
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),

              // Sil ve Düzenle Butonları
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: Text(loc.editPrice),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber),
                        onPressed: () async {
                          final yeniFiyatController =
                              TextEditingController(
                            text: car.price.toStringAsFixed(2),
                          );
                          final yeniFiyat = await showDialog<double>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(loc.updatePriceTitle),
                              content: TextField(
                                controller: yeniFiyatController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: loc.newPriceLabel),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, null),
                                  child: Text(loc.cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final val = double.tryParse(
                                      yeniFiyatController.text
                                          .replaceAll(',', '.'),
                                    );
                                    Navigator.pop(ctx, val);
                                  },
                                  child: Text(loc.save),
                                ),
                              ],
                            ),
                          );

                          if (yeniFiyat != null && yeniFiyat > 0) {
                            final updatedCar =
                                car.copyWith(price: yeniFiyat);
                            await carRepo
                                .update(car.id.toString(), updatedCar);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content:
                                      Text(loc.priceUpdated),
                                  backgroundColor: Colors.amber,
                                ),
                              );
                              (context as Element)
                                  .markNeedsBuild();
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: Text(loc.deleteListing),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(loc.deleteListingTitle),
                              content:
                                  Text(loc.deleteListingConfirm),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, false),
                                  child: Text(loc.cancel),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, true),
                                  child: Text(
                                    loc.delete,
                                    style: const TextStyle(
                                        color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await carRepo
                                .delete(car.id.toString());
                            if (context.mounted) {
                              // Return `true` to signal deletion to ListScreen
                              Navigator.pop(context, true);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content:
                                      Text(loc.listingDeleted),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
