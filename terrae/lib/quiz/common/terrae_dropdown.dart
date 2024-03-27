import 'package:flutter/material.dart';

import '../../globals.dart';

class TerraeDropdown extends StatefulWidget {
  const TerraeDropdown({super.key, required this.items, required this.onSelected});

  final List<String> items;
  final Function(String) onSelected;

  @override
  State<TerraeDropdown> createState() => _TerraeDropdownState();
}

class _TerraeDropdownState extends State<TerraeDropdown> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4)
      ),
      child: DropdownButton<String>(
        hint: Padding(
          padding: const EdgeInsets.all(8),
          child: Text("GAME MODE", style: defaultPlainText),
        ),
        underline: const SizedBox() ,
        dropdownColor: Colors.white,
        value: _selectedItem, 
        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(item, style: defaultPlainText),
            ),
          );
        }).toList(),
        onChanged: (newItem) {
          setState(() => _selectedItem = newItem!);
          widget.onSelected(newItem!);
        },
      ),
    );
  }
}
