import 'package:flutter/material.dart';
import 'package:terrae/quiz/api.dart';
import 'package:terrae/quiz/country.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

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

  void fetchCountries() async {
    List<Country> countries = await _api.getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}