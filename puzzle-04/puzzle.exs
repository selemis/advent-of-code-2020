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
    letters = map.password |> String.codepoints
    char_1 = Enum.at(letters, map.position_1 - 1)
    char_2 = Enum.at(letters, map.position_2 - 1)
    chars = [char_1, char_2]
            |> Enum.filter( fn x -> x == map.letter end)
    chars == [map.letter]
  end

  def occurrences(map) do
    map.password
      |> String.codepoints
      |> Enum.filter(fn x -> x == map.letter end)
      |> Enum.count()
  end

  def parse(line) do
    [range, letter, password] = String.split(line, " ", trim: true)
    {position_1, position_2} = parse_range(range)
    %{
      position_1: position_1,
      position_2: position_2,
          letter: parse_letter(letter),
        password: password,
    }
  end

  def parse_range(range) do
    [pos_1, pos_2] = String.split(range, "-")
    {String.to_integer(pos_1), String.to_integer(pos_2)}
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
