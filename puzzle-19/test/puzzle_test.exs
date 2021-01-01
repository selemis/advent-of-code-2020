ExUnit.start()

defmodule PuzzleTest do

  use ExUnit.Case

  test "sort list" do
    sorted_list = read()

    assert sorted_list == [1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19]
  end

  test "get candidate differences" do
    list = read()

    assert Puzzle.find_candidates(0, list) == [1]

    [h | t] = list

    assert Puzzle.find_candidates(h, t) == [4]
  end

  test "find differences" do
    {diff1, _, diff3} = Puzzle.find_differences(0, read(), 0, 0, 0)

    assert diff1 == 7
    assert diff3 == 4

    list = read("input-test-02.txt")
    {diff1, _, diff3} = Puzzle.find_differences(0, list, 0, 0, 0)

    assert diff1 == 22
    assert diff3 == 9
  end

  defp read(filename \\ "input-test.txt") do
    filename |> Puzzle.read_sorted()
  end

end
