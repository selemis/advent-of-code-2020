ExUnit.start

defmodule PuzzleTest do
  use ExUnit.Case

  #BFFFBBFRRR: row 70, column 7, seat ID 567.

  test "BFFFBBF" do
    row  = "BFFFBBF"
    assert Puzzle.bisect(row) == 70
  end

  test "RRR" do
    col  = "RRR"
    assert Puzzle.bisect(col) == 7
  end

  test "BFFFBBFRRR" do
    code = "BFFFBBFRRR"
    assert Puzzle.row(code) == 70
    assert Puzzle.col(code) == 7
  end

  test "seat" do
    code = "BFFFBBFRRR"
    assert Puzzle.seat(code) == 567
  end

  test "solve" do
    Puzzle.solve() == 842
  end


end


