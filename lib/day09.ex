defmodule AOC2021.DAY09 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 9")

    case open_file_contents("inputs/day09.input") do
      {:ok, all_points} ->
        low_points =
          all_points |> Enum.map(&find_low(&1, all_points)) |> Enum.filter(&(!is_nil(&1)))

        sum_points = low_points |> Enum.map(fn {_, v} -> v + 1 end) |> Enum.sum()

        Logger.info("Part One: Risk Sum: #{sum_points}")

        basins = find_basins(low_points, all_points, [])

        basin_lengths =
          basins
          |> Enum.map(&(Map.values(&1) |> length))
          |> Enum.sort()
          |> Enum.slice(-3..-1)
          |> Enum.product()

        Logger.info("Part Two - Basins #{basin_lengths}")

        {:ok}

      {:error, _error} ->
        {:error}
    end
  end

  def open_file_contents(path) do
    case File.read(path) do
      {:ok, input} ->
        rows = input |> String.split("\n")
        encoded_rows = encode_rows(rows, 0, %{})

        {:ok, encoded_rows}

      {:error, error} ->
        {:error, error}
    end
  end

  def encode_rows([row | rows], current_row, acc) do
    acc = encode_row(row |> String.graphemes(), current_row, 0, acc)
    encode_rows(rows, current_row + 1, acc)
  end

  def encode_rows([], _, acc), do: acc

  def encode_row([h | t], current_row, current_column, acc) do
    encode_row(
      t,
      current_row,
      current_column + 1,
      acc |> Map.put({current_row, current_column}, h |> String.to_integer())
    )
  end

  def encode_row([], _, _, acc), do: acc

  def find_low({{row, column}, value} = location, locations) do
    up = Map.get(locations, {row - 1, column}, 9)
    down = Map.get(locations, {row + 1, column}, 9)
    left = Map.get(locations, {row, column - 1}, 9)
    right = Map.get(locations, {row, column + 1}, 9)

    case value < up && value < down && value < left && value < right do
      true -> location
      false -> nil
    end
  end

  def find_basins([low_point | low_points], all_points, acc) do
    basin_size = calculate_basin(low_point, all_points, %{})
    find_basins(low_points, all_points, [basin_size | acc])
  end

  def find_basins([], _, acc), do: acc

  def calculate_basin({{row, column} = key, value}, all_points, acc) when value != 9 do
    up_key = {row - 1, column}
    up_value = Map.get(all_points, up_key, 9)

    down_key = {row + 1, column}
    down_value = Map.get(all_points, down_key, 9)

    left_key = {row, column - 1}
    left_value = Map.get(all_points, left_key, 9)

    right_key = {row, column + 1}
    right_value = Map.get(all_points, right_key, 9)

    acc = Map.put(acc, key, value)

    acc =
      case Map.get(acc, up_key, nil) do
        nil -> calculate_basin({up_key, up_value}, all_points, acc)
        _ -> acc
      end

    acc =
      case Map.get(acc, down_key, nil) do
        nil -> calculate_basin({down_key, down_value}, all_points, acc)
        _ -> acc
      end

    acc =
      case Map.get(acc, left_key, nil) do
        nil -> calculate_basin({left_key, left_value}, all_points, acc)
        _ -> acc
      end

    acc =
      case Map.get(acc, right_key, nil) do
        nil -> calculate_basin({right_key, right_value}, all_points, acc)
        _ -> acc
      end

    acc
  end

  def calculate_basin(_, _, acc), do: acc
end
