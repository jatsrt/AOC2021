defmodule AOC2021.DAY03 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 3 V2")

    case open_file_contents("inputs/day03.input") do
      {:ok, contents} ->
        {gamma_result, _} =
          process_list(contents, 0, 12, [], &gamma/1) |> Enum.join() |> Integer.parse(2)

        {epsilon_result, _} =
          process_list(contents, 0, 12, [], &epsilon/1) |> Enum.join() |> Integer.parse(2)

        Logger.info(
          "Part One - Gamma:#{gamma_result} Epsilon:#{epsilon_result} Product:#{gamma_result * epsilon_result}"
        )

        {oxygen_result, _} =
          process_and_filter_list(contents, 0, 12, &gamma/1) |> Enum.join() |> Integer.parse(2)

        {co2_result, _} =
          process_and_filter_list(contents, 0, 12, &epsilon/1) |> Enum.join() |> Integer.parse(2)

        Logger.info(
          "Part Two - Oxygen:#{oxygen_result} CO2:#{co2_result} Product:#{oxygen_result * co2_result}"
        )

        {:ok}

      {:error, _error} ->
        {:error}
    end
  end

  def open_file_contents(path) do
    Logger.info("Opening input file")

    case File.read(path) do
      {:ok, input} ->
        contents = input |> String.split("\n", trim: true)
        Logger.info("Input Count: #{Enum.count(contents)}")
        {:ok, contents}

      {:error, error} ->
        Logger.error("Error reading file: #{error}")
        {:error, error}
    end
  end

  def process_and_filter_list(list, position, length, f)
      when position < length and length(list) > 1 do
    result = f.(accumulate(list, position, 0))
    list = filter_list(list, result, position, [])
    process_and_filter_list(list, position + 1, length, f)
  end

  def process_and_filter_list(list, _, _, _), do: list

  def filter_list([h | t], filter, position, acc) do
    item = filter_item(h, h |> String.at(position) |> String.to_integer(), filter)
    filter_list(t, filter, position, acc ++ item)
  end

  def filter_list([], _, _, acc), do: acc

  def filter_item(item, a, b) when a == b, do: [item]
  def filter_item(_, _, _), do: []

  def process_list(list, position, length, acc, f) when position < length do
    result = f.(accumulate(list, position, 0))
    process_list(list, position + 1, length, [result | acc], f)
  end

  def process_list(_, _, _, acc, _), do: acc |> Enum.reverse()

  def accumulate([h | t], position, acc),
    do: accumulate(t, position, acc + value_of(h |> String.at(position)))

  def accumulate([], _, acc), do: acc

  def value_of("0"), do: -1
  def value_of("1"), do: 1

  def gamma(v) when v >= 0, do: 1
  def gamma(_), do: 0

  def epsilon(v) when v < 0, do: 1
  def epsilon(_), do: 0
end
