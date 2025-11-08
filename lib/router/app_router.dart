import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/home/home_page.dart';
import '../pages/login_signup/login_signup_page.dart';

/// Central place to define all routes.
/// Includes Supabase auth integration for auto redirect.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',

    // Rebuild router whenever auth state changes
    refreshListenable: GoRouterRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange,
    ),

    // Redirect logic based on current Supabase session
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final bool isLoggedIn = session != null;
      final bool isLoggingIn = state.matchedLocation == '/login';

      // Not logged in → force login page
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // Logged in → block access to login page
      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      // Otherwise stay where you are
      return null;
    },

    // Define routes
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

    // Optional: Simple 404 page
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(child: Text('Page not found: ${state.uri}')),
      ),
    ),
  );
}

/// Centralized route names to avoid typos.
abstract class AppRouteNames {
  static const home = 'home';
  static const login = 'login';
}

/// Helper: notifies GoRouter when the Supabase auth stream changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
