import 'package:flutter/material.dart';
import 'package:terrae/comp/vm.dart';

class CompView extends StatefulWidget {
  const CompView({super.key});

  @override
  State<CompView> createState() => _CompViewState();
}

class _CompViewState extends State<CompView> {
  final codeController = TextEditingController();
  final vm = VM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 300, height: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 240, 240),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _buildInput(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 600, height: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 240, 240),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _buildMemory(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 916, height: 120,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 240, 240),
                borderRadius: BorderRadius.circular(4),
              ),
              child: _buildOutput(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: codeController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _button("execute", () {
              setState(() {
                vm.run(codeController.text);
              });
            }),
            _button("reset", () {
              setState(() {
                vm.reset();
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildMemory() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: vm.memory.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '0x${index.toRadixString(16).padLeft(2, '0').toUpperCase()}: ${vm.memory[index]}',
                style: const TextStyle(
                  fontSize: 12, 
                  color: Colors.black
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOutput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey)
        ),
        child: ListView.builder(
          itemCount: vm.out.length,
          itemBuilder: (context, idx) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                vm.out[idx]
              ),
            ); 
          }
        ),
      ),
    );
  }

  Widget _button(String text, Function onClick) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onClick(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 80, height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey)
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
