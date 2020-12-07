class BaggageChecker
  attr_reader :containers

  def initialize(rules)
    @containers = {}

    rules.each do |rule|
      container = rule.scan(/\A(.*?) bags/).flatten.first
      bag_colors = rule.scan(/\d+ (.*?) bag/).flatten

      bag_colors.each do |color|
        containers[color] ||= []
        containers[color].push(container) unless containers[color]&.include?(container)
      end
    end
  end

  def possible_containers_by_color(color, possibilities: [])
    return possibilities unless containers[color]

    possibilities += containers[color]

    containers[color].each do |color|
     possibilities += possible_containers_by_color(color) - possibilities
    end

    possibilities
  end
end

class BaggageCheckerPlus
  attr_reader :containers

  def initialize(rules)
    @containers = {}

    rules.each do |rule|
      container = rule.scan(/\A(.*?) bags/).flatten.first
      bag_colors = rule.scan(/(\d+) (.*?) bag/)

      bag_colors.each do |count, color|
        containers[container] ||= {}
        containers[container][color] = count
      end
    end
  end

  def all_contained_bags_by_color(color, count = 0)
    return count unless containers[color]

    containers[color].sum do |color, bag_count|
      bag_count.to_i + bag_count.to_i * all_contained_bags_by_color(color)
    end
  end
end


rules = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split("\n")
puts BaggageChecker.new(rules).possible_containers_by_color("shiny gold").size
puts BaggageCheckerPlus.new(rules).all_contained_bags_by_color("shiny gold")

