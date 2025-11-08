import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'router/app_router.dart'; //  GoRouter config

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Initialize Supabase
  await Supabase.initialize(
    url: 'https://qswnbtetcfqeijvwevty.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzd25idGV0Y2ZxZWlqdndldnR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI0MTUxMzAsImV4cCI6MjA3Nzk5MTEzMH0.GzR6SuCAHUK2OW5g450dVOdzUqnZSVybpHi17m4T7I0',
  );

  // 2) Clean URLs for web
  setUrlStrategy(PathUrlStrategy());

  // 3) Run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Realfun Attendance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router, // now auth-aware
    );
  }
}
