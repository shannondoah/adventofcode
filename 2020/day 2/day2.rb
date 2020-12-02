class PolicyChecker
  def self.check(policy, password, rule: :verify_char_count)
    new(policy).send(rule, password)
  end

  def initialize(policy)
    @char = policy[-1]

    match_data = policy.match(/(\d+)-(\d+) .*?/)
    @min = match_data[1].to_i
    @max = match_data[2].to_i
  end

  def verify_char_count(password)
    password.scan(@char).size.between?(@min, @max)
  end

  def verify_char_positions(password)
    pos1 = password[@min]
    pos2 = password[@max]

    pos2 != pos1 && [pos1, pos2].include?(@char)
  end
end

list = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split("\n")

puts list.count { |item| PolicyChecker.check(*item.split(":")) }
puts list.count { |item| PolicyChecker.check(*item.split(":"), rule: :verify_char_positions) }
