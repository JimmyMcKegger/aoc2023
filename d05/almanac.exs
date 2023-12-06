defmodule Almanac do
  @input "input.txt"

  def part1,
    do:
      @input
      |> parse_seeds
      |> handle
      |> Enum.min()
      |> Integer.to_string()

  def handle({results, []}), do: results

  def handle({seeds, instructions}) do
    [this_round | later] = instructions

    chunked_round = Stream.chunk_every(this_round, 3)

    seeds =
      Stream.map(seeds, fn seed ->
        mapping({seed, chunked_round})
      end)

    handle({seeds, later})
  end

  def mapping({next_thing, []}), do: next_thing

  def mapping({current_thing, chunked_maps_stream}) do
    chunked_maps = Enum.to_list(chunked_maps_stream)

    [h | t] = chunked_maps
    [target, source, range] = h

    cond do
      current_thing in source..(source + range - 1) ->
        current_thing - (source - target)

      true ->
        mapping({current_thing, t})
    end
  end

  def parse_seeds(text) do
    lines =
      text
      |> File.read!()
      |> String.split("\n\n")
      |> Enum.map(&Regex.scan(~r/\d+/, &1))
      |> Enum.map(&List.flatten/1)
      |> Enum.map(fn line ->
        Enum.map(line, &String.to_integer/1)
      end)

    [seeds | instructions] = lines

    {seeds, instructions}
  end
end

IO.puts("Part1")
IO.puts(Almanac.part1())
