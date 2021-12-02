defmodule AOC2021.DAY02 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 2")

    case open_file_contents("lib/aoc2021.day02.input") do
      {:ok, contents} ->
        {:ok, depth, hp} = calculate(contents, 0, 0)
        Logger.info("Part One - Depth:#{depth} HP:#{hp} Result:#{hp * depth}")

        {:ok, depth, hp, aim} = calculate_with_aim(contents, 0, 0, 0)
        Logger.info("Part Two - Aim:#{aim} Depth:#{depth} HP:#{hp} Resut:#{hp * depth}")

      {:error, _error} ->
        {:error}
    end
  end

  def open_file_contents(path) do
    Logger.info("Opening input file")

    case File.read(path) do
      {:ok, input} ->
        contents =
          input
          |> String.split("\n", trim: true)
          |> Enum.map(&String.split/1)
          |> Enum.map(fn [a, v] -> [a |> String.to_atom(), v |> String.to_integer()] end)

        Logger.info("Input Count: #{Enum.count(contents)}")
        {:ok, contents}

      {:error, error} ->
        Logger.error("Error reading file: #{error}")
        {:error, error}
    end
  end

  def calculate([[d, a] | t], depth, hp) when d == :up, do: calculate(t, depth - a, hp)
  def calculate([[d, a] | t], depth, hp) when d == :down, do: calculate(t, depth + a, hp)
  def calculate([[d, a] | t], depth, hp) when d == :forward, do: calculate(t, depth, hp + a)
  def calculate([], depth, hp), do: {:ok, depth, hp}

  def calculate_with_aim([[d, a] | t], depth, hp, aim) when d == :up,
    do: calculate_with_aim(t, depth, hp, aim - a)

  def calculate_with_aim([[d, a] | t], depth, hp, aim) when d == :down,
    do: calculate_with_aim(t, depth, hp, aim + a)

  def calculate_with_aim([[d, a] | t], depth, hp, aim) when d == :forward,
    do: calculate_with_aim(t, depth + aim * a, hp + a, aim)

  def calculate_with_aim([], depth, hp, aim), do: {:ok, depth, hp, aim}
end
