instructions = File.read("input.txt").split("\n")

x = 0
y = 0
z = 0

instructions.each do |line|
  dir, num = line.split(" ");
  num = num.to_i

  case dir.to_sym
  when :forward
    x += num
    y += z * num
  when :down
    z += num
  when :up
    z -= num
  end
end

puts x * y

