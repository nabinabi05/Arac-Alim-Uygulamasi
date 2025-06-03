import 'package:dio/dio.dart';
import '../models/activity.dart';
import 'iactivity.dart';

class ActivityRepositoryApi implements IActivityRepository {
  final Dio _dio;
  ActivityRepositoryApi(this._dio);

  @override
  Future<List<Activity>> fetchAll({Map<String, dynamic>? filters}) async {
    final res = await _dio.get('/activities/', queryParameters: filters);
    return (res.data as List)
        .map((e) => Activity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Activity> fetchById(String id) async {
    final res = await _dio.get('/activities/$id/');
    return Activity.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<Activity> create(Activity activity) async {
    final res = await _dio.post('/activities/', data: activity.toJson());
    return Activity.fromJson(res.data as Map<String, dynamic>);
  }
}
