import 'package:flutter/material.dart';
import 'package:terrae/comp/vm.dart';

class CompView extends StatefulWidget {
  const CompView({super.key});

  @override
  State<CompView> createState() => _CompViewState();
}

class _CompViewState extends State<CompView> {
  final vm = VM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(

      ),
    );
  }
}