import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  final int score;

  ScoreWidget({required this.score});

  @override
  Widget build(BuildContext context) {
    // Get the screen width from MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine the font size based on the screen width
    double fontSize;
    if (screenWidth > 1000) {
      fontSize = 20;
    } else if (screenWidth >= 800) {
      fontSize = 18;
    } else if (screenWidth >= 600) {
      fontSize = 16;
    } else {
      fontSize = 14;
    }

    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(3, 3),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Text(
        'Score: $score',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
