defmodule Puzzle do

  @number 2020

  def answer() do
    list = value_list()
    IO.inspect {factor_1, factor_2, factor_3} =  search(list, list)
    factor_1 * factor_2 * factor_3 
  end

  def search(original_list, list) do
    [h|t] = list
    rest = List.delete(original_list, h)
    remainer = @number - h
    {reply, factor_1, factor_2 } = search_two_factors(rest, rest, nil, false, remainer)
    if reply == :not_found do
      search(original_list, t)
    else
      {h, factor_1, factor_2}
    end
  end

  def search_two_factors(_original_list, [], _candidate, false, _remainer) do
    {:not_found, nil, nil}
  end

  def search_two_factors(original_list, list, _candidate, false, remainer) do
    [h | t] = list
    candidate = remainer - h
    search_two_factors(original_list, t, candidate, Enum.member?(original_list, candidate), remainer)
  end


  def search_two_factors(_original_list, _list, candidate, _continue, remainer) do
    {:ok, candidate, remainer - candidate}
  end


  def value_list() do
    read_file()
      |> String.split("\n", trim: true)
      |> Enum.map(fn(x) -> String.to_integer(x) end)
  end

  def read_file do
    {:ok, content} = "input.txt" |> File.read()

    content
  end

end

IO.inspect Puzzle.answer()
