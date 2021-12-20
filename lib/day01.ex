defmodule AOC2021.DAY01 do
  def run() do
    IO.puts("AOC 2021 Day 1")
    contents = "inputs/day01.input" |> File.read!() |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)

    part_one = contents |> reduce_it()
    IO.puts("Part One - #{part_one}")

    part_two = contents |> Enum.chunk_every(3, 1, :discard) |> Enum.map(&Enum.sum/1) |> reduce_it()
    IO.puts("Part Two - #{part_two}")
  end

  defp reduce_it(contents) do
    contents
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn
      [first, second], sum when first < second -> sum + 1
      [_, _], sum -> sum
    end)
  end
end
