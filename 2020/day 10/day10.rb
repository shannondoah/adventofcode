class AdapterSort
  attr_reader :adapters

  def initialize(adapters)
    @adapters = adapters << adapters.max + 3 # appends device
  end

  def get_joltage_differences
    current = 0

    differences = adapters.each_with_object({}) do |adapter, differences|
      difference = adapter - current
      differences[difference] = (differences[difference] || 0) + 1

      current = adapter
    end

    differences[1] * differences[3]
  end

  # Starts from the device joltage value and recursively adds
  # the number of possible paths to each preceding adapter
  # given a max diff of 3. For each "adapter", the number of
  # combinations is equal to the sum of the combinations of
  # the three "adapters" before it. If that "adapter" is not
  # in your collection, or if the value is lower than 0 (past
  # the outlet - does not exist), the count for that adapter
  # will be zero. If the value equals zero, then you have
  # reached the outlet, which has a single path.
  #
  # Caches the results for each possible adapter so when
  # calculating value[4], we can reuse value[2] and value[1]
  # from calculating value[3]
  def count_arrangements(value = adapters.max, cache = {})
    return cache[value] if cache[value]

    if value.zero?
      cache[value] = 1
      return 1
    elsif value.negative? || !adapters.include?(value)
      cache[value] = 0
      return 0
    end

    cache[value] = (1..3).map do |n|
      count_arrangements(value-n, cache)
    end.reduce(:+)

    cache[value]
  end
end

adapters = File.read(File.expand_path('input.txt', File.dirname(__FILE__)))
  .split("\n")
  .map(&:to_i)
  .sort!

puts AdapterSort.new(adapters).count_arrangements
