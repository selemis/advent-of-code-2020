defmodule Puzzle do

  def answer() do
    read_file()
      |> String.split(~r/\n/, trim: true)
      |> Enum.map(fn x -> parse(x) end)
      |> Enum.map(fn x -> valid?(x) end)
      |> Enum.filter(fn x -> x == true end)
      |> Enum.count()
  end

  def valid?(map) do
    occurrences = occurrences(map)
    map.min <= occurrences && map.max >= occurrences
  end

  def occurrences(map) do
    map.password
      |> String.codepoints
      |> Enum.filter(fn x -> x == map.letter end)
      |> Enum.count()
  end

  def parse(line) do
    [range, letter, password] = String.split(line, " ", trim: true)
    {min, max} = parse_range(range)
    %{min: min, max: max, letter: parse_letter(letter), password: password}
  end

  def parse_range(range) do
    [min, max] = String.split(range, "-")
    {String.to_integer(min), String.to_integer(max)}
  end

  def parse_letter(letter) do
    [l] = String.split(letter, ":", trim: true)
    l
  end

  def read_file() do
    "input.txt"
      |> File.read!()
  end

end

IO.inspect Puzzle.answer()
