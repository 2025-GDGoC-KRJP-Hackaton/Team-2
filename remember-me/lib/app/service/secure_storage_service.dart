import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:remember_me/app/api/token.dart';

class SecureStorageService {
  static SecureStorageService get I => GetIt.I<SecureStorageService>();

  late final FlutterSecureStorage secureStorage;

  Future<String?> get accessToken => secureStorage.read(key: "jwtAccessToken");
  Future<String?> get refreshToken =>
      secureStorage.read(key: "jwtRefreshToken");

  void init() {
    secureStorage = const FlutterSecureStorage();
  }

  Future<void> setTokens(Token token) async {
    await Future.wait([
      secureStorage.write(key: "jwtAccessToken", value: token.access_token),
      secureStorage.write(key: "jwtRefreshToken", value: token.refresh_token),
    ]);
  }

  Future<Token?> getTokens() async {
    final accessToken = await secureStorage.read(key: "jwtAccessToken");
    final refreshToken = await secureStorage.read(key: "jwtRefreshToken");
    if (accessToken == null || refreshToken == null) return null;
    return Token(access_token: accessToken, refresh_token: refreshToken);
  }

  Future<void> removeTokens() async {
    await secureStorage.delete(key: "jwtAccessToken");
    await secureStorage.delete(key: "jwtRefreshToken");
  }

  Future<void> deleteAll() async {
    await secureStorage.deleteAll();
  }
}
