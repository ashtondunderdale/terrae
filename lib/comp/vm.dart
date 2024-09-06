class Instruction {
  String command;
  List<String> args;

  Instruction({
    required this.command,
    required this.args,
  });
}

const Map<String, int> opCodes = {
  "mov": 0x01,
  "add": 0x02,
  "sub": 0x03,
  "jmp": 0x04,
};

class VM {
  int ip = 0;
  List<int> memory = List.filled(256, 0);

  void run(String code) {
    var program = parse(code);
    load(program);

    execute();
  }
  
  List<Instruction> parse(String code) {
    var lines = code.split("\n");

    List<Instruction> instructions = [];
    for (String line in lines) {
      if (line.isEmpty) continue;

      var parts = line.split(" ");

      var command = parts[0];
      List<String> args = [];

      if (parts.length > 3) throw "arguments exceeded";

      if (parts.length > 1) args.add(parts[1]);
      if (parts.length > 2) args.add(parts[2]);

      instructions.add(
        Instruction(command: command, args: args)
      );
    }

    return instructions;
  }

  void load(List<Instruction> program) {
    int address = 0;

    for (var instruction in program) {
      int opCode = opCodes[instruction.command] ?? 0xff;
      memory[address++] = opCode;

    }
  }

  void execute() {

  }
  
}