import 'package:flutter/material.dart';

import 'Games/games.dart';

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
      home: const PlatformSelectionScreen(),
    );
  }
}

class PlatformSelectionScreen extends StatefulWidget {
  const PlatformSelectionScreen({super.key});

  @override
  State<PlatformSelectionScreen> createState() =>
      _PlatformSelectionScreenState();
}

class _PlatformSelectionScreenState extends State<PlatformSelectionScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // qui puoi gestire la navigazione verso altre schermate
    });
  }

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
            // Testo
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
                children: [
                  _buildPlatformCard("assets/images/playstation.png", "PlayStation"),
                  const SizedBox(height: 20),
                  _buildPlatformCard("assets/images/xbox.png", "Xbox"),
                  const SizedBox(height: 20),
                  _buildPlatformCard("assets/images/nintendo.png", "Nintendo"),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.purple,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformCard(String imagePath, String title) {
    return InkWell(
      onTap: () {
        // Naviga alla schermata di dettaglio
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
