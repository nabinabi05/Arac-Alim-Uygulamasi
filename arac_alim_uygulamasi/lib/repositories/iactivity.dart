import '../models/activity.dart';

abstract class IActivityRepository {
  /// Tüm aktiviteleri getir (isteğe bağlı filtre ile)
  Future<List<Activity>> fetchAll({Map<String, dynamic>? filters});

  /// ID ile tek bir aktivite getir
  Future<Activity> fetchById(String id);

  /// Yeni bir aktivite oluştur
  Future<Activity> create(Activity activity);
}
