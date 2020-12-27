defmodule Puzzle do

  def solve() do
    "input.txt"
      |> read_instructions()
      |> run_program()
  end

  def run_program(instructions) do
    state = %{current: 0, acc: 0}
    %{acc: value} = run(instructions, state, [], false)
    value
  end

  def read_instructions(filename) do
    filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> read_instruction(x) end)
  end

  def execute(:acc, argument, %{current: index, acc: value}) do
    %{current: index + 1, acc: value + argument}
  end

  def execute(:nop, _argument, %{current: index, acc: value}) do
    %{current: index + 1, acc: value}
  end

  def execute(:jmp, argument, %{current: index, acc: value}) do
    %{current: index + argument, acc: value}
  end

  defp run(_instructions, state, _visited, true), do: state

  defp run(instructions, state, visited, false) do
    {instruction, argument}  = Enum.at(instructions, state.current)
    visited = [state.current | visited]
    state = execute(instruction, argument, state)
    revisit? = Enum.member?(visited, state.current)
    run(instructions, state, visited, revisit?)
  end

  defp read_instruction(line) do
    [instruction, argument] = line |> String.split(" ")
    {String.to_atom(instruction), String.to_integer(argument)}
  end

end

IO.inspect Puzzle.solve()
