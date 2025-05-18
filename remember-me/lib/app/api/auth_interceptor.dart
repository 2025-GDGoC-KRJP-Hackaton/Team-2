import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:remember_me/app/auth/auth_service.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final AuthService authService;
  final Dio dio;
  final Dio rawDio;

  AuthInterceptor({
    required this.authService,
    required this.dio,
    required this.rawDio,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers = Map<String, dynamic>.from(options.headers);

    if (authService.state.isLoggedIn && authService.state.accessToken != null) {
      options.headers["Authorization"] =
          "Bearer ${authService.state.accessToken}";
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (AuthService.I.state.isLoggedIn == false) {
      return super.onError(err, handler);
    }
    try {
      await authService.refreshAccessToken();

      final updatedHeaders = Map<String, dynamic>.from(
        err.requestOptions.headers,
      );
      updatedHeaders["Authorization"] =
          "Bearer ${authService.state.accessToken}";
      err.requestOptions.headers = updatedHeaders;

      final res = await rawDio.fetch(err.requestOptions);

      return handler.resolve(res);
    } catch (error) {
      if (_isTokenError(error)) {
        await authService.handleTokenExpiration();
      }
      if (error is DioException) {
        return handler.next(error);
      }
    }
  }

  bool _isTokenError(Object error) {
    if (error is DioException) {
      return error.response?.statusCode == 401;
    }

    return false;
  }
}
