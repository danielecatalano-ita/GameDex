import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModels/WishlistViewModel.dart';
import '../Games/GameDetailPageView.dart';

class WishlistScreenView extends StatefulWidget {
  const WishlistScreenView({super.key});

  @override
  State<WishlistScreenView> createState() => _WishlistScreenViewState();
}

class _WishlistScreenViewState extends State<WishlistScreenView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final wishlistVM = Provider.of<WishlistViewModel>(context);
    final wishlist = wishlistVM.wishlist
        .where((game) =>
        game.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔍 Barra di ricerca
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Cerca nella wishlist...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🎮 Controllo se la wishlist è vuota
          if (wishlist.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "Wishlist vuota",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
            )
          else
          // 🎮 Griglia giochi
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: wishlist.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final game = wishlist[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                GameDetailPageView(game: game.toJson()),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          game.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 48),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
