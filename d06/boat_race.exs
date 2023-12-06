defmodule BoatRace do
    @input "sample.txt"

    def part2(), do:
        read_all()
        |> List.to_tuple()
        |> win_race
        |> Enum.reduce(0, fn _tup, acc -> acc + 1 end)

    def part1(), do:
        read_input()
        |> group
        |> find_all_winners
        |> Enum.map(&Enum.count/1)
        |> Enum.product()

    def find_all_winners(list, results \\ []) do
        [h | t] = list

        results = [win_race(h) | results]

        find_winners(t, results)
    end

    def find_winners([], results), do: results
    def find_winners(list, results) do
        [h | t] = list

        results = [win_race(h) | results]
        find_winners(t, results)
    end

    def win_race({time, current_record_distance}) do
        for option <- 0..time, (option * (time - option)) > current_record_distance, do: {option, option * (time - option)}
    end

    def group([times, distances]) do
        Enum.zip(times, distances)
    end

    def chunkfor(input) do
        case input do
            "sample.txt" -> 3
            "input.txt" -> 4
        end
    end

    def read_input do
        @input
        |> File.read!()
        |> String.split("\n", trim: true)
        |> Enum.map(&Regex.scan(~r/\d+/, &1))
        |> Enum.map(&List.flatten/1)
        |> List.flatten
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(chunkfor(@input))
    end

    def read_all() do
        @input
        |> File.read!()
        |> String.split("\n", trim: true)
        |> Enum.map(&Regex.scan(~r/\d+/, &1))
        |> Enum.map(&List.flatten/1)
        |> Enum.map(&Enum.join/1)
        |> Enum.map(&String.to_integer/1)

    end

end

IO.inspect BoatRace.part1(), label: "Part 1"
IO.inspect BoatRace.part2(), label: "Part 2"
