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
  "out": 0x05,
};

class VM {
  int ip = 0;
  List<int> memory = List.filled(256, 0);
  List<String> out = [];

  void run(String code) {
    output("Running...");

    var timer = Stopwatch()..start();

    var program = parse(code);
    load(program);

    try {
      execute();
      output("Program ran for: ${timer.elapsedMilliseconds} ms");
      output("Exited with status code 0");
    } catch (exception) {
      timer.stop();
      output("Error: $exception");
      output("Program ran for: ${timer.elapsedMilliseconds} ms");
      output("Exited with status code 1");
    }
  }

  List<Instruction> parse(String code) {
    var lines = code.split("\n");

    List<Instruction> instructions = [];
    for (String line in lines) {
      if (line.isEmpty) continue;

      var parts = line.split(" ");
      var command = parts[0];

      List<String> args = [];
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

      for (var arg in instruction.args) {
        memory[address++] = int.tryParse(arg) ?? 0;
      }
    }
  }

  void execute() {
    while (ip < memory.length) {
      var instr = memory[ip];
      ip++;

      switch (instr) {
        case 0x01:
          var location = memory[ip++];
          memory[location] = memory[ip++];
          break;
        case 0x02:
          var dest = memory[ip++];
          var src = memory[ip++];
          memory[dest] += memory[src];
          break;
        case 0x03:
          var dest = memory[ip++];
          var src = memory[ip++];
          memory[dest] -= memory[src];
          break;
        case 0x04:
          ip = memory[ip];
          break;
        case 0x05:
          var location = memory[ip++];
          output(memory[location].toString());
          break;
        case 0xff:
          throw Exception("Unknown instruction at address ${ip - 1}");
      }
    }
  }

  void output(String message) {
    out.add(message);
  }
  
  void reset() {
    ip = 0;
    memory = List.filled(256, 0);
    out.clear();
  }
}
