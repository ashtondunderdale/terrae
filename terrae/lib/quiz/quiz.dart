import 'package:flutter/material.dart';
import 'package:terrae/quiz/common/terrae_button.dart';
import 'package:terrae/quiz/common/terrae_dropdown.dart';
import 'package:terrae/quiz/country.dart';
import 'package:terrae/quiz/play_quiz.dart';

class Quiz extends StatefulWidget {
  Quiz({super.key});

  final List<Country> countries = [];

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  String gamemode = "PRACTICE";
  String category = "WORLD";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TerraeButton(
              text: "PLAY", 
              icon: Icons.play_arrow, 
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayQuiz(gamemode: gamemode, category: category)));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: TerraeDropdown(
              initialText: "PRACTICE",
              items: const ["TIMED", "PRACTICE"], 
              onSelected: (item) {
                gamemode = item;
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: TerraeDropdown(
              initialText: "WORLD",
              items: const ["WORLD", "AFRICA", "ASIA", "OCEANIA", "EUROPE", "NORTH AMERICA", "SOUTH AMERICA"], 
              onSelected: (item) {
                category = item;
              }
            ),
          ),
        ],
      ),
    );
  }
}