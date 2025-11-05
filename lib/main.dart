import 'package:flutter/material.dart';
import 'router/app_router.dart'; //to do routing such as /login and /home
import 'package:flutter_web_plugins/url_strategy.dart'; 






void main() {
  setUrlStrategy(PathUrlStrategy()); // clean web URLs (no #)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3) Use MaterialApp.router
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Realfun Attendance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
