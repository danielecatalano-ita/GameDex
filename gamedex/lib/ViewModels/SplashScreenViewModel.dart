import 'package:flutter/material.dart';

class SplashScreenViewModel extends ChangeNotifier {
  late final AnimationController progressController;
  final AssetImage logoImage = const AssetImage('assets/images/gamedex_logo.png');
  bool didPrecache = false;
  static const int splashSeconds = 3;

  // Passa il vsync dalla View (State)
  void init(TickerProvider vsync, VoidCallback onCompleted) {
    progressController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: splashSeconds),
    );

    progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onCompleted();
      }
    });

    progressController.forward();
  }

  void precacheLogo(BuildContext context) {
    if (!didPrecache) {
      precacheImage(logoImage, context);
      didPrecache = true;
    }
  }

  void disposeVM() {
    progressController.dispose();
  }

  double computeOpacity(double t) {
    const double fadePortion = 0.2;
    if (t <= 0) return 0.0;
    if (t < fadePortion) return (t / fadePortion);
    if (t > 1 - fadePortion) return ((1 - t) / fadePortion).clamp(0.0, 1.0);
    return 1.0;
  }
}
