defmodule AOC2021.DAY07 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 7")

    case open_file_contents("inputs/day07.input") do
      {:ok, contents} ->
        {min, max} = contents |> Enum.min_max()

        min_fuel_consumption =
          min..max |> Enum.map(&fuel(contents, &1, ranged: false)) |> Enum.min()

        Logger.info("Part One - Min Fuel #{min_fuel_consumption}")

        min_fuel_consumption =
          min..max |> Enum.map(&fuel(contents, &1, ranged: true)) |> Enum.min()

        Logger.info("Part Two - Min Fuel #{min_fuel_consumption}")
        {:ok}

      {:error, _error} ->
        {:error}
    end
  end

  def open_file_contents(path) do
    case File.read(path) do
      {:ok, input} ->
        {:ok, input |> String.split(",") |> Enum.map(&String.to_integer/1)}

      {:error, error} ->
        {:error, error}
    end
  end

  def fuel(positions, new_position, ranged: false),
    do: positions |> Enum.map(fn p -> abs(p - new_position) end) |> Enum.sum()

  def fuel(positions, new_position, ranged: true),
    do: positions |> Enum.map(fn p -> 0..abs(p - new_position) |> Enum.sum() end) |> Enum.sum()
end
