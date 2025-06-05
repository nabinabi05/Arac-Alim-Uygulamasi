/// lib/providers/repositories.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../constants.dart';
import '../dio_jwt_interceptor.dart';

import '../repositories/auth_repository_api.dart';
import '../repositories/car_repository_api.dart';
import '../repositories/activity_repository_api.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: kApiBase))
    // 1) Interceptor to attach JWT if available
    ..interceptors.add(jwtInterceptor())
    // 2) LogInterceptor to print request/response to console
    ..interceptors.add(
      LogInterceptor(
        request: true,        // log request method & URL & headers & body
        requestBody: true,    // log JSON bodies
        responseBody: true,   // log response bodies
        responseHeader: false,
        requestHeader: false,
      ),
    );
  return dio;
});

/// AuthRepository
final authRepoProvider = Provider<AuthRepositoryApi>((ref) {
  return AuthRepositoryApi(ref.read(dioProvider));
});

/// CarRepository
final carRepoProvider = Provider<CarRepositoryApi>((ref) {
  return CarRepositoryApi(ref.read(dioProvider));
});

/// ActivityRepository
final activityRepoProvider = Provider<ActivityRepositoryApi>((ref) {
  return ActivityRepositoryApi(ref.read(dioProvider));
});
