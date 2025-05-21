class Order {
  int? id;
  int userId;
  int carId;
  String date;

  Order({this.id, required this.userId, required this.carId, required this.date});

  factory Order.fromMap(Map<String, dynamic> m) =>
    Order(
      id: m['id'],
      userId: m['userId'],
      carId: m['carId'],
      date: m['date'],
    );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'userId': userId,
    'carId': carId,
    'date': date,
  };
}
