import 'package:flutter/material.dart';

class TerraeButton extends StatefulWidget {
  const TerraeButton({super.key, 
    required this.text,
    required this.icon, 
    required this.onTap,
  });

  final String text;
  final IconData? icon; 
  final VoidCallback onTap;

  @override
  State<TerraeButton> createState() => _TerraeButtonState();
}

class _TerraeButtonState extends State<TerraeButton> {
  bool _hovered = false;
  bool _tapDown = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _tapDown = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _tapDown = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _tapDown = false;
          });
        },
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _tapDown
                ? const Color.fromARGB(255, 207, 207, 207)
                : _hovered
                    ? const Color.fromARGB(255, 223, 223, 223)
                    : const Color.fromARGB(255, 241, 241, 241),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      widget.icon,
                      color: const Color.fromARGB(255, 82, 82, 82),
                      size: 18,
                    ),
                  ),
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 82, 82, 82),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
