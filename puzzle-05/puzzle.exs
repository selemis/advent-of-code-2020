defmodule Puzzle do

  @move_x 3
  @move_y 1

  def answer() do
    forest = forest_part()
    starting_point = {1, 1}
    {max_x, max_y} =  max_cord(forest)
    traverse(forest, starting_point, 0, max_x, max_y)
  end

  def traverse(_forest, {_x, y}, num_of_trees, _max_x, max_y) when y == max_y do
    num_of_trees
  end

  def traverse(forest, starting_point, num_of_trees, max_x, max_y) do
    next_point = move(starting_point, max_x)
    {:ok, item} = Map.fetch(forest, next_point)
    num_of_trees = count_trees(num_of_trees, item)
    traverse(forest, next_point, num_of_trees, max_x, max_y)
  end

  def count_trees(num_of_trees, "#"), do: num_of_trees + 1
  def count_trees(num_of_trees, _), do: num_of_trees

  def move({x, y}, max_x) when x > max_x - @move_x, do: {x - max_x + @move_x, y + @move_y}
  def move({x, y}, _max_x), do: {x + @move_x, y + @move_y}

  def forest_part() do
    "input.txt"
      |> File.read!()
      |> String.split(~r/\n/)
      |> Enum.map(fn x -> String.codepoints(x) end)
      |> Enum.with_index()
      |> Enum.map(fn row -> row_to_struct(row) end)
      |> Enum.reduce(fn (a, b) -> Map.merge(a, b) end)
  end

  def row_to_struct(row) do
    {point, y_cord} = row
    l = for {item, y_cord}  <- Enum.with_index(point), do: {item, y_cord}
    l
      |> Enum.map(fn {point, x_cord} -> {x_cord + 1, y_cord + 1, point} end)
      |> Map.new(fn {x_cord, y_cord, point} -> {{x_cord, y_cord}, point} end)
  end

  def max_cord(map) do
    map
      |> Map.keys()
      |> Enum.max()
  end

end

IO.inspect Puzzle.answer()
