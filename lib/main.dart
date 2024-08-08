import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart'; // Import the flutter_animate package
import 'widgets/timer_widget.dart';
import 'widgets/score_widget.dart';
import 'widgets/combo_widget.dart';
import 'level_manager.dart'; // Import the LevelManager and Level classes

void main() {
  runApp(MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MemoryGameScreen(),
    );
  }
}

class MemoryGameScreen extends StatefulWidget {
  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late LevelManager _levelManager;
  List<IconData> _cards = []; // Initialize with empty list
  List<bool> _cardFlips = []; // Initialize with empty list
  List<GlobalKey<FlipCardState>> _cardKeys = []; // Initialize with empty list
  int _firstSelected = -1; // Initialize with default value
  int _secondSelected = -1; // Initialize with default value
  int _score = 0; // Initialize score
  int _combo = 1; // Initialize combo
  DateTime _lastMatchTime = DateTime.now(); // Initialize last match time
  bool _levelCompleted = false; // Initialize level completed state

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    try {
      _levelManager = LevelManager();
      _initGame();
    } catch (e) {
      // Handle the error, e.g., by showing a message to the user
      print('Error loading levels: $e');
    }
  }

  void _initGame() async {
    await _levelManager.loadLevel(_levelManager.currentLevel);

    final level = _levelManager.getCurrentLevelData();
    if (level != null) {
      setState(() {
        _cards = _generateCardList(level.cardIcons);
        _cardFlips = List<bool>.filled(_cards.length, false);
        _cardKeys = List.generate(_cards.length, (index) => GlobalKey<FlipCardState>());
        _firstSelected = -1;
        _secondSelected = -1;
        _lastMatchTime = DateTime.now();
        _levelCompleted = false; // Reset level completed state
      });
    }
  }

  List<IconData> _generateCardList(List<String> iconNames) {
    List<IconData> cards = [];
    for (String iconName in iconNames) {
      IconData icon = _iconFromString(iconName);
      cards.add(icon);
      cards.add(icon);
    }
    cards.shuffle(Random());
    return cards;
  }

  IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'Icons.access_alarm':
        return Icons.access_alarm;
      case 'Icons.accessibility':
        return Icons.accessibility;
      case 'Icons.account_balance':
        return Icons.account_balance;
      case 'Icons.adb':
        return Icons.adb;
      case 'Icons.add_a_photo':
        return Icons.add_a_photo;
      case 'Icons.airplanemode_active':
        return Icons.airplanemode_active;
      case 'Icons.anchor':
        return Icons.anchor;
      case 'Icons.android':
        return Icons.android;
      case 'Icons.attach_file':
        return Icons.attach_file;
      case 'Icons.battery_alert':
        return Icons.battery_alert;
      case 'Icons.beenhere':
        return Icons.beenhere;
      case 'Icons.book':
        return Icons.book;
      case 'Icons.bluetooth':
        return Icons.bluetooth;
      case 'Icons.build':
        return Icons.build;
      case 'Icons.cake':
        return Icons.cake;
      default:
        return Icons.help_outline;
    }
  }

  void _onCardTapped(int index) {
    if (_cardFlips[index]) return; // Ignore taps on already flipped cards

    if (_firstSelected == -1) {
      setState(() {
        _firstSelected = index;
      });
    } else if (_secondSelected == -1 && _firstSelected != index) {
      setState(() {
        _secondSelected = index;
      });
      Future.delayed(Duration(seconds: 1), () {
        if (_cards[_firstSelected] == _cards[_secondSelected]) {
          setState(() {
            _cardFlips[_firstSelected] = true;
            _cardFlips[_secondSelected] = true;
            _updateScoreAndCombo();
          });
          _checkLevelCompletion();
        } else {
          _cardKeys[_firstSelected].currentState?.toggleCard();
          _cardKeys[_secondSelected].currentState?.toggleCard();
        }
        setState(() {
          _firstSelected = -1;
          _secondSelected = -1;
        });
      });
    }
  }

  void _updateScoreAndCombo() {
    DateTime now = DateTime.now();
    if (now.difference(_lastMatchTime).inSeconds <= 2) {
      _combo = min(_combo + 1, 3);
    } else {
      _combo = 1;
    }
    _score += 10 * _combo;
    _lastMatchTime = now;
  }

  void _checkLevelCompletion() {
    if (_cardFlips.every((flipped) => flipped)) {
      setState(() {
        _levelCompleted = true;
      });
    }
  }

  void _onNextLevel() {
    setState(() {
      _levelManager.nextLevel();
      _initGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Timer centered at the top
                      Align(
                        alignment: Alignment.topCenter,
                        child: TimerWidget(onTick: (seconds) {}),
                      ),
                      // Widgets for score and combo, aligned to the right
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(4, 4),
                                  blurRadius: 8.0,
                                ),
                              ],
                            ),
                            child: ScoreWidget(score: _score),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(4, 4),
                                  blurRadius: 8.0,
                                ),
                              ],
                            ),
                            child: ComboWidget(combo: _combo),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double cardSize =
                          (min(constraints.maxWidth, constraints.maxHeight) - 40) / 4;
                      return Stack(
                        children: [
                          Center(
                            child: AnimatedOpacity(
                              opacity: _levelCompleted ? 0.0 : 1.0,
                              duration: Duration(seconds: 1),
                              child: IgnorePointer(
                                ignoring: _levelCompleted,
                                child: Container(
                                  width: cardSize * 4,
                                  height: cardSize * (_cards.length / 4).ceil(),
                                  child: GridView.builder(                      
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 1.0,
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    itemCount: _cards.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (!_cardFlips[index] && (_firstSelected == -1 || _secondSelected == -1)) {
                                            _cardKeys[index].currentState?.toggleCard();
                                            _onCardTapped(index);
                                          }
                                        },
                                        child: FlipCard(
                                          key: _cardKeys[index],
                                          flipOnTouch: false,
                                          direction: FlipDirection.HORIZONTAL,
                                          front: Container(
                                            width: cardSize,
                                            height: cardSize,
                                            color: Colors.blue,
                                            child: Center(
                                              child: Icon(Icons.help_outline, size: 40.0, color: Colors.white),
                                            ),
                                          ),
                                          back: Container(
                                            width: cardSize,
                                            height: cardSize,
                                            color: Colors.white,
                                            child: Center(
                                              child: Icon(_cards[index], size: 40.0, color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (_levelCompleted)
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: _onNextLevel,
                                child: Text("Next Level"),
                              ).animate().fadeIn(duration: Duration(seconds: 1)),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
