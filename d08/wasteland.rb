class Wasteland
  attr_accessor :instructions
  attr_reader :guide

  @@input = 'input.txt'

  def initialize
    @instructions = get_instructions
    @guide = get_guide
  end

  def travel
    position = 'AAA'
    i = 0
    until position == 'ZZZ'
      position = instructions[0] == 'L' ? guide[position][0] : guide[position][1]
      i += 1
      instructions.rotate!
    end

    i
  end

  def get_instructions
    File.read(@@input).split("\n")[0].chars
  end

  def get_guide
    guide = {}
    File.read(@@input).split("\n")[2..].map do |line|
      letters = line.scan(/[A-Z]{3}+/)
      guide[letters[0]] = [letters[1], letters[2]]
    end

    guide
  end
end

w = Wasteland.new

puts "Part 1 takes #{w.travel} steps"
