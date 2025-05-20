class Car {
  int? id;
  String brand;
  String model;
  double price;

  Car({this.id, required this.brand, required this.model, required this.price});

  factory Car.fromMap(Map<String, dynamic> m) =>
    Car(id: m['id'], brand: m['brand'], model: m['model'], price: m['price']);

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'brand': brand,
    'model': model,
    'price': price,
  };
}