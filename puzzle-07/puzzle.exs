defmodule Puzzle do

  @byr "byr"
  @iyr "iyr"
  @eyr "eyr"
  @hgt "hgt"
  @hcl "hcl"
  @ecl "ecl"
  @pid "pid"
  @valid_ecl_words ~w(amb blu brn gry grn hzl oth)
  @valid_hcl_nums Enum.to_list(0..9) |> Enum.map(fn(x) -> Integer.to_string(x) end)
  @valid_hcl_letters for n <- ?a..?f, do: << n :: utf8 >>
  @valid_hcl_chars Enum.concat(@valid_hcl_nums, @valid_hcl_letters)

  def answer() do
    passwords()
      |> Enum.map(fn x -> valid?(x) end)
      |> Enum.filter(fn x -> x == true end)
      |> Enum.count()
  end

  def passwords() do
    "input.txt"
      |> File.read!()
      |> String.split("\n\n")
      |> Enum.map(fn x -> parse_line(x) end)
  end

  def valid?(password) do
    numeric_key_between?(password, @byr, 1920, 2002)
      and numeric_key_between?(password, @iyr, 2010, 2020)
      and numeric_key_between?(password, @eyr, 2020, 2030)
      and valid_hgt?(password)
      and valid_hcl?(password)
      and valid_ecl?(password)
      and valid_pid?(password)
  end

  def numeric_key_between?(password, key, min, max) do
    numeric_key?(password, key, min, max, Map.has_key?(password, key))
  end

  def numeric_key?(password, key, min, max, true) do
    value = Map.get(password, key) |> String.to_integer
    value >= min and value <= max
  end

  def numeric_key?(_password, _key, _min, _max, false), do: false

  def valid_hgt?(password), do: val_hgt?(password, Map.has_key?(password, @hgt))

  def val_hgt?(password, true) do
    value = Map.get(password, @hgt)
    cond do
      is_inches?(value) ->
        inches = extract_height_number(value, "in")
        inches >= 59 and inches <= 76
      is_cm?(value) ->
        cm = extract_height_number(value, "cm")
        cm >= 150 and cm <= 193
      true ->
        false
    end
  end

  def val_hgt?(_password, false), do: false

  defp is_inches?(value), do: String.contains?(value, "in")

  defp is_cm?(value), do:  String.contains?(value, "cm")

  defp extract_height_number(value, metric) do
    value
      |> String.split(metric)
      |> List.first()
      |> String.to_integer()
  end

  def valid_hcl?(password), do: val_hcl(password, Map.has_key?(password, @hcl))

  defp val_hcl(password, true) do
    value = Map.get(password, @hcl)
    val_hcl_second_part?(value, starts_with_pound?(value))
  end

  defp val_hcl(_password, false), do: false

  defp starts_with_pound?(value) do
    String.starts_with?(value, "#")
  end

  defp val_hcl_second_part?(value, true) do
    second_part = value |> String.split("#") |> List.last()
    six_hcl_chars?(second_part) and valid_hcl_chars?(second_part)
  end

  defp val_hcl_second_part?(_value, false), do: false

  defp six_hcl_chars?(second_part) do
    num_of_chars = second_part |> String.codepoints() |> Enum.count()
    num_of_chars == 6
  end

  defp valid_hcl_chars?(second_part) do
    num_of_valid_chars = second_part
      |> String.codepoints
      |> Enum.map(fn x -> Enum.member?(@valid_hcl_chars, x) end)
      |> Enum.filter(fn x -> x == true end)
      |> Enum.count()

    num_of_valid_chars == 6
  end

  def valid_ecl?(password), do: val_ecl(password, Map.has_key?(password, @ecl))

  def val_ecl(password, true) do
    Enum.member?(@valid_ecl_words, Map.get(password, @ecl))
  end

  def val_ecl(_password, false), do: false

  def valid_pid?(password), do: val_pid(password, Map.has_key?(password, @pid))

  def val_pid(password, true) do
    value = Map.get(password, @pid)
    nine_chars?(value) and is_numeric?(value)
  end

  def val_pid(_password, false), do: false

  defp nine_chars?(value) do
    num_of_chars = value |> String.codepoints |> Enum.count()
    num_of_chars == 9
  end

  defp is_numeric?(value), do: Regex.match?(~r{\A\d*\z}, value) 

  def parse_line(line) do
    line
      |> String.split(" ")
      |> Enum.map(fn x -> String.split(x, "\n", trim: true) end)
      |> List.flatten()
      |> Enum.map(fn x -> String.split(x, ":") end)
      |> to_password(%{})
  end

  def to_password([], result), do: result

  def to_password(list, result ) do
    [ [key, value] | t ] = list
    result = Map.put(result, key, value)
    to_password(t, result)
  end

end

IO.inspect Puzzle.answer()

