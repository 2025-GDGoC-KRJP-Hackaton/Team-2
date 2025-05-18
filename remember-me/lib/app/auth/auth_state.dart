import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remember_me/app/api/token.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

final authStateProvider = NotifierProvider<_AuthStateNotifier, AuthState>(
  _AuthStateNotifier.new,
);

class _AuthStateNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState(isLoggedIn: true);
  }

  void setTokens(Token token) {
    state = state.copyWith(
      accessToken: token.access_token,
      refreshToken: token.refresh_token,
      isLoggedIn: true,
    );
  }

  void removeToken() {
    state = state.copyWith(
      accessToken: null,
      refreshToken: null,
      isLoggedIn: false,
    );
  }
}

class AuthStateListenable extends ChangeNotifier {
  AuthStateListenable(this.container) {
    _subscription = container.listen<AuthState>(authStateProvider, (
      previous,
      next,
    ) {
      notifyListeners();
    });
  }

  final ProviderContainer container;
  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

@freezed
class AuthState with _$AuthState {
  factory AuthState({
    required bool isLoggedIn,
    String? accessToken,
    String? refreshToken,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}
