class BoardingPass
  ROWS = 127
  SEATS = 7
  UPPER = %w[B R]
  LOWER = %w[F L]

  ALL_SEAT_IDS = (0..ROWS).to_a.flat_map { |y| (0..SEATS).to_a.map { |x| y * 8 + x } }

  def self.find_empty_seat(passes)
    occupied = passes.map { |pass| new(pass).seat_id }
    (ALL_SEAT_IDS - occupied).detect { |id| occupied.include?(id-1) && occupied.include?(id+1) }
  end

  def initialize(passcode)
    @rowcode = passcode[0..6]
    @seatcode = passcode[-3..passcode.length]
  end

  def row
    @row ||= find(0, ROWS, @rowcode)
  end

  def seat
    @seat ||= find(0, SEATS, @seatcode[-3..@seatcode.length])
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
puts BoardingPass.find_empty_seat(passes)
