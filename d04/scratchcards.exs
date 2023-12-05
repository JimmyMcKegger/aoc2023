defmodule Scratchcards do
  @input "input.txt"

  def part1() do
    read_input() |> Enum.reduce(0, &card_points/2)
  end

  def part2() do
    read_input() |> make_map |> parse_cards |> make_copies
  end

  def make_copies({all_lines, card_map}) do
    total_lines = Enum.count(all_lines)

    card_map =
      Enum.reduce(all_lines, card_map, fn [card_num, winners, nums], card_map ->
        this_card = hd(card_num) |> String.to_integer()
        # evaluate row winners
        win_set = MapSet.new(winners)

        # find the number of winning cards in the line
        count =
          nums
          |> Enum.filter(fn num -> MapSet.member?(win_set, num) end)
          |> Enum.count()

        # increment the value of the next count cards in the card_map with
        # use for to make an update_map with keys to update
        if count > 0 do
          to_update = for c <- (this_card + 1)..(this_card + count), c <= total_lines, do: c

          update_map =
            Enum.reduce(to_update, %{}, fn x, acc ->
              Map.update(acc, x, card_map[this_card], &(&1 + count))
            end)

          card_map =
            Map.merge(card_map, update_map, fn _k, v1, v2 ->
              v1 + v2
            end)
        else
          card_map
        end
      end)

    Map.values(card_map) |> Enum.sum()
  end

  def parse_cards({all_lines, card_map}) do
    all_lines =
      all_lines
      |> Enum.map(&parse_line/1)
      |> Enum.map(fn {card, winners, nums} ->
        Enum.map([card, winners, nums], &Regex.scan(~r/\d+/, &1))
        |> Enum.map(&List.flatten/1)
      end)

    {all_lines, card_map}
  end

  def make_map(all_lines) do
    len = Enum.count(all_lines)

    # starting counts
    card_map =
      Enum.reduce(1..len, %{}, fn card, acc -> Map.put(acc, card, 1) end)

    # for each line
    {all_lines, card_map}
  end

  def card_points(line, acc) do
    {_card_num, winners, card_nums} = parse_line(line)

    acc + score_card(winners, card_nums)
  end

  def parse_line(line) do
    [card_num, values] = String.split(line, ": ")
    [winners, card_nums] = String.split(values, " | ")

    {card_num, winners, card_nums}
  end

  def score_card(winning_num_text, card_num_text) do
    # split both into lists
    [winning_nums, card_nums] =
      [winning_num_text, card_num_text]
      |> Enum.map(&to_list_of_ints/1)

    win_set = MapSet.new(winning_nums)

    # find card numbers in win set
    card_nums
    |> Enum.filter(fn num -> MapSet.member?(win_set, num) end)
    |> Enum.reduce(0, &calculate_points/2)
  end

  def calculate_points(_num, 0), do: 1
  def calculate_points(_num, acc), do: acc * 2

  def to_list_of_ints(nums),
    do:
      nums
      |> String.split(~r/\s+/)
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.to_integer/1)

  def read_input,
    do:
      @input
      |> File.read!()
      |> String.trim()
      |> String.split("\n")
end

IO.puts(Scratchcards.part1())
IO.puts(Scratchcards.part2())
