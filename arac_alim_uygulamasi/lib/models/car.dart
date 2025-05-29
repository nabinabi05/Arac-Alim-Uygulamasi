class Car {
  final int id;
  final String brand;
  final String modelName;
  final int year;
  final double price;
  final String description;
  final double? latitude;
  final double? longitude;

  Car({
    required this.id,
    required this.brand,
    required this.modelName,
    required this.year,
    required this.price,
    required this.description,
    this.latitude,
    this.longitude,
  });

  factory Car.fromMap(Map<String, dynamic> m) => Car(
    id: m['id'] as int,
    brand: m['brand'] as String,
    modelName: m['modelName'] as String,
    year: m['year'] as int,
    price: (m['price'] as num).toDouble(),
    description: m['description'] as String,
    latitude: m['latitude'] != null ? (m['latitude'] as num).toDouble() : null,
    longitude: m['longitude'] != null ? (m['longitude'] as num).toDouble() : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'brand': brand,
    'modelName': modelName,
    'year': year,
    'price': price,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
  };
