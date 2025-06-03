// lib/providers/database_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';

// 1. AppDatabase sağlayan provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase(); // ya da ._openConnection vs. sizin kullandığınız yapıya göre
});

// 2. FavoritesDao sağlayan provider
final favoritesDaoProvider = Provider<FavoritesDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.favoritesDao;
});

// (Opsiyonel) MyCarsDao, CarRepo gibi sağlayıcılar buraya eklenir
