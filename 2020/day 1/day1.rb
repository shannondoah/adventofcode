def find_by_two(input, sum: 2020, initial: nil)
  input.each do |num|
    next if num >= sum

    remaining = 2020 - num

    return num * remaining if input.include?(remaining)
  end

  nil
end

def find_by_three(input, sum: 2020)
  input.each do |num|
    subsum = 2020 - num

    input.each do |num2|
      next if num2 >= subsum

      remaining = subsum - num2

      return num * num2 * remaining if input.include?(remaining)
    end
  end
end

input = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split("\n").map(&:to_i)

puts find_by_two(input)
puts find_by_three(input)
