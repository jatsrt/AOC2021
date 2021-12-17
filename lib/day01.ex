defmodule AOC2021.DAY01 do
  def run() do
    IO.puts("AOC 2021 Day 1")
    contents = "inputs/day01.input" |> File.read!() |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)

    part_one = contents |> Enum.chunk_every(2, 1, :discard) |> Enum.map(&count_it/1) |> Enum.sum()
    IO.puts("Part One - #{part_one}")

    part_two =
      contents
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.map(&Enum.sum/1)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&count_it/1)
      |> Enum.sum()

    IO.puts("Part Two - #{part_two}")
  end

  defp count_it([first, second]) when first < second, do: 1
  defp count_it([_, _]), do: 0
end
