defmodule AOC2021.DAY01 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 1")

    case open_file_contents("lib/aoc2021.day01.input") do
      {:ok, contents} ->
        generate_answers(contents)

      {:error, _error} ->
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
        Logger.error("Error reading file: #{error}")
        {:error, error}
    end
  end

  def generate_answers(input) when is_list(input) do
    {:ok, [part_one, part_two]} = generate_simple_answers(input)
    Logger.info("Simple part one: #{part_one} part two: #{part_two}")

    {:ok, [part_one, part_two]} = generate_non_simple_answers(input)
    Logger.info("Non simple part one: #{part_one} part two: #{part_two}")

    {:ok}
  end

  def generate_simple_answers(input) when is_list(input) do
    part_one = input |> Enum.chunk_every(2, 1, :discard) |> Enum.map(&count_it/1) |> Enum.sum()

    part_two =
      input
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.map(&Enum.sum/1)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&count_it/1)
      |> Enum.sum()

    {:ok, [part_one, part_two]}
  end

  def generate_non_simple_answers(input) when is_list(input) do
    windowed_input =
      input
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.map(&Enum.sum/1)

    part_one = find_answer(input, 0)
    part_two = find_answer(windowed_input, 0)

    {:ok, [part_one, part_two]}
  end

  def count_it([first, second]) when first < second, do: 1
  def count_it([_, _]), do: 0

  def find_answer([h | [n | _] = t], acc) when h < n, do: find_answer(t, acc + 1)
  def find_answer([_ | [_ | _] = t], acc), do: find_answer(t, acc)
  def find_answer([_ | []], acc), do: acc
end
