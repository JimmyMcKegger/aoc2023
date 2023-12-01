defmodule Trebuchet do
  @input File.read!("input.txt")
  @digit_words ~w[one two three four five six seven eight nine]

  def part1(input \\ @input),
    do:
      input
      |> String.split()
      |> Enum.map(&first_and_last/1)
      |> Enum.sum()

  def part2(),
    do:
      @input
      |> String.replace(@digit_words, &words_to_digits/1)
      |> String.replace(@digit_words, &words_to_digits/1)
      |> part1()

  defp first_and_last(line) do
    nums = Regex.scan(~r/\d/, line)
    h = List.first(nums)
    t = List.last(nums)

    String.to_integer("#{h}#{t}")
  end

  defp words_to_digits(word) do
    tups = for {w, d} <- Enum.zip(@digit_words, 1..9), do: {w, d}
    map = Enum.into(tups, %{})
    num = Integer.to_string(map[word])

    # preserve last letter to share with next word
    "#{num}#{String.last(word)}"
  end
end
