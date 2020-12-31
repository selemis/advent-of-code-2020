defmodule Puzzle do

  def solve() do
    list = "input.txt" |> read_list()
    number = list |> find_invalid(25)
    weakness(list, number)
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

  def weakness(list, number) do
    factors = find_factors(:new, nil, list, number)
    Enum.max(factors) + Enum.min(factors)
  end

  def find_factors(:new, _factors, list, number) do
    {reply, factors} = sum_until(list, 0, [], number)
    find_factors(reply, factors, list, number)
  end

  def find_factors(:ok, factors, _list, _number) do
    factors |> Enum.map(&(String.to_integer(&1)))
  end

  def find_factors(:break, _factors, list, number) do
    [_h | t] = list
    find_factors(:new, nil, t, number)
  end

  def sum_until(list, acc, factors, number) do
    [h | t] = list
    acc = acc + String.to_integer(h)
    factors = [h | factors]
    check(acc, factors, t, number)
  end

  defp check(acc, factors, _list, number) when acc == number, do: {:ok, factors}

  defp check(acc, factors, list, number) when acc < number do
    sum_until(list, acc, factors, number)
  end

  defp check(acc, _factors, _list, number) when acc > number, do: {:break, nil}
end

IO.inspect Puzzle.solve()
