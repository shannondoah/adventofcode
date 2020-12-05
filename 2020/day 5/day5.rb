class BoardingPass
  UPPER = %w[B R]
  LOWER = %w[F L]

  def initialize(passcode)
    @rowcode = passcode[0..6]
    @seatcode = passcode[-3..passcode.length]
  end

  def row
    @row ||= find(0, 127, @rowcode)
  end

  def seat
    @seat ||= find(0, 7, @seatcode[-3..@seatcode.length])
  end

  def seat_id
    @seat_id ||= row * 8 + seat
  end

  def find(min, max, code)
    code.split("") do |char|
      mid = median(min, max)

      UPPER.include?(char) ? min = mid+1 : max = mid
    end

    UPPER.include?(code[code.length-1]) ? max : min
  end

  private

  def median(min, max)
    range = (min..max).to_a
    mid = range.length / 2
    (range[mid-1] + range[-mid]) / 2
  end
end

passes = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split("\n")
puts passes.map { |pass| BoardingPass.new(pass).seat_id }.max
