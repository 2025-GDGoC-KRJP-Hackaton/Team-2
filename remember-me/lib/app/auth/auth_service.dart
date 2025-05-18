import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:remember_me/app/api/api_service.dart';
import 'package:remember_me/app/api/token.dart';
import 'package:remember_me/app/auth/auth_state.dart';
import 'package:remember_me/app/service/secure_storage_service.dart';

class AuthService {
  static AuthService get I => GetIt.I<AuthService>();

  late final ProviderContainer container;
  final ApiService _api;
  final SecureStorageService secureStorageService;

  AuthState get state => container.read(authStateProvider);

  AuthService({
    required ApiService api,
    required this.secureStorageService,
    required this.container,
  }) : _api = api {
    _api.setAuthService(this);
  }
  Future<AuthService> init() async {
    final tokens = await secureStorageService.getTokens();

    if (tokens != null) {
      container.read(authStateProvider.notifier).setTokens(tokens);
    }
    return this;
  }

  Future<void> refreshAccessToken() async {
    if (state.refreshToken == null) return;
    final response = await ApiService.I.refreshToken(state.refreshToken!);

    response.fold(
      onSuccess: (token) => setTokens(token),
      onFailure: (e) {
        throw e;
      },
    );
  }

  Future<void> handleTokenExpiration() async {
    secureStorageService.removeTokens();
    container.read(authStateProvider.notifier).removeToken();
  }

  void setTokens(Token token) {
    secureStorageService.setTokens(token);
    container.read(authStateProvider.notifier).setTokens(token);
  }

  void logout() async {
    container.read(authStateProvider.notifier).removeToken();
    secureStorageService.removeTokens();
  }
}
