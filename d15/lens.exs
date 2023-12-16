defmodule Lens do
  @input "input.txt"

  def p1 do
    readfile()
    |> Enum.reduce(0, fn line, acc ->
      acc + initialize(line)
    end)
  end

  defp initialize(line),
    do:
      line
      |> String.to_charlist()
      |> Enum.reduce(0, &hash_algorithm/2)

  defp hash_algorithm(char, acc),
    do:
      acc
      |> Kernel.+(char)
      |> Kernel.*(17)
      |> rem(256)

  defp readfile,
    do:
      @input
      |> File.read!()
      |> String.split(",", trim: true)
end

IO.puts(Lens.p1())
