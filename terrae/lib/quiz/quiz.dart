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
  String gameMode = "";
  String category = "";
  
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayQuiz(gameMode: gameMode, category: category)));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: TerraeDropdown(
              initialText: "GAMEMODE",
              items: const ["TIMED", "PRACTICE"], 
              onSelected: (item) {
                gameMode = item;
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: TerraeDropdown(
              initialText: "CATEGORY",
              items: const ["WORLD", "ASIA", "AUSTRAILIA", "EUROPE", "NORTH AMERICA", "SOUTH AMERICA", "AFRICA"], 
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