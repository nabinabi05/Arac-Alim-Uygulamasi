/// lib/dio_jwt_interceptor.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _storage = const FlutterSecureStorage();

Interceptor jwtInterceptor() => InterceptorsWrapper(
  onRequest: (options, handler) async {
    // 1) If this request is going to /users/ or /token/, skip attaching a token:
    //
    //    - options.path is just the path part, e.g. "/users/" or "/token/".
    //    - We compare directly so we don’t inadvertently send any stale/expired JWT
    //      to an endpoint that should be public.
    final path = options.path;
    if (path == '/users/' || path == '/token/' || path == '/token/refresh/') {
      return handler.next(options);
    }

    // 2) Otherwise, read the stored JWT (if any) and add it to the header:
    final token = await _storage.read(key: 'jwt');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  },
);
