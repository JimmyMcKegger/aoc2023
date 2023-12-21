defmodule Aplenty do
  @input "input.txt"

  def p1 do
    readfile()
    |> read_rules()
    |> acceptable_parts()
    |> Enum.sum()
  end

  def acceptable_parts({parts, rules}) do
    Enum.map(parts, fn part ->
      validate_part(part, rules)
    end)
  end

  def validate_part(part, rules) do
    handle_rule(part, rules["in"], rules)
  end

  def handle_rule(part, rule_set, rules) do
    [this_rule | other_rules] = rule_set

    case this_rule do
      "A" ->
        Map.values(part) |> Enum.sum()

      "R" ->
        0

      rule ->
        if Map.has_key?(rules, this_rule) do
          handle_rule(part, rules[this_rule], rules)
        else
          [condition | result] = String.split(rule, ":")

          if handle_contitional(condition, part) do
            result = hd(result)
            handle_rule(part, [result], rules)
          else
            handle_rule(part, other_rules, rules)
          end
        end
    end
  end

  def handle_contitional(condition, part) do
    conditional_map =
      Regex.named_captures(~r/(?<letter>[xmas])(?<operator>[<>=])(?<value>\d+)/, condition)

    case conditional_map["operator"] do
      ">" ->
        part[conditional_map["letter"]] > String.to_integer(conditional_map["value"])

      "<" ->
        part[conditional_map["letter"]] < String.to_integer(conditional_map["value"])

      another_operator ->
        raise "UNEXPECTED OPERATOR"
    end
  end

  defp read_rules([rules, parts]), do: {make_parts(parts), make_rules(rules)}

  defp make_rules(rules),
    do:
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(&Regex.named_captures(~r/(?<name>\w+){(?<steps>[^}]+)/, &1))
      |> Enum.reduce(%{}, fn rule, acc ->
        Map.put(acc, rule["name"], String.split(rule["steps"], ","))
      end)

  defp make_parts(parts),
    do:
      parts
      |> String.split("\n", trim: true)
      |> Enum.map(&Regex.named_captures(~r/x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)/, &1))
      |> Enum.map(&for {k, v} <- &1, do: {k, String.to_integer(v)})
      |> Enum.map(&Enum.into(&1, %{}))

  defp readfile(),
    do:
      @input
      |> File.read!()
      |> String.trim()
      |> String.split("\n\n")
end

p1 = Aplenty.p1()

IO.puts("Part 1: #{p1}")
