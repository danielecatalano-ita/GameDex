import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Models/GamesListModel.dart';
import '../../Models/platform_color_helper.dart';
import '../../ViewModels/WishlistViewModel.dart';

class GameDetailPageView extends StatefulWidget {
  final Map<String, dynamic> game;

  const GameDetailPageView({super.key, required this.game});

  @override
  State<GameDetailPageView> createState() => _GameDetailPageViewState();
}

class _GameDetailPageViewState extends State<GameDetailPageView> {
  @override
  Widget build(BuildContext context) {
    final wishlistVM = Provider.of<WishlistViewModel>(context);
    final game = Game.fromJson(widget.game);

    bool isFavorite = wishlistVM.isInWishlist(game);

    String listToString(dynamic list) {
      if (list == null) return 'N/D';
      if (list is List && list.isNotEmpty) {
        return list.map((e) => e.toString()).join(', ');
      }
      if (list is String && list.isNotEmpty) return list;
      return 'N/D';
    }

    String releaseDatesToString(dynamic dates) {
      if (dates == null) return 'N/D';
      if (dates is Map && dates.isNotEmpty) {
        return dates.entries.map((e) => '${e.key}: ${e.value}').join('\n');
      }
      return 'N/D';
    }

    List<TextSpan> _buildLinks(dynamic links, BuildContext context) {
      if (links == null) {
        return [
          const TextSpan(
            text: 'N/D',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          )
        ];
      }

      List<String> linkList = [];
      if (links is List && links.isNotEmpty) {
        linkList = links.map((e) => e.toString()).toList();
      } else if (links is String && links.isNotEmpty) {
        linkList = [links];
      }

      return linkList.map((link) {
        return TextSpan(
          text: link + '\n',
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.parse(link);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Impossibile aprire il link')),
                );
              }
            },
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(game.name ?? 'Dettagli gioco'),
        backgroundColor: PlatformColorHelper.getColor(game.platform),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              wishlistVM.toggleWishlist(game);
              setState(() {}); // Aggiorna la stella
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite
                        ? '${game.name} rimosso dalla Wishlist'
                        : '${game.name} aggiunto alla Wishlist',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    game.image ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              game.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              game.description ?? 'Descrizione non disponibile',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _infoRow('Genere', listToString(game.genre)),
            _infoRow('Sviluppatori', listToString(game.developers)),
            _infoRow('Publisher', listToString(game.publishers)),
            _infoRow('Piattaforma', game.platform ?? 'N/D'),
            _infoRow('Date di rilascio', releaseDatesToString(game.releaseDates)),
            _infoRow('Prezzo',
                game.price != null ? '\$${game.price?.toStringAsFixed(2)}' : 'N/D'),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Link utili:\n',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 20),
                  ),
                  ..._buildLinks(game.usefull_links, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
