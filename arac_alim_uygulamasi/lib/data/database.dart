// lib/data/database.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';

part 'database.g.dart';

/// 1) `QueryExecutor` sağlayan yardımcı metot:
///    Drift, `LazyDatabase` ile asenkron klasör yolu oluşturmayı kolaylaştırıyor.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Belgeler dizinini bul
    final dbFolder = await getApplicationDocumentsDirectory();
    // db dosyasının yolu: <dokümanlar klasörü>/appdb.sqlite
    final file = File(p.join(dbFolder.path, 'appdb.sqlite'));
    return NativeDatabase(file);
  });
}

/// 2) `AppDatabase` sınıfı:  
///    - `_$AppDatabase` sınıfı, drift build_runner tarafından üretilir.
///    - Parametreli ctor: `super(_openConnection())` ile `QueryExecutor` verilir.
@DriftDatabase(tables: [Favorites, MyCars], daos: [FavoritesDao, MyCarsDao])
class AppDatabase extends _$AppDatabase {
  /// Bu ctor, `_$AppDatabase` sınıfının parametreli ctor'unu çağırır:
  AppDatabase() : super(_openConnection());

  /// 3) DAO örneklerini late olarak tanımlıyoruz:
  late final FavoritesDao favoritesDao = FavoritesDao(this);
  late final MyCarsDao myCarsDao = MyCarsDao(this);

  /// 4) Şema versiyonunu “2” olarak belirtiyoruz.
  ///    Eğer daha önce `schemaVersion = 1` idiyse, MigrationStrategy devreye girecek.
  @override
  int get schemaVersion => 2;

  /// 5) Migration kurallarını yazıyoruz:
  ///    - from = 1 iken, Favorites tablosuna userId kolonu eklenir.
  ///    - Eğer carId’yi de daha önce tabloya eklemediyseniz, onu da eklersiniz.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from == 1) {
            // 1 → 2 geçişi sırasında “userId” kolonu ekleniyor
            await m.addColumn(favorites, favorites.userId);
            // Eğer carId de önce yoktu (örnekse), onu ekleyin:
            await m.addColumn(favorites, favorites.carId);
            // NOT: Eğer MyCars tablosunda da değişiklik varsa, burada belirtebilirsiniz.
          }
          // Daha ileri versiyonlar için ek migration’lar ekleyebilirsiniz.
        },
      );

  /// 6) MyCars tablosu için temel CRUD metotları:
  Future<int> insertMyCar(MyCarsCompanion entry) {
    return into(myCars).insert(entry);
  }

  Future<bool> updateMyCar(MyCar car) {
    return update(myCars).replace(car);
  }

  Future<int> deleteMyCar(int localId) {
    return (delete(myCars)..where((tbl) => tbl.id.equals(localId))).go();
  }
}

/// 7) FavoritesDao:  
///    - “userId” filtresiyle çalışacak şekilde yeniden yazıldı.
@DriftAccessor(tables: [Favorites])
class FavoritesDao extends DatabaseAccessor<AppDatabase>
    with _$FavoritesDaoMixin {
  final AppDatabase db;
  FavoritesDao(this.db) : super(db);

  /// Sadece belli bir userId’ye ait favorileri döndür:
  Future<List<Favorite>> getAllFavoritesByUser(int userId) {
    return (select(favorites)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }

  /// Belirtilen userId & carId eşleşiyorsa true döndürür:
  Future<bool> isFavorite(int userId, int carId) async {
    final result = await (select(favorites)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.carId.equals(carId)))
        .get();
    return result.isNotEmpty;
  }

  /// Yeni favori ekle (kullanıcı + araba)
  Future<int> addFavorite(int userId, int carId) {
    return into(favorites).insert(FavoritesCompanion(
      userId: Value(userId),
      carId: Value(carId),
    ));
  }

  /// Kullanıcının belli bir carId’yi favorisinden çıkarması
  Future<int> removeFavoriteByUserAndCar(int userId, int carId) {
    return (delete(favorites)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.carId.equals(carId)))
        .go();
  }

  /// Opsiyonel: Tüm favorileri silmek
  Future<int> removeAllFavoritesByUser(int userId) {
    return (delete(favorites)..where((tbl) => tbl.userId.equals(userId))).go();
  }
}

/// 8) MyCarsDao:  
///    Eğer “MyCarsDao”’ya ihtiyaç yoksa, bu kısmı tamamen kaldırabilirsiniz.
///    Ancak eğer tablet kısmı da kullanılıyorsa, aşağıdaki gibi bir DAO tanımlamanız gerekir.
///    (Aksi takdirde annotation’daki “MyCarsDao” belirsiz kalır ve hata alırsınız.)
@DriftAccessor(tables: [MyCars])
class MyCarsDao extends DatabaseAccessor<AppDatabase> with _$MyCarsDaoMixin {
  final AppDatabase db;
  MyCarsDao(this.db) : super(db);

  /// Örnek bir metot: Tüm MyCars satırlarını getir
  Future<List<MyCar>> getAllMyCars() {
    return select(myCars).get();
  }

  /// Örnek bir metot: ID’ye göre MyCar sil
  Future<int> deleteMyCarById(int id) {
    return (delete(myCars)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Gerektiği kadar diğer CRUD metotlarını ekleyin...
}
