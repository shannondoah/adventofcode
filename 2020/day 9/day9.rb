class XMASDecoder
  attr_reader :numbers, :preamble_length

  def initialize(numbers, preamble: 25)
    @numbers = numbers
    @preamble_length = preamble
  end

  def detect_anomaly
    pointer = preamble_length
    num = 0

    while pointer < numbers.length do
      num = numbers[pointer]
      preamble = numbers[(pointer-preamble_length)..pointer-1]
      pointer += 1

      break unless find_components(num, preamble.sort)
    end

    num
  end

  def detect_encryption_weakness(anomaly = detect_anomaly)
    pointer = 0
    min_max_sum = 0

    while pointer < numbers.length do
      components = collect_components_for_sum(numbers[pointer], pointer, anomaly)
      min_max_sum = components.min + components.max

      break if components.reduce(:+) == anomaly

      pointer += 1
    end

    min_max_sum
  end

  private

  def collect_components_for_sum(start, pointer, cap, components = [])
    components << numbers[pointer]
    return components if start >= cap

    collect_components_for_sum(start + numbers[pointer+1], pointer+1, cap, components)
  end

  def find_components(sum, preamble)
    return if preamble[-2..-1].reduce(:+) < sum

    preamble.each do |num|
      next if num > sum

      match = preamble.detect { |num2| sum - num == num2 }

      return match if match
    end

    nil
  end
end

input = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split("\n").map(&:to_i)
decoder =  XMASDecoder.new(input)
puts decoder.detect_anomaly
puts decoder.detect_encryption_weakness
