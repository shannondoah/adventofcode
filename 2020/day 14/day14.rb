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
      masked_addr = apply_mask(mask, in_bits(mem))
      floating_addrs = get_floating_addresses(masked_addr)

      write_values_to_memory(floating_addrs, val)
    end
  end

  def in_bits(value)
    value = value.to_i.to_s(2).rjust(36, '0')
  end

   def apply_mask(mask, addr)
    mask.chars.each_with_index do |bit, i|
      next if bit == "0"

      addr[i] = bit
    end

    addr
  end

  def get_floating_addresses(addr)
    x_combos = %w[0 1].repeated_permutation(addr.count('X')).to_a

    x_combos.each_with_object([]) do |combo, array|
      new_address = addr.dup
      addr.chars.each { |c| new_address.sub!("X", combo.shift) if c == "X" }

      array << new_address
    end
  end

  def write_values_to_memory(addresses, value)
    addresses.each { |address| memory[address.to_i(2)] = value }
  end
end

input = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split(/[\A|\n](?=mask)/)
puts FerryDocker.new(input).run_programs
