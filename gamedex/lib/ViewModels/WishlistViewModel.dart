import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/GamesListModel.dart';

class WishlistViewModel extends ChangeNotifier {
  final List<Game> _wishlist = [];
  static const String _prefsKey = 'wishlist_games';

  List<Game> get wishlist => _wishlist;

  WishlistViewModel() {
    _loadWishlist();
  }

  bool isInWishlist(Game game) {
    return _wishlist.any((g) => g.id == game.id);
  }

  Future<void> toggleWishlist(Game game) async {
    if (isInWishlist(game)) {
      _wishlist.removeWhere((g) => g.id == game.id);
    } else {
      _wishlist.add(game);
    }
    notifyListeners();
    await _saveWishlist();
  }

  /// --- SALVATAGGIO SU DISCO ---
  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList =
    _wishlist.map((game) => jsonEncode(game.toJson())).toList();
    await prefs.setStringList(_prefsKey, jsonList);
  }

  /// --- CARICAMENTO ALL'AVVIO ---
  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_prefsKey);

    if (jsonList != null) {
      _wishlist
        ..clear()
        ..addAll(jsonList
            .map((jsonStr) => Game.fromJson(jsonDecode(jsonStr)))
            .toList());
      notifyListeners();
    }
  }
}
