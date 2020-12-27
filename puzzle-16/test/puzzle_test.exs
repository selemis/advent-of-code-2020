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

  test "program infinite loop" do
    instructions =  Puzzle.read_instructions("test-input.txt")
    state = Puzzle.run_program(instructions)

    assert state.acc == 5
    assert state.status == :infinite
    assert Puzzle.terminated?(state) == false
  end

  test "program terminates" do
    instructions =  Puzzle.read_instructions("input-terminate-test.txt")
    state = Puzzle.run_program(instructions)

    assert state.acc == 8
    assert state.status == :terminated
    assert Puzzle.terminated?(state) == true
  end

  test "change instruction" do
    instructions =  Puzzle.read_instructions("test-input.txt")
    new_instructions = Puzzle.change(instructions, 2, :nop)

    assert new_instructions == [nop: 0, acc: 1, nop: 4, acc: 3, jmp: -3, acc: -99, acc: 1, jmp: -4, acc: 6]
  end

  test "mutations" do
    instructions =  Puzzle.read_instructions("test-input.txt")
    mutations = Puzzle.calc_mutations(instructions, :nop, :jmp)

    assert mutations == [{0, :jmp}]

    mutations = Puzzle.calc_mutations(instructions, :jmp, :nop)

    assert mutations == [{2, :nop}, {4, :nop}, {7, :nop}]
  end

  test "alternatives" do
    instructions =  Puzzle.read_instructions("test-input.txt")

    assert [
        %{acc: 4, current: 1, status: :infinite},
        %{acc: -94, current: 6, status: :infinite},
        %{acc: 8, current: 9, status: :terminated}
    ] == Puzzle.alternatives(instructions, :jmp, :nop)
  end


end
