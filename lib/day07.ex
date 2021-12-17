defmodule AOC2021.DAY07 do
  def run() do
    IO.puts("AOC 2021 Day 7")

    contents = "inputs/day07.input" |> File.read!() |> String.split(",") |> Enum.map(&String.to_integer/1)
    {min, max} = contents |> Enum.min_max()

    min_fuel_consumption = min..max |> Enum.map(&fuel(contents, &1, ranged: false)) |> Enum.min()
    IO.puts("Part One - Min Fuel #{min_fuel_consumption}")

    min_fuel_consumption = min..max |> Enum.map(&fuel(contents, &1, ranged: true)) |> Enum.min()
    IO.puts("Part Two - Min Fuel #{min_fuel_consumption}")
  end

  defp fuel(positions, new_position, ranged: false), do: positions |> Enum.map(fn p -> abs(p - new_position) end) |> Enum.sum()
  defp fuel(positions, new_position, ranged: true), do: positions |> Enum.map(fn p -> 0..abs(p - new_position) |> Enum.sum() end) |> Enum.sum()
end
