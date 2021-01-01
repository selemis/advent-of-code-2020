defmodule Puzzle do

  def solve() do
    list = "input.txt" |> read_sorted()
    {diff1, _, diff3} = find_differences(0, list, 0, 0, 0)

    diff1 * (diff3 + 1)
  end

  def read_sorted(filename) do
    filename
      |> File.read!()
      |> String.split(~r/\n/, trim: true)
      |> Enum.map(&(String.to_integer(&1)))
      |> Enum.sort()
  end

  def find_candidates(item, list) do
    list
      |> Enum.filter(&(&1<= item + 3))
  end

  def find_differences(_item, [], diff1, diff2, diff3), do: {diff1, diff2, diff3}

  def find_differences(item, list, diff1, diff2, diff3) do
    candidates = find_candidates(item, list)
    {diff1, diff2, diff3} = classify(candidates, item, diff1, diff2, diff3)
    [h | t] = list
    find_differences(h, t, diff1, diff2, diff3)
 end

 defp classify(candidates, item, diffs1, diffs2, diffs3) do
    [h | _t] = candidates
    do_classify(h - item, diffs1, diffs2, diffs3)
  end

  defp do_classify(1, diffs1, diffs2, diffs3), do: {diffs1 + 1, diffs2, diffs3}
  defp do_classify(2, diffs1, diffs2, diffs3), do: {diffs1, diffs2 + 1, diffs3}
  defp do_classify(3, diffs1, diffs2, diffs3), do: {diffs1, diffs2, diffs3 + 1}
end

IO.inspect Puzzle.solve()
