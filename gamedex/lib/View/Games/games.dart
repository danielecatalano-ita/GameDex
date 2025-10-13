import 'package:flutter/material.dart';

class GamesList extends StatefulWidget {
  final String platformName;

  const GamesList({super.key, required this.platformName});

  @override
  State<GamesList> createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  String searchQuery = "";

  // Lista esempio di immagini dei giochi (da sostituire con JSON)
  final List<String> allGames = [
    "assets/images/game1.png",
    "assets/images/game2.png",
    "assets/images/game3.png",
    "assets/images/game4.png",
    "assets/images/game5.png",
    "assets/images/game6.png",
  ];
//funzione che restituisce il colore in base alla piattaforma

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

  @override
  Widget build(BuildContext context) {
    final filteredGames = allGames
        .where((img) => img.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

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

            // Griglia giochi
            Expanded(
              child: GridView.builder(
                itemCount: filteredGames.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 giochi per riga
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      filteredGames[index],
                      fit: BoxFit.cover,
                    ),
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
