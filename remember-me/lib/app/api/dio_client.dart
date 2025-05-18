import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:remember_me/app/api/api_error.dart';
import 'package:remember_me/app/api/auth_interceptor.dart';
import 'package:remember_me/app/api/result.dart';
import 'package:remember_me/app/auth/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:remember_me/app/route/router_service.dart';

class MyDio {
  final Dio dio;
  final Dio rawDio;
  final _host =
      bool.parse(dotenv.env["API_DEBUG"] ?? "false")
          ? "http://localhost:8000"
          : dotenv.env["API_ADDRESS"].toString();

  MyDio({required this.dio, required this.rawDio}) {
    dio.options.baseUrl = _host;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.interceptors.add(LogInterceptor(responseBody: true));

    rawDio.options.baseUrl = _host;
    rawDio.interceptors.add(LogInterceptor(responseBody: true));
  }

  void setAuthService(AuthService service) => dio.interceptors.add(
    AuthInterceptor(authService: service, dio: dio, rawDio: rawDio),
  );

  Future<Result<T>> _request<T>({
    required String path,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool isRaw = false,
  }) async {
    try {
      final dio = isRaw ? rawDio : this.dio;

      final response = await dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          followRedirects: true,
          maxRedirects: 5,
          persistentConnection: true,
          preserveHeaderCase: false,
        ),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (fromJson != null) {
        return Result.success(fromJson(response.data));
      } else {
        return Result.success(response.data as T);
      }
    } on DioException catch (e) {
      return Result.failure(ApiError.fromDioError(e));
    } catch (e) {
      if (kDebugMode) rethrow;
      return Result.failure(ApiError.unknown(e));
    }
  }

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    void Function(int, int)? onReceiveProgress,
    bool isRaw = false,
  }) async {
    return _request<T>(
      path: path,
      method: 'GET',
      queryParameters: queryParameters,
      fromJson: fromJson,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool isRaw = false,
  }) async {
    return _request<T>(
      path: path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      fromJson: fromJson,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      isRaw: isRaw,
    );
  }

  Future<Result<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return _request<T>(
      path: path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      fromJson: fromJson,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Result<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path: path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      fromJson: fromJson,
    );
  }

  Future<Result<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return _request<T>(
      path: path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      fromJson: fromJson,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
