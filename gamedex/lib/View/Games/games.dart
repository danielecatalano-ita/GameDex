import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'GameDetailPage.dart';

class GamesList extends StatefulWidget {
  final String platformName;
  const GamesList({super.key, required this.platformName});

  @override
  State<GamesList> createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  String searchQuery = "";

  // Colore per piattaforma
  Color getPlatformColor(String platformName) {
    switch (platformName.toLowerCase()) {
      case "playstation":
        return Colors.blue;
      case "xbox":
        return Colors.green;
      case "nintendo":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Carica i giochi dal file JSON
  Future<List<dynamic>> loadGames() async {
    try {
      // Determina il file JSON in base alla piattaforma
      String fileName;
      switch (widget.platformName.toLowerCase()) {
        case "playstation":
          fileName = "assets/json/playstation.json";
          break;
        case "xbox":
          fileName = "assets/json/xbox.json";
          break;
        case "nintendo":
          fileName = "assets/json/nintendo.json";
          break;
        default:
          fileName = "assets/json/games.json"; // un fallback generico
      }

      final jsonString = await rootBundle.loadString(fileName);
      final data = jsonDecode(jsonString);

      if (data is List) return data;
      if (data is Map) return [data];

      return [];
    } catch (e) {
      debugPrint("Errore nel caricamento JSON: $e");
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.platformName),
        backgroundColor: getPlatformColor(widget.platformName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Barra di ricerca
            TextField(
              decoration: InputDecoration(
                hintText: "Cerca un gioco...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Griglia di giochi (2 per riga)
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: loadGames(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Errore: ${snapshot.error}"));
                  }

                  final games = snapshot.data ?? [];

                  // Filtra i giochi in base alla ricerca
                  final filteredGames = games.where((game) {
                    final name = (game['name'] ?? '').toLowerCase();
                    return name.contains(searchQuery.toLowerCase());
                  }).toList();

                  if (filteredGames.isEmpty) {
                    return const Center(child: Text("Nessun gioco trovato"));
                  }

                  return GridView.builder(
                    itemCount: filteredGames.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 giochi per riga
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final game = filteredGames[index];
                      return GestureDetector(
                        onTap: () {
                          // Naviga alla pagina dei dettagli del gioco, passando i dati del gioco
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameDetailPage(game: game),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            game['image'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 48),
                          ),
                        ),
                      );

                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
