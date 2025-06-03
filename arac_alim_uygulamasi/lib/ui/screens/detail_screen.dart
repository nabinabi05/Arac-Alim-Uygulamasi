// lib/ui/screens/detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/car.dart';
import '../../providers/repositories.dart';       // authRepoProvider
import '../../providers/database_provider.dart';  // favoritesDaoProvider
import '../../data/database.dart';                // Favorite, Car modeli
import 'screen_template.dart';
import '../../utils/location_utils.dart';         // Şehir/ilçe için fonksiyon

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
            body: Center(child: Text('Hata: ${carSnapshot.error}')),
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
          title: 'İlan Detayı',
          currentIndex: 1,
          body: Column(
            children: [
              // Üstteki detay bilgileri (marka, fiyat, açıklama vb.)…
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
                      Text('Yıl: ${car.year}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Fiyat: ${car.price.toStringAsFixed(2)} ₺', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 12),
                      const Text(
                        'Açıklama:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(car.description, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      // Şehir/İlçe
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 20, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Text(
                            _cityAndDistrict ?? 'Konum alınıyor...',
                            style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // ---------------------- Favori Buton Bölümü ----------------------

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FutureBuilder<int?>(
                  // 1) Önce currentUserId alalım
                  future: authRepo.getCurrentUserId(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState != ConnectionState.done) {
                      return const SizedBox(
                        height: 48,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final currentUserId = userSnapshot.data;
                    // Eğer giriş yapılmamışsa mesaj göster
                    if (currentUserId == null) {
                      return const Center(child: Text('Favori eklemek için giriş yapın.'));
                    }

                    // 2) Şimdi bu userId’yi kullanarak “isFavorite” kontrolü yapalım
                    return FutureBuilder<bool>(
                      future: favoritesDao.isFavorite(currentUserId, car.id),
                      builder: (context, favSnapshot) {
                        if (favSnapshot.connectionState != ConnectionState.done) {
                          return const SizedBox(
                            height: 48,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final isFav = favSnapshot.data ?? false;

                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(isFav ? Icons.star : Icons.star_border),
                                label: Text(isFav ? 'Favoriden Çıkar' : 'Favoriye Ekle'),
                                onPressed: () async {
                                  if (isFav) {
                                    await favoritesDao.removeFavoriteByUserAndCar(
                                      currentUserId, car.id);
                                  } else {
                                    await favoritesDao.addFavorite(
                                      currentUserId, car.id);
                                  }
                                  // İki FutureBuilder üst üste olduğu için
                                  // hem userSnapshot hem favSnapshot’ı tazelemek için:
                                  if (mounted) (context as Element).markNeedsBuild();
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                child: const Text('Favorilere Git'),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/profile');
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

              // -------------------- Sil ve Düzenle Butonları --------------------

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Fiyatı Düzenle'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        onPressed: () async {
                          final yeniFiyatController = TextEditingController(
                            text: car.price.toStringAsFixed(2),
                          );
                          final yeniFiyat = await showDialog<double>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Fiyat Güncelle"),
                              content: TextField(
                                controller: yeniFiyatController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: "Yeni fiyat (₺)"),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("İptal")),
                                TextButton(
                                  onPressed: () {
                                    final val = double.tryParse(
                                      yeniFiyatController.text.replaceAll(',', '.'),
                                    );
                                    Navigator.pop(ctx, val);
                                  },
                                  child: const Text("Kaydet"),
                                ),
                              ],
                            ),
                          );

                          if (yeniFiyat != null && yeniFiyat > 0) {
                            final updatedCar = car.copyWith(price: yeniFiyat);
                            await carRepo.update(car.id.toString(), updatedCar);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Fiyat güncellendi!"),
                                  backgroundColor: Colors.amber,
                                ),
                              );
                              (context as Element).markNeedsBuild();
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: const Text('Sil'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('İlanı Sil'),
                              content: const Text('Bu ilanı silmek istediğine emin misin?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Sil', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await carRepo.delete(car.id.toString());
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("İlan silindi."), backgroundColor: Colors.red),
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
