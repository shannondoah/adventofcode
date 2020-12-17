class BusSchedule
  attr_reader :arrival

  def initialize(arrival, bus_list)
    @arrival = arrival.to_i
    @bus_list = bus_list.split(",").reject!{ |b| b == "x" }.map(&:to_i)
  end

  def get_closest_departure
    bus, departure = @bus_list
      .map { |bus| [bus, (arrival - (arrival % bus) + bus)] }
      .min { |a, b| a[1] <=> b[1] }

    bus * (departure - arrival)
  end
end

class BusOrganizer
  attr_reader :bus_list

  def initialize(bus_list)
    @bus_list = bus_list.split(",").each_with_object({}).with_index do |(bus, obj), index|
      if bus == "x"
        offset = offset ? offset + 1 : 1
        next
      end

      obj[bus.to_i] = offset ? index + offset : index
    end
  end

  def get_earliest_time
    time = 0
    interval = 1

    bus_list.each do |bus, offset|
      until ((time + offset) % bus).zero?
        time += interval
      end

      # Once a match is found, we only need to check the times
      # that are multiples of each consecutive bus, so that when
      # a match is found for the next bus, we already know the
      # previous buses will come at the correct intervals.
      interval *= bus
    end

    time
  end
end

arrival, schedule = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split("\n")
puts BusSchedule.new(arrival, schedule).get_closest_departure
puts BusOrganizer.new(schedule).get_earliest_time
