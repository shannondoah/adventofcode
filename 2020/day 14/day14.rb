class FerryDocker
  attr_reader :programs
  attr_accessor :memory

  BITS = 36

  def initialize(programs)
    @programs = programs
    @memory = {}
  end

  def run_programs
    programs.each do |program|
      run_program(program)
    end

    memory.values.sum(&:to_i)
  end

  def run_program(program)
    program = program.split("\n")
    mask = program.shift.split("mask = ")[1]

    program.each_with_object({}) do |line, obj|
      mem, val = line.scan(/mem\[(\d+).*?(\d+)\z/).flatten
      masked_val = apply_mask(mask, in_bits(val))

      memory[mem] = masked_val.to_i(2)
    end
  end

  def in_bits(value)
    value = value.to_i.to_s(2)
    ([0] * (BITS - value.length)).join + value
  end

  def apply_mask(mask, value)
    value = value.split("")
    mask.split("").each_with_index do |bit, i|
      next if bit == "X"

      value[i] = bit
    end

    value.join
  end
end

input = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split(/[\A|\n](?=mask)/)
puts FerryDocker.new(input).run_programs
