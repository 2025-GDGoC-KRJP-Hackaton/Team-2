import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:remember_me/app/auth/auth_state.dart';
import 'package:remember_me/app/screens/history/history_page.dart';
import 'package:remember_me/app/screens/home/home_page.dart';
import 'package:remember_me/app/screens/home_screen.dart';
import 'package:remember_me/app/screens/login/login_page.dart';

extension GoRouterX on GoRouter {
  BuildContext? get context => configuration.navigatorKey.currentContext;
  OverlayState? get overlayState {
    final context = this.context;
    if (context == null) return null;
    return Overlay.of(context);
  }

  Uri get currentUri {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList =
        lastMatch is ImperativeRouteMatch
            ? lastMatch.matches
            : routerDelegate.currentConfiguration;
    return matchList.uri;
  }
}

abstract class Routes {
  static const String home = '/';
  static const String error = '/error';
  static const String login = '/login';
  static const String register = '/register';
  static const String history = '/history';
}

class RouterService {
  static RouterService get I => GetIt.I<RouterService>();

  late final GoRouter router;
  final ProviderContainer container;

  RouterService({required this.container});

  String? queryParameter(String key) => router.currentUri.queryParameters[key];

  void init() {
    final refreshListenable = AuthStateListenable(container);
    router = GoRouter(
      initialLocation: Routes.home,
      redirect: (context, state) {
        final authState = container.read(authStateProvider);

        if (authState.isLoggedIn) {
          return null;
        }
        return Routes.login;
      },
      routes: [
        GoRoute(
          path: Routes.login,
          builder: (context, state) {
            return LoginPage();
          },
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            return HomePage();
          },
        ),
        GoRoute(
          path: Routes.history,
          builder: (context, state) {
            return HistoryPage();
          },
        ),
      ],
      refreshListenable: refreshListenable,
    );
  }
}
