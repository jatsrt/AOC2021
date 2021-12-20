defmodule AOC2021.DAY07 do
  def run() do
    IO.puts("AOC 2021 Day 7")

    positions = "inputs/day07.input" |> File.read!() |> String.split(",") |> Enum.map(&String.to_integer/1)
    {min, max} = Enum.min_max(positions)

    consumption =
      Enum.map(min..max, &Enum.reduce(positions, 0, fn p, sum -> sum + abs(p - &1) end))
      |> Enum.min()

    IO.puts("Part One - Min Fuel #{consumption}")

    consumption =
      Enum.map(min..max, &Enum.reduce(positions, 0, fn p, sum -> sum + Enum.sum(0..abs(p - &1)) end))
      |> Enum.min()

    IO.puts("Part Two - Min Fuel #{consumption}")
  end
end
