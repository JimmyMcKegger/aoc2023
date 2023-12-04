# frozen_string_literal: true

INPUT = 'input.txt'

class Engine
  def initialize(schematic)
    @lines = build_from(schematic)
  end

  def part1
    find_parts.flatten.sum
  end

  def part2
    only_valid = proc { |_k, val| val[0] * val[1] if val.size == 2 }

    find_parts(true).map(&only_valid).compact.sum
  end

  def build_from(schematic)
    File.readlines(schematic).map(&:chomp)
  end

  def find_parts(only_gears = false)
    nums = []
    gear_candidates = Hash.new { |hash, key| hash[key] = [] }

    @lines.each_with_index do |line, outer_index|
      line.scan(/\d+/)
      inner_index = 0

      while inner_index < line.length
        if line[inner_index] =~ /\d/
          # parse the number
          found_num = line[inner_index..].match(/\d+/)[0]

          # look around perimiter to validate
          if only_gears
            build_candidates(found_num, inner_index, outer_index, line.length, gear_candidates)
          else
            nums << get_all_nums(found_num, inner_index, outer_index, line.length)
          end

          inner_index += found_num.size
          next
        end
        inner_index += 1
      end
    end

    only_gears ? gear_candidates : nums
  end

  def build_candidates(found_num, inner_index, outer_index, line_length, gear_candidates)
    results = check_perimeter(found_num.size, inner_index, outer_index, line_length, /\*/)
    results.compact.each do |row, col|
      gear_candidates["#{row}|#{col}"] << found_num.to_i
    end
  end

  def get_all_nums(found_num, inner_index, outer_index, line_length)
    valid_parts = check_perimeter(found_num.size, inner_index, outer_index, line_length, /[^\w.]/)
    valid_parts.any? ? [found_num.to_i] : []
  end

  def check_perimeter(size, x, y, limit, pattern)
    chars_above = y.positive?
    chars_below = y < @lines.length - 1
    chars_left = x.positive?
    chars_right = x + size < limit - 1

    specials = []

    # top
    if chars_above
      hit = @lines[y - 1][x...(x + size)] =~ pattern
      specials << [y - 1, x + hit] if hit

      # top corners
      if chars_left
        hit = @lines[y - 1][x - 1] =~ pattern
        specials << [y - 1, x - 1] if hit
      end
      if chars_right
        hit = @lines[y - 1][x + size] =~ pattern
        specials << [y - 1, x + size] if hit
      end
    end
    # below
    if chars_below
      hit = @lines[y + 1][x...(x + size)] =~ pattern
      specials << [y + 1, x + hit] if hit
      # bottom corners
      if chars_left
        hit = @lines[y + 1][x - 1] =~ pattern
        specials << [y + 1, x - 1] if hit
      end
      if chars_right
        hit = @lines[y + 1][x + size] =~ pattern
        specials << [y + 1, x + size] if hit
      end
    end
    # left
    if chars_left
      hit = @lines[y][x - 1] =~ pattern
      specials << [y, x - 1] if hit
    end
    # right
    if chars_right
      hit = @lines[y][x + size] =~ pattern
      specials << [y, x + size] if hit
    end

    specials
  end
end

e = Engine.new(INPUT)
puts "Part1 #{e.part1}"
puts "Part2 #{e.part2}"
