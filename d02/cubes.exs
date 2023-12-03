defmodule Cubes do
  @input "input.txt"
  @bag %{"red" => 12, "green" => 13, "blue" => 14}

  def part1, do: each_game() |> Enum.reduce(0, &play/2)

  def part2,
    do:
      each_game()
      |> Enum.map(&count_min_required/1)
      |> Enum.map(&Map.values/1)
      |> Enum.map(&Enum.product/1)
      |> Enum.sum()

  defp count_min_required(line) do
    all_counts = Regex.scan(~r/(\d+)\s+(\w+)/, line)

    Enum.reduce(all_counts, %{}, fn [_, num, color], acc ->
      num = String.to_integer(num)
      existing_value = Map.get(acc, color, 0)

      if existing_value < num do
        Map.put(acc, color, num)
      else
        acc
      end
    end)
  end

  defp play(line, acc) do
    [game, rolls] = String.split(line, ":")

    if possible?(rolls) do
      acc + indentify(game)
    else
      acc
    end
  end

  defp possible?(rolls),
    do:
      rolls
      |> String.split(";", trim: true)
      |> Enum.flat_map(&validate/1)
      |> Enum.all?()

  defp validate(string) do
    for pick <- Regex.split(~r/,/, string) do
      [_, num, colour] = Regex.run(~r/(\d+)\s+(\w+)/, pick)

      @bag[colour] >= String.to_integer(num)
    end
  end

  defp indentify(game) do
    Regex.run(~r/\d+/, game) |> List.first() |> String.to_integer()
  end

  defp each_game() do
    File.read!(@input)
    |> String.split("\n", trim: true)
  end
end

IO.puts Cubes.part1
IO.puts Cubes.part2
