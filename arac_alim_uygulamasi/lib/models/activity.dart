// lib/models/activity.dart
class Activity {
  final int id;
  final int carId;
  final String activityType; // ör: "price_update"
  final String message;
  final DateTime timestamp;

  Activity({
    required this.id,
    required this.carId,
    required this.activityType,
    required this.message,
    required this.timestamp,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'] as int,
        carId: json['car'] as int,
        activityType: json['activity_type'] as String,
        message: json['message'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  Map<String, dynamic> toJson() => {
        'car': carId,
        'activity_type': activityType,
        'message': message,
      };
}
