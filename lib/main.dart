import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart'; 


//web pages
import 'pages/login_signup/login_signup_page.dart';
import 'pages/home/home_page.dart';



void main() {
  setUrlStrategy(PathUrlStrategy()); // clean web URLs (no #)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 1) Create the router
  static final _router = GoRouter(
    // Which URL opens first if none specified:
    initialLocation: '/login',

    // 2) Declare routes
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginSignupPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // 3) Use MaterialApp.router
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Realfun Attendance',
      routerConfig: _router, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
