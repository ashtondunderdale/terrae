import 'package:flutter/material.dart';
import 'package:terrae/globals.dart';

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

  List<Country> countries = [];
  int countryIndex = 0;

  @override
  void initState() {
    super.initState();

    fetchCountries();
  }

  void fetchCountries() async => countries = await _api.getCountries();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(4)
          ),
          width: 600,
          height: 700,
          child: _buildQuestion(),
        ),
      ),
    );
  }
}

Widget _buildQuestion() {
  return Text("");
}