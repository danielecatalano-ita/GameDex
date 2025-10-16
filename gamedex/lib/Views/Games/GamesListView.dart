import 'package:flutter/material.dart';
import 'package:gamedex/ViewModels/GamesListViewModel.dart';
import 'package:gamedex/Views/Games/GameDetailPageView.dart';
import 'package:provider/provider.dart';


class GamesList extends StatelessWidget {
  final String platformName;
  const GamesList({super.key, required this.platformName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GamesListViewModel()..loadGames(platformName),
      child: Consumer<GamesListViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: AppBar(
            title: Text(platformName),
            backgroundColor: viewModel.getPlatformColor(platformName),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Cerca un gioco...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: viewModel.updateSearchQuery,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : viewModel.games.isEmpty
                      ? const Center(child: Text("Nessun gioco trovato"))
                      : GridView.builder(
                    itemCount: viewModel.games.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final game = viewModel.games[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameDetailPageView(game: {
                                'name': game.name,
                                'description': game.description,
                                'genre': game.genre,
                                'developers': game.developers,
                                'publishers': game.publishers,
                                'platform': game.platform,
                                'releaseDates': game.releaseDates,
                                'price': game.price,
                                'usefull_links': game.usefull_links,
                                'image': game.image,
                                'id': game.id,
                              }),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
