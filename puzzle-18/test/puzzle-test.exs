ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  test "get preamble" do
    assert Puzzle.preamble(read(), 5) == [
      35,
      20,
      15,
      25,
      47,
    ]
  end

  test "number to check" do
    assert Puzzle.number_to_check(read(), 5) == 40
  end

  test "find pairs" do
    list = read()
    preable = Puzzle.preamble(read(), 5)
    number = Puzzle.number_to_check(list, 5)

    assert Puzzle.pairs(preable, number) == [{15, 25}, {25, 15}]
  end

  test "find invalid number" do
    assert Puzzle.find_invalid(read(), 5) == 127
  end

  test "find factors" do
    assert Puzzle.find_factors(:new, nil, read(), 127) == [40, 47, 25, 15]
  end

  test "encryption weakness" do
    assert Puzzle.weakness(read(), 127) == 62
  end

  defp read() do
    Puzzle.read_list("test-input.txt")
  end

end
