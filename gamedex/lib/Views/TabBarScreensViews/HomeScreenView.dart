import 'package:flutter/material.dart';
import '../Games/GamesListView.dart';


/// --- HOME SCREEN (scelta piattaforma) ---
class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo + Nome App
            Column(
              children: [
                Image.asset(
                  "assets/images/gamedex_logo.png",
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 8),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Scegli la piattaforma:",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            // Liste piattaforme
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                children: const [
                  PlatformCard(
                      imagePath: "assets/images/playstation.png",
                      title: "PlayStation"),
                  SizedBox(height: 20),
                  PlatformCard(
                      imagePath: "assets/images/xbox.png", title: "Xbox"),
                  SizedBox(height: 20),
                  PlatformCard(
                      imagePath: "assets/images/nintendo.png",
                      title: "Nintendo"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- CARD PIATTAFORMA ---
class PlatformCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const PlatformCard({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GamesList(platformName: title),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imagePath,
            height: 140,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}