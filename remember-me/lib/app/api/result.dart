import 'package:remember_me/app/api/api_error.dart';

class Result<S> {
  final S? _success;
  final ApiError? _error;
  final bool isSuccess;

  Result._({S? success, ApiError? error, required this.isSuccess})
    : _success = success,
      _error = error;

  factory Result.success(S data) {
    return Result._(success: data, error: null, isSuccess: true);
  }

  factory Result.failure(ApiError error) {
    return Result._(success: null, error: error, isSuccess: false);
  }

  S get data {
    if (!isSuccess) throw Exception("Cannot get data from error result");
    return _success!;
  }

  ApiError get error {
    if (isSuccess) throw Exception("Cannot get error from success result");
    return _error!;
  }

  R fold<R>({
    required R Function(S data) onSuccess,
    required R Function(ApiError error) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess(_success as S);
    } else {
      return onFailure(_error!);
    }
  }

  Result<T> map<T>(T Function(S data) mapper) {
    if (isSuccess) {
      return Result.success(mapper(_success as S));
    } else {
      return Result.failure(_error!);
    }
  }

  Future<Result<T>> asyncMap<T>(Future<T> Function(S data) mapper) async {
    if (isSuccess) {
      try {
        final mapped = await mapper(_success as S);
        return Result.success(mapped);
      } catch (e) {
        return Result.failure(_error as ApiError);
      }
    } else {
      return Result.failure(_error!);
    }
  }
}
