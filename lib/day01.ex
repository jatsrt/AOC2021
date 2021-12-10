defmodule AOC2021.DAY01 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 1")

    case open_file_contents("inputs/day01.input") do
      {:ok, contents} ->
        generate_answers(contents)

      {:error, _error} ->
        {:error}
    end
  end

  defp open_file_contents(path) do
    case File.read(path) do
      {:ok, input} ->
        {:ok, input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp generate_answers(input) when is_list(input) do
    {:ok, [part_one, part_two]} = generate_simple_answers(input)
    Logger.info("Simple part one: #{part_one} part two: #{part_two}")

    {:ok, [part_one, part_two]} = generate_non_simple_answers(input)
    Logger.info("Non simple part one: #{part_one} part two: #{part_two}")

    {:ok}
  end

  defp generate_simple_answers(input) when is_list(input) do
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

  defp generate_non_simple_answers(input) when is_list(input) do
    windowed_input =
      input
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.map(&Enum.sum/1)

    part_one = find_answer(input)
    part_two = find_answer(windowed_input)

    {:ok, [part_one, part_two]}
  end

  defp count_it([first, second]) when first < second, do: 1
  defp count_it([_, _]), do: 0

  defp find_answer(list, acc \\ 0)
  defp find_answer([h | [n | _] = t], acc) when h < n, do: find_answer(t, acc + 1)
  defp find_answer([_ | [_ | _] = t], acc), do: find_answer(t, acc)
  defp find_answer([_ | []], acc), do: acc
end
