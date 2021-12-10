defmodule AOC2021.DAY03 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 3")

    case open_file_contents("inputs/day03.input") do
      {:ok, contents} ->
        {gamma_result, _} =
          process_list(contents, 0, 12, &gamma/1) |> Enum.join() |> Integer.parse(2)

        {epsilon_result, _} =
          process_list(contents, 0, 12, &epsilon/1) |> Enum.join() |> Integer.parse(2)

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

  defp open_file_contents(path) do
    case File.read(path) do
      {:ok, input} ->
        {:ok, input |> String.split("\n", trim: true)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp process_and_filter_list(list, position, length, f)
       when position < length and length(list) > 1 do
    result = f.(accumulate(list, position, 0))
    list = filter_list(list, result, position)
    process_and_filter_list(list, position + 1, length, f)
  end

  defp process_and_filter_list(list, _, _, _), do: list

  defp filter_list(list, filter, position, acc \\ [])

  defp filter_list([h | t], filter, position, acc) do
    item = filter_item(h, h |> String.at(position) |> String.to_integer(), filter)
    filter_list(t, filter, position, acc ++ item)
  end

  defp filter_list([], _, _, acc), do: acc

  defp filter_item(item, a, b) when a == b, do: [item]
  defp filter_item(_, _, _), do: []

  defp process_list(list, position, length, f, acc \\ [])

  defp process_list(list, position, length, f, acc) when position < length do
    result = f.(accumulate(list, position))
    process_list(list, position + 1, length, f, [result | acc])
  end

  defp process_list(_, _, _, _, acc), do: acc |> Enum.reverse()

  defp accumulate(list, postion, acc \\ 0)

  defp accumulate([h | t], position, acc),
    do: accumulate(t, position, acc + value_of(h |> String.at(position)))

  defp accumulate([], _, acc), do: acc

  defp value_of("0"), do: -1
  defp value_of("1"), do: 1

  defp gamma(v) when v >= 0, do: 1
  defp gamma(_), do: 0

  defp epsilon(v) when v < 0, do: 1
  defp epsilon(_), do: 0
end
