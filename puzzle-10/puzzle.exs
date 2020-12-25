defmodule Puzzle do

  @max_seat 1023

  def solve() do
    seats = "input.txt"
      |> File.read!()
      |> String.split(~r/\n/, trim: true)
      |> Enum.map(fn x -> seat(x) end)
      |> Enum.map(fn x -> floor(x) end)

    {a, b} = (0..1023) 
      |> Enum.to_list() 
      |> Enum.map(fn x -> exist?(x, seats) end)
      |> Enum.filter(fn {x, y} -> x == true end)
      |> List.first()

    b
  end

  def exist?(seat_id, seats) do
    a = Enum.member?(seats, seat_id - 1)
    b = Enum.member?(seats, seat_id + 1)
    c = Enum.member?(seats, seat_id)
    {a and b and not c, seat_id}
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

IO.inspect Puzzle.solve()
