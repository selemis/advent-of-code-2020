defmodule Puzzle do

  def solve() do
    "input.txt"
      |> read_sorted()
      |> find_ways()
  end

  def read_sorted(filename) do
    filename
      |> File.read!()
      |> String.split(~r/\n/, trim: true)
      |> Enum.map(&(String.to_integer(&1)))
      |> Enum.sort()
  end

  def find_ways(list) do
    list
      |> consequitive()
      |> modify_first_element()
      |> Enum.map(&(tribonacci(&1)))
      |> Enum.reduce(1, &(&1 * &2))
  end

  def consequitive(list) do
    _consequitive(list, [])
      |> Enum.map(fn x -> to_count(x) end)
  end

  def tribonacci(0), do: 0
  def tribonacci(1), do: 1
  def tribonacci(2), do: 1
  def tribonacci(n), do: tribonacci(n - 1) + tribonacci(n - 2) + tribonacci(n - 3)

  defp _consequitive([], result), do: result |> Enum.reverse()

  defp _consequitive([ a, b | t ], result) when a + 1 == b do
    _consequitive([ {a + 1, 2} | t ], result)
  end

  defp _consequitive([ {a, n},  b | t ], result)  when a + 1 == b do
    _consequitive([ {a + 1, n + 1} | t ], result)
  end

  defp _consequitive([ a | t ], result), do: _consequitive(t, [a | result])

  defp modify_first_element([h| t]) when h > 1, do: [ h + 1 | t]
  defp modify_first_element(list), do: list

  defp to_count({_a, b}), do: b
  defp to_count(_x), do: 1

end

IO.inspect Puzzle.solve()
