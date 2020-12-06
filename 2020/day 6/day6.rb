def sum_affirmatives_by_any_in_group(groups)
  groups.map { |g| g.scan(/[a-z]/i).uniq.size }.reduce(:+)
end

def sum_affirmatives_by_all_in_group(groups)
  groups.map { |g| g.split("\n").map { |i| i.scan(/[a-z]/i) }.inject(:&).size }
    .reduce(:+)
end

customs_forms = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split("\n\n")

puts sum_affirmatives_by_any_in_group(customs_forms)
puts sum_affirmatives_by_all_in_group(customs_forms)
