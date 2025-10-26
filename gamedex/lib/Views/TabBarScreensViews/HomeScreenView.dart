import 'package:flutter/material.dart';
import 'package:gamedex/Views/TabBarScreensViews/ProfileScreenView.dart';
import 'package:gamedex/Views/TabBarScreensViews/WishlistScreenView.dart';
import '../Games/GamesListView.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = const [
    HomeTab(),
    WishlistScreenView(),
    ProfileScreenView(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Swipe disabilitato
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: const Color(0xFF6E24FF),
        activeColor: Colors.white,
        color: Colors.black54,
        style: TabStyle.react,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.favorite, title: 'Wishlist'),
          TabItem(icon: Icons.person, title: 'Profilo'),
        ],
        initialActiveIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}

/// --- HOME TAB ---
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 50),
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
