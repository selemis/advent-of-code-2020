defmodule Puzzle do

  @number 2020

  def answer() do
    {a,b} = find_numbers()
    a * b
  end

  def find_numbers() do
    list = value_list()
    search(list, list, nil, false)
  end

  def search(original_list, list, _candidate, false) do
    [h | t] = list
    candidate = @number - h
    search(original_list, t, candidate, Enum.member?(original_list, candidate))
  end

  def search(_original_list, _list, candidate, _continue) do
    {candidate, @number - candidate}
  end

  def value_list() do
    read_file()
      |> String.split("\n", trim: true)
      |> Enum.map(fn(x) -> String.to_integer(x) end)
  end

  def read_file do
    {:ok, content} = "input.txt" |> File.read()

    content
  end

end

IO.inspect Puzzle.answer()
