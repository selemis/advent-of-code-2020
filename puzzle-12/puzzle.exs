defmodule Puzzle do

  def solve() do
    groups()
      |> Enum.map(fn x -> String.split(x, "\n", trim: true) end)
      |> Enum.map(fn x -> num_of_common_positive_answers(x) end)
      |> Enum.sum()
  end

  defp num_of_common_positive_answers(group) do
    group
      |> Enum.map(fn x -> String.codepoints(x) end)
      |> Enum.reduce(fn(x, y) -> intersection(x, y) end)
      |> Enum.count()
  end

  defp groups() do
    "input.txt"
      |> File.read!()
      |> String.split("\n\n", trim: true)
  end

  defp intersection(list1, list2) do
    list3 = list1 -- list2
    list1 -- list3
  end

end

IO.inspect Puzzle.solve()
