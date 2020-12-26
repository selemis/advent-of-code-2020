ExUnit.start

defmodule PuzzleTest do
  use ExUnit.Case

  test "parse rule - contains no bags" do
    text = "dotted black bags contain no other bags."

    assert Puzzle.parse_rule(text) == %{color: "dotted black", content: [] }
  end

  test "parse rule - contains one type of bag" do
    text = "bright white bags contain 1 shiny gold bag."

    assert Puzzle.parse_rule(text) == %{color: "bright white", content: [{1, "shiny gold"}] }
  end

  test "parse rule - contains multiple types of bags" do
    text = "pale brown bags contain 1 faded fuchsia bag, 2 wavy orange bags, 1 mirrored coral bag, 5 dotted brown bags."

    assert Puzzle.parse_rule(text) == %{
        color: "pale brown",
      content: [
                  {1, "faded fuchsia"},
                  {2, "wavy orange"},
                  {1, "mirrored coral"},
                  {5, "dotted brown"},
               ],
    }

  end

  test "play" do
    rules = Puzzle.parse_rules("test-input.txt")

    #IO.inspect rules

    container = Puzzle.container_of(rules, "shiny gold")

    assert Enum.member?(container, "muted yellow")
    assert Enum.member?(container, "bright white")
    assert Enum.member?(container, "dark orange")
    assert Enum.member?(container, "light red")
  end


end
