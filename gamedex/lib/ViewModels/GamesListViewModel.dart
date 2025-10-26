import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../Models/GamesListModel.dart';
import '../Models/platform_color_helper.dart';


class GamesListViewModel extends ChangeNotifier {
  List<Game> _games = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Game> get games => _filteredGames();
  bool get isLoading => _isLoading;

  // Colore in base alla piattaforma
  Color getPlatformColor(String platformName) {
    return PlatformColorHelper.getColor(platformName);
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  Future<void> loadGames(String platformName) async {
    _isLoading = true;
    notifyListeners();

    try {
      String fileName;
      switch (platformName.toLowerCase()) {
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
          fileName = "assets/json/games.json";
      }

      final jsonString = await rootBundle.loadString(fileName);
      final data = jsonDecode(jsonString);

      if (data is List) {
        _games = data.map((e) => Game.fromJson(e)).toList();
      } else {
        _games = [];
      }
    } catch (e) {
      debugPrint("Errore nel caricamento: $e");
      _games = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Game> _filteredGames() {
    if (_searchQuery.isEmpty) return _games;
    return _games
        .where((game) => game.name.toLowerCase().contains(_searchQuery))
        .toList();
  }
}
