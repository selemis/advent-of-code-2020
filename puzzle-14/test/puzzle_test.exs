ExUnit.start

defmodule PuzzleTest do
  use ExUnit.Case

  test "content_for_directly" do
    content = read_rules()
      |> Puzzle.content_for_directly("shiny gold", 1)

    assert Enum.member?(content, {1, 1, "dark olive"})
    assert Enum.member?(content, {1, 2, "vibrant plum"})
    assert Enum.count(content) == 2
  end

  test "content_for" do
    content = read_rules()
      |> Puzzle.content_for([{1, 1, "shiny gold"}], [])

    assert Enum.member?(content, {1, 1, "dark olive"})
    assert Enum.member?(content, {1, 2, "vibrant plum"})
    assert Enum.member?(content, {2, 6, "dotted black"})
    assert Enum.member?(content, {2, 5, "faded blue"})
    assert Enum.member?(content, {1, 3, "faded blue"})
    assert Enum.member?(content, {1, 4, "dotted black"})
    assert Enum.count(content) == 6
  end

  test "count_bags test-input.txt" do
    number = "test-input.txt"
                |> Puzzle.count_bags()

    assert number == 32
  end

  test "count_bags test-input-2.txt" do
    number = "test-input-2.txt"
                |> Puzzle.count_bags()

    assert number == 126
  end

  def read_rules() do
    "test-input.txt"
      |> Puzzle.parse_rules()
  end


end
