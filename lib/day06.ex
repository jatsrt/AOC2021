defmodule AOC2021.DAY06 do
  def run() do
    IO.puts("AOC 2021 Day 6")

    fish_map = "inputs/day06.input" |> File.read!() |> String.split(",") |> Enum.map(&String.to_integer/1) |> Enum.frequencies()

    fishes =
      {Map.get(fish_map, 0, 0), Map.get(fish_map, 1, 0), Map.get(fish_map, 2, 0), Map.get(fish_map, 3, 0), Map.get(fish_map, 4, 0), Map.get(fish_map, 5, 0), Map.get(fish_map, 6, 0),
       Map.get(fish_map, 7, 0), Map.get(fish_map, 8, 0)}

    sum = fishes |> Stream.iterate(&breed/1) |> Enum.at(80) |> Tuple.sum()
    IO.puts("Part 1 - Fish Count: #{sum}")

    sum = fishes |> Stream.iterate(&breed/1) |> Enum.at(256) |> Tuple.sum()
    IO.puts("Part 2 - Fish Count: #{sum}")
  end

  defp breed({zero, one, two, three, four, five, six, seven, eight}), do: {one, two, three, four, five, six, zero + seven, eight, zero}
end
