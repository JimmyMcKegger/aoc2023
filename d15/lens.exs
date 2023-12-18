defmodule Lens do
  @input "input.txt"

  def p1,
    do: Enum.reduce(readfile(), 0, &(initialize(&1) + &2))

  def p2 do
    readfile()
    |> labeler()
    |> Enum.reduce(boxes(), &place_lenses/2)
    |> Enum.map(&focus_power/1)
    |> Enum.sum()
  end

  defp place_lenses([line], acc) do
    case line do
      [_, label, "=", number] ->
        update_lens(acc, label, number)

      [_, label, "-"] ->
        remove_lens(acc, label)

      _ ->
        raise "Invalid input"
    end
  end

  defp focus_power({_box, []}), do: 0

  defp focus_power({box, lenses}) do
    lenses
    |> Enum.with_index(1)
    |> Enum.map(fn {{_label, focal_length}, slot} -> (box + 1) * slot * focal_length end)
    |> Enum.sum()
  end

  defp update_lens(acc, label, number) do
    number = String.to_integer(number)
    key = String.to_atom(label)

    box_id = label |> initialize()
    values = acc[box_id]

    already_there? = Keyword.has_key?(values, key)

    new_values = replace_or_add(values, key, number, already_there?)

    Map.replace(acc, box_id, new_values)
  end

  def replace_or_add(values, key, number, false), do: values ++ [{key, number}]

  def replace_or_add(values, key, number, _existing_position),
    do: Keyword.replace(values, key, number)

  defp remove_lens(acc, label) do
    box_id = initialize(label)
    values = Enum.reject(acc[box_id], fn {k, _v} -> String.to_atom(label) == k end)

    Map.put(acc, box_id, values)
  end

  def initialize(line),
    do: String.to_charlist(line) |> Enum.reduce(0, &hash_algo/2)

  def boxes do
    Enum.reduce(0..255, %{}, fn b, acc ->
      Map.put(acc, b, [])
    end)
  end

  def hash_algo(char, acc),
    do: (acc + char) |> Kernel.*(17) |> rem(256)

  defp readfile,
    do: File.read!(@input) |> String.trim() |> String.split(",", trim: true)

  defp labeler(instr),
    do: Enum.map(instr, &Regex.scan(~r/([\w]+)([=-])(\d)?/, &1))
end

p1 = Lens.p1()
IO.puts("Part 1: #{p1}")

p2 = Lens.p2()
IO.puts("Part 2: #{p2}")
