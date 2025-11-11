// app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';


import '../pages/home/home_page.dart';
import '../pages/login_signup/login_signup_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',

    // Rebuild router when auth state changes (login/logout)
    refreshListenable: GoRouterRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange,
    ),

    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final loggingIn = state.matchedLocation == '/login';

      // not logged in → force to /login
      if (session == null && !loggingIn) {
        return '/login';
      }

      // logged in but on /login → send to /home
      if (session != null && loggingIn) {
        return '/home';
      }

      // no change
      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginSignupPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}

/// Tiny helper so go_router reacts to auth changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
