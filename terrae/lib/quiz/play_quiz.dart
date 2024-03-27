import 'package:flutter/material.dart';
import 'package:terrae/globals.dart';
import 'package:terrae/quiz/common/terrae_button.dart';
import 'package:terrae/quiz/common/terrae_text_field.dart';

import 'api.dart';
import 'country.dart';

class PlayQuiz extends StatefulWidget {
  const PlayQuiz({super.key, required this.gameMode});

  final String gameMode;

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  final CountryApi _api = CountryApi();

  late List<Country> _countries;
  bool _dataLoaded = false;
  int _countryIndex = 0;

  IconData answerIcon = Icons.question_mark;


  final TextEditingController capitalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  void fetchCountries() async {
    _countries = await _api.getCountries();
    setState(() {
      _dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_dataLoaded) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: lightBackground,
            borderRadius: BorderRadius.circular(4),
          ),
          width: 600,
          height: 700,
          child: _buildQuestion(context, _countries, _countryIndex, capitalController, answerIcon, (answer) {
            setState(() {
              if (_countries[_countryIndex].capitals.any((c) => c == answer)) {
                answerIcon = Icons.check;
              } else {
                answerIcon = Icons.close;
              }

              _countryIndex++;
              capitalController.text = "";
            });
          }),
        ),
      ),
    );
  }
}
Widget _buildQuestion(
  BuildContext context, 
  List<Country> countries, 
  int countryIndex, 
  TextEditingController controller,
  IconData answerIcon,
  Function(String) onNextCountry, 
  ) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${countryIndex + 1} / ${countries.length.toString()}", style: defaultPlainTextDark),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What is the capital of", style: defaultPlainTextLight),
            Text(countries[countryIndex].name, style: defaultTitleText),
            const SizedBox(height: 40),
            Row(
              children: [
                TerraeTextField(
                  hintText: "capital...",
                  controller: controller,
                  onSubmitted: () {
                    onNextCountry(controller.text);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    answerIcon,
                    color: answerIcon == Icons.check 
                      ? Colors.green : answerIcon == Icons.close 
                      ? Colors.red : Colors.grey,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TerraeButton(
              text: "back to home", 
              icon: Icons.arrow_back, 
              onTap: () {
                Navigator.pop(context);
              }
            ),
            const SizedBox(width: 24),
            TerraeButton(
              onTap: () {
                onNextCountry(controller.text);
              }, 
              text: "next",
              icon: null,
            ),
          ],
        ),
      ],
    ),
  );
}
