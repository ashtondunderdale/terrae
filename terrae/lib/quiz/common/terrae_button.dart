import 'package:flutter/material.dart';

class TerraeButton extends StatefulWidget {
  const TerraeButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final Icon icon;
  final VoidCallback onTap;

  @override
  State<TerraeButton> createState() => _TerraeButtonState();
}

class _TerraeButtonState extends State<TerraeButton> {
  bool hovered = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),

      child: AnimatedContainer(
        duration: Duration(milliseconds: hovered ? 50 : 150),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          color: hovered ? const Color.fromARGB(255, 223, 223, 223) : const Color.fromARGB(255, 241, 241, 241),
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.text),
                widget.icon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
