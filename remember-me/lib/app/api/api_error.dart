// api_error.dart
import 'package:dio/dio.dart';

enum ErrorType {
  network,
  badRequest,
  unauthorized,
  badCredentials,
  notFound,
  serverError,
  unknown,
}

class ApiError {
  final ErrorType type;
  final String message;
  final int? statusCode;
  final dynamic rawError;

  ApiError({
    required this.type,
    required this.message,
    this.statusCode,
    this.rawError,
  });

  factory ApiError.unknown(dynamic e) {
    return ApiError(
      type: ErrorType.unknown,
      message: "알 수 없는 오류가 발생했습니다.",
      rawError: e,
    );
  }

  factory ApiError.fromDioError(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return ApiError(
          type: ErrorType.network,
          message: "네트워크 연결에 문제가 있습니다.",
          statusCode: statusCode,
          rawError: error,
        );

      case DioExceptionType.badResponse:
        if (statusCode == null) {
          return ApiError(
            type: ErrorType.unknown,
            message: "알 수 없는 오류가 발생했습니다.",
            rawError: error,
          );
        }

        if (statusCode == 400) {
          return ApiError(
            type: ErrorType.badRequest,
            message: "잘못된 요청입니다.",
            statusCode: statusCode,
            rawError: error,
          );
        } else if (statusCode == 401 || statusCode == 403) {
          return ApiError(
            type: ErrorType.unauthorized,
            message: "인증에 실패했습니다.",
            statusCode: statusCode,
            rawError: error,
          );
        } else if (statusCode == 404) {
          return ApiError(
            type: ErrorType.notFound,
            message: "요청한 리소스를 찾을 수 없습니다.",
            statusCode: statusCode,
            rawError: error,
          );
        } else if (statusCode == 422) {
          return ApiError(
            type: ErrorType.badCredentials,
            message: "잘못된 요청 정보입니다.",
            statusCode: statusCode,
            rawError: error,
          );
        } else if (statusCode >= 500) {
          return ApiError(
            type: ErrorType.serverError,
            message: "서버 오류가 발생했습니다.",
            statusCode: statusCode,
            rawError: error,
          );
        } else {
          return ApiError(
            type: ErrorType.unknown,
            message: "알 수 없는 오류가 발생했습니다.",
            statusCode: statusCode,
            rawError: error,
          );
        }

      default:
        return ApiError(
          type: ErrorType.unknown,
          message: "알 수 없는 오류가 발생했습니다.",
          rawError: error,
        );
    }
  }
}
