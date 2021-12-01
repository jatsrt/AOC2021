defmodule AOC2021.DAY01 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 1")

    case open_file_contents("lib/aoc2021.day01.input") do
      {:ok, contents} ->
        simple_answer_part_one =
          contents |> Enum.chunk_every(2, 1, :discard) |> Enum.map(&count_it/1) |> Enum.sum()

        Logger.info("The simple answer is part one: #{simple_answer_part_one}")

        non_simple_answer_part_one = find_answer(contents, 0)

        Logger.info("The non simple answer is part one: #{non_simple_answer_part_one}")

        part_two_contents = contents |> Enum.chunk_every(3, 1, :discard) |> Enum.map(&Enum.sum/1)

        simple_answer_part_two =
          part_two_contents
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.map(&count_it/1)
          |> Enum.sum()

        Logger.info("The simple answer is part two: #{simple_answer_part_two}")

        non_simple_answer_part_two = find_answer(part_two_contents, 0)

        Logger.info("The non simple answer is part two: #{non_simple_answer_part_two}")

        {:ok}

      {:error, error} ->
        Logger.error("Error reading file: #{error}")
        {:error}
    end
  end

  def open_file_contents(path) do
    Logger.info("Opening input file")

    case File.read(path) do
      {:ok, input} ->
        contents = input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
        Logger.info("Input Count: #{Enum.count(contents)}")
        {:ok, contents}

      {:error, error} ->
        {:error, error}
    end
  end

  def count_it([first, second]) when first < second, do: 1
  def count_it([_, _]), do: 0

  def find_answer([h | [n | _] = t], acc) when h < n, do: find_answer(t, acc + 1)
  def find_answer([_ | [_ | _] = t], acc), do: find_answer(t, acc)
  def find_answer([_ | []], acc), do: acc
end
