class Car {
  final int id;
  final String brand;
  final String modelName;
  final int year;
  final double price;
  final String description;
  final int owner;
  final DateTime createdAt;
  final double latitude;
  final double longitude;

  Car({
    required this.id,
    required this.brand,
    required this.modelName,
    required this.year,
    required this.price,
    required this.description,
    required this.owner,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
  });

  factory Car.fromJson(Map<String, dynamic> j) {
    int parsedYear;
    final rawYear = j['year'];
    if (rawYear is int) {
      parsedYear = rawYear;
    } else if (rawYear is String) {
      parsedYear = int.tryParse(rawYear) ?? 0;
    } else {
      parsedYear = 0;
    }

    double parsedPrice;
    final rawPrice = j['price'];
    if (rawPrice is num) {
      parsedPrice = rawPrice.toDouble();
    } else if (rawPrice is String) {
      parsedPrice = double.tryParse(rawPrice) ?? 0.0;
    } else {
      parsedPrice = 0.0;
    }

    double parsedLatitude = 0.0;
    final rawLat = j['latitude'];
    if (rawLat is num) {
      parsedLatitude = rawLat.toDouble();
    } else if (rawLat is String) {
      parsedLatitude = double.tryParse(rawLat) ?? 0.0;
    }

    double parsedLongitude = 0.0;
    final rawLon = j['longitude'];
    if (rawLon is num) {
      parsedLongitude = rawLon.toDouble();
    } else if (rawLon is String) {
      parsedLongitude = double.tryParse(rawLon) ?? 0.0;
    }

    return Car(
      id: j['id'] as int,
      brand: j['brand'] as String,
      modelName: j['model_name'] as String,
      year: parsedYear,
      price: parsedPrice,
      description: j['description'] as String? ?? '',
      owner: j['owner'] as int,
      createdAt: DateTime.parse(j['created_at'] as String),
      latitude: parsedLatitude,
      longitude: parsedLongitude,
    );
  }

  Map<String, dynamic> toJson() => {
        'brand': brand,
        'model_name': modelName,
        'year': year,
        'price': price,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        // owner ve created_at sunucuda atanır
      };

  Car copyWith({
    int? id,
    String? brand,
    String? modelName,
    int? year,
    double? price,
    String? description,
    int? owner,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
  }) {
    return Car(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      modelName: modelName ?? this.modelName,
      year: year ?? this.year,
      price: price ?? this.price,
      description: description ?? this.description,
      owner: owner ?? this.owner,
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
