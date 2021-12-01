defmodule AOC2021.DAY01 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 1")

    case File.read("lib/aoc2021.day01.input") do
      {:ok, result} ->
        Logger.info("Input file read")
        {:ok, input} = tokenize_file(result)
        count_part_one = find_answer(input, 0)
        Logger.info("The answer is part one: #{count_part_one}")

        count_part_two =
          find_answer(input |> Enum.chunk_every(3, 1, :discard) |> Enum.map(&Enum.sum/1), 0)

        Logger.info("The answer is part two: #{count_part_two}")
        {:ok}

      {:error, error} ->
        Logger.error("Error reading file: #{error}")
        {:error}
    end
  end

  def tokenize_file(input) do
    contents = input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
    Logger.info("Input Count: #{Enum.count(contents)}")
    {:ok, contents}
  end

  def find_answer([h | [n | _] = t], acc) when h < n do
    find_answer(t, acc + 1)
  end

  def find_answer([h | [n | _] = t], acc) when h >= n do
    find_answer(t, acc)
  end

  def find_answer([_ | []], acc) do
    acc
  end
end
