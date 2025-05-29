class Car {
  final int id;
  final String brand;
  final String modelName;
  final int year;
  final double price;
  final String description;

  Car({
    required this.id,
    required this.brand,
    required this.modelName,
    required this.year,
    required this.price,
    required this.description,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json['id'] as int,
        brand: json['brand'] as String,
        modelName: json['model_name'] as String,
        year: json['year'] as int,
        price: (json['price'] as num).toDouble(),
        description: json['description'] as String? ?? '',
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model_name': modelName,
      'year': year,
      'price': price,
      'description': description,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) => Car(
        id: map['id'] as int,
        brand: map['brand'] as String,
        modelName: map['model_name'] as String,
        year: map['year'] as int,
        price: (map['price'] as num).toDouble(),
        description: map['description'] as String? ?? '',
      );
}
