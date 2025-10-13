import 'package:flutter/material.dart';
import 'Splash_screen/splash.dart';

void main() {
  runApp(const GameDexApp());
}

class GameDexApp extends StatelessWidget {
  const GameDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameDex',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
