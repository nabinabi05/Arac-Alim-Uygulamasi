// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<int> carId = GeneratedColumn<int>(
      'car_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [id, userId, carId, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(Insertable<Favorite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('car_id')) {
      context.handle(
          _carIdMeta, carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta));
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      carId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}car_id'])!,
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final int id;

  /// AA: Her favori kaydı artık “bu kullanıcıya ait” olacak:
  final int userId;

  /// Daha önce sadece carId vardı; artık kullanıcıya özel yapıyoruz:
  final int carId;
  final DateTime addedAt;
  const Favorite(
      {required this.id,
      required this.userId,
      required this.carId,
      required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['car_id'] = Variable<int>(carId);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      id: Value(id),
      userId: Value(userId),
      carId: Value(carId),
      addedAt: Value(addedAt),
    );
  }

  factory Favorite.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      carId: serializer.fromJson<int>(json['carId']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'carId': serializer.toJson<int>(carId),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  Favorite copyWith({int? id, int? userId, int? carId, DateTime? addedAt}) =>
      Favorite(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        carId: carId ?? this.carId,
        addedAt: addedAt ?? this.addedAt,
      );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      carId: data.carId.present ? data.carId.value : this.carId,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('carId: $carId, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, carId, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.carId == this.carId &&
          other.addedAt == this.addedAt);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> carId;
  final Value<DateTime> addedAt;
  const FavoritesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.carId = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int carId,
    this.addedAt = const Value.absent(),
  })  : userId = Value(userId),
        carId = Value(carId);
  static Insertable<Favorite> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? carId,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (carId != null) 'car_id': carId,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  FavoritesCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? carId,
      Value<DateTime>? addedAt}) {
    return FavoritesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (carId.present) {
      map['car_id'] = Variable<int>(carId.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('carId: $carId, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $MyCarsTable extends MyCars with TableInfo<$MyCarsTable, MyCar> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MyCarsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<int> carId = GeneratedColumn<int>(
      'car_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelNameMeta =
      const VerificationMeta('modelName');
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
      'model_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, carId, brand, modelName, year, price, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'my_cars';
  @override
  VerificationContext validateIntegrity(Insertable<MyCar> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('car_id')) {
      context.handle(
          _carIdMeta, carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model_name')) {
      context.handle(_modelNameMeta,
          modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta));
    } else if (isInserting) {
      context.missing(_modelNameMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MyCar map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MyCar(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      carId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}car_id']),
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand'])!,
      modelName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_name'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $MyCarsTable createAlias(String alias) {
    return $MyCarsTable(attachedDatabase, alias);
  }
}

class MyCar extends DataClass implements Insertable<MyCar> {
  final int id;
  final int? carId;
  final String brand;
  final String modelName;
  final int year;
  final double price;
  final String description;
  final DateTime? createdAt;
  const MyCar(
      {required this.id,
      this.carId,
      required this.brand,
      required this.modelName,
      required this.year,
      required this.price,
      required this.description,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || carId != null) {
      map['car_id'] = Variable<int>(carId);
    }
    map['brand'] = Variable<String>(brand);
    map['model_name'] = Variable<String>(modelName);
    map['year'] = Variable<int>(year);
    map['price'] = Variable<double>(price);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  MyCarsCompanion toCompanion(bool nullToAbsent) {
    return MyCarsCompanion(
      id: Value(id),
      carId:
          carId == null && nullToAbsent ? const Value.absent() : Value(carId),
      brand: Value(brand),
      modelName: Value(modelName),
      year: Value(year),
      price: Value(price),
      description: Value(description),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory MyCar.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MyCar(
      id: serializer.fromJson<int>(json['id']),
      carId: serializer.fromJson<int?>(json['carId']),
      brand: serializer.fromJson<String>(json['brand']),
      modelName: serializer.fromJson<String>(json['modelName']),
      year: serializer.fromJson<int>(json['year']),
      price: serializer.fromJson<double>(json['price']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'carId': serializer.toJson<int?>(carId),
      'brand': serializer.toJson<String>(brand),
      'modelName': serializer.toJson<String>(modelName),
      'year': serializer.toJson<int>(year),
      'price': serializer.toJson<double>(price),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  MyCar copyWith(
          {int? id,
          Value<int?> carId = const Value.absent(),
          String? brand,
          String? modelName,
          int? year,
          double? price,
          String? description,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      MyCar(
        id: id ?? this.id,
        carId: carId.present ? carId.value : this.carId,
        brand: brand ?? this.brand,
        modelName: modelName ?? this.modelName,
        year: year ?? this.year,
        price: price ?? this.price,
        description: description ?? this.description,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  MyCar copyWithCompanion(MyCarsCompanion data) {
    return MyCar(
      id: data.id.present ? data.id.value : this.id,
      carId: data.carId.present ? data.carId.value : this.carId,
      brand: data.brand.present ? data.brand.value : this.brand,
      modelName: data.modelName.present ? data.modelName.value : this.modelName,
      year: data.year.present ? data.year.value : this.year,
      price: data.price.present ? data.price.value : this.price,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MyCar(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('brand: $brand, ')
          ..write('modelName: $modelName, ')
          ..write('year: $year, ')
          ..write('price: $price, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, carId, brand, modelName, year, price, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MyCar &&
          other.id == this.id &&
          other.carId == this.carId &&
          other.brand == this.brand &&
          other.modelName == this.modelName &&
          other.year == this.year &&
          other.price == this.price &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class MyCarsCompanion extends UpdateCompanion<MyCar> {
  final Value<int> id;
  final Value<int?> carId;
  final Value<String> brand;
  final Value<String> modelName;
  final Value<int> year;
  final Value<double> price;
  final Value<String> description;
  final Value<DateTime?> createdAt;
  const MyCarsCompanion({
    this.id = const Value.absent(),
    this.carId = const Value.absent(),
    this.brand = const Value.absent(),
    this.modelName = const Value.absent(),
    this.year = const Value.absent(),
    this.price = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MyCarsCompanion.insert({
    this.id = const Value.absent(),
    this.carId = const Value.absent(),
    required String brand,
    required String modelName,
    required int year,
    required double price,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : brand = Value(brand),
        modelName = Value(modelName),
        year = Value(year),
        price = Value(price);
  static Insertable<MyCar> custom({
    Expression<int>? id,
    Expression<int>? carId,
    Expression<String>? brand,
    Expression<String>? modelName,
    Expression<int>? year,
    Expression<double>? price,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (carId != null) 'car_id': carId,
      if (brand != null) 'brand': brand,
      if (modelName != null) 'model_name': modelName,
      if (year != null) 'year': year,
      if (price != null) 'price': price,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MyCarsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? carId,
      Value<String>? brand,
      Value<String>? modelName,
      Value<int>? year,
      Value<double>? price,
      Value<String>? description,
      Value<DateTime?>? createdAt}) {
    return MyCarsCompanion(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      brand: brand ?? this.brand,
      modelName: modelName ?? this.modelName,
      year: year ?? this.year,
      price: price ?? this.price,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (carId.present) {
      map['car_id'] = Variable<int>(carId.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (modelName.present) {
      map['model_name'] = Variable<String>(modelName.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MyCarsCompanion(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('brand: $brand, ')
          ..write('modelName: $modelName, ')
          ..write('year: $year, ')
          ..write('price: $price, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $MyCarsTable myCars = $MyCarsTable(this);
  late final FavoritesDao favoritesDao = FavoritesDao(this as AppDatabase);
  late final MyCarsDao myCarsDao = MyCarsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favorites, myCars];
}

typedef $$FavoritesTableCreateCompanionBuilder = FavoritesCompanion Function({
  Value<int> id,
  required int userId,
  required int carId,
  Value<DateTime> addedAt,
});
typedef $$FavoritesTableUpdateCompanionBuilder = FavoritesCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<int> carId,
  Value<DateTime> addedAt,
});

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carId => $composableBuilder(
      column: $table.carId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carId => $composableBuilder(
      column: $table.carId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get carId =>
      $composableBuilder(column: $table.carId, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$FavoritesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoritesTable,
    Favorite,
    $$FavoritesTableFilterComposer,
    $$FavoritesTableOrderingComposer,
    $$FavoritesTableAnnotationComposer,
    $$FavoritesTableCreateCompanionBuilder,
    $$FavoritesTableUpdateCompanionBuilder,
    (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
    Favorite,
    PrefetchHooks Function()> {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> carId = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
          }) =>
              FavoritesCompanion(
            id: id,
            userId: userId,
            carId: carId,
            addedAt: addedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required int carId,
            Value<DateTime> addedAt = const Value.absent(),
          }) =>
              FavoritesCompanion.insert(
            id: id,
            userId: userId,
            carId: carId,
            addedAt: addedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoritesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoritesTable,
    Favorite,
    $$FavoritesTableFilterComposer,
    $$FavoritesTableOrderingComposer,
    $$FavoritesTableAnnotationComposer,
    $$FavoritesTableCreateCompanionBuilder,
    $$FavoritesTableUpdateCompanionBuilder,
    (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
    Favorite,
    PrefetchHooks Function()>;
typedef $$MyCarsTableCreateCompanionBuilder = MyCarsCompanion Function({
  Value<int> id,
  Value<int?> carId,
  required String brand,
  required String modelName,
  required int year,
  required double price,
  Value<String> description,
  Value<DateTime?> createdAt,
});
typedef $$MyCarsTableUpdateCompanionBuilder = MyCarsCompanion Function({
  Value<int> id,
  Value<int?> carId,
  Value<String> brand,
  Value<String> modelName,
  Value<int> year,
  Value<double> price,
  Value<String> description,
  Value<DateTime?> createdAt,
});

class $$MyCarsTableFilterComposer
    extends Composer<_$AppDatabase, $MyCarsTable> {
  $$MyCarsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carId => $composableBuilder(
      column: $table.carId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelName => $composableBuilder(
      column: $table.modelName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$MyCarsTableOrderingComposer
    extends Composer<_$AppDatabase, $MyCarsTable> {
  $$MyCarsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carId => $composableBuilder(
      column: $table.carId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelName => $composableBuilder(
      column: $table.modelName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MyCarsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MyCarsTable> {
  $$MyCarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get carId =>
      $composableBuilder(column: $table.carId, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get modelName =>
      $composableBuilder(column: $table.modelName, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MyCarsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MyCarsTable,
    MyCar,
    $$MyCarsTableFilterComposer,
    $$MyCarsTableOrderingComposer,
    $$MyCarsTableAnnotationComposer,
    $$MyCarsTableCreateCompanionBuilder,
    $$MyCarsTableUpdateCompanionBuilder,
    (MyCar, BaseReferences<_$AppDatabase, $MyCarsTable, MyCar>),
    MyCar,
    PrefetchHooks Function()> {
  $$MyCarsTableTableManager(_$AppDatabase db, $MyCarsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MyCarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MyCarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MyCarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> carId = const Value.absent(),
            Value<String> brand = const Value.absent(),
            Value<String> modelName = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              MyCarsCompanion(
            id: id,
            carId: carId,
            brand: brand,
            modelName: modelName,
            year: year,
            price: price,
            description: description,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> carId = const Value.absent(),
            required String brand,
            required String modelName,
            required int year,
            required double price,
            Value<String> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              MyCarsCompanion.insert(
            id: id,
            carId: carId,
            brand: brand,
            modelName: modelName,
            year: year,
            price: price,
            description: description,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MyCarsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MyCarsTable,
    MyCar,
    $$MyCarsTableFilterComposer,
    $$MyCarsTableOrderingComposer,
    $$MyCarsTableAnnotationComposer,
    $$MyCarsTableCreateCompanionBuilder,
    $$MyCarsTableUpdateCompanionBuilder,
    (MyCar, BaseReferences<_$AppDatabase, $MyCarsTable, MyCar>),
    MyCar,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$MyCarsTableTableManager get myCars =>
      $$MyCarsTableTableManager(_db, _db.myCars);
}

mixin _$FavoritesDaoMixin on DatabaseAccessor<AppDatabase> {
  $FavoritesTable get favorites => attachedDatabase.favorites;
}
mixin _$MyCarsDaoMixin on DatabaseAccessor<AppDatabase> {
  $MyCarsTable get myCars => attachedDatabase.myCars;
}
