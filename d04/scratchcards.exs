require IEx

defmodule Scratchcards do
  @input "input.txt"

  def part1() do
    read_input() |> Enum.reduce(0, &count_cards/2)
  end

  def count_cards(line, acc) do
    [_card_num, values] = String.split(line, ": ")
    [winners, card_nums] = String.split(values, " | ")

    acc + score_card(winners, card_nums)
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
    |> Enum.reduce(0, &calculate_score/2)
  end

  def calculate_score(_num, 0), do: 1

  def calculate_score(_num, acc), do: acc * 2

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

IEx.pry()
