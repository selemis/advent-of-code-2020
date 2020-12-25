defmodule Puzzle do

  def solve() do
    "input.txt"
      |> File.read!()
      |> String.split(~r/\n/, trim: true)
      |> Enum.map(fn x -> seat(x) end)
      |> Enum.max()
  end

  def seat(code) do
    row(code) * 8 + col(code)
  end

  def row(code) do
    String.slice(code, 0, 7) |> bisect()
  end

  def col(code) do
    String.slice(code, 7, 3) |> bisect()
  end

  def bisect(string) do
    string
      |> String.reverse()
      |> String.codepoints()
      |> Enum.map(fn x -> to_letter(x) end)
      |> to_decimal(0, [])
      |> Enum.sum()
  end

  def to_decimal([], _exponent, result), do: result

  def to_decimal(list, exponent, result) do
    [h | t] = list
    r = h * :math.pow(2, exponent)
    to_decimal(t, exponent + 1, [r | result])
  end

  def to_letter("F"), do: 0
  def to_letter("B"), do: 1
  def to_letter("R"), do: 1
  def to_letter("L"), do: 0

end
