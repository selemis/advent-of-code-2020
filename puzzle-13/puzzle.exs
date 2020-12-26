defmodule Puzzle do

  def solve() do
    "input.txt"
      |> parse_rules()
      |> container_of("shiny gold")
      |> Enum.count()
  end

  def parse_rules(filename) do
    filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> Puzzle.parse_rule(x) end)
  end

  def container_of(rules, color) do
    do_container_of(rules, [color], [])
  end

  def parse_rule(text) do
    parts = text |> String.split("contain")

    %{
        color: extract_color(parts),
      content: extract_content(parts),
    }
  end

  defp do_container_of(_rules, [], results), do: results

  defp do_container_of(rules, colors, results) do
    new_colors = colors
                  |> Enum.map(fn x-> direct_container_of(rules, x) end)
                  |> List.flatten()

    results = Enum.concat(results, new_colors)
                |> Enum.uniq()

    do_container_of(rules, new_colors, results)
  end

  defp direct_container_of(rules, color) do
    rules
      |> matching_rules(color)
      |> Enum.map(fn x -> x.color end)
      |> Enum.uniq
  end

  defp matching_rules(rules, color) do
    rules |> Enum.filter(fn v -> contains_color?(v, color) end)
  end

  defp contains_color?(%{color: _c, content: list}, color) do
    search_for_color(list, color, false)
  end

  defp search_for_color(_list, _color, true), do: true

  defp search_for_color([], _color, found), do: found

  defp search_for_color(list, color, false) do
    [{_num, bag} | t] = list
    search_for_color(t, color, bag == color)
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
