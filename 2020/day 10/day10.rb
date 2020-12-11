def get_joltage_differences(adapters)
  current = 0

  differences = adapters.each_with_object({}) do |adapter, differences|
    difference = adapter - current
    differences[difference] = (differences[difference] || 0) + 1

    current = adapter
  end

  differences[3] += 1 # increment for device

  differences[1] * differences[3]
end

def get_distinct_arrangements(adapters)
  outlet = 0
  device = adapters.max + 3
  skippable = []

  adapters.each_with_index do |adapter, i|
    lookahead = adapters[i+1] || device
    lookbehind = i.zero? ? outlet : adapters[i-1]

    skippable << adapter if (lookahead - lookbehind) <= 3
  end

  puts "Skippables: #{skippable.size}"
  combinations = 0
  (skippable.size + 1).times do |n|
    combinations += skippable.combination(n).reject do |combination|
      combination.each_cons(3).find { |x,y,z| y - x == 1 && z - y == 1}&.any?
    end.size

    puts n
  end

  combinations
end

adapters = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split("\n").map(&:to_i).sort
puts get_joltage_differences(adapters)
puts get_distinct_arrangements(adapters)
