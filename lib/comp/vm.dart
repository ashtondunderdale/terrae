enum InstructionType {
  mov
}

class Instruction {
  InstructionType type;
  List<String> args;

  Instruction({
    required this.type,
    required this.args,
  });
}

class VM {
  int ip = 0;
  List<int> memory = List.filled(256, 0);

  List<Instruction> program = [];

  void run() {

  }

}