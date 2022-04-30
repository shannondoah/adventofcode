binary_nums = File.read("input.txt").split("\n")

gamma = ""
epsilon = ""
counter = (0..11).each_with_object({}) do |key, hash|
  hash[key] = { "0" => 0, "1" => 0 }
end

binary_nums.each do |num|
  num.split("").each_with_index do |num, idx|
    counter[idx][num] += 1
  end
end

# PART 1
# counter.each do |_, v|
#   gamma += v.key(v.values.max)
#   epsilon += v.key(v.values.min)
# end

# puts gamma.to_i(2) * epsilon.to_i(2)


# PART 2

def o_gen_rating(numbers, idx)
  return numbers.first if numbers.size == 1

  zeroes = []
  ones = []
  numbers.each { |num| num[idx] == "0" ? zeroes.push(num) : ones.push(num) }
  next_nums = zeroes.size <= ones.size ? numbers - zeroes : numbers - ones
  o_gen_rating(next_nums, idx + 1)
end

def co2_scrub_rating(numbers, idx)
  return numbers.first if numbers.size == 1

  zeroes = []
  ones = []
  numbers.each { |num| num[idx] == "0" ? zeroes.push(num) : ones.push(num) }
  next_nums = zeroes.size <= ones.size ? numbers - ones : numbers - zeroes
  co2_scrub_rating(next_nums, idx + 1)
end

puts o_gen_rating(binary_nums, 0).to_i(2) * co2_scrub_rating(binary_nums, 0).to_i(2)
