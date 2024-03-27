import 'package:flutter/material.dart';
import 'package:terrae/globals.dart';

class TerraeDialog extends StatelessWidget {
  const TerraeDialog({super.key, required this.correctAnswers, required this.secondsPassed});

  final int correctAnswers;
  final int secondsPassed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 320,
          height: 200,
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(4),
          ),
          child: DefaultTextStyle(
            style: defaultPlainTextLight, 
            child: Column(
              children: [
                Text(
                  "$correctAnswers / 193",
                  style: defaultTitleText,
                ),
                Text(
                  "${secondsPassed ~/ 60}:${(secondsPassed % 60).toString().padLeft(2, '0')}",
                  style: defaultTitleText,
                ),
              ],
            ),
          )
        ),
      ],
    );
  }
}