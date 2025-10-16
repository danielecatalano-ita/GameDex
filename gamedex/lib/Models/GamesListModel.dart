class Game {
  final int id;
  final String name;
  final List<String> genre;
  final List<String> developers;
  final List<String> publishers;
  final Map<String, String> releaseDates;
  final List<String> usefull_links;
  final double? price;
  final String image;
  final String description;
  final String platform; // opzionale, utile per colore appbar

  Game({
    required this.id,
    required this.name,
    required this.genre,
    required this.developers,
    required this.publishers,
    required this.releaseDates,
    required this.usefull_links,
    required this.price,
    required this.image,
    required this.description,
    required this.platform,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      genre: List<String>.from(json['genre'] ?? []),
      developers: List<String>.from(json['developers'] ?? []),
      publishers: List<String>.from(json['publishers'] ?? []),
      releaseDates: Map<String, String>.from(json['releaseDates'] ?? {}),
      usefull_links: List<String>.from(json['usefull_links'] ?? []),
      price: (json['price'] != null)
          ? double.tryParse(json['price'].toString())
          : null,
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      platform: json['platform'] ?? 'Sconosciuta',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genre': genre,
      'developers': developers,
      'publishers': publishers,
      'releaseDates': releaseDates,
      'usefull_links': usefull_links,
      'price': price,
      'image': image,
      'description': description,
      'platform': platform,
    };
  }
}
