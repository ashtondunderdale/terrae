import 'dart:async';

import 'package:flutter/material.dart';
import 'package:terrae/globals.dart';
import 'package:terrae/quiz/common/terrae_button.dart';
import 'package:terrae/quiz/common/terrae_dialog.dart';
import 'package:terrae/quiz/common/terrae_text_field.dart';

import 'api.dart';
import 'country.dart';

class PlayQuiz extends StatefulWidget {
  const PlayQuiz({super.key, required this.gameMode, required this.category});

  final String gameMode;
  final String category;

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  final CountryApi _api = CountryApi();

  late List<Country> _countries;
  bool _dataLoaded = false;
  int _countryIndex = 0;

  IconData answerIcon = Icons.question_mark;
  String answerMessage = "";

  Map<String, bool> answeredCountries = {};
  int correctAnswers = 0;

  final TextEditingController capitalController = TextEditingController();

  late Timer _timer;
  int _secondsPassed = 0;

  @override
  void initState() {
    super.initState();
    fetchCountries();
    _startTimer();
  }

  void fetchCountries() async {
    _countries = await _api.getCountries(widget.gameMode);
    _countries.shuffle();

    setState(() {
      _dataLoaded = true;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsPassed++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
          child: Column(
            children: [
              Expanded(
                child: _buildQuestion(context, _countries, _countryIndex, capitalController, answerIcon, answerMessage, answeredCountries, _secondsPassed, (answer) {
                  bool correct = _countries[_countryIndex].capitals.any((c) => c.toString().toLowerCase() == answer.toLowerCase());

                  setState(() {
                    if (correct) {
                      answerIcon = Icons.check;
                      answerMessage = "";
                      correctAnswers++;
                    } else {
                      answerIcon = Icons.close;
                      answerMessage = "The capital of ${_countries[_countryIndex].name} is ${_countries[_countryIndex].capitals.first}";
                    }

                    answeredCountries.addAll({_countries[_countryIndex].name: correct});

                    if (_countryIndex + 1 != _countries.length) {
                      _countryIndex++;
                    } else {
                      _timer.cancel();
                      
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return TerraeDialog(correctAnswers: correctAnswers, secondsPassed: _secondsPassed);
                        },
                      );
                    }
                    capitalController.text = "";
                  });
                }),
              ),
            ],
          ),
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
  String answerMessage,
  Map<String, bool> answeredCountries,
  int secondsPassed,
  Function(String) onNextCountry,
) {
  final ScrollController _scrollController = ScrollController();

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("${countryIndex + 1} / ${countries.length.toString()}", style: defaultPlainTextDark),
            const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  "${secondsPassed ~/ 60}:${(secondsPassed % 60).toString().padLeft(2, '0')}",
                  style: defaultPlainTextDark,
                ),
              ),
          ],
        ),
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
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    answerIcon,
                    color: answerIcon == Icons.check
                        ? Colors.green
                        : answerIcon == Icons.close
                            ? Colors.red
                            : Colors.grey,
                    size: 18,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 8),
              child: Text(answerMessage, style: defaultPlainTextDark.copyWith(
                color: answerIcon == Icons.check 
                  ? Colors.green : answerIcon == Icons.close 
                  ? Colors.red : Colors.grey,)),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var item in answeredCountries.keys)
                      Text(item, style: defaultPlainTextLight.copyWith(
                        color: answeredCountries[item] == true
                          ? Colors.green : answeredCountries.containsKey(item)
                          ? Colors.red : Colors.grey)),         
                  ],
                ),
              ),
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
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
