depths = File.read("input.txt").split("\n").map(&:to_i)

# count = 0
# depths.each_with_index do |num, idx|
#   next if idx.zero?

#   count += 1 if depths[idx - 1] < num
# end
# puts count

# PART 2

count = 0
prev_val = nil
depths.each_with_index do |num, idx|
  section_depth = depths[idx..idx+2].sum

  count += 1 if prev_val && section_depth > prev_val
  prev_val = section_depth
end
puts count
