class TreeCounter
  TREE = "#"
  NOT_TREE = "."

  attr_reader :columns

  def initialize(input)
    rows = input.split("\n")
    @floor = rows.length
    @repeat = rows.first.length
    @columns = {}

    @repeat.times do |n|
      columns[n] = rows.map { |item| item[n] }
    end
  end

  def count_trees(hslope, vslope)
    hpointer = 0
    vpointer = 0
    count = 0

    while vpointer < @floor do
      hpointer -= @repeat if hpointer >= @repeat

      count += 1 if columns[hpointer][vpointer] == TREE

      hpointer += hslope
      vpointer += vslope
    end

    count
  end
end

map = File.read(File.expand_path('input.txt', File.dirname(__FILE__)))
tree_counter = TreeCounter.new(map)
puts tree_counter.count_trees(3, 1)

slopes = [
  [1,1],
  [3,1],
  [5,1],
  [7,1],
  [1,2]
]

puts slopes.map { |slope| tree_counter.count_trees(*slope) }.reduce(:*)
