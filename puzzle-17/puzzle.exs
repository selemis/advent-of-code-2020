defmodule Puzzle do

  def solve() do
    "input.txt"
      |> read_list()
      |> find_invalid(25)
  end

  def find_invalid(list, preamble_size) do
    number = number_to_check(list, preamble_size)
    pairs = pairs(preamble(list, preamble_size), number)

    if Enum.count(pairs) > 0 do
      [_h | t] = list
      find_invalid(t, preamble_size)
    else
      number
    end
  end

  def read_list(filename) do
    filename
      |> File.read!()
      |> String.split(~r/\n/, trim: true)
  end

  def preamble(list, size) do
    list
      |> Enum.take(size)
      |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def number_to_check(list, preamble_size) do
    Enum.at(list, preamble_size) |> String.to_integer()
  end

  def pairs(preable, number) do
    for i <- preable, j <- preable, i+j == number, i != j, do: {i, j}
  end

end

IO.inspect Puzzle.solve()
