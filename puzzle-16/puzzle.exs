defmodule Puzzle do

  def solve() do
    instructions = "input.txt"
      |> read_instructions()

    a = instructions |> Puzzle.alternatives(:nop, :jmp)
    b = instructions |> Puzzle.alternatives(:jmp, :nop)

    Enum.concat(a, b)
      |> Enum.filter(fn %{status: status} -> status == :terminated end)
      |> Enum.map(fn x -> x.acc end)
      |> List.first()
  end

  def run_program(instructions) do
    state = %{current: 0, acc: 0, status: :running}
    run(instructions, state, [], false)
  end

  def read_instructions(filename) do
    filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> read_instruction(x) end)
  end

  def execute(:acc, argument, state = %{current: index, acc: value}) do
    %{state | current: index + 1, acc: value + argument}
  end

  def execute(:nop, _argument, state = %{current: index}) do
    %{state | current: index + 1}
  end

  def execute(:jmp, argument, state = %{current: index}) do
    %{state | current: index + argument}
  end

  def terminated?(state), do: state.status == :terminated

  def change(instructions, index, new_instruction) do
    {_instruction, argument} = instructions |> Enum.at(index)
    instructions |> List.replace_at(index, {new_instruction, argument})
  end

  def calc_mutations(instructions, old_instruction, new_instruction) do
    instructions
      |> Enum.with_index()
      |> Enum.filter(fn {{instr, _arg}, _index} -> instr == old_instruction end)
      |> Enum.map(fn {{_instr, _arg} , index} -> {index, new_instruction} end)
  end

  def alternatives(instructions, old_instruction, new_instruction) do
    instructions
      |> Puzzle.calc_mutations(old_instruction, new_instruction)
      |> Enum.map(fn {index, new_instruction} -> Puzzle.change(instructions, index, new_instruction) end)
      |> Enum.map(fn instructions -> Puzzle.run_program(instructions) end)
  end


  defp run(_instructions, state, _visited, true), do: %{state | status: :infinite}

  defp run(instructions, state, visited, false) do
    if out_of_instructions?(instructions, state.current) do
      %{state | status: :terminated}
    else
      {instruction, argument}  = Enum.at(instructions, state.current)
      visited = [state.current | visited]
      state = execute(instruction, argument, state)
      revisit? = Enum.member?(visited, state.current)
      run(instructions, state, visited, revisit?)
    end
  end

  defp out_of_instructions?(instructions, current), do: current >= Enum.count(instructions)

  defp read_instruction(line) do
    [instruction, argument] = line |> String.split(" ")
    {String.to_atom(instruction), String.to_integer(argument)}
  end

end

IO.inspect Puzzle.solve()
