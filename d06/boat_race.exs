defmodule BoatRace do
  @input "input.txt"

  def part2(),
    do:
      read_input()
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
      |> win_race
      |> Enum.reduce(0, fn _tup, acc -> acc + 1 end)

  def part1(),
    do:
      read_input()
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(chunk_for(@input))
      |> group
      |> find_all
      |> Enum.map(&Enum.count/1)
      |> Enum.product()

  defp find_all(list, results \\ []) do
    [h | t] = list

    results = [win_race(h) | results]

    find_winners(t, results)
  end

  defp find_winners([], results), do: results

  defp find_winners(list, results) do
    [h | t] = list

    results = [win_race(h) | results]
    find_winners(t, results)
  end

  defp win_race({total_time, current_record_distance}) do
    for hold_time <- 0..total_time,
        distance = hold_time * (total_time - hold_time),
        distance > current_record_distance,
        do: {hold_time, distance}
  end

  defp group([times, distances]) do
    Enum.zip(times, distances)
  end

  defp chunk_for(input) do
    case input do
      "sample.txt" -> 3
      "input.txt" -> 4
    end
  end

  defp read_input,
    do:
      @input
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&Regex.scan(~r/\d+/, &1))
      |> Enum.map(&List.flatten/1)
end

IO.puts BoatRace.part1
IO.puts BoatRace.part2
