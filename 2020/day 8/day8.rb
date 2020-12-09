class ConsoleBoot
  attr_reader :instructions

  def initialize(instructions)
    @instructions = instructions.each_with_object({}).with_index do |(ins, result), index|
      result[index] = %i{opcode sign int}.zip(ins.scan(/(.{3}) ([+|-])+(\d+)/).flatten).to_h
    end
  end

  Result = Struct.new(:accumulator, :repeats)

  def run_program
    accumulator = 0
    pointer = 0
    repeat = []

    until repeat.include?(pointer) do
      repeat << pointer
      cmd = instructions[pointer]
      case cmd[:opcode]
      when "acc"
        accumulator = accumulator.send(cmd[:sign], cmd[:int].to_i)
        pointer += 1
      when "jmp"
        pointer = pointer.send(cmd[:sign], cmd[:int].to_i)
      when "nop"
        pointer += 1
      end

      break if pointer >= instructions.length
    end

    Result.new(accumulator, pointer < instructions.length)
  end

  def test_program
    accumulator = 0
    pointer = 0

    while pointer < instructions.length do
      cmd = instructions[pointer]
      pointer += 1

      next if cmd[:opcode] == "acc"

      switch_opcode(cmd)
      result = run_program

      if !result.repeats
        accumulator = result.accumulator
        break
      end

      # Change it back for next run
      switch_opcode(cmd)
    end

    accumulator
  end

  def switch_opcode(instruction)
    instruction[:opcode] = instruction[:opcode] == "jmp" ? "nop" : "jmp"
  end
end

instructions = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split("\n")
puts ConsoleBoot.new(instructions).run_program.accumulator
puts ConsoleBoot.new(instructions).test_program
