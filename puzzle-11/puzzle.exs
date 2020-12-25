defmodule Puzzle do

  def solve() do
    groups
      |> Enum.map(fn x -> String.split(x, "\n") end)
      |> Enum.map(fn x -> num_of_uniq_positive_answers(x) end)
      |> Enum.sum()
  end

  defp num_of_uniq_positive_answers(group) do
    group
      |> Enum.map(fn x -> String.codepoints(x) end)
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.count()
  end

  defp groups() do
    "input.txt"
      |> File.read!()
      |> String.split("\n\n", trim: true)
  end

end

IO.inspect Puzzle.solve()
