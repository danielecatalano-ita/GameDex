import 'package:flutter/material.dart';

class GameDetailPage extends StatelessWidget {
  final Map<String, dynamic> game;

  const GameDetailPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game['name'] ?? 'Dettagli gioco'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              game['image'] ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              game['name'] ?? 'Nome non disponibile',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(game['description'] ?? 'Descrizione non disponibile'),
          ],
        ),
      ),
    );
  }
}
