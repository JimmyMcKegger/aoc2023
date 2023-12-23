class Digger
  attr_accessor :position, :trench, :map

  def initialize
    @position = [0, 0]
    @trench = [[0, 0]]
    @map = []
  end

  def print
    @map.each do |row|
      puts row.join
    end

    puts "\n\n"
  end

  def trace(array)
    array.each do |line|
      direction, num_spaces, = line

      case direction
      when 'U'
        num_spaces.to_i.times do
          @position[1] -= 1
          @trench << @position.dup
        end
      when 'D'
        num_spaces.to_i.times do
          @position[1] += 1
          @trench << @position.dup
        end
      when 'L'
        num_spaces.to_i.times do
          @position[0] -= 1
          @trench << @position.dup
        end
      when 'R'
        num_spaces.to_i.times do
          @position[0] += 1
          @trench << @position.dup
        end
      else
        raise 'Invalid direction'
      end
    end
  end

  def fill(x=1, y=1)
    queue = [[x, y]]

    while !queue.empty?
      x, y = queue.shift

      if @map[x][y] == '.'

        @map[x][y] = '#'

        queue.push([x + 1, y])
        queue.push([x - 1, y])
        queue.push([x, y + 1])
        queue.push([x, y - 1])
      end
    end
  end

  def draw
    x, y = find_boundaries
    x_size = (x[0]..x[1]).size
    y_size = (y[0]..y[1]).size

    grid = []

    y_size.times do
      grid << Array.new(x_size, '.')
    end

    @map = grid
  end

  def dig
    @trench.each do |x, y|
      @map[y][x] = '#'
    end
  end

  def find_boundaries
    x = @trench.map(&:first).minmax
    y = @trench.map(&:last).minmax

    puts "X: #{x}"
    puts "Y: #{y}"

    [x, y]
  end
end

def main
  lines = ''
  File.open('input.txt') do |file|
    lines = file.readlines.map(&:chomp)
    lines = lines.map { |line| line.scan(/\w+/) }
  end
  digger = Digger.new
  digger.trace(lines)
  digger.draw
  digger.dig
  digger.fill
  puts "Part 1: #{digger.map.flatten.count("#")} cubic meters of lava"
end

main if $PROGRAM_NAME == __FILE__
