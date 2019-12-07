const program = "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,9,19,23,2,23,13,27,1,27,9,31,2,31,6,35,1,5,35,39,1,10,39,43,2,43,6,47,1,10,47,51,2,6,51,55,1,5,55,59,1,59,9,63,1,13,63,67,2,6,67,71,1,5,71,75,2,6,75,79,2,79,6,83,1,13,83,87,1,9,87,91,1,9,91,95,1,5,95,99,1,5,99,103,2,13,103,107,1,6,107,111,1,9,111,115,2,6,115,119,1,13,119,123,1,123,6,127,1,127,5,131,2,10,131,135,2,135,10,139,1,13,139,143,1,10,143,147,1,2,147,151,1,6,151,0,99,2,14,0,0".split(",");

const compute = (noun, verb) => {
  let instructions = [...program];
  instructions.splice(1, 1, noun);
  instructions.splice(2, 1, verb);

  for (var i = 0; i < instructions.length; i += 4) {
    if (instructions[i] === 1) {
      executeOpCodeOne(instructions, i);
    } else if (instructions[i] === 2) {
      executeOpCodeTwo(instructions, i);
    } else if (instructions[i] === 99) {
      return instructions[0];
    } else {
      return alert("Your program is broken");
    }
  }
}

const executeOpCodeOne = (instr, addr) => {
    const num = instr[instr[addr + 1]] + instr[instr[addr + 2]];
    instr.splice(instr[addr + 3], 1, num)
}

const executeOpCodeTwo = (instr, addr) => {
    const num = instr[instr[addr + 1]] * instr[instr[addr + 2]];
    instr.splice(instr[addr + 3], 1, num)
}

const codify = (noun, verb) => {
    return 100 * noun + verb;
}

const possibleInputs = () => {
    // All inputs must be between 0..99 inclusive
    const array = Array.from({length: 100}, (x,i) => i);
    // return each value in the range mapped to all other unique
    // pairs in the range
    return array.flatMap(
        (v, i) => array.slice(i + 1).map( w => [v, w] )
    );
}

const getInstructionsForResult = (result) => {
    inputs = possibleInputs();

    for (var i = 0; i < inputs.length; i++) {
        const pair = inputs[i];
        if (compute(...pair) === result) {
            codify(...pair);
        } else if (compute(...pair.reverse()) === result) {
            codify(...pair.reverse());
        }
    }
}
