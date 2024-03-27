import 'package:flutter/material.dart';
import 'package:terrae/globals.dart';

class TerraeTextField extends StatefulWidget {
  const TerraeTextField({super.key, required this.hintText, required this.controller, required this.onSubmitted});

  final String hintText;
  final TextEditingController controller;
  final VoidCallback onSubmitted;
  
  @override
  State<TerraeTextField> createState() => _TerraeTextFieldState();
}

class _TerraeTextFieldState extends State<TerraeTextField> {
  late FocusNode _focusNode;

  @override
    void initState() {
      super.initState();
      _focusNode = FocusNode();
    }

    @override
    void dispose() {
      _focusNode.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          height: 32,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            textAlignVertical: TextAlignVertical.center,
            onSubmitted: (_) {
              widget.onSubmitted();
              _focusNode.requestFocus();
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(bottom: 32 / 2, left: 8),              
              hintStyle: defaultPlainTextDark,
            ),
          ),
        ),
      ),
    );
  }
}
