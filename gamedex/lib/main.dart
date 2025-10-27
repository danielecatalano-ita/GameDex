import 'package:flutter/material.dart';
import 'package:gamedex/ViewModels/AuthViewModel.dart';
import 'package:gamedex/Views/Splash_screen/SplashScreenView.dart';
import 'package:provider/provider.dart';
import 'Views/Splash_screen/SplashScreenView.dart';
import 'ViewModels/WishlistViewModel.dart';

void main() {
  runApp(const GameDexApp());
}

class GameDexApp extends StatelessWidget {
  const GameDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        title: 'GameDex',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: const SplashScreenView(),
      ),
    );
  }
}
