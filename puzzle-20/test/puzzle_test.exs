ExUnit.start()

defmodule PuzzleTest do

  use ExUnit.Case

  test "sort list" do
    assert read() == [1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19]
  end

    #The reason is that '\v\f' and [11, 12] are the same thing. Here is why: https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html#charlists 

  test "map to consequitive elements" do
    assert Puzzle.consequitive([1]) == [1]
    assert Puzzle.consequitive([2]) == [1]
    assert Puzzle.consequitive([1, 2]) == [2]
    assert Puzzle.consequitive([1, 2, 3]) == [3]
    assert Puzzle.consequitive([1, 2, 3, 4]) == [4]
    assert Puzzle.consequitive([1, 2, 3, 5]) == [3, 1]

    assert Puzzle.consequitive([1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19]) ==
      [1, 4, 3, 2, 1]
  end

  test "tribonacci sequeunce" do
    assert Puzzle.tribonacci(0) == 0
    assert Puzzle.tribonacci(1)  == 1
    assert Puzzle.tribonacci(2)  == 1
    assert Puzzle.tribonacci(3)  == 2
    assert Puzzle.tribonacci(4)  == 4
    assert Puzzle.tribonacci(5)  == 7
    assert Puzzle.tribonacci(6)  == 13
    assert Puzzle.tribonacci(7)  == 24
    assert Puzzle.tribonacci(8)  == 44
    assert Puzzle.tribonacci(9)  == 81
    assert Puzzle.tribonacci(10) == 149
  end

  test "find ways" do
    assert Puzzle.find_ways(read()) == 8

    ways = "input-test-02.txt"
             |> read()
             |> Puzzle.find_ways()

    assert ways == 19208
  end

  defp read(filename \\ "input-test.txt") do
    filename |> Puzzle.read_sorted()
  end

end
