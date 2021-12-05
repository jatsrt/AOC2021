defmodule AOC2021.DAY02 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 2")

    case open_file_contents("inputs/day02.input") do
      {:ok, contents} ->
        {:ok, depth, hp} = calculate(contents, 0, 0)
        Logger.info("Part One - Depth:#{depth} HP:#{hp} Result:#{hp * depth}")

        {:ok, depth, hp, aim} = calculate(contents, 0, 0, 0)
        Logger.info("Part Two - Aim:#{aim} Depth:#{depth} HP:#{hp} Resut:#{hp * depth}")

        {:ok}

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

  def calculate([[:up, a] | t], depth, hp), do: calculate(t, depth - a, hp)
  def calculate([[:down, a] | t], depth, hp), do: calculate(t, depth + a, hp)
  def calculate([[:forward, a] | t], depth, hp), do: calculate(t, depth, hp + a)
  def calculate([], depth, hp), do: {:ok, depth, hp}

  def calculate([[:up, a] | t], depth, hp, aim), do: calculate(t, depth, hp, aim - a)
  def calculate([[:down, a] | t], depth, hp, aim), do: calculate(t, depth, hp, aim + a)

  def calculate([[:forward, a] | t], depth, hp, aim),
    do: calculate(t, depth + aim * a, hp + a, aim)

  def calculate([], depth, hp, aim), do: {:ok, depth, hp, aim}
end
