import 'package:flutter/material.dart';

class TerraeDropdown extends StatefulWidget {
  const TerraeDropdown({Key? key, required this.items, required this.onSelected});

  final List<String> items;
  final Function(String) onSelected;

  @override
  State<TerraeDropdown> createState() => _TerraeDropdownState();
}

class _TerraeDropdownState extends State<TerraeDropdown> {
  late String _selectedItem;
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.items.first;
    _overlayEntry = OverlayEntry(builder: (context) => _buildDropdownMenu());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Overlay.of(context)?.insert(_overlayEntry);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.all(8),
        child: Text(_selectedItem),
      ),
    );
  }

  Widget _buildDropdownMenu() {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            _overlayEntry.remove();
          },
          child: Container(
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedItem = item;
                    });
                    _overlayEntry.remove();
                    widget.onSelected(item);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(item),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
