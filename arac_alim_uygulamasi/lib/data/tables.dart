// lib/data/tables.dart

import 'package:drift/drift.dart';

/// 1) Favori İlanlar Tablosu
class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// AA: Her favori kaydı artık “bu kullanıcıya ait” olacak:
  IntColumn get userId => integer().customConstraint('NOT NULL')();

  /// Daha önce sadece carId vardı; artık kullanıcıya özel yapıyoruz:
  IntColumn get carId => integer().customConstraint('NOT NULL')();

  DateTimeColumn get addedAt => dateTime().clientDefault(
        () => DateTime.now(),
      )();
}

/// 2) Kullanıcının İlanları Tablosu (Offline kopya)
class MyCars extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get carId => integer().nullable()();
  TextColumn get brand => text()();
  TextColumn get modelName => text()();
  IntColumn get year => integer()();
  RealColumn get price => real()();
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().nullable()();
}
