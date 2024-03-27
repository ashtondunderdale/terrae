import 'package:flutter/material.dart';
import 'package:terrae/globals.dart';
import 'package:terrae/quiz/common/terrae_button.dart';

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
            color: lightGrey,
            borderRadius: BorderRadius.circular(4),
          ),
          width: 600,
          height: 700,
          child: _buildQuestion(_countries, _countryIndex, () {
            setState(() {
              _countryIndex++;
            });
          }),
        ),
      ),
    );
  }
}
Widget _buildQuestion(List<Country> countries, int countryIndex, VoidCallback onNextCountry) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("${countryIndex + 1} / ${countries.length.toString()}", style: defaultPlainText),
          ],
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What is the capital of", style: defaultPlainText),
            Text(countries[countryIndex].name, style: defaultTitleText),
          ],
        ),
        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: TerraeButton(
            onTap: onNextCountry, 
            text: "Next",
            icon: null,
          ),
        ),
      ],
    ),
  );
}