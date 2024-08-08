import 'package:flutter/services.dart' show rootBundle;
import 'package:memory_game/level_provider.dart';

class LevelManager {
  int currentLevel = 1;
  Level? _currentLevelData;

  Future<void> loadLevel(int level) async {
    // Load level data from JSON file
    final String jsonString = await rootBundle.loadString('assets/levels/level$level.json');
    _currentLevelData = await Level.loadFromJson(jsonString);
  }

  Level? getCurrentLevelData() {
    return _currentLevelData;
  }

  void nextLevel() {
    ++currentLevel;
  }
}
