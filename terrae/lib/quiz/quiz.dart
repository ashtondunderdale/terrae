import 'package:flutter/material.dart';
import 'package:terrae/quiz/api.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  QuizApi _api = QuizApi();

  @override
  void initState() {
    super.initState();
    _api.getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}