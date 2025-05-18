import 'dart:io';

import 'package:dio/dio.dart';
import 'package:remember_me/app/api/dio_client.dart';
import 'package:remember_me/app/api/result.dart';
import 'package:remember_me/app/api/token.dart';
import 'package:remember_me/app/auth/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:remember_me/app/provider/user/user.dart';
import 'package:remember_me/app/screens/history/logic/history.dart';
import 'package:uuid/uuid.dart';

class ApiService {
  static ApiService get I => GetIt.I<ApiService>();

  late final MyDio _dio;

  void setAuthService(AuthService authService) =>
      _dio.setAuthService(authService);

  ApiService() {
    _dio = MyDio(dio: Dio(), rawDio: Dio());
  }

  Future<Result<String>> getAnswer(String text) async {
    return _dio.post(
      "/api/v1/memories/recall",
      data: {"query": text},
      fromJson: (json) => json["answer"],
    );
  }

  Future<Result<Token>> signIn(String email, String password) => _dio.post(
    "/api/v1/auth/signin",
    data: {"email": email, "password": password},
    fromJson: (json) => Token.fromJson(json),
  );

  Future<Result<Token>> signUp(String email, String password, String name) =>
      _dio.post(
        "/api/v1/auth/signup",
        data: {
          "email": email,
          "password": password,
          "firebase_uid": const Uuid().v4(),
          "display_name": name,
        },
        fromJson: (json) => Token.fromJson(json),
      );

  Future<Result<Token>> refreshToken(String refreshToken) => _dio.post(
    "/api/v1/auth/refresh",
    data: {"refresh_token": refreshToken},
    fromJson: (json) => Token.fromJson(json),
    isRaw: true,
  );

  Future<Result<User>> getUser() =>
      _dio.get("/api/v1/users/me", fromJson: (json) => User.fromJson(json));

  Future<Result<bool>> uploadTextMemory(String text) async =>
      _dio.post("/api/v1/memories/text", data: {"text": text});

  Future<Result<bool>> uploadImageMemory(File image, String fileUrl) async {
    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(image.path),
      "image_url": fileUrl,
    });
    return _dio.post("/api/v1/memories/image", data: formData);
  }

  Future<Result<List<History>>> getHistories() async {
    return _dio.get(
      "/api/v1/memories/me",
      fromJson:
          (json) =>
              (json["memories"])
                  .map<History>((e) => History.fromJson(e))
                  .toList(),
    );
  }
}
