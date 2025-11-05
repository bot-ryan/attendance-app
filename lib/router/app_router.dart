// lib/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../pages/home/home_page.dart';
import '../pages/login_signup/login_signup_page.dart';

/// Central place to define all routes.
/// You can add guards, redirects, nested routes, etc. here later.
class AppRouter {
  // Expose a singleton router so you can import and use it in main.dart
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/home',
        name: AppRouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        name: AppRouteNames.login,
        builder: (context, state) => const LoginSignupPage(),
      ),
    ],
    // Optional: a simple 404 page
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(child: Text('Page not found: ${state.uri}')),
      ),
    ),
  );
}

/// Keeping route names centralized helps avoid typos.
abstract class AppRouteNames {
  static const home = 'home';
  static const login = 'login';
}
