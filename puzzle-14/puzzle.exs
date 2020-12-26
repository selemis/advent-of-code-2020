defmodule Puzzle do

  def solve() do
    "input.txt" |> count_bags()
  end

  def count_bags(filename) do
    filename
      |> parse_rules()
      |> Puzzle.content_for([{1, 1, "shiny gold"}], [])
      |> Enum.map(fn {multiplier, number, _color} -> multiplier * number end)
      |> Enum.sum()
  end

  def content_for(_rules, [], results), do: results

  def content_for(rules, colors, results) do
    new_colors = colors
      |> Enum.map(fn {multi, num, col} -> content_for_directly(rules, col, multi * num) end)
      |> List.flatten()

    results = Enum.concat(new_colors, results)
    content_for(rules, new_colors, results)
  end

  def content_for_directly(rules, color, multiplier) do
    rules
      |> Enum.filter(fn %{color: c, content: _list} -> c == color end)
      |> List.first()
      |> Map.get(:content)
      |> Enum.map(fn {num, color} -> {multiplier, num, color} end)
  end

  def parse_rules(filename) do
    filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> Puzzle.parse_rule(x) end)
  end

  def parse_rule(text) do
    parts = text |> String.split("contain")

    %{
        color: extract_color(parts),
      content: extract_content(parts),
    }
  end

  defp extract_color(parts) do
    parts
      |> List.first()
      |> String.split("bags")
      |> List.first()
      |> String.trim()
  end

  defp extract_content(parts) do
    [_color_info | content_info] = parts

    content_info
      |> List.first()
      |> String.trim()
      |> check_content()
  end

  defp check_content("no other bags."), do: []

  defp check_content(content_string) do
    do_check(content_string, multiple_colors?(content_string))
  end

  defp do_check(content_string, false) do
    [parse_single_content_color(content_string)]
  end

  defp do_check(content_string, true) do
    content_string
      |> String.split(",")
      |> Enum.map(fn x -> String.trim(x) end)
      |> Enum.map(fn x -> parse_single_content_color(x) end)
  end

  defp parse_single_content_color(content_string) do
    [quantity, color1, color2, _] = content_string |> String.split(" ")
    {String.to_integer(quantity), "#{color1} #{color2}"}
  end

  defp multiple_colors?(content_string), do: String.contains?(content_string, ",")

end

IO.inspect Puzzle.solve()
