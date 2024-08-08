import 'dart:convert';

class Level {
  final int level;
  final List<String> cardIcons;

  Level({
    required this.level,
    required this.cardIcons,
  });

  // Factory constructor to create Level from JSON
  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      level: json['level'],
      cardIcons: List<String>.from(json['cardIcons']),
    );
  }

  // Method to load level from a JSON string
  static Future<Level> loadFromJson(String jsonString) async {
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return Level.fromJson(jsonData);
  }
}
