import 'package:flutter/material.dart';

/// --- WISHLIST SCREEN (vuota per ora) ---
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Wishlist vuota",
        style: TextStyle(fontSize: 20, color: Colors.grey),
      ),
    );
  }
}
