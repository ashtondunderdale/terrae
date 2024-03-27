import 'package:flutter/material.dart';
import 'package:terrae/quiz/api.dart';
import 'package:terrae/quiz/common/terrae_button.dart';
import 'package:terrae/quiz/common/terrae_dropdown.dart';
import 'package:terrae/quiz/country.dart';

class Quiz extends StatefulWidget {
  Quiz({super.key});

  List<Country> countries = [];

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  final QuizApi _api = QuizApi();

  @override
  void initState() {
    super.initState();

    fetchCountries();
  }

  void fetchCountries() async => widget.countries = await _api.getCountries();

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
                
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: TerraeDropdown(
              items: const ["RANDOM", "TIMED", "PRACTICE"], 
              onSelected: (item) {
                
              }
            ),
          )
        ],
      ),
    );
  }
}