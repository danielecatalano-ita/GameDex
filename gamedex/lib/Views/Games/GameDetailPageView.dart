import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDetailPageView extends StatelessWidget {
  final Map<String, dynamic> game;

  const GameDetailPageView({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // Funzione di supporto per visualizzare liste come stringa separata da virgole
    String listToString(dynamic list) {
      try {
        if (list == null) return 'N/D';
        if (list is List && list.isNotEmpty) {
          return list.map((e) => e.toString()).join(', ');
        }
        if (list is String && list.isNotEmpty) return list;
        return 'N/D';
      } catch (e) {
        return 'N/D';
      }
    }

    // Formatta le date di release
    String releaseDatesToString(dynamic dates) {
      if (dates == null) return 'N/D';
      if (dates is Map) {
        if (dates.isEmpty) return 'N/D';
        return dates.entries.map((e) => '${e.key}: ${e.value}').join('\n');
      }
      return 'N/D';
    }

    // Costruisce i TextSpan cliccabili per i link
    List<TextSpan> _buildLinks(dynamic links, BuildContext context) {
      if (links == null) return [
        const TextSpan(text: 'N/D', style: TextStyle(color: Colors.blue, fontSize: 16))
      ];

      List<String> linkList = [];
      if (links is List && links.isNotEmpty) {
        linkList = links.map((e) => e.toString()).toList();
      } else if (links is String && links.isNotEmpty) {
        linkList = [links];
      }

      return linkList.map((link) {
        return TextSpan(
          text: link + '\n', // ogni link va a capo
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
        title: Text(game['name'] ?? 'Dettagli gioco'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Immagine 16:9 con bordi arrotondati
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    game['image'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Nome
            Text(
              game['name'] ?? 'Nome non disponibile',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Descrizione
            Text(
              game['description'] ?? 'Descrizione non disponibile',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Genere
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Genere: ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                  ),
                  TextSpan(
                    text: listToString(game['genre']),
                    style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Sviluppatori
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Sviluppatori: ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                  ),
                  TextSpan(
                    text: listToString(game['developers']),
                    style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Publisher
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Publisher: ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                  ),
                  TextSpan(
                    text: listToString(game['publishers']),
                    style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Piattaforma
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Piattaforma: ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                  ),
                  TextSpan(
                    text: game['platform'] ?? 'N/D',
                    style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Date di release
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Date di rilascio:\n',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                  ),
                  TextSpan(
                    text: releaseDatesToString(game['releaseDates']),
                    style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Prezzo
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Prezzo: ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                  ),
                  TextSpan(
                    text: game['price'] != null ? '\$${game['price'].toStringAsFixed(2)}' : 'N/D',
                    style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Link utili
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Link utili:\n',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
                  ),
                  ..._buildLinks(game['usefull_links'], context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
