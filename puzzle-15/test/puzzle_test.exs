ExUnit.start

defmodule PuzzleTest do
  use ExUnit.Case

  test "read instructions" do
    instructions =  Puzzle.read_instructions("test-input.txt")
    assert instructions == [nop: 0, acc: 1, jmp: 4, acc: 3, jmp: -3, acc: -99, acc: 1, jmp: -4, acc: 6]
  end

  test "execute" do
    state = %{current: 0, acc: 0}
    new_state = Puzzle.execute(:acc, 4, state)

    assert new_state.current == 1
    assert new_state.acc == 4

    new_state = Puzzle.execute(:nop, 0, new_state)

    assert new_state.current == 2
    assert new_state.acc == 4

    new_state = Puzzle.execute(:jmp, 4, new_state)

    assert new_state.current == 6
    assert new_state.acc == 4
  end

  test "run_program" do
    instructions =  Puzzle.read_instructions("test-input.txt")
    assert Puzzle.run_program(instructions) == 5
  end


end
