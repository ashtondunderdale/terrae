import 'package:flutter/material.dart';
import 'package:terrae/quiz/play_quiz.dart';
import 'package:terrae/quiz/quiz.dart';

void main() {
  runApp(const App());
  
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlayQuiz(gameMode: ""),
    );
  }
}
