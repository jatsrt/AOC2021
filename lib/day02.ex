defmodule AOC2021.DAY02 do
  def run() do
    IO.puts("AOC 2021 Day 2")

    directions =
      "inputs/day02.input"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split/1)
      |> Enum.map(fn [a, v] -> {a, v |> String.to_integer()} end)

    {depth, hp} =
      Enum.reduce(directions, {0, 0}, fn
        {"up", v}, {depth, hp} -> {depth - v, hp}
        {"down", v}, {depth, hp} -> {depth + v, hp}
        {"forward", v}, {depth, hp} -> {depth, hp + v}
      end)

    IO.puts("Part One - Depth: #{depth} HP: #{hp} Result: #{hp * depth}")

    {depth, hp, aim} =
      Enum.reduce(directions, {0, 0, 0}, fn
        {"up", v}, {depth, hp, aim} -> {depth, hp, aim - v}
        {"down", v}, {depth, hp, aim} -> {depth, hp, aim + v}
        {"forward", v}, {depth, hp, aim} -> {depth + aim * v, hp + v, aim}
      end)

    IO.puts("Part Two - Aim: #{aim} Depth: #{depth} HP: #{hp} Resut: #{hp * depth}")
  end
end
