class FerryNavigator
  attr_reader :instructions
  attr_accessor :facing
  START_DIR = "E"
  DIRECTIONS = %W[N E S W]

  def initialize(program)
    @instructions = program.split("\n").each_with_object([]) do |line, arr|
      arr << [line.slice!(0), line.to_i]
    end
    @facing = START_DIR
  end

  def navigate
    x = 0
    y = 0

    instructions.each do |dir, int|
      case dir
      when "L", "R"
        change_facing(dir, int)
      when "F"
        if %w[N S].include?(facing)
          y = change_position(y, facing, int)
        else
          x = change_position(x, facing, int)
        end
      when "N", "S"
        y = change_position(y, dir, int)
      when "E", "W"
        x = change_position(x, dir, int)
      end
    end

    x.abs + y.abs
  end

  def change_position(val, dir, int)
    case dir
    when "N", "E"
      val += int
    when "S", "W"
      val -= int
    end
  end

  def change_facing(dir, rotate)
    if dir == "L"
      rotate = 360 - rotate
    end

    new_direction = DIRECTIONS.index(facing) + rotate/90
    new_direction -= DIRECTIONS.length if new_direction >= DIRECTIONS.length

    @facing = DIRECTIONS[new_direction]
  end
end

program = File.read(File.expand_path('input.txt', File.dirname(__FILE__)))
puts FerryNavigator.new(program).navigate
